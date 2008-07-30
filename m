Return-Path: <linux-kernel-owner+w=401wt.eu-S1756173AbYG3QLJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756173AbYG3QLJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 12:11:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752156AbYG3QK4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 12:10:56 -0400
Received: from chimx.wms.com ([208.46.59.21]:31260 "EHLO chimx.wms.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751550AbYG3QKz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 12:10:55 -0400
Date: Wed, 30 Jul 2008 11:10:52 -0500
From: Chris Fester <cfester@wms.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Matt Waddel <matt.waddel@freescale.com>,
       Greg Ungerer <gerg@snapgear.com>
Subject: [PATCH] ROMFS 0 byte file read error
Message-ID: <20080730161051.GA3133@kaboom.dhcp.chi.wms.com>
Reply-To: cfester@wms.com
Mail-Followup-To: lkml <linux-kernel@vger.kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Matt Waddel <matt.waddel@freescale.com>,
	Greg Ungerer <gerg@snapgear.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-OriginalArrivalTime: 30 Jul 2008 16:10:53.0683 (UTC) FILETIME=[D7869C30:01C8F25E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've verified that the git tree at:
git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git

also has the zero byte file problem for romfs.  This patch
fixes the problem.  Avoids calling romfs_copyfrom when in 
the 0 size case.

Thanks!
Chris Fester

Signed-off-by: Chris Fester <cfester@wms.com>
---

diff --git a/fs/romfs/inode.c b/fs/romfs/inode.c
index 8e51a2a..5d24113 100644
--- a/fs/romfs/inode.c
+++ b/fs/romfs/inode.c
@@ -430,10 +430,10 @@ romfs_readpage(struct file *file, struct page * page)
 
        /* 32 bit warning -- but not for us :) */
        offset = page_offset(page);
-       if (offset < i_size_read(inode)) {
+       if (offset <= i_size_read(inode)) {
                avail = inode->i_size-offset;
                readlen = min_t(unsigned long, avail, PAGE_SIZE);
-               if (romfs_copyfrom(inode, buf, ROMFS_I(inode)->i_dataoffset+offset, readlen) == readlen) {
+               if (!readlen || romfs_copyfrom(inode, buf, ROMFS_I(inode)->i_dataoffset+offset, readlen) == readlen) {
                        if (readlen < PAGE_SIZE) {
                                memset(buf + readlen,0,PAGE_SIZE-readlen);
                        }

