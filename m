Return-Path: <linux-kernel-owner+w=401wt.eu-S1755339AbZDOTZB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755339AbZDOTZB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 15:25:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753445AbZDOTYv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 15:24:51 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53343 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753335AbZDOTYu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 15:24:50 -0400
Date: Wed, 15 Apr 2009 12:17:38 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: tglx@linutronix.de, yinghai@kernel.org, rusty@rustcorp.com.au,
       hpa@zytor.com, ebiederm@xmission.com, garyhade@us.ibm.com,
       lcm@us.ibm.com, venkatesh.pallipadi@intel.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] irq: correct CPUMASKS_OFFSTACK typo -v2
Message-Id: <20090415121738.8d1d750c.akpm@linux-foundation.org>
In-Reply-To: <20090415100105.GC6669@elte.hu>
References: <20090402013108.GB7103@us.ibm.com>
	<20090404003520.GA8847@us.ibm.com>
	<20090410215515.GC7242@us.ibm.com>
	<20090411065510.GA11799@elte.hu>
	<20090413220321.GA11098@us.ibm.com>
	<49E4146C.7060507@kernel.org>
	<49E4162A.3060701@kernel.org>
	<20090414131711.GA4403@elte.hu>
	<49E4F513.1060709@kernel.org>
	<20090414135958.36c79836.akpm@linux-foundation.org>
	<20090415100105.GC6669@elte.hu>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Apr 2009 12:01:05 +0200
Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > On Tue, 14 Apr 2009 13:41:55 -0700
> > Yinghai Lu <yinghai@kernel.org> wrote:
> > 
> > > irq
> > 
> > Speaking of which, could someone please take a look at
> > http://www.gossamer-threads.com/lists/linux/kernel/1060580?do=post_view_threaded#1060580
> > ?
> [...]
> 
> > But try_one_irq() is running tifm_7xx1_isr() with local interrupts 
> > enabled, which upsets lockdep.
> 
> It doesnt just upset lockdep, it could also cause real lockups. 

Only if the interrupt were to magically come back to life, then
trigger.  I think.  Possibly in the case of shared interrupts we'd lock
up because of an interrupt from another device.

> Lockdep is just the canary, the lockup is the methane explosion.
> 
> > But I suspect that the code as it stands is non-buggy. Unless the 
> > interrupt can magically come back to life. In which case any 
> > change we make is purely a make-lockdep-shut-up thing.
> 
> Hm, i'd suggest we go for the methane leak instead of squashing the 
> canary. Which in this case would be try_one_irq() ignoring 
> IRQF_DISABLED or so? Affecting (much) more ISRs than just 
> tifm_7xx1_isr()?

tifm_7xx1_isr() is requested with bare IRQF_SHARED, so that function is
supposed to be called with local interrupts enabled.

And indeed, try_one_irq() is calling it with local interrupts enabled. 
That gets lockdep upset.  I assume there's magic in lockdep somewhere
which recognises the case where a function is called in hard irq
context with local interrupts enabled and, knowing that the controller
won't generate another interrupt, treats this as
local-interrupt-disabled.  Or something.

I don't know how to fix this really.  We _could_ fudge it by disabling
local interrupts in try_one_irq().  But the ISR could legitimately do
(say) spin_unlock_irq() and muck everything up.

