Return-Path: <linux-kernel-owner+w=401wt.eu-S1757512AbZCBTHv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757512AbZCBTHv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 14:07:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751948AbZCBTHm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 14:07:42 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45252 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750910AbZCBTHl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 14:07:41 -0500
Date: Mon, 2 Mar 2009 11:06:39 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       lkml <linux-kernel@vger.kernel.org>,
       linux-arch <linux-arch@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC][PATCH] irq: remove IRQF_DISABLED
In-Reply-To: <200903021948.51500.bzolnier@gmail.com>
Message-ID: <alpine.LFD.2.00.0903021101460.3111@localhost.localdomain>
References: <1235996477.5330.174.camel@laptop> <200903021855.02765.bzolnier@gmail.com> <alpine.LFD.2.00.0903021012080.3111@localhost.localdomain> <200903021948.51500.bzolnier@gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 2 Mar 2009, Bartlomiej Zolnierkiewicz wrote:
>
> Hmm, I said nothing about how it is implemented in the IDE code itself. :)

Bart, you're missing the point. I'm _also_ not at all interested in how 
it's implemented in the IDE code.

The whole - and only - point is that there are drivers that are _known_ to 
require non-IRQF_DISABLED semantics. IDE is one such one.

> Fixing this is on long-term TODO (there was just a ton of more high-prio
> stuff to take care of first).

Even if you can fix IDE to do everything using softirq's or other tricks 
(threads, whatever), nothing really changes. It just means that now there 
is one less driver that may need the non-IRQF_DISABLED semantics.

So I'm perfectly happy with

 - making IRQF_DISABLED the _default_ (and make the value of the flag be 
   0, for example, so that people can still _use_ it)

 - but when we find a driver that depended on irq's being on, have a new 
   flag like IRQF_REENABLE, which has the semantics of the current default 
   of !IRQF_DISABLED

but I don't think it's reasonable to just drop the support. IDE requires 
it, and it's been a known requirement for basically forever. Other drivers 
with similar issues? Who the heck knows? 

I do know that the _generic_ SCSI layer used to have some insane reset 
timeouts inside the interrupt handler, and literally *depended* on timer 
interrupts happening while inside the SCSI interrupt. I'm hoping that's no 
longer the case. But this is the kind of thing that has been going on.

			Linus
