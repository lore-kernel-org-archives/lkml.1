Return-Path: <linux-kernel-owner+w=401wt.eu-S1752599AbXCaVrO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752599AbXCaVrO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2007 17:47:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752609AbXCaVrN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Mar 2007 17:47:13 -0400
Received: from mx2.suse.de ([195.135.220.15]:50197 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752599AbXCaVrN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2007 17:47:13 -0400
From: Neil Brown <neilb@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Date: Sun, 1 Apr 2007 07:46:47 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <17934.54983.192724.145829@notabene.brown>
Cc: Bernhard Rosenkraenzer <bero@arklinux.org>, linux-kernel@vger.kernel.org,
       Dan Williams <dan.j.williams@intel.com>
Subject: Re: 2.6.21-rc5-mm[12]: Oops on bootup in xor_see_2
In-Reply-To: message from Andrew Morton on Saturday March 31
References: <200703311736.47751.bero@arklinux.org>
	<20070331124049.ec87cb3a.akpm@linux-foundation.org>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday March 31, akpm@linux-foundation.org wrote:
> On Sat, 31 Mar 2007 17:36:47 +0000 Bernhard Rosenkraenzer <bero@arklinux.org> wrote:
> 
> > I'm getting this Oops when booting an 2.6.21-rc5-mm1 or 2.6.21-rc5-mm2 on an 
> > Acer Aspire 1501 LMi in 32 bit mode (2.6.21-rc4-mm1 + hotfixes works 
> > perfectly):
> > 
> > xor: automatically using best checksumming function: pIII_sse

Hmmm... I've seen that before

> > Code: 44 89 74 24 48 0f 20 c6 0f 06 0f 11 04 24 0f 11 4c 24 10 0f 11 54 24 20 
> > 0f
> >       11 5c 24 30 0f 18 82 00 01 00 00 0f 18 82 20 01 00 00 <00> 00 00 00 00 
> > 00
> >       00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> > -

Them bytes that look like '00' are mostly supposed to look like 'F0' -
an x86 'noop'.

Apparently a bin-utils bug.  An alpha of OpenSUSE-10.3 was compiling
kernels like this.  I'm told it has been fixed.

What distro/gcc version/binutils version was this compiled on?

It is possible that we should change the ".align 32" in
include/asm-i386/xor.h to ".align 32, 0xf0" or similar, but my
assembler knowledge stopped growing when it reached 6809, so I'd
rather someone who knew something about it did anything that was
required....

> 
> Dan, I'm assuming your changes in there are the cause of this.  AFAICT all
> you're doing is moving code around, so it's a bit odd.
> 
> Bernhard, the config would be useful please.
> 
> Neil, is calibrate_xor_block() being rational?
> 
> 	b1 = (void *) __get_free_pages(GFP_KERNEL, 2);
> 	...
> 	b2 = b1 + 2*PAGE_SIZE + BENCH_SIZE;
> 
> Is it correct to add BENCH_SIZE to b2 here?

I think it is intentional.  I cannot say if it is correct.
The purpose is to defeat cache effects somehow.
The result of that code together with the value of BENCH_SIZE being
PAGE_SIZE is that 4 pages are allocated, and the first and last are
used.
I have no idea how any cache would treat this, but that seems to be
the intent of the code.

NeilBrown
