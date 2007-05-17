Return-Path: <linux-kernel-owner+w=401wt.eu-S1762286AbXEQUda@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762286AbXEQUda (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 16:33:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756626AbXEQUdY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 16:33:24 -0400
Received: from www.osadl.org ([213.239.205.134]:48484 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755837AbXEQUdX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 16:33:23 -0400
Subject: RE: bug seen with dynticks from CONFIG_HARDIRQS_SW_RESEND
From: Thomas Gleixner <tglx@linutronix.de>
To: "Woodruff, Richard" <r-woodruff2@ti.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <3B6D69C3A9EBCA4BA5DA60D913027429010258E8@dlee13.ent.ti.com>
References: <3B6D69C3A9EBCA4BA5DA60D913027429010253CD@dlee13.ent.ti.com>
	 <1179396659.3764.40.camel@chaos>
	 <3B6D69C3A9EBCA4BA5DA60D913027429010258E8@dlee13.ent.ti.com>
Content-Type: text/plain
Date: Thu, 17 May 2007 22:38:16 +0200
Message-Id: <1179434296.12981.14.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-05-17 at 15:14 -0500, Woodruff, Richard wrote:
> > which code is disabling / enabling the timer interrupt ?
> 
> - No one in this case is calling enable_irq(#timer). The failure is
> triggered from a non-tick-related enable_irq(#x). The function
> handle_IRQ_event() always calls handle_dynamic_tick(). Thus every real
> interrupt or fake interrupt though resend_irq will touch the timer code
> paths.
> 
> To better describe:
>   -0- Users space does an ioctl to driver
>   -1- This driver calls enable_irq(#x)
>   -2- This triggers a check_irq_resend()
>   -3- This causes a tasklet schedule of the resend_tasklet for #x
>   -4- This driver later does a spin_unlock_bh
>   -5- This triggers a check for softirq/tasklets
>   -6- The resend_tasklet is run and calls desc->handle_irq
>   -7- This calls handle_level_irq
>   -8- This calls handle_IRQ_event
>   -9- This first calls handle_dynamic_tick

This is the original ARM dyntick stuff, right ?

The dyntick support on your architecture is broken. Why does it fiddle
with the timer, when the system is not idle ?

This stuff should go away ASAP. A lot of ARMs are already converted to
clock events are using the generic NOHZ implementation, which does not
have those problems at all.

	tglx



