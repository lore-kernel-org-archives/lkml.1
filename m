Return-Path: <linux-kernel-owner+w=401wt.eu-S1753421AbYBLXMm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753421AbYBLXMm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 18:12:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761912AbYBLXLS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 18:11:18 -0500
Received: from fg-out-1718.google.com ([72.14.220.155]:8053 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761813AbYBLXLQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 18:11:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=to:cc:subject:date:message-id:x-mailer:in-reply-to:references:from;
        b=X4QsIJ/6cwH7h5xtRwDeQccofxg8tp05TgPMuw9GhMOYG6suMoz2yg10Nt7i4u/NwoDhoiAUFMkNMKzYWfjbXe3Jojuh7Yy243igiBAwebe2ogwFkAWeKqms6bTGNgC6chRYeTy7Yf+ByFORpHTTW/AGWxtFNipJY4DvpTqp+co=
To: LKML <linux-kernel@vger.kernel.org>
Cc: Marcin Slusarz <marcin.slusarz@gmail.com>,
       Mark Fasheh <mark.fasheh@oracle.com>,
       Kurt Hackel <kurt.hackel@oracle.com>, ocfs2-devel@oss.oracle.com
Subject: [PATCH] ocfs2: le*_add_cpu conversion
Date: Wed, 13 Feb 2008 00:06:18 +0100
Message-Id: <1202857582-15450-14-git-send-email-marcin.slusarz@gmail.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1202857582-15450-1-git-send-email-marcin.slusarz@gmail.com>
References: <1202857582-15450-1-git-send-email-marcin.slusarz@gmail.com>
From: marcin.slusarz@gmail.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marcin Slusarz <marcin.slusarz@gmail.com>

replace all:
little_endian_variable = cpu_to_leX(leX_to_cpu(little_endian_variable) +
					expression_in_cpu_byteorder);
with:
	leX_add_cpu(&little_endian_variable, expression_in_cpu_byteorder);
generated with semantic patch

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Mark Fasheh <mark.fasheh@oracle.com>
Cc: Kurt Hackel <kurt.hackel@oracle.com>
Cc: ocfs2-devel@oss.oracle.com
---
 fs/ocfs2/dir.c        |    5 ++---
 fs/ocfs2/localalloc.c |    3 +--
 2 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/fs/ocfs2/dir.c b/fs/ocfs2/dir.c
index e280833..8a18758 100644
--- a/fs/ocfs2/dir.c
+++ b/fs/ocfs2/dir.c
@@ -390,9 +390,8 @@ static int __ocfs2_delete_entry(handle_t *handle, struct inode *dir,
 				goto bail;
 			}
 			if (pde)
-				pde->rec_len =
-					cpu_to_le16(le16_to_cpu(pde->rec_len) +
-						    le16_to_cpu(de->rec_len));
+				le16_add_cpu(&pde->rec_len,
+						le16_to_cpu(de->rec_len));
 			else
 				de->inode = 0;
 			dir->i_version++;
diff --git a/fs/ocfs2/localalloc.c b/fs/ocfs2/localalloc.c
index add1ffd..d0e217e 100644
--- a/fs/ocfs2/localalloc.c
+++ b/fs/ocfs2/localalloc.c
@@ -588,8 +588,7 @@ int ocfs2_claim_local_alloc_bits(struct ocfs2_super *osb,
 	while(bits_wanted--)
 		ocfs2_set_bit(start++, bitmap);
 
-	alloc->id1.bitmap1.i_used = cpu_to_le32(*num_bits +
-				le32_to_cpu(alloc->id1.bitmap1.i_used));
+	le32_add_cpu(&alloc->id1.bitmap1.i_used, *num_bits);
 
 	status = ocfs2_journal_dirty(handle, osb->local_alloc_bh);
 	if (status < 0) {
-- 
1.5.3.7

