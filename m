Return-Path: <linux-kernel-owner+w=401wt.eu-S1752722AbXLEXd5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752722AbXLEXd5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 18:33:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751439AbXLEXds
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 18:33:48 -0500
Received: from ns1.suse.de ([195.135.220.2]:50624 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751095AbXLEXdr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 18:33:47 -0500
Date: Thu, 6 Dec 2007 00:33:45 +0100
From: Nick Piggin <npiggin@suse.de>
To: carsteno@de.ibm.com
Cc: Christian Borntraeger <borntraeger@de.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Andrew Morton <akpm@linux-foundation.org>, rob@landley.net,
       Jens Axboe <axboe@kernel.dk>
Subject: Re: [patch] ext2: xip check fix
Message-ID: <20071205233345.GB5617@wotan.suse.de>
References: <20071204042628.GA26636@wotan.suse.de> <200712041054.51599.borntraeger@de.ibm.com> <20071204101009.GB9618@wotan.suse.de> <20071204112100.GA20420@wotan.suse.de> <20071204112327.GB20420@wotan.suse.de> <4756C714.2040809@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4756C714.2040809@de.ibm.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 05, 2007 at 04:43:16PM +0100, Carsten Otte wrote:
> Nick Piggin wrote:
> >Am I missing something here? I wonder how s390 works without this change?
> >
> >--
> >ext2 should not worry about checking sb->s_blocksize for XIP before the
> >sb's blocksize actually gets set.
> >
> >Signed-off-by: Nick Piggin <npiggin@suse.de>
> >---
> >Index: linux-2.6/fs/ext2/super.c
> >===================================================================
> >--- linux-2.6.orig/fs/ext2/super.c
> >+++ linux-2.6/fs/ext2/super.c
> >@@ -844,8 +844,7 @@ static int ext2_fill_super(struct super_
> >
> > 	blocksize = BLOCK_SIZE << le32_to_cpu(sbi->s_es->s_log_block_size);
> >
> >-	if ((ext2_use_xip(sb)) && ((blocksize != PAGE_SIZE) ||
> >-				  (sb->s_blocksize != blocksize))) {
> >+	if (ext2_use_xip(sb) && blocksize != PAGE_SIZE) {
> > 		if (!silent)
> > 			printk("XIP: Unsupported blocksize\n");
> > 		goto failed_mount;
> "blocksize" contains the blocksize of the device here, and 
> sb->s_blocksize does contain the filesystem block size as saved in the 
> super block.

You mean blocksize is the size of the ext2 block, and s_blocksize is the
default size of the block device.


> Xip does only work, if both do match PAGE_SIZE because it 
> does'nt support multiple calls to direct_access in the get_xip_page 
> address space operation. Thus we check both here, actually this was 
> changed from how it looks after your patch as a bugfix where our 
> tester tried a 4k filesystem on a 2k blockdev.
> Did I miss something?

However, the bdev block size may be changed with sb_set_blocksize. It
doesn't actually have to match the hardware sector size -- if this
does matter for XIP, then I think you need some other check here.
