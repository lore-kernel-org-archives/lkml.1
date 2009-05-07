Return-Path: <linux-kernel-owner+w=401wt.eu-S1761993AbZEGPJy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761993AbZEGPJy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 11:09:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754299AbZEGPJn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 11:09:43 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:36189 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753248AbZEGPJm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 11:09:42 -0400
Date: Thu, 7 May 2009 17:09:39 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jason Wessel <jason.wessel@windriver.com>
Cc: greg@kroah.com, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/5] usb,early_printk: unregister early usb before
	rest_init()
Message-ID: <20090507150939.GD2344@elte.hu>
References: <1241575205-12199-1-git-send-email-jason.wessel@windriver.com> <1241575205-12199-2-git-send-email-jason.wessel@windriver.com> <1241575205-12199-3-git-send-email-jason.wessel@windriver.com> <1241575205-12199-4-git-send-email-jason.wessel@windriver.com> <1241575205-12199-5-git-send-email-jason.wessel@windriver.com> <20090506073456.GC17457@elte.hu> <4A018A69.5030800@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A018A69.5030800@windriver.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jason Wessel <jason.wessel@windriver.com> wrote:

> Ingo Molnar wrote:
> > * Jason Wessel <jason.wessel@windriver.com> wrote:
> >
> >> The early_printk EHCI debug driver can hang the system or cause
> >> unpredictable results because two separate APIs will attempt to write
> >> to the mapped PCI region.
> [clip]
> >> +postcore_initcall(usb_early_debug_cleanup);
> >
> > We already have CON_BOOT which allows the unregistering of early
> > consoles, via disable_boot_consoles() initcall in kernel/printk.c.
> >
> > The hang should be solved differently: either by calling
> > disable_boot_consoles() explicitly after console_init() - or by
> > introducing another CON_ flag that marks the console for early
> > forced unregistering.
> 
> I thought about adding another flag in console_init() such that an
> early console which cannot safely be used can elect to unregister.
> There are two problems with this.
> 
> 1) We actually need a call back to unset ehci_debug, or the
>    console_unregister needs to set/clear a flag which then must be
>    checked on each early_printk write, else any further call laying
>    around for early_printk can crash the system.

yeah, it should definitely be unregistered in the 'blackout' period.

> 
> 2) Ideally you want to keep printk alive for as long as possible,
>    which means you can have it all the way through start_kernel()
>    before the "blackout period" while waiting for pci and usb init.
> 
> Given these two issues, is it your preference still to see a patch 
> that changes console_init or add another call back to 
> start_kernel() ?
> 
> An earlier iteration of this patch added a call back in 
> start_kernel just before rest_init(), but it seemed like it was 
> not needed since we can hook on to part of the relevent function 
> init chain.
> 
> I am open to fixing this in what ever manner is acceptable.

My main point is to please use clean init sequences, instead of 
relying on the current (pretty random) semantics of postcore_init().

It is a property of the USB code that it has trouble with the early 
console - so an explicit call to unregister_usb_early_consoles() 
call would solve it.

Probably followed by a reregister_usb_early_consoles() call - your 
patch AFAICS breaks earlyprint=dbg,...,keep functionality, right?

	Ingo
