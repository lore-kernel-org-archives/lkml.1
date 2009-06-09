Return-Path: <linux-kernel-owner+w=401wt.eu-S1760751AbZFIMzq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760751AbZFIMzq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 08:55:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757848AbZFIMzi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 08:55:38 -0400
Received: from khc.piap.pl ([195.187.100.11]:39223 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757620AbZFIMzi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 08:55:38 -0400
To: <linux-kernel@vger.kernel.org>, linux-serial@vger.kernel.org
Cc: Lee Howard <lee.howard@mainpine.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Oxford 16954 UART capabilities
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Tue, 09 Jun 2009 14:55:37 +0200
Message-ID: <m3eittlg6u.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm using a quadruple UART card based on Oxford's OX16PCI954 chip. There
is a message about a capability mismatch for which I no longer have
enough patience to ignore:

Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
serial 0000:04:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
ttyS0: detected caps 00000700 should be 00000100
0000:04:00.0: ttyS0 at I/O 0xec00 (irq = 16) is a 16C950/954
ttyS1: detected caps 00000700 should be 00000100
0000:04:00.0: ttyS1 at I/O 0xec08 (irq = 16) is a 16C950/954
ttyS2: detected caps 00000700 should be 00000100
0000:04:00.0: ttyS2 at I/O 0xec10 (irq = 16) is a 16C950/954
ttyS3: detected caps 00000700 should be 00000100
0000:04:00.0: ttyS3 at I/O 0xec18 (irq = 16) is a 16C950/954

I'm not sure what's the problem:

8250.h:
#define UART_CAP_FIFO  (1 << 8)        /* UART has FIFO */
#define UART_CAP_EFR   (1 << 9)        /* UART has EFR */
#define UART_CAP_SLEEP (1 << 10)       /* UART has IER sleep */

8250.c (uart_config[]):

        [PORT_16C950] = {
                .name           = "16C950/954",
                .fifo_size      = 128,
                .tx_loadsz      = 128,
                .fcr            = UART_FCR_ENABLE_FIFO | UART_FCR_R_TRIG_10,
                .flags          = UART_CAP_FIFO,
        },

...

/*
 * This is a helper routine to autodetect StarTech/Exar/Oxsemi UART's.
 * When this function is called we know it is at least a StarTech
 * 16650 V2, but it might be one of several StarTech UARTs, or one of
 * its clones.  (We treat the broken original StarTech 16650 V1 as a
 * 16550, and why not?  Startech doesn't seem to even acknowledge its
 * existence.)
 *
 * What evil have men's minds wrought...
 */
static void autoconfig_has_efr(struct uart_8250_port *up)
{
        unsigned int id1, id2, id3, rev;

        /*
         * Everything with an EFR has SLEEP
         */
        up->capabilities |= UART_CAP_EFR | UART_CAP_SLEEP;

then for OX 16950 it does:
        up->port.type = PORT_16C950;
        return;

so the above CAP_EFR | CAP_SLEEP stay set.

Should autoconfig_has_efr() clear these bits, or are the caps in
uart_config[] incorrect?

The datasheet lists bit 4 of IER register as "sleep mode". The EFR is
enabled by writing 0xBF to LCR which seem consistent with the driver
code.

Should we just add UART_CAP_EFR and _SLEEP to uart_config[PORT_16C950]?
-- 
Krzysztof Halasa
