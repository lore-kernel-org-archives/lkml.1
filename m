Return-Path: <linux-kernel-owner+w=401wt.eu-S1755502AbZGBVNx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755502AbZGBVNx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 17:13:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753456AbZGBVNp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 17:13:45 -0400
Received: from zrtps0kp.nortel.com ([47.140.192.56]:51813 "EHLO
	zrtps0kp.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753509AbZGBVNp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 17:13:45 -0400
Message-ID: <4A4D2306.2000208@nortel.com>
Date: Thu, 02 Jul 2009 17:13:42 -0400
From: "Doug Graham" <dgraham@nortel.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20081216)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: V3 minixfs bug
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 02 Jul 2009 21:13:44.0648 (UTC) FILETIME=[FB799480:01C9FB59]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Is anybody interested in bugs in the minixfs V3 support that probably
only turn up on big-endian machines, or on filesystems with more than
64K inodes?

The problem is that that there are a few places (three that I've found)
where the "inode" field of a minix_dir_entry is used without checking
first to see if the dirent is really a minix3_dir_entry.  The inode number
in a V1/V2 dirent is 16 bits, whereas that in a V3 dirent is 32 bits.  
Accessing
it as a 16 bit field when it really should be accessed as a 32 bit field
probably kinda sorta works on a little-endian machine, but leads to some
rather odd behaviour on big-endian machines.

Here's a patch:

--- linux-2.6.29.2/fs/minix/dir.c       2009/07/02 21:05:33     1.1
+++ linux-2.6.29.2/fs/minix/dir.c       2009/07/02 21:10:31
@@ -311,14 +311,18 @@
        struct inode *inode = (struct inode*)mapping->host;
        char *kaddr = page_address(page);
        loff_t pos = page_offset(page) + (char*)de - kaddr;
-       unsigned len = minix_sb(inode->i_sb)->s_dirsize;
+       struct minix_sb_info *sbi = minix_sb(inode->i_sb);
+       unsigned len = sbi->s_dirsize;
        int err;

        lock_page(page);
        err = __minix_write_begin(NULL, mapping, pos, len,
                                        AOP_FLAG_UNINTERRUPTIBLE, &page, 
NULL);
        if (err == 0) {
-               de->inode = 0;
+               if (sbi->s_version == MINIX_V3)
+                       ((minix3_dirent *) de)->inode = 0;
+               else
+                       de->inode = 0;
                err = dir_commit_chunk(page, pos, len);
        } else {
                unlock_page(page);
@@ -443,7 +447,10 @@
        err = __minix_write_begin(NULL, mapping, pos, sbi->s_dirsize,
                                        AOP_FLAG_UNINTERRUPTIBLE, &page, 
NULL);
        if (err == 0) {
-               de->inode = inode->i_ino;
+               if (sbi->s_version == MINIX_V3)
+                       ((minix3_dirent *) de)->inode = inode->i_ino;
+               else
+                       de->inode = inode->i_ino;
                err = dir_commit_chunk(page, pos, sbi->s_dirsize);
        } else {
                unlock_page(page);
@@ -473,7 +480,14 @@
        ino_t res = 0;

        if (de) {
-               res = de->inode;
+               struct address_space *mapping = page->mapping;
+               struct inode *inode = (struct inode*)mapping->host;
+               struct minix_sb_info *sbi = minix_sb(inode->i_sb);
+
+               if (sbi->s_version == MINIX_V3)
+                       res = ((minix3_dirent *) de)->inode;
+               else
+                       res = de->inode;
                dir_put_page(page);
        }
        return res;


--Doug

