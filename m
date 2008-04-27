Return-Path: <linux-kernel-owner+w=401wt.eu-S1762067AbYD0AsT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762067AbYD0AsT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2008 20:48:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756800AbYD0AsH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Apr 2008 20:48:07 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:11187 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755543AbYD0AsE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2008 20:48:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type:message-id;
        b=FlG5HVShux3qXUaNlol0k21xKxQQQFtbNDNLwnKSRYkC6HhnYdiL0f/q07+ZkEMavXrBIL1Wxsyx6yaeY4rNh77QcA5aaubRmjycIBEuzHRo0ZLBa+s95okn4LsQrMZ/Pc/MJc9U06SkMAvOkrcEqXIhZJg4h1y0DG2KZgAEnNc=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: David Chinner <dgc@sgi.com>
Subject: [PATCH] xfs: reduce stack usage in xfs_page_state_convert()
Date: Sun, 27 Apr 2008 02:46:58 +0200
User-Agent: KMail/1.8.2
Cc: xfs@oss.sgi.com, Eric Sandeen <sandeen@sandeen.net>,
       Adrian Bunk <bunk@kernel.org>, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_C08EI5Sq2GBn7oU"
Message-Id: <200804270246.58828.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_C08EI5Sq2GBn7oU
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi David,

This patch reduces xfs_page_state_convert() stack usage by 16 bytes
by eliminating some local variables, and reducing the size
of scope for other locals.

Compile tested only.

Signed-off-by: Denys Vlasenko <vda.linux@googlemail.com>

P.S.

xfs_page_state_convert() carries the following comment:
 * Calling this without startio set means we are being asked to make a dirty
 * page ready for freeing it's buffers.  When called with startio set then
 * we are coming from writepage.
which leads to the following proposal: reimplement it as two
functions, one which work as if startio parameter == 0
and the other as if startio == 1.
This will result in a bit of code duplication, but reduces
stack usage on writepage path and allows for these two functions
to have more descriptive names. (Presently the meaning of this
function needs to be explained in that comment -> function
name is not descriptive enough, because it does different things
depending on startio value).

Do you like this idea?
--
vda

--Boundary-00=_C08EI5Sq2GBn7oU
Content-Type: text/x-diff;
  charset="us-ascii";
  name="stk2.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="stk2.diff"

diff -urpN linux-2.6-xfs1/fs/xfs/linux-2.6/xfs_aops.c linux-2.6-xfs1.stk2/fs/xfs/linux-2.6/xfs_aops.c
--- linux-2.6-xfs1/fs/xfs/linux-2.6/xfs_aops.c	2008-04-22 04:06:46.000000000 +0200
+++ linux-2.6-xfs1.stk2/fs/xfs/linux-2.6/xfs_aops.c	2008-04-27 02:38:51.000000000 +0200
@@ -935,17 +935,11 @@ xfs_page_state_convert(
 	unsigned long           p_offset = 0;
 	unsigned int		type;
 	__uint64_t              end_offset;
-	pgoff_t                 end_index, last_index, tlast;
-	ssize_t			size, len;
+	pgoff_t                 end_index, last_index;
 	int			flags, err, iomap_valid = 0, uptodate = 1;
 	int			page_dirty, count = 0;
-	int			trylock = 0;
 	int			all_bh = unmapped;
-
-	if (startio) {
-		if (wbc->sync_mode == WB_SYNC_NONE && wbc->nonblocking)
-			trylock |= BMAPI_TRYLOCK;
-	}
+#define len (1 << inode->i_blkbits)
 
 	/* Is this page beyond the end of the file? */
 	offset = i_size_read(inode);
@@ -975,7 +969,6 @@ xfs_page_state_convert(
  	 */
 	end_offset = min_t(unsigned long long,
 			(xfs_off_t)(page->index + 1) << PAGE_CACHE_SHIFT, offset);
-	len = 1 << inode->i_blkbits;
 	p_offset = min_t(unsigned long, end_offset & (PAGE_CACHE_SIZE - 1),
 					PAGE_CACHE_SIZE);
 	p_offset = p_offset ? roundup(p_offset, len) : PAGE_CACHE_SIZE;
@@ -1031,13 +1024,18 @@ xfs_page_state_convert(
 				flags = BMAPI_WRITE | BMAPI_IGNSTATE;
 			} else if (buffer_delay(bh)) {
 				type = IOMAP_DELAY;
-				flags = BMAPI_ALLOCATE | trylock;
+				flags = BMAPI_ALLOCATE;
+				if (startio && wbc->sync_mode == WB_SYNC_NONE && wbc->nonblocking) {
+					flags = BMAPI_ALLOCATE | BMAPI_TRYLOCK;
+				}
 			} else {
 				type = IOMAP_NEW;
 				flags = BMAPI_WRITE | BMAPI_MMAP;
 			}
 
 			if (!iomap_valid) {
+				ssize_t size;
+
 				/*
 				 * if we didn't have a valid mapping then we
 				 * need to ensure that we put the new mapping
@@ -1082,6 +1080,8 @@ xfs_page_state_convert(
 			 * underneath it. Map the extent by reading it.
 			 */
 			if (!iomap_valid || flags != BMAPI_READ) {
+				ssize_t size;
+
 				flags = BMAPI_READ;
 				size = xfs_probe_cluster(inode, page, bh,
 								head, 1);
@@ -1129,6 +1129,8 @@ xfs_page_state_convert(
 		xfs_start_page_writeback(page, wbc, 1, count);
 
 	if (ioend && iomap_valid) {
+		pgoff_t tlast;
+
 		offset = (iomap.iomap_offset + iomap.iomap_bsize - 1) >>
 					PAGE_CACHE_SHIFT;
 		tlast = min_t(pgoff_t, offset, last_index);
@@ -1156,6 +1158,7 @@ error:
 		ClearPageUptodate(page);
 	}
 	return err;
+#undef len
 }
 
 /*

--Boundary-00=_C08EI5Sq2GBn7oU--
