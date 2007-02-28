Return-Path: <linux-kernel-owner+w=401wt.eu-S1752063AbXB1IvY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752063AbXB1IvY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Feb 2007 03:51:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752065AbXB1IvY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Feb 2007 03:51:24 -0500
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:11037 "EHLO
	pd2mo2so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752063AbXB1IvX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Feb 2007 03:51:23 -0500
Date: Wed, 28 Feb 2007 00:51:18 -0800 (PST)
From: Zwane Mwaikambo <zwane@infradead.org>
Subject: Re: [patch 00/21] 2.6.19-stable review
In-reply-to: <m1lkiikcth.fsf@ebiederm.dsl.xmission.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Chuck Ebbert <cebbert@redhat.com>, Andi Kleen <ak@suse.de>,
       Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
       stable@kernel.org, Justin Forbes <jmforbes@linuxtx.org>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, alan@lxorguk.ukuu.org.uk
Message-id: <Pine.LNX.4.64.0702272312580.2632@montezuma.windriver.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
References: <20070221013619.GA30227@kroah.com> <45DC9E1D.40805@redhat.com>
 <20070221114737.a09be761.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0702211208500.4043@woody.linux-foundation.org>
 <m1lkiikcth.fsf@ebiederm.dsl.xmission.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Feb 2007, Eric W. Biederman wrote:

> > http://www.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.20/2.6.20-mm2/broken-out/x86_64-mm-handle-irqs-pending-in-irr-during-irq-migration.patch
> >> 
> >> That's mainly an Andi decision.  Let's cc him.
> >
> > Would be good to have Eric also ack them as safe and obvious.
> >
> > Btw, that latter one has corrupted sign-offs from Andi (it's in the middle 
> > of the text, very confusing).
> 
> There are two questions.
> 1) What can we do to make the situation better.
> 2) Is the hole completely plugged.
> 
> When I wrote the patch I had the local apic priorities backwards in my
> head.  So apic_in_service_vector can return the wrong value if two
> irqs are in service.  Now I don't think we allows ourselves to enable
> interrupts in an interrupt service routing until after we have acked
> the local apic so this should be harmless.  The fix is also trivial
> of just having apic_in_service_vector return: "~get_irq_regs()->orig_rax".
> 
> Except for that one possible problem everything I can think of are
> just theoretical cracks at this point, and they don't make the
> situation any worse.
> 
> Given that this patch has appears to have undergone a noticeable
> amount of testing, by people other than myself, and clears up the
> symptoms.  I have no problem 

Hi Eric,
	Thanks for getting this cruft cleaned up. I have a few comments 
regarding;

handle-irqs-pending-in-irr-during-irq-migration.patch

1) It relies on checking the IRR, this could race with the corresponding 
vector bit being set by hardware.

2) apic_handle_pending_vector is oddly named since it doesn't actually 
handle a pending vector but drops it if it has been freed.

3) It looks complex

So how about the following scheme. Add a check in do_IRQ whether the irq's 
domain contains the current cpu, if not we free the vector upon handler 
completion.

Cheers,
	Zwane
