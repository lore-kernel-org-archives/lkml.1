Return-Path: <linux-kernel-owner+w=401wt.eu-S1761439AbXEQU3i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761439AbXEQU3i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 16:29:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756857AbXEQU3a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 16:29:30 -0400
Received: from soda.ext.ti.com ([198.47.26.145]:52401 "EHLO soda.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754614AbXEQU33 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 16:29:29 -0400
X-Greylist: delayed 781 seconds by postgrey-1.27 at vger.kernel.org; Thu, 17 May 2007 16:29:14 EDT
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: bug seen with dynticks from CONFIG_HARDIRQS_SW_RESEND
Date: Thu, 17 May 2007 15:14:09 -0500
Message-ID: <3B6D69C3A9EBCA4BA5DA60D913027429010258E8@dlee13.ent.ti.com>
In-Reply-To: <1179396659.3764.40.camel@chaos>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: bug seen with dynticks from CONFIG_HARDIRQS_SW_RESEND
Thread-Index: AceYawm96zmPkx+xQPyvXHEVB8xx9AASDDow
References: <3B6D69C3A9EBCA4BA5DA60D913027429010253CD@dlee13.ent.ti.com> <1179396659.3764.40.camel@chaos>
From: "Woodruff, Richard" <r-woodruff2@ti.com>
To: "Thomas Gleixner" <tglx@linutronix.de>
Cc: <linux-kernel@vger.kernel.org>, "Ingo Molnar" <mingo@elte.hu>
X-OriginalArrivalTime: 17 May 2007 20:14:10.0424 (UTC) FILETIME=[EE1A8780:01C798BF]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Wed, 2007-05-16 at 18:20 -0500, Woodruff, Richard wrote:
> > The crashes were because the frame pointer per_cpu____irq_regs value
was
> > 0.  That code does a user_mode(get_irq_regs()).  Currently regs is
set
> > only upon real hardware entry on an irq.
> >
> > The crash path shows resend_irqs() could be called with in a context
> > where set_irq_regs() was not executed.  In one specific case this
was
> > from
> >
softirq->tasklet_action(resend_tasklet)->resend_irqs->handle_level_irq->
> > handle_IRQ_event->...->profile_tick.
> >
> > It seems anyone calling kernel/irq/manage.c:enable_irq() at the
wrong
> > time can trigger this crash.
> 
> which code is disabling / enabling the timer interrupt ?

- No one in this case is calling enable_irq(#timer). The failure is
triggered from a non-tick-related enable_irq(#x). The function
handle_IRQ_event() always calls handle_dynamic_tick(). Thus every real
interrupt or fake interrupt though resend_irq will touch the timer code
paths.

To better describe:
  -0- Users space does an ioctl to driver
  -1- This driver calls enable_irq(#x)
  -2- This triggers a check_irq_resend()
  -3- This causes a tasklet schedule of the resend_tasklet for #x
  -4- This driver later does a spin_unlock_bh
  -5- This triggers a check for softirq/tasklets
  -6- The resend_tasklet is run and calls desc->handle_irq
  -7- This calls handle_level_irq
  -8- This calls handle_IRQ_event
  -9- This first calls handle_dynamic_tick
  -A- This will call though the ticker code to tick update
  -B- Finally you die in profile_tick.
  -C- Boom in dereference of 0 from user_mode(regs)

As there was no real interrupt the frame marker for irq_regs was not set
and the system dies.  Entry was via trap from the ioctl, not irq do_irq.

A dummy non-zero frame allows it to work but doesn't give true
profiling.  The resend path seems generally unsafe today.  Why not set
it on traps?

Regards,
Richard W.

