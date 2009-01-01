Return-Path: <linux-kernel-owner+w=401wt.eu-S1756138AbZAAVIt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756138AbZAAVIt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jan 2009 16:08:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750741AbZAAVIk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Jan 2009 16:08:40 -0500
Received: from verein.lst.de ([213.95.11.210]:54747 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750733AbZAAVIk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jan 2009 16:08:40 -0500
Date: Thu, 1 Jan 2009 22:08:31 +0100
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: oops in __bounce_end_io_read under kvm
Message-ID: <20090101210831.GA20419@lst.de>
References: <20081226173606.GA14933@lst.de> <20081228181057.GV32491@kernel.dk> <20081228181948.GA23568@lst.de> <20081228182459.GX32491@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081228182459.GX32491@kernel.dk>
User-Agent: Mutt/1.3.28i
X-Spam-Score: -0.001 () BAYES_44
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 28, 2008 at 07:25:00PM +0100, Jens Axboe wrote:
> On Sun, Dec 28 2008, Christoph Hellwig wrote:
> > On Sun, Dec 28, 2008 at 07:10:59PM +0100, Jens Axboe wrote:
> > > Is this -rc9 stock + xfs patches, or does it include -mm or -next
> > > patches (or the block patches)?
> > 
> > Just -rc9 and xfs updates.  The only change outside of fs/xfs/ is a new
> > define in fs.h and a couple new helpers in inode.c
> 
> OK, then it's surely a new bug. Could you do a gdb l *0xbla on that
> address to check where it's faulting?

It took a while to reproduce it again, but I got it again today.


(gdb) l *0xc01a5444
0xc01a5444 is in __bounce_end_io_read
(/home/hch/work/xfs/arch/x86/include/asm/string_32.h:35).
30	extern size_t strlen(const char *s);
31	
32	static __always_inline void *__memcpy(void *to, const void *from, size_t n)
33	{
34		int d0, d1, d2;
35		asm volatile("rep ; movsl\n\t"
36			     "movl %4,%%ecx\n\t"
37			     "andl $3,%%ecx\n\t"
38			     "jz 1f\n\t"
39			     "rep ; movsb\n\t"

