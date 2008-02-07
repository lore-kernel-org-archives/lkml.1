Return-Path: <linux-kernel-owner+w=401wt.eu-S1756059AbYBGItk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756059AbYBGItk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 03:49:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754466AbYBGIta
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 03:49:30 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:47937 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754450AbYBGIt3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 03:49:29 -0500
Date: Thu, 7 Feb 2008 09:49:11 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86_64: fix page table size
Message-ID: <20080207084911.GA10959@elte.hu>
References: <200802061246.43413.yinghai.lu@sun.com> <200802061501.26533.yinghai.lu@sun.com> <20080206231226.GA6417@elte.hu> <200802062022.44069.yinghai.lu@sun.com> <20080207080930.GB28631@elte.hu> <86802c440802070036w1aced44ft8ab880e8ddeedc85@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86802c440802070036w1aced44ft8ab880e8ddeedc85@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Yinghai Lu <yhlu.kernel@gmail.com> wrote:

> > btw., it would be nice to have some "lots of RAM simulation" 
> > debugging code which would just _fake_ a really large e820 map and 
> > would in the end throw away the 'fake' pages later during bootup. 
> > Perhaps tell the early allocator to never allocate into these fake 
> > areas [via an struct e820 entry flag], but all our sizing code and 
> > the boot bitmaps, etc. would be sized accordingly, as if we had this 
> > much RAM - and we'd trigger these nuances. We could put this into a 
> > new "fakemem=128GB" boot option and hence we could boot with 
> > fakemem=128GB on a 2GB box and could at least hope to be able to 
> > boot [with some serious amount of RAM wasted on over-sized 
> > pagetables, allocator bitmaps and mem_map[]]. Hm?
> 
> sound interesting. but need some variable to prevent using non exist 
> page.

yeah, exactly. You could try into using the "PG_arch_1" struct page 
->flags bit - it's not utilized on x86. That way we could avoid free-ing 
it into the general page pool. We could check for it in 
arch/x86/mm/init_64.c's online_page() function [that's where we release 
most pages into the page pool].

Perhaps it might also be handy to introduce a page_is_fake_ram(addr) 
method that searches the e820 maps for fake ram, to make sure we never 
allocate such ranges.

Such a feature would be very useful.

	Ingo
