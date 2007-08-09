Return-Path: <linux-kernel-owner+w=401wt.eu-S1765579AbXHIUkU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765579AbXHIUkU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 16:40:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755173AbXHIUkE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 16:40:04 -0400
Received: from sandeen.net ([209.173.210.139]:13595 "EHLO sandeen.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754370AbXHIUkC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 16:40:02 -0400
Message-ID: <46BB7BA0.70107@sandeen.net>
Date: Thu, 09 Aug 2007 15:40:00 -0500
From: Eric Sandeen <sandeen@sandeen.net>
User-Agent: Thunderbird 2.0.0.6 (Macintosh/20070728)
MIME-Version: 1.0
To: linux-kernel Mailing List <linux-kernel@vger.kernel.org>
CC: linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: [PATCH V2] limit minixfs printks on corrupted dir i_size, CVE-2006-6058
References: <46BB6101.4030307@redhat.com>
In-Reply-To: <46BB6101.4030307@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Perhaps this is simpler, and preferable.  Thanks to adilger for
reminding me about printk_ratelimit.  :)

----

This attempts to address CVE-2006-6058 
http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2006-6058
 
first reported at http://projects.info-pull.com/mokb/MOKB-17-11-2006.html

Essentially a corrupted minix dir inode reporting a very large
i_size will loop for a very long time in minix_readdir, minix_find_entry,
etc, because on EIO they just move on to try the next page.  This is
under the BKL, printk-storming as well.  This can lock up the machine 
for a very long time.  Simply ratelimiting the printks gets things back
under control.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Index: linux-2.6.22-rc4/fs/minix/itree_v1.c
===================================================================
--- linux-2.6.22-rc4.orig/fs/minix/itree_v1.c
+++ linux-2.6.22-rc4/fs/minix/itree_v1.c
@@ -27,7 +27,8 @@ static int block_to_path(struct inode * 
 	if (block < 0) {
 		printk("minix_bmap: block<0\n");
 	} else if (block >= (minix_sb(inode->i_sb)->s_max_size/BLOCK_SIZE)) {
-		printk("minix_bmap: block>big\n");
+		if (printk_ratelimit())
+			printk("minix_bmap: block>big\n");
 	} else if (block < 7) {
 		offsets[n++] = block;
 	} else if ((block -= 7) < 512) {
Index: linux-2.6.22-rc4/fs/minix/itree_v2.c
===================================================================
--- linux-2.6.22-rc4.orig/fs/minix/itree_v2.c
+++ linux-2.6.22-rc4/fs/minix/itree_v2.c
@@ -28,7 +28,8 @@ static int block_to_path(struct inode * 
 	if (block < 0) {
 		printk("minix_bmap: block<0\n");
 	} else if (block >= (minix_sb(inode->i_sb)->s_max_size/sb->s_blocksize)) {
-		printk("minix_bmap: block>big\n");
+		if (printk_ratelimit())
+			printk("minix_bmap: block>big\n");
 	} else if (block < 7) {
 		offsets[n++] = block;
 	} else if ((block -= 7) < 256) {



