Return-Path: <linux-kernel-owner+w=401wt.eu-S1752468AbYIXMbT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752468AbYIXMbT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 08:31:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751054AbYIXMbL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 08:31:11 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:34631 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750875AbYIXMbK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 08:31:10 -0400
Date: Wed, 24 Sep 2008 14:30:55 +0200
From: Sebastien Dugue <sebastien.dugue@bull.net>
To: Milton Miller <miltonm@bga.com>
Cc: Jan-Bernd Themann <ossthema@de.ibm.com>,
       Christoph Raisch <RAISCH@de.ibm.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH HACK] powerpc: quick hack to get a functional eHEA with
 hardirq preemption
Message-ID: <20080924143055.6102f317@bull.net>
In-Reply-To: <200809240958.m8O9wM7k010996@sullivan.realtime.net>
References: <200809231743.23828.ossthema@de.ibm.com>
 <20080915100406.342e027a@bull.net>
 <200809240958.m8O9wM7k010996@sullivan.realtime.net>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.2; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


  Hi Milton,

On Wed, 24 Sep 2008 04:58:22 -0500 (CDT) Milton Miller <miltonm@bga.com> wrote:

> Jan-Bernd wrote:
> > Ben, can you / your team look into the implementation
> > of the set_irq_type functionality needed for XICS?
> 
> I'm not volunteering to look at or implement any changes for how xics
> works with generic irq, but I'm trying to understand what the rt kernel
> is trying to accomplish with this statement:
> 
> On Mon Sep 15 at 18:04:06 EST in 2008, Sebastien Dugue wrote:
> > When entering the low level handler, level sensitive interrupts are
> > masked, then eio'd in interrupt context and then unmasked at the
> > end of hardirq processing.  That's fine as any interrupt comming
> > in-between will still be processed since the kernel replays those
> > pending interrupts.
> 
> Is this to generate some kind of software managed nesting and priority
> of the hardware level interrupts?

  No, not really. This is only to be sure to not miss interrupts coming
from the same source that were received during threaded hardirq processing.
Some instrumentation showed that it never seems to happen in the eHEA
interrupt case, so I think we can forget this aspect.

  Also, the problem only manifests with the eHEA RX interrupt. For example,
the IBM Power Raid (ipr) SCSI exhibits absolutely no problem under an RT
kernel. From this I conclude that:

  IPR - PCI - XICS is OK
  eHEA - IBMEBUS - XICS is broken with hardirq preemption.

  I also checked that forcing the eHEA interrupt to take the non threaded
path does work.


  Here is a side by side comparison of the fasteoi flow with and without hardirq
threading (sorry it's a bit wide)


					fasteoi flow:
					------------

	Non threaded hardirq			|			threaded hardirq
						|
   interrupt context				|	   interrupt context		hardirq thread
   -----------------				|	   -----------------		--------------
						|
						|
clear IRQ_REPLAY and IRQ_WAITING		|	clear IRQ_REPLAY and IRQ_WAITING
						|
increment percpu interrupt count		|	increment percpu interrupt count
						|
if no action or IRQ_INPROGRESS or IRQ_DISABLED	|	if no action or IRQ_INPROGRESS or IRQ_DISABLED
						|
  set IRQ_PENDING				|	  set IRQ_PENDING
						|
  mask						|	  mask
						|
  eoi						|	  eoi
						|
  done						|	  done
						|
set IRQ_INPROGRESS				|	set IRQ_INPROGRESS
						|
						|
						|	wakeup IRQ thread
						|
						|	mask
						|
						|	eoi
						|
						|	done		     --
						|			       \
						|				\
						|				 \
						|				  --> loop
						|
clear IRQ_PENDING				|				        clear IRQ_PENDING
						|
call handle_IRQ_event				|				        call handle_IRQ_event
						|
						|					check for prempt
						|
						|				      until IRQ_PENDING cleared
						|
						|
clear IRQ_INPROGRESS				|				      clear IRQ_INPROGRESS
						|
if not IRQ_DISABLED				|				      if not IRQ_DISABLED
						|
  unmask					|				        unmask
						|
eoi						|
						|
done						|




  the non-threaded flow does (in interrupt context):

    mask
    handle interrupt
    unmask
    eoi

  the threaded flow does:

    mask
    eoi
		handle interrupt
		unmask

  If I remove the mask() call, then the eHEA is no longer hanging.

> 
> The reason I ask is the xics controller can do unlimited nesting
> of hardware interrupts.  In fact, the hardware has 255 levels of
> priority, of which 16 or so are reserved by the hypervisor, leaving
> over 200 for the os to manage.  Higher numbers are lower in priority,
> and the hardware will only dispatch an interrupt to a given cpu if
> it is currenty at a lower priority.  If it is at a higher priority
> and the interrupt is not bound to a specific cpu it will look for
> another cpu to dispatch it.  The hardware will not re-present an
> irq until the it is EOId (managed by a small state machine per
> interrupt at the source, which also handles no cpu available try
> again later), but software can return its cpu priority to the
> previous level to recieve other interrupt sources at the same level.
> The hardware also supports lazy update of the cpu priority register
> when an interrupt is presented; as long as the cpu is hard-irq
> enabled it can take the irq then write is real priority and let the
> hw decide if the irq is still pending or it must defer or try another
> cpu in the rejection scenerio.  The only restriction is that the
> EOI can not cause an interrupt reject by raising the priority while
> sending the EOI command.
> 
> The per-interrupt mask and unmask calls have to go through RTAS, a
> single-threaded global context, which in addition to increasing
> path length will really limit scalability.  The interrupt controller
> poll and reject facilities are accessed through hypervisor calls
> which are comparable to a fast syscall, and parallel to all cpus.
> 
> We used to lower the priority to allow other interrupts in, but we
> realized that in addition to the questionable latency in doing so,
> it only caused unlimited stack nesting and overflow without per-irq
> stacks.  We currently set IPIs above other irqs so we typically
> only process them during a hard irq (but we return to base level
> after IPI and could take another base irq, a bug).
> 
> 
> So, Sebastien, with this information, is does the RT kernel have
> a strategy that better matches this hardware?

  Don't think so. I think that the problem may be elsewhere as
everything is fine with PCI devices (well at least SCSI).

  As I said earlier in another mail, it seems that the eHEA
is behaving as if it was generating edge interrupts which do not
support masking. Don't know.

  Thanks a lot for the explanation, looks like the xics + hypervisor
combo is way more complex than I thought.

  Sebastien.

> 
> milton
> 
