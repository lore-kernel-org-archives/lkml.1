Return-Path: <linux-kernel-owner+w=401wt.eu-S1756411AbXLUQBq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756411AbXLUQBq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2007 11:01:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753436AbXLUQB3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Dec 2007 11:01:29 -0500
Received: from fk-out-0910.google.com ([209.85.128.184]:48280 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753274AbXLUQB2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2007 11:01:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=jZ2YFlfQ0+1SXG6jse7FwyWQGFPz5vBzYr3HJTayvRQKlyFzrnsKOACIvMhuWRYKXJ3CrMXYS+AiG+HJU7Eo8nAWKYAMBpqx/H+c9gHim18QJwuGv9w+I1L5cPRi9rIOMC5lMS+osSEZhOtVFYlO5EXMQdGxZDuDbypjMBGqR7I=
Date: Fri, 21 Dec 2007 17:02:59 +0100
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Ben Fennema <bfennema@falcon.csc.calpoly.edu>, Jan Kara <jack@suse.cz>
Subject: [PATCH 4/5] udf: fix 3 signedness & 1 unitialized variable warnings
Message-ID: <20071221160252.GD8575@joi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sparse generated:
fs/udf/inode.c:324:41: warning: incorrect type in argument 4 (different signedness)
fs/udf/inode.c:324:41:    expected long *<noident>
fs/udf/inode.c:324:41:    got unsigned long *<noident>

inode_getblk always set 4th argument to uint32_t value
3rd parameter of map_bh is sector_t (which is unsigned long or u64)
so convert phys value to sector_t

fs/udf/inode.c:1818:47: warning: incorrect type in argument 3 (different signedness)
fs/udf/inode.c:1818:47:    expected int *<noident>
fs/udf/inode.c:1818:47:    got unsigned int *<noident>
fs/udf/inode.c:1826:46: warning: incorrect type in argument 3 (different signedness)
fs/udf/inode.c:1826:46:    expected int *<noident>
fs/udf/inode.c:1826:46:    got unsigned int *<noident>

udf_get_filelongad and udf_get_shortad are called always for uint32_t
values (struct extent_position->offset), so it's safe to convert offset
parameter to uint32_t

gcc warned:
fs/udf/inode.c: In function 'udf_get_block':
fs/udf/inode.c:299: warning: 'phys' may be used uninitialized in this function
initialize it to 0 (if someday someone will break inode_getblk we will catch it immediately)

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
CC: Ben Fennema <bfennema@falcon.csc.calpoly.edu>
Acked-by: Jan Kara <jack@suse.cz>
---
 fs/udf/directory.c |    8 ++++----
 fs/udf/inode.c     |    6 +++---
 fs/udf/udfdecl.h   |    4 ++--
 3 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/fs/udf/directory.c b/fs/udf/directory.c
index ff8c08f..984e5dc 100644
--- a/fs/udf/directory.c
+++ b/fs/udf/directory.c
@@ -271,7 +271,7 @@ static extent_ad *udf_get_fileextent(void *buffer, int bufsize, int *offset)
 }
 #endif

-short_ad *udf_get_fileshortad(uint8_t *ptr, int maxoffset, int *offset,
+short_ad *udf_get_fileshortad(uint8_t *ptr, int maxoffset, uint32_t *offset,
 			      int inc)
 {
 	short_ad *sa;
@@ -281,7 +281,7 @@ short_ad *udf_get_fileshortad(uint8_t *ptr, int maxoffset, int *offset,
 		return NULL;
 	}

-	if ((*offset < 0) || ((*offset + sizeof(short_ad)) > maxoffset))
+	if ((*offset + sizeof(short_ad)) > maxoffset)
 		return NULL;
 	else if ((sa = (short_ad *)ptr)->extLength == 0)
 		return NULL;
@@ -291,7 +291,7 @@ short_ad *udf_get_fileshortad(uint8_t *ptr, int maxoffset, int *offset,
 	return sa;
 }

-long_ad *udf_get_filelongad(uint8_t *ptr, int maxoffset, int *offset, int inc)
+long_ad *udf_get_filelongad(uint8_t *ptr, int maxoffset, uint32_t *offset, int inc)
 {
 	long_ad *la;

@@ -300,7 +300,7 @@ long_ad *udf_get_filelongad(uint8_t *ptr, int maxoffset, int *offset, int inc)
 		return NULL;
 	}

-	if ((*offset < 0) || ((*offset + sizeof(long_ad)) > maxoffset))
+	if ((*offset + sizeof(long_ad)) > maxoffset)
 		return NULL;
 	else if ((la = (long_ad *)ptr)->extLength == 0)
 		return NULL;
diff --git a/fs/udf/inode.c b/fs/udf/inode.c
index 6ff8151..1178ae0 100644
--- a/fs/udf/inode.c
+++ b/fs/udf/inode.c
@@ -51,7 +51,7 @@ static int udf_update_inode(struct inode *, int);
 static void udf_fill_inode(struct inode *, struct buffer_head *);
 static int udf_alloc_i_data(struct inode *inode, size_t size);
 static struct buffer_head *inode_getblk(struct inode *, sector_t, int *,
-					long *, int *);
+					sector_t *, int *);
 static int8_t udf_insert_aext(struct inode *, struct extent_position,
 			      kernel_lb_addr, uint32_t);
 static void udf_split_extents(struct inode *, int *, int, int,
@@ -296,7 +296,7 @@ static int udf_get_block(struct inode *inode, sector_t block,
 {
 	int err, new;
 	struct buffer_head *bh;
-	unsigned long phys;
+	sector_t phys = 0;

 	if (!create) {
 		phys = udf_block_map(inode, block);
@@ -469,7 +469,7 @@ out:
 }

 static struct buffer_head *inode_getblk(struct inode *inode, sector_t block,
-					int *err, long *phys, int *new)
+					int *err, sector_t *phys, int *new)
 {
 	static sector_t last_block;
 	struct buffer_head *result = NULL;
diff --git a/fs/udf/udfdecl.h b/fs/udf/udfdecl.h
index c8016cc..b17ca67 100644
--- a/fs/udf/udfdecl.h
+++ b/fs/udf/udfdecl.h
@@ -185,8 +185,8 @@ extern struct fileIdentDesc *udf_fileident_read(struct inode *, loff_t *,
 						sector_t *);
 extern struct fileIdentDesc *udf_get_fileident(void *buffer, int bufsize,
 					       int *offset);
-extern long_ad *udf_get_filelongad(uint8_t *, int, int *, int);
-extern short_ad *udf_get_fileshortad(uint8_t *, int, int *, int);
+extern long_ad *udf_get_filelongad(uint8_t *, int, uint32_t *, int);
+extern short_ad *udf_get_fileshortad(uint8_t *, int, uint32_t *, int);

 /* crc.c */
 extern uint16_t udf_crc(uint8_t *, uint32_t, uint16_t);
--
1.5.3.4

