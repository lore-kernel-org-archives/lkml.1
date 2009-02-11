Return-Path: <linux-kernel-owner+w=401wt.eu-S1757401AbZBKQIk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757401AbZBKQIk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 11:08:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755990AbZBKQIb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 11:08:31 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:45597 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755647AbZBKQIa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 11:08:30 -0500
X-IronPort-AV: E=Sophos;i="4.38,193,1233550800"; 
   d="scan'208";a="39444335"
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Message-ID: <18834.63479.700909.321686@mariner.uk.xensource.com>
Date: Wed, 11 Feb 2009 16:08:23 +0000
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Anders Kaseorg <andersk@MIT.EDU>,
       "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>
Subject: [PATCH] IRQ handling race and spurious IIR read in serial/8250.c
In-Reply-To: <alpine.DEB.2.00.0902101249181.20723@vinegar-pot.mit.edu>
References: <1233800599.5398.0.camel@balanced-tree>
	<18827.7191.646173.99255@mariner.uk.xensource.com>
	<1233862446.5676.28.camel@balanced-tree>
	<1233870772.5676.40.camel@balanced-tree>
	<18833.40557.119090.48930@mariner.uk.xensource.com>
	<alpine.DEB.2.00.0902101249181.20723@vinegar-pot.mit.edu>
X-Mailer: VM 7.19 under Emacs 21.4.1
From: Ian Jackson <Ian.Jackson@eu.citrix.com>
X-OriginalArrivalTime: 11 Feb 2009 16:08:28.0758 (UTC) FILETIME=[FA1BCF60:01C98C62]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Anders Kaseorg writes ("Re: Serial console hangs with Linux 2.6.20 HVM guest"):
> Yes, I took Linux v2.6.20 on amd64, ran `make defconfig`, then ran `make 
> menuconfig` and turned off CONFIG_HOTPLUG_CPU (Processor type and features 
> ò Support for hot-pluggable CPUs).

Thanks.  I think I have tracked down the bug.  In
drivers/serial/8250.c in Linux there are two bugs:
 1. UART_BUG_TXEN can be spuriously set, due to an IRQ race
 2. The workaround then applied by the kernel is itself buggy

Anders: can you try two tests for me ?  Firstly, in
serial8250_startup, delete the section which sets UART_BUG_TXEN (see
2nd patch below); I think this will fix the symptoms for you.
Secondly, in serial8250_start_tx delete the read from the IIR and the
relevant branch of the text (see 3rd patch below); I think this will
also in itself fix your symptoms.  I haven't compiled either patch (so
you may find that eg I missed deleting some variables).


The bugs in detail (this discussion applies to 2.6.20 and also to
2.6.28.4):

 1. The hunk of serial8250_startup I quote below attempts to discover
    whether writing the IER re-asserts the THRI (transmit ready)
    interrupt.  However the spinlock that it has taken out,
    port->lock, is not the one that the IRQ service routine takes
    before reading the IIR (i->lock).  As a result, on an SMP system
    the generated interrupt races with the straight-line code in
    serial8250_startup.

    If serial8250_startup loses the race (perhaps because the system
    is a VM and its VCPU got preempted), UART_BUG_TXEN is spuriously
    added to bugs.  This is quite unlikely in a normal system but in
    certain Xen configurations, particularly ones where there is CPU
    pressure, we may lose the race every time.

    It is not exactly clear to me how this ought to be resolved.  One
    possibility is that the UART_BUG_TXEN problem might be worked
    around perfectly well by the new and very similar workaround
    UART_BUG_THRE[1] in 2.6.21ish in which case it could just be
    removed.
    
 2. UART_BUG_TXEN's workaround appears to be intended to be harmless.
    However what it actually does is to read the IIR, thus clearing
    any actual interrupt (including incidentally non-THRI), and then
    only perform the intended servicing if the interrupt was _not_
    asserted.  That is, it breaks on any serial port with the bug.

    As far as I can see there is not much use in UART_BUG_TXEN reading
    IIR at all, so a suitable change if we want to keep UART_BUG_TXEN
    might be the first patch I enclose below (again, not compiled
    or tested).

    If UART_BUG_TXEN is retained something along these lines should be
    done at the very least.

Ian.

[1] http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=40b36daad0ac704e6d5c1b75789f371ef5b053c1
    in which case UART


Proposed initial band-aid fix (against 2.6.28.4):


Do not read IIR in serial8250_start_tx when UART_BUG_TXEN

Reading the IIR clears some oustanding interrupts so it is not safe.
Instead, simply transmit immediately if the buffer is empty without
regard to IIR.

Signed-off-by: Ian Jackson <ian.jackson@eu.citrix.com>

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


Anders - first patch to try (against 2.6.20):

--- drivers/serial/8250.c~	2007-02-04 18:44:54.000000000 +0000
+++ drivers/serial/8250.c	2009-02-11 15:39:43.000000000 +0000
@@ -1645,25 +1645,6 @@
 
 	serial8250_set_mctrl(&up->port, up->port.mctrl);
 
-	/*
-	 * Do a quick test to see if we receive an
-	 * interrupt when we enable the TX irq.
-	 */
-	serial_outp(up, UART_IER, UART_IER_THRI);
-	lsr = serial_in(up, UART_LSR);
-	iir = serial_in(up, UART_IIR);
-	serial_outp(up, UART_IER, 0);
-
-	if (lsr & UART_LSR_TEMT && iir & UART_IIR_NO_INT) {
-		if (!(up->bugs & UART_BUG_TXEN)) {
-			up->bugs |= UART_BUG_TXEN;
-			pr_debug("ttyS%d - enabling bad tx status workarounds\n",
-				 port->line);
-		}
-	} else {
-		up->bugs &= ~UART_BUG_TXEN;
-	}
-
 	spin_unlock_irqrestore(&up->port.lock, flags);
 
 	/*


Anders - second patch to try (against 2.6.20):
Fix should be suitable for distribution IMO.

Signed-off-by: Ian Jackson <ian.jackson@eu.citrix.com>

--- drivers/serial/8250.c~	2007-02-04 18:44:54.000000000 +0000
+++ drivers/serial/8250.c	2009-02-11 15:41:51.000000000 +0000
@@ -1136,10 +1136,9 @@
 		serial_out(up, UART_IER, up->ier);
 
 		if (up->bugs & UART_BUG_TXEN) {
-			unsigned char lsr, iir;
+			unsigned char lsr;
 			lsr = serial_in(up, UART_LSR);
-			iir = serial_in(up, UART_IIR);
-			if (lsr & UART_LSR_TEMT && iir & UART_IIR_NO_INT)
+			if (lsr & UART_LSR_TEMT)
 				transmit_chars(up);
 		}
 	}

