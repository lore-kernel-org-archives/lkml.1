Return-Path: <linux-kernel-owner+w=401wt.eu-S1758562AbXHISqi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758562AbXHISqi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 14:46:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752736AbXHISq1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 14:46:27 -0400
Received: from mx1.redhat.com ([66.187.233.31]:53537 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752176AbXHISqZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 14:46:25 -0400
Message-ID: <46BB6101.4030307@redhat.com>
Date: Thu, 09 Aug 2007 13:46:25 -0500
From: Eric Sandeen <sandeen@redhat.com>
User-Agent: Thunderbird 2.0.0.6 (Macintosh/20070728)
MIME-Version: 1.0
To: linux-kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: [PATCH] limit minixfs dir_pages on corrupted dir i_size, CVE-2006-6058
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This attempts to address CVE-2006-6058 
http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2006-6058

first reported at http://projects.info-pull.com/mokb/MOKB-17-11-2006.html

Essentially a corrupted minix dir inode reporting a very large
i_size will loop for a very long time in minix_readdir, minix_find_entry,
etc, because on EIO they just move on to try the next page.  This is
under the BKL, printk'ing as well.  This can lock up the machine 
for a very long time.  A simple approach is to at least limit the nr. of 
pages attempted to no more than s_max_size.  (s_max_size is about 256MB for
V1, but 2GB for V2; this could still result in a lot of EIO reads in the V2
case, should the retry loops in minix_readdir & friends be short-circuited
somehow instead?  A simple "break" rather than "continue" on error would 
certainly resolve it, too...)

Signed-off-by: Eric Sandeen <sandeen@redhat.com>

--- linux-2.6.22-rc4.orig/fs/minix/dir.c
+++ linux-2.6.22-rc4/fs/minix/dir.c
@@ -42,7 +42,15 @@ minix_last_byte(struct inode *inode, uns
 
 static inline unsigned long dir_pages(struct inode *inode)
 {
-	return (inode->i_size+PAGE_CACHE_SIZE-1)>>PAGE_CACHE_SHIFT;
+	loff_t size = inode->i_size;
+
+	if (size > minix_sb(inode->i_sb)->s_max_size) {
+		printk("%s: inode %lld i_size > s_max_size\n",
+			__FUNCTION__, inode->i_size);
+		size = minix_sb(inode->i_sb)->s_max_size;
+	}
+
+	return (size+PAGE_CACHE_SIZE-1)>>PAGE_CACHE_SHIFT;
 }
 
 static int dir_commit_chunk(struct page *page, unsigned from, unsigned to)

