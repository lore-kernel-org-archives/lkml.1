Return-Path: <linux-kernel-owner+w=401wt.eu-S1755929AbYGYUKS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755929AbYGYUKS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 16:10:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751357AbYGYUKE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 16:10:04 -0400
Received: from chimx.wms.com ([208.46.59.21]:5469 "EHLO chimx.wms.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751343AbYGYUKD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 16:10:03 -0400
X-Greylist: delayed 910 seconds by postgrey-1.27 at vger.kernel.org; Fri, 25 Jul 2008 16:10:03 EDT
Date: Fri, 25 Jul 2008 14:54:37 -0500
From: Chris Fester <cfester@wms.com>
To: linux-kernel@vger.kernel.org
Subject: ROMFS error reading 0 byte files
Message-ID: <20080725195437.GA15807@kaboom.dhcp.chi.wms.com>
Mail-Followup-To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-OriginalArrivalTime: 25 Jul 2008 19:54:52.0618 (UTC) FILETIME=[4DB09AA0:01C8EE90]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I've been poking around at a problem I've been having with the
latest kernels and romfs.  The symptom is getting an Input/output
error when reading a zero length file:

# find . -size 0
./usr/lib/gconv/gconv-modules.cache
# cat ./usr/lib/gconv/gconv-modules.cache 
cat: ./usr/lib/gconv/gconv-modules.cache: Input/output error

The problem seems to have occurred somewhere between 2.6.22 and
2.6.23.  Not much changed in the romfs code then, but the
mm/filemap.c had a bit of changes.  Personally I saw this problem
with Debian Lenny kernels 2.6.24 and 2.6.25.  Looking at the
kernel.org source I suspect the problem is still in 2.6.26.

I'm not a filesystem or mm expert, but I would like to get a good
solution going... if it means I get more familiar with mm and 
filesystems then so be it.  :)

Matt Waddel proposed this patch back in November of 2007 on the
uclinux-dev mail list:

diff --git a/fs/romfs/inode.c b/fs/romfs/inode.c
index dae7945..ed04d73 100644
--- a/fs/romfs/inode.c
+++ b/fs/romfs/inode.c
@@ -430,7 +430,7 @@ romfs_readpage(struct file *file, struct page * page)

		/* 32 bit warning -- but not for us :) */
		offset = page_offset(page);
-		if (offset < i_size_read(inode)) {
+		if (offset <= i_size_read(inode)) {
			avail = inode->i_size-offset;
			readlen = min_t(unsigned long, avail, PAGE_SIZE);
			if (romfs_copyfrom(inode, buf, ROMFS_I(inode)->i_dataoffset+offset, readlen) == readlen) {

I mailed Matt recently and he's been using this patch for a while now
with no failures.

I'm not sure if this patch is the best solution.  I was looking at 
cramfs's inode.c:cramfs_readpage, and it looks like it's structured
a little more optimally in the 0 length case.  

For reference to the original discussion, see the uclinux-dev mail list:
http://mailman.uclinux.org/pipermail/uclinux-dev/2007-December/044836.html

Since the maintainer for romfs seems to have moved on, could someone with
vfs knowledge please direct me on what I should do next?  The company I
work for uses romfs extensively in their products.  So far they've been
lucky because the newest kernel being used is 2.6.18.  But there's 
rumblings to upgrade to a newer kernel, and I'd like to be prepared with
a good solid fix in mainline rather than patching.

Thanks in advance for any help!
Chris Fester

