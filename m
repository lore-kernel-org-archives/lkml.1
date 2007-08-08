Return-Path: <linux-kernel-owner+w=401wt.eu-S935772AbXHHAGo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935772AbXHHAGo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 20:06:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759623AbXHHAGe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 20:06:34 -0400
Received: from one.firstfloor.org ([213.235.205.2]:48851 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756708AbXHHAGc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 20:06:32 -0400
Date: Wed, 8 Aug 2007 02:06:31 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Cal Peake <cp@absolutedigital.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Chuck Ebbert <cebbert@redhat.com>,
       Gabriel C <nix.or.die@googlemail.com>, Frank Hale <frankhale@gmail.com>,
       Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel ACPI Mailing List <linux-acpi@vger.kernel.org>,
       len.brown@intel.com, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: ACPI on Averatec 2370
Message-ID: <20070808000631.GB7353@one.firstfloor.org>
References: <Pine.LNX.4.64.0707301048460.5693@lancer.cnet.absolutedigital.net> <Pine.LNX.4.64.0708021335060.28012@lancer.cnet.absolutedigital.net> <46B22BDA.8090604@redhat.com> <Pine.LNX.4.64.0708021512530.28012@lancer.cnet.absolutedigital.net> <46B23E08.4070106@redhat.com> <Pine.LNX.4.64.0708021627590.28012@lancer.cnet.absolutedigital.net> <alpine.LFD.0.999.0708021353320.8184@woody.linux-foundation.org> <Pine.LNX.4.64.0708021723160.28012@lancer.cnet.absolutedigital.net> <alpine.LFD.0.999.0708031447420.8184@woody.linux-foundation.org> <Pine.LNX.4.64.0708071803570.28199@lancer.cnet.absolutedigital.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0708071803570.28199@lancer.cnet.absolutedigital.net>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 07, 2007 at 06:15:37PM -0400, Cal Peake wrote:
> On Fri, 3 Aug 2007, Linus Torvalds wrote:
> 
> > > MSR_K8_ENABLE_C1E lo == 0x04c14015
> > > MSR_K8_ENABLE_C1E hi == 0x00000000
> > > lo & ENABLE_C1E_MASK == 0
> > 
> > And yeah, that claims that C1E is not on, but:
> > 
> > > amd_apic_timer_broken: forcing return value of 1
> 
> So it seems my initial debugging report was, err, incomplete. I failed to 
> notice that the amd_apic_timer_broken function was getting called twice, 
> once for each core.
> 
> The second call shows this:
> 
>   MSR_K8_ENABLE_C1E == 0x14c14015

Ah interesting. Ok finally that all starts making sense.

Not sure why the MSR varies between cores though.

> which causes our ENABLE_C1E_MASK check to be true and thus properly 
> return 1 from the function. So when we call the above function from 
> init_amd we prolly need to do a
> 
>   set_bit(X86_FEATURE_LAPIC_TIMER_BROKEN, c->x86_capability);
> 
> for each core if any of them happen to return true upon checking for a 
> broken timer.

It's better to just make it a global instead.

-Andi
