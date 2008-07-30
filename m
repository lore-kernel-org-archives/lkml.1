Return-Path: <linux-kernel-owner+w=401wt.eu-S1759538AbYG3SKs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759538AbYG3SKs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 14:10:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752003AbYG3SKh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 14:10:37 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51832 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752009AbYG3SKg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 14:10:36 -0400
Date: Wed, 30 Jul 2008 11:06:29 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Chris Fester <cfester@wms.com>
cc: lkml <linux-kernel@vger.kernel.org>,
       Alexander Viro <viro@zeniv.linux.org.uk>,
       Matt Waddel <matt.waddel@freescale.com>,
       Greg Ungerer <gerg@snapgear.com>
Subject: Re: [PATCH] ROMFS 0 byte file read error
In-Reply-To: <20080730161051.GA3133@kaboom.dhcp.chi.wms.com>
Message-ID: <alpine.LFD.1.10.0807301052180.3334@nehalem.linux-foundation.org>
References: <20080730161051.GA3133@kaboom.dhcp.chi.wms.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 30 Jul 2008, Chris Fester wrote:
>
> I've verified that the git tree at:
> git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git
> 
> also has the zero byte file problem for romfs.  This patch
> fixes the problem.  Avoids calling romfs_copyfrom when in 
> the 0 size case.

Hmm. Who calls 'readpage()' with an offset past the end of the file 
anyway? This _really_ shouldn't matter.

But regardless, isn't the bug that 'romfs_readpage()' sets an error bit 
by default - ie even if there was no actual IO error? The thing is also 
very confused about types: if it really wants to be safe in "loff_t, then 
it had bettr not do the "min_t()" in just "unsigned long".

So this whole routine really seems to be much more broken than your patch 
implies, and your patch just works around some brokenness.

Of course, I think it's all 32-bit and some of these problems cannot 
actually happen, but wouldn't it be more obvious to rewrite it to have a 
separate error return ("result") and a variable saying how much of the 
page was filled ("filled")?

Something like this. UNTESTED. Pls verify and send back if this is ok. The 
patch is certainly bigger, but I think that the end result is more 
obvious.

		Linus

---
 fs/romfs/inode.c |   37 +++++++++++++++++++++++--------------
 1 files changed, 23 insertions(+), 14 deletions(-)

diff --git a/fs/romfs/inode.c b/fs/romfs/inode.c
index 8e51a2a..60d2f82 100644
--- a/fs/romfs/inode.c
+++ b/fs/romfs/inode.c
@@ -418,7 +418,8 @@ static int
 romfs_readpage(struct file *file, struct page * page)
 {
 	struct inode *inode = page->mapping->host;
-	loff_t offset, avail, readlen;
+	loff_t offset, size;
+	unsigned long filled;
 	void *buf;
 	int result = -EIO;
 
@@ -430,21 +431,29 @@ romfs_readpage(struct file *file, struct page * page)
 
 	/* 32 bit warning -- but not for us :) */
 	offset = page_offset(page);
-	if (offset < i_size_read(inode)) {
-		avail = inode->i_size-offset;
-		readlen = min_t(unsigned long, avail, PAGE_SIZE);
-		if (romfs_copyfrom(inode, buf, ROMFS_I(inode)->i_dataoffset+offset, readlen) == readlen) {
-			if (readlen < PAGE_SIZE) {
-				memset(buf + readlen,0,PAGE_SIZE-readlen);
-			}
-			SetPageUptodate(page);
-			result = 0;
+	size = i_size_read(inode);
+	filled = 0;
+	result = 0;
+	if (offset < size) {
+		unsigned long readlen;
+
+		size -= offset;
+		readlen = size > PAGE_SIZE ? PAGE_SIZE : size;
+
+		filled = romfs_copyfrom(inode, buf, ROMFS_I(inode)->i_dataoffset+offset, readlen);
+
+		if (filled != readlen) {
+			SetPageError(page);
+			filled = 0;
+			result = -EIO;
 		}
 	}
-	if (result) {
-		memset(buf, 0, PAGE_SIZE);
-		SetPageError(page);
-	}
+
+	if (filled < PAGE_SIZE)
+		memset(buf + filled, 0, PAGE_SIZE-filled);
+
+	if (!result)
+		SetPageUptodate(page);
 	flush_dcache_page(page);
 
 	unlock_page(page);
