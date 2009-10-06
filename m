Return-Path: <linux-kernel-owner+w=401wt.eu-S1756214AbZJFHzi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756214AbZJFHzi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 03:55:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756142AbZJFHzh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 03:55:37 -0400
Received: from atlantis.8hz.com ([212.129.237.78]:59420 "EHLO atlantis.8hz.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756117AbZJFHzh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 03:55:37 -0400
X-Greylist: delayed 899 seconds by postgrey-1.27 at vger.kernel.org; Tue, 06 Oct 2009 03:55:36 EDT
Date: Tue, 6 Oct 2009 07:32:33 +0000
From: Sean Young <sean@mess.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>,
       linux-kernel@vger.kernel.org, jesse.barnes@intel.com
Subject: Re: [RFC/PATCH] Winbond CIR driver for the WPCD376I chip (ACPI/PNP id WEC1022)
Message-ID: <20091006073233.GA66182@atlantis.8hz.com>
References: <20090624213645.GA18843@hardeman.nu> <20090624234501.3d35642f@lxorguk.ukuu.org.uk> <55ca74318001aae803805a7bccfaca36.squirrel@www.hardeman.nu> <20090625134946.46109bac@lxorguk.ukuu.org.uk> <c17c39d3458ffa3aebee03ff26d90c23.squirrel@www.hardeman.nu> <20090625141752.740e081d@lxorguk.ukuu.org.uk> <a4495505aea6a06643c8072fd790fb5d.squirrel@www.hardeman.nu> <20090625143533.19ff85e5@lxorguk.ukuu.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090625143533.19ff85e5@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 25, 2009 at 02:35:33PM +0100, Alan Cox wrote:
> On Thu, 25 Jun 2009 15:28:31 +0200 (CEST)
> David Härdeman <david@hardeman.nu> wrote:
> > On Thu, June 25, 2009 15:17, Alan Cox wrote:
> > >> Which way of stopping the serial layer from grabbing the port did you
> > >> have in mind?
> > >
> > > You can vanish it with setserial as stands. There isn't a good
> > > interface for doing that from kernel side but as you can see from
> > > setserial the infrastructure is all there to add it.
> > 
> > Seems user-unfriendly...wouldn't blacklisting that particular port (using
> > ACPI or PNP id or something) be a better solution?
> 
> Possibly - what I am saying is that the mechanisms exist internally for
> this including flipping a port at run time between IR and normal modes
> when appropriate

Thanks to the documentation Jesse Barnes provided me:

This particular "serial port" is a bastardised serial port. From a 
software perspective it looks like a serial port with extensions, but 
it can only function as an IR device to the physical world (there are no 
uart pins for this port on the superio chip). So there is no reason 
to flip to "uart" mode.

Due to the extensions it can't be used with just the serial interface; 
some functions won't be available to userspace.

The problem here is that arch/x86/include/asm/serial.h defines 
SERIAL_PORT_DFN, which lists the four serial ports which are detected 
in serial8250_isa_init_ports(). The bastardised IR serial port is 
detected as a serial port and then cannot be claimed by the winbond-cir 
driver.

There is a real serial port on this superio chip which is accurately 
described by PNP. Should we really be guessing what hardware is present
and then getting a false positive on modern x86 hardware?

Alternatively, we could:

1) Detect the type of port better and discard it as unusable

I'm not sure this can be done. On an earlier version of this Super I/O 
chip (the PC8374L), this port can be used as an uart and I can't find no
way of detecting the difference other than the Super I/O chip (see below).

2) Detect the presence of the WEC1022 PNP id, somehow

Not sure how this can be done, depends on initialisation order.

3) Detect the Super I/O chip and ignore this port

This is done in the patch below. Any review comments would be appreciated;
it does work.

Actually, Super I/O detection is done in several places in the tree. 
Shouldn't there be a central place which does this detection? This would
also allow switching of port modes on Super I/O chips which do support
that.

4) Make the port vanish.

Having hardware appear and disappear because it doesn't really exist seems
like a horrible kludge to me.

Thanks,
Sean
-- 
diff --git a/drivers/serial/8250.c b/drivers/serial/8250.c
index b1ae774..0555453 100644
--- a/drivers/serial/8250.c
+++ b/drivers/serial/8250.c
@@ -926,6 +926,36 @@ static int broken_efr(struct uart_8250_port *up)
 	return 0;
 }
 
+#ifdef CONFIG_X86
+/*
+ * The WPCD376I has one fake NS16550 port (the second serial port) which can
+ * only be used for IR purposes. It cannot be used as an UART.
+ */
+#define CHIP_ID_REG	0x20	/* Super I/O ID (SID) / family */
+#define CHIP_REV_REG	0x27	/* Super I/O revision ID (SRID) */
+
+static int superio_is_WPCD376I()
+{
+	int rc = -ENOENT;
+
+	if (!request_region(0x2e, 2, "wpcd376i"))
+		return -EBUSY;
+
+	outb(CHIP_ID_REG, 0x2e);
+	if (inb(0x2e) != CHIP_ID_REG || inb(0x2f) != 0xf1)
+		goto out;
+
+	outb(CHIP_REV_REG, 0x2e);
+	if (inb(0x2e) == CHIP_REV_REG && (inb(0x2f) & 0xe0) == 0x80)
+		rc = 0;
+
+out:
+	release_region(0x2e, 2);
+
+	return rc;
+}
+#endif
+
 /*
  * We know that the chip has FIFOs.  Does it have an EFR?  The
  * EFR is located in the same register position as the IIR and
@@ -1006,9 +1036,14 @@ static void autoconfig_16550a(struct uart_8250_port *up)
 
 			serial_outp(up, UART_LCR, 0);
 
-			up->port.uartclk = 921600*16;
-			up->port.type = PORT_NS16550A;
-			up->capabilities |= UART_NATSEMI;
+			if (!superio_is_WPCD376I()) {
+				up->capabilities &= ~UART_CAP_FIFO;
+				up->port.type = PORT_UNKNOWN;
+			} else {
+				up->port.uartclk = 921600*16;
+				up->port.type = PORT_NS16550A;
+				up->capabilities |= UART_NATSEMI;
+			}
 			return;
 		}
 	}
