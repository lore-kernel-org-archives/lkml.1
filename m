Return-Path: <linux-kernel-owner+w=401wt.eu-S933219AbYF3WNm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933219AbYF3WNm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 18:13:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761864AbYF3WNd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 18:13:33 -0400
Received: from gate.crashing.org ([63.228.1.57]:59877 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760284AbYF3WNc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 18:13:32 -0400
Subject: Re: [RT] MPIC edge sensitive issues with hardirq preemption (was:
	Re: [PATCH v2 -rt] ide: workaround buggy hardware issues with preemptable
	hardirqs)
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: avorontsov@ru.mvista.com
Cc: Ingo Molnar <mingo@elte.hu>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Sergei Shtylyov <sshtylyov@ru.mvista.com>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>,
       Daniel Walker <dwalker@mvista.com>
In-Reply-To: <20080630190132.GA6492@polina.dev.rtsoft.ru>
References: <20080623234037.GA6793@polina.dev.rtsoft.ru>
	 <20080623235141.GB17297@elte.hu>
	 <20080624000016.GA12547@polina.dev.rtsoft.ru>
	 <20080625123431.GA25452@polina.dev.rtsoft.ru>
	 <20080628005436.GA1956@polina.dev.rtsoft.ru>
	 <1214781974.20711.7.camel@pasglop>
	 <20080630190132.GA6492@polina.dev.rtsoft.ru>
Content-Type: text/plain
Date: Tue, 01 Jul 2008 07:59:57 +1000
Message-Id: <1214863197.20711.57.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 	
> Thanks for the idea. With hardirq preempton, fasteoi path does not replay
> edge interrupts indeed (at least for MPIC).
> 
> Here how I tested this: I have external interrupt connected to the button
> on this board, thus I registered irq handler which is doing exactly this
> (irq is edge sensitive):
> 
> printk("handled\n"); mdelay(2000);
> 
> Without hardirq preemption: pressing button twice prints two messages.
> With hardirq preemption: pressing button twice prints just one message.
> 
> This happens because:
> - irq has come;
> - fasteoi handler mask()s it, and wakes up the thread;

Do we eoi first ? We should.

> - thread calls irq handler;
> - another IRQ is coming, but MPIC's IRQ is still masked and MPIC does not
>   see it.
> - thread unmasks the IRQ, second IRQ got lost.
>
> But how this could be a bug in the PIC code? IMO this is a bug in the
> kernel/irq code, since it assumes that fasteoi PIC will retrigger masked
> edge sources... This isn't true for at least MPIC. To make this work for
> all fasteoi PICs, we should mask edge sensitive interrupts very very
> carefully.

Well, retriggering of edge irqs while masked is some new "assumption"
that I deduced from your explanations of how RT works and indeed is not
provided by most PICs which will disable edge detection on masked
interrupts...

I'll double check if the MPIC/OpenPIC spec says anything about this.

I think it's a bug in the RT code to assume that. It should not mask
edge interrupts basically. That does mean that it would have to
differenciate edge and level, and thus can't use the same fasteoi
handler for both I suppose...

> Also...
> 
> I found that I completely messed with MPIC's sense types: my brain was
> jammed with the idea that MPIC irq type 0 is low level sensitive, but the
> true thing is that it is rising edge sensitive. (Ah, I know where I got
> confused, type 0 is active-low for ISA PICs).
> 
> So in all my previous emails I was wrong when I was saying "mpic is
> programmed to low level sensitive". It was programmed for rising edge
> sensitive. An all my further reasonings were flawed because of this.
> 
> Re-programming MPIC to high level sensitive also makes IDE work. But
> this doesn't mean that IRQ code is correct.
> 
> So, in the end, this isn't IDE issue... Much thanks to everyone for
> ideas and help... instead of one bug, it seems I've found two. :-)
> None in the IDE code.
> 
> 
> Following patch fixes MPIC edge sensitive interrupts processing with
> hardirqs preemption.
> 
> We're still using handle_fasteoi_irq, but passing control to
> thread_edge_irq if interrupt is edge sensitive. Otherwise usual fasteoi
> path handles the IRQ.
> 
> Plys, we're masking edge interrupt _and_ marking it as pending and masked
> only if we're already handling one (exactly as we do with !preemptable
> hardirqs). And the trick is that thread_edge_irq() will unmask it before
> executing handle_IRQ_event.
> 
> 
> So here is the patch, how does it look?
> 
> (quite weird that I have to pass irq trigger flags to desc->status,
> but really, there is no other way. it seems safe though, because
> all irqactions should conform only to one trigger type).

I'll let Thomas and Ingo provide feedback here...

Ben.

