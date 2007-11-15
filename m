Return-Path: <linux-kernel-owner+w=401wt.eu-S933384AbXKOV0f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933384AbXKOV0f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 16:26:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763777AbXKOV00
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 16:26:26 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45484 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758885AbXKOV0Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 16:26:25 -0500
Date: Thu, 15 Nov 2007 13:26:13 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
cc: Bron Gondwana <brong@fastmail.fm>, Christian Kujau <lists@nerdbynature.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       robm@fastmail.fm
Subject: Re: mmap dirty limits on 32 bit kernels (Was: [BUG] New Kernel
 Bugs)
In-Reply-To: <alpine.LFD.0.9999.0711151300250.4260@woody.linux-foundation.org>
Message-ID: <alpine.LFD.0.9999.0711151320010.4260@woody.linux-foundation.org>
References: <20071113.043207.44732743.davem@davemloft.net>  <20071113110259.44c56d42.akpm@linux-foundation.org>  <alpine.DEB.0.9999.0711132055550.7865@sheep.housecafe.de>  <20071113130411.26ccae12.akpm@linux-foundation.org>  <alpine.DEB.0.99999.0711132239350.3960@sheep.housecafe.de>
  <20071115040708.GB15302@brong.net>  <alpine.LFD.0.9999.0711142020220.2786@woody.linux-foundation.org>  <20071115052538.GA21522@brong.net>  <alpine.LFD.0.9999.0711142130090.2786@woody.linux-foundation.org>  <alpine.LFD.0.9999.0711142148380.2786@woody.linux-foundation.org>
  <20071115115049.GA8297@brong.net>  <alpine.LFD.0.9999.0711150818320.2786@woody.linux-foundation.org>  <1195155601.22457.25.camel@lappy> <1195159457.22457.35.camel@lappy> <alpine.LFD.0.9999.0711151252340.4260@woody.linux-foundation.org>
 <alpine.LFD.0.9999.0711151300250.4260@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 15 Nov 2007, Linus Torvalds wrote:
> 
> The problem with HIGHMEM is that it causes various metadata (dentries, 
> inodes, page struct tables etc) to eat up memory "prime real estate" under 
> the same kind of conditions that also dirty a lot of memory. So the reason 
> we disallow HIGHMEM from dirty limits is only *partly* the per-device or 
> mapping DMA limits, and to a large degree the fact that non-highmem memory 
> is special in general, and it is usually the non-highmem areas that are 
> constrained - and need to be protected.

Final note on this (promise): 

I'd really be very interested to hear if the patch I *do* think makes 
sense (ie the removal of the old "unmapped_ratio" logic) actually already 
solves most of Bron's problems.

It may well be that that unmapped_ratio logic effectively undid the system 
configuration changes that Bron has done. It doesn't matter if Bron has

	>From our sysctl.conf:
	# This should help reduce flushing on Cache::FastMmap files
	vm.dirty_background_ratio = 50
	vm.dirty_expire_centisecs = 9000
	vm.dirty_ratio = 80
	vm.dirty_writeback_centisecs = 3000

if it turns out that the "unmapped_ratio" logic turns the 80% back down to 
5%.

It may well be that 80% of the non-highmem memory is plenty good enough! 

Sure, older kernels allowed even more of memory to be dirty (since they 
didn't count dirty mappings at all), but we may have a case where the fact 
that we discount the HIGHMEM stuff isn't the major problem in itself, and 
that the dirty_ratio sysctl should be ok - but just gets screwed over by 
that unmapped_ratio logic.

So Bron, if you can test that patch, I'd love to hear if it matters. It 
may not make any difference (maybe you don't actually trigger the 
unmapped_ratio logic at all), but I think it has the potential for being 
totally broken for you.

People that don't change the dirty_ratio from the default values would 
generally never care, because the default dirty-ratio is *already* so low 
that even if the unmapped_ratio logic triggers, it won't much matter!

		Linus
