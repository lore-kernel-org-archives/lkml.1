Return-Path: <linux-kernel-owner+w=401wt.eu-S1762110AbZE2UHQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762110AbZE2UHQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 May 2009 16:07:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760352AbZE2UHG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 May 2009 16:07:06 -0400
Received: from yw-out-2324.google.com ([74.125.46.28]:62157 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753704AbZE2UHF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 May 2009 16:07:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=ojjk8eRyD68Zadum276PS3ON8Fhh6/UX7u3cCbC6WiSWjsglt7jf5D4kRs4ET6qzvM
         5Uz9X9vIrumRll0hzJphzEbLrKwzZxw8q7mCR8CaBmTqEJTRN6rrUnULEcbJLKcqIljv
         uPeN+HBtCZ917HeOOb5qoZRTcxEf+LF8rau7A=
MIME-Version: 1.0
Date: Fri, 29 May 2009 17:07:06 -0300
Message-ID: <d970ff420905291307p62e9c6eck772e7ee3757ee44a@mail.gmail.com>
Subject: MPC8343 - serial8250: too much work
From: Alemao <xcarandiru@gmail.com>
To: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Im facing some problems with serial, linux-2.6.23, getting flooded
with this message in logs:

---
serial8250: too much work for irq16
---

Something I notice, in my .dts I have the following lines:

serial0: serial@4500,  interrupts   =  <9  0x8>
serial1: serial@4600,  interrupts   =  <10 0x8>
spi:       spi@7000,     interrupts   =  <16 0x8>


But when kernel starts:

---
Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
serial8250.0: ttyS0 at MMIO 0xe0004500 (irq = 16) is a 16550A
---

Why IRQ 16? Shouldn't it be IRQ 9?

I traced functions calls in 8250.c driver:

---
serial8250_interrup() -> serial8250_handle_port() -> transmit_chars()
---

"too much work" is for transmiting, but there's nothing to transmit.

In my MPC8343 board I have only serial0 connected to a MAX3232, serial1
is floating.

I found this comments in linux/drivers/serial/8250.h, and tried to use
same defines that they used, but no success:

/*
 * Digital did something really horribly wrong with the OUT1 and OUT2
 * lines on at least some ALPHA's.  The failure mode is that if either
 * is cleared, the machine locks up with endless interrupts.
 */

/*
 * WindRiver did something similarly broken on their SBC8560 board. The
 * UART tristates its IRQ output while OUT2 is clear, but they pulled
 * the interrupt line _up_ instead of down, so if we register the IRQ
 * while the UART is in that state, we die in an IRQ storm.
 */


I also tried removing serial1 and spi from .dts, but didn't work.

Any sugestions?

Cheers,

--
Alemao
