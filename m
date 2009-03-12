Return-Path: <linux-kernel-owner+w=401wt.eu-S1756695AbZCLR6w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756695AbZCLR6w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 13:58:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756122AbZCLR6k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 13:58:40 -0400
Received: from mx2.redhat.com ([66.187.237.31]:57149 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754126AbZCLR6j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 13:58:39 -0400
To: linux-kernel@vger.kernel.org
Cc: linux-serial@vger.kernel.org,
       "xen-devel\@lists.xensource.com" <xen-devel@lists.xensource.com>,
       Ian Jackson <Ian.Jackson@eu.citrix.com>,
       Anders Kaseorg <andersk@MIT.EDU>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] IRQ handling race and spurious IIR read in serial/8250.c
From: Markus Armbruster <armbru@redhat.com>
Date: Thu, 12 Mar 2009 18:57:27 +0100
Message-ID: <874oxyei9k.fsf@pike.pond.sub.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ian Jackson <ian.jackson@eu.citrix.com>

Do not read IIR in serial8250_start_tx when UART_BUG_TXEN

Reading the IIR clears some oustanding interrupts so it is not safe.
Instead, simply transmit immediately if the buffer is empty without
regard to IIR.

Signed-off-by: Ian Jackson <ian.jackson@eu.citrix.com>
Reviewed-by: Markus Armbruster <armbru@redhat.com>

---
Ian Jackson recently debugged a problem reported by Anders Kaseorg, and
posted a fix (see http://lkml.org/lkml/2009/2/11/240).  As far as I can
see, the patch has been dropped on the floor.

I also experienced the problem, and Ian's patch fixes it for me.

The bug bites Xen HVM guests.  Output to the serial console stalls until
some input happens.  As Ian's analysis quoted below shows, it is a race
condition that could theoretically bite elsewhere as well.

Ian Jackson explained:
> The bugs in detail (this discussion applies to 2.6.20 and also to
> 2.6.28.4):
>
>  1. The hunk of serial8250_startup I quote below attempts to discover
>     whether writing the IER re-asserts the THRI (transmit ready)
>     interrupt.  However the spinlock that it has taken out,
>     port->lock, is not the one that the IRQ service routine takes
>     before reading the IIR (i->lock).  As a result, on an SMP system
>     the generated interrupt races with the straight-line code in
>     serial8250_startup.
>
>     If serial8250_startup loses the race (perhaps because the system
>     is a VM and its VCPU got preempted), UART_BUG_TXEN is spuriously
>     added to bugs.  This is quite unlikely in a normal system but in
>     certain Xen configurations, particularly ones where there is CPU
>     pressure, we may lose the race every time.
>
>     It is not exactly clear to me how this ought to be resolved.  One
>     possibility is that the UART_BUG_TXEN problem might be worked
>     around perfectly well by the new and very similar workaround
>     UART_BUG_THRE[1] in 2.6.21ish in which case it could just be
>     removed.
>      2. UART_BUG_TXEN's workaround appears to be intended to be
> harmless.
>     However what it actually does is to read the IIR, thus clearing
>     any actual interrupt (including incidentally non-THRI), and then
>     only perform the intended servicing if the interrupt was _not_
>     asserted.  That is, it breaks on any serial port with the bug.
>
>     As far as I can see there is not much use in UART_BUG_TXEN reading
>     IIR at all, so a suitable change if we want to keep UART_BUG_TXEN
>     might be the first patch I enclose below (again, not compiled
>     or tested).
>
>     If UART_BUG_TXEN is retained something along these lines should be
>     done at the very least.
>
> Ian.
>
> [1] http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=40b36daad0ac704e6d5c1b75789f371ef5b053c1
>     in which case UART

--- ../linux-2.6.28.4/drivers/serial/8250.c~	2009-02-06 21:47:45.000000000 +0000
+++ ../linux-2.6.28.4/drivers/serial/8250.c	2009-02-11 15:55:24.000000000 +0000
@@ -1257,14 +1257,12 @@
 		serial_out(up, UART_IER, up->ier);
 
 		if (up->bugs & UART_BUG_TXEN) {
-			unsigned char lsr, iir;
+			unsigned char lsr;
 			lsr = serial_in(up, UART_LSR);
 			up->lsr_saved_flags |= lsr & LSR_SAVE_FLAGS;
-			iir = serial_in(up, UART_IIR) & 0x0f;
 			if ((up->port.type == PORT_RM9000) ?
-				(lsr & UART_LSR_THRE &&
-				(iir == UART_IIR_NO_INT || iir == UART_IIR_THRI)) :
-				(lsr & UART_LSR_TEMT && iir & UART_IIR_NO_INT))
+				(lsr & UART_LSR_THRE) :
+				(lsr & UART_LSR_TEMT))
 				transmit_chars(up);
 		}
 	}


