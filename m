Return-Path: <linux-kernel-owner+w=401wt.eu-S1760136AbXFSXbr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760136AbXFSXbr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 19:31:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759722AbXFSXbg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 19:31:36 -0400
Received: from atlrel9.hp.com ([156.153.255.214]:47386 "EHLO atlrel9.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759635AbXFSXbe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 19:31:34 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Andrey Borzenkov <arvidjaar@mail.ru>
Subject: Re: 2.6.22-rc: regression: no irda0 interface (2.6.21 was OK), smsc does not find chip
Date: Tue, 19 Jun 2007 17:31:23 -0600
User-Agent: KMail/1.9.6
Cc: Samuel Ortiz <samuel@sortiz.org>,
       "Linus Walleij (LD/EAB)" <linus.walleij@ericsson.com>,
       linux-kernel@vger.kernel.org,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>, ambx1@neo.rr.com,
       linux-pcmcia@lists.infradead.org
References: <A6D19A13FE030A409EC4362C172E091F016F51AF@eseldmw101.eemea.ericsson.se> <200706150919.14150.bjorn.helgaas@hp.com> <200706162038.57296.arvidjaar@mail.ru>
In-Reply-To: <200706162038.57296.arvidjaar@mail.ru>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_MdGeGinlbIdOxjL"
Message-Id: <200706191731.24085.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_MdGeGinlbIdOxjL
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Saturday 16 June 2007 10:38:56 am Andrey Borzenkov wrote:
> it appears that quirk is not even applied because PnP tells us device is not 
> active:
> 
> [  571.118483] pnp: PnP ACPI init
> [  571.118611] ACPI: bus type pnp registered
> [  571.158828] quirk_smc_enable: active = 0
> [  571.182090] pnp: PnP ACPI: found 12 devices

Yup.  That could probably be improved.

_CRS definitely reports SIR and FIR backwards from most platforms.

I can make the device talk by configuring it "by hand," e.g.,

  # cd /sys/bus/pnp/devices/00:0a
  # echo "set io 0x2e8-0x2ef io 0x100-0x107 irq 5 dma 1" > resources
  # echo activate > resources
  # ~/smsc
  smsc_dump: 0x24 0xfe UART1 config
  smsc_dump: 0x25 0xba SIR base (0x2e8)
  smsc_dump: 0x28 0x45 UART IRQ
  smsc_dump: 0x2b 0x20 FIR base (0x100)
  smsc_dump: 0x2c 0x01 FIR DMA
  smsc_dump: 0x0c 0x0e IRDA mode
  smsc_dump: 0x07 0x50 powerdown mode
  smsc_dump: 0x0a 0x40 toshiba mystery
  # ~/inb 0x100 8 0x100
  selecting bank 3 (fir at 0x100)
  0x0100: 0x10 0xb8 0xf2 0x00 0x51 0x00 0x00 0x03

("smsc" and "inb" are little test programs (attached).  "smsc" dumps
the SIO configuration, and "inb" dumps I/O ports.  In this case,
I'm looking at the FIR ports, and the values there are what smsc-ircc2
expects.)

Seems like it should be simple to do the same thing automatically
in the driver or a quirk, but I haven't been able to get that to work.

I'll be out of the office most of the time from now until July 5, but
I'll get back to this when I return.

Bjorn


P.S.  "reboot" doesn't seem to work on my box.  I tried "reboot=b",
"reboot=c", "reboot=h", and none of them seems to work.  Does it work
on yours?

--Boundary-00=_MdGeGinlbIdOxjL
Content-Type: text/x-csrc;
  charset="iso-8859-15";
  name="smsc.c"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="smsc.c"

/*
 * Dump SMSC/LPC47N227 config, typically IRDA config
 */


#include <stdio.h>
#include <stdlib.h>
#include <sys/io.h>

/******************************************
 Keys. They should work with every SMsC SIO
 ******************************************/

#define SMSCSIO_CFGACCESSKEY		0x55
#define SMSCSIO_CFGEXITKEY			0xaa

/*****************************
 * Generic SIO Flat (!?)     *
 *****************************/
 
/* Register 0x0d */
#define SMSCSIOFLAT_DEVICEID_REG				0x0d

/* Register 0x0c */
#define SMSCSIOFLAT_UARTMODE0C_REG				0x0c
#define 	SMSCSIOFLAT_UART2MODE_MASK			0x38
#define 	SMSCSIOFLAT_UART2MODE_VAL_COM		0x00
#define 	SMSCSIOFLAT_UART2MODE_VAL_IRDA		0x08
#define 	SMSCSIOFLAT_UART2MODE_VAL_ASKIR		0x10

/* Register 0x25 */
#define SMSCSIOFLAT_UART2BASEADDR_REG			0x25

/* Register 0x2b */
#define SMSCSIOFLAT_FIRBASEADDR_REG				0x2b

/* Register 0x2c */
#define SMSCSIOFLAT_FIRDMASELECT_REG			0x2c
#define 	SMSCSIOFLAT_FIRDMASELECT_MASK		0x0f

/* Register 0x28 */
#define SMSCSIOFLAT_UARTIRQSELECT_REG			0x28
#define 	SMSCSIOFLAT_UART2IRQSELECT_MASK		0x0f
#define 	SMSCSIOFLAT_UART1IRQSELECT_MASK		0xf0
#define 	SMSCSIOFLAT_UARTIRQSELECT_VAL_NONE	0x00


/*********************
 * LPC47N227         *
 *********************/

#define LPC47N227_CFGACCESSKEY		0x55
#define LPC47N227_CFGEXITKEY		0xaa

/* Register 0x00 */
#define LPC47N227_FDCPOWERVALIDCONF_REG		0x00
#define 	LPC47N227_FDCPOWER_MASK			0x08
#define 	LPC47N227_VALID_MASK				0x80

/* Register 0x02 */
#define LPC47N227_UART12POWER_REG				0x02
#define 	LPC47N227_UART1POWERDOWN_MASK		0x08
#define 	LPC47N227_UART2POWERDOWN_MASK		0x80

/* Register 0x07 */
#define LPC47N227_APMBOOTDRIVE_REG				0x07
#define 	LPC47N227_PARPORT2AUTOPWRDOWN_MASK	0x10 /* auto power down on if set */
#define 	LPC47N227_UART2AUTOPWRDOWN_MASK	0x20 /* auto power down on if set */
#define 	LPC47N227_UART1AUTOPWRDOWN_MASK	0x40 /* auto power down on if set */

/* Register 0x0c */
#define LPC47N227_UARTMODE0C_REG				0x0c
#define 	LPC47N227_UART2MODE_MASK			0x38
#define 	LPC47N227_UART2MODE_VAL_COM		0x00
#define 	LPC47N227_UART2MODE_VAL_IRDA		0x08
#define 	LPC47N227_UART2MODE_VAL_ASKIR		0x10

/* Register 0x0d */
#define LPC47N227_DEVICEID_REG					0x0d
#define 	LPC47N227_DEVICEID_DEFVAL			0x5a

/* Register 0x0e */
#define LPC47N227_REVISIONID_REG				0x0e

/* Register 0x25 */
#define LPC47N227_UART2BASEADDR_REG			0x25

/* Register 0x28 */
#define LPC47N227_UARTIRQSELECT_REG			0x28
#define 	LPC47N227_UART2IRQSELECT_MASK		0x0f
#define 	LPC47N227_UART1IRQSELECT_MASK		0xf0
#define 	LPC47N227_UARTIRQSELECT_VAL_NONE	0x00

/* Register 0x2b */
#define LPC47N227_FIRBASEADDR_REG				0x2b

/* Register 0x2c */
#define LPC47N227_FIRDMASELECT_REG				0x2c
#define 	LPC47N227_FIRDMASELECT_MASK		0x0f
#define 	LPC47N227_FIRDMASELECT_VAL_DMA1	0x01 /* 47n227 has three dma channels */
#define 	LPC47N227_FIRDMASELECT_VAL_DMA2	0x02
#define 	LPC47N227_FIRDMASELECT_VAL_DMA3	0x03
#define 	LPC47N227_FIRDMASELECT_VAL_NONE	0x0f

static inline unsigned int smsc_read(unsigned int port, unsigned int reg)
{
	outb(reg, port);
	return inb(port + 1);
}

static inline void smsc_write(unsigned int port, unsigned int reg, unsigned int
val)
{
	outb(reg, port);
	outb(val, port + 1);
}

static void smsc_dump(unsigned int iobase)
{
	unsigned char val;

	outb(LPC47N227_CFGACCESSKEY, iobase); // enter configuration state

	val = smsc_read(iobase, 0x24);
	printf("%s: 0x%02x 0x%02x UART1 config\n", __FUNCTION__, 0x24, val);

	val = smsc_read(iobase, SMSCSIOFLAT_UART2BASEADDR_REG);
	printf("%s: 0x%02x 0x%02x SIR base (0x%x)\n", __FUNCTION__, SMSCSIOFLAT_UART2BASEADDR_REG, val, val << 2);

	val = smsc_read(iobase, SMSCSIOFLAT_UARTIRQSELECT_REG);
	printf("%s: 0x%02x 0x%02x UART IRQ\n", __FUNCTION__, SMSCSIOFLAT_UARTIRQSELECT_REG, val);

	val = smsc_read(iobase, SMSCSIOFLAT_FIRBASEADDR_REG);
	printf("%s: 0x%02x 0x%02x FIR base (0x%x)\n", __FUNCTION__, SMSCSIOFLAT_FIRBASEADDR_REG, val, val << 3);

	val = smsc_read(iobase, SMSCSIOFLAT_FIRDMASELECT_REG);
	printf("%s: 0x%02x 0x%02x FIR DMA\n", __FUNCTION__, SMSCSIOFLAT_FIRDMASELECT_REG, val);

	val = smsc_read(iobase, SMSCSIOFLAT_UARTMODE0C_REG);
	printf("%s: 0x%02x 0x%02x IRDA mode\n", __FUNCTION__, SMSCSIOFLAT_UARTMODE0C_REG, val);

	val = smsc_read(iobase, LPC47N227_APMBOOTDRIVE_REG);
	printf("%s: 0x%02x 0x%02x powerdown mode\n", __FUNCTION__, LPC47N227_APMBOOTDRIVE_REG, val);

	val = smsc_read(iobase, 0x0a);
	printf("%s: 0x%02x 0x%02x toshiba mystery\n", __FUNCTION__, 0x0a, val);

	outb(LPC47N227_CFGEXITKEY, iobase); // leave configuration state
}

main()
{
	if (iopl(3) < 0) {
		perror("iopl");
		exit(-1);
	}

	/* see smsc-ircc2.c for typical addresses */
	smsc_dump(0x2e);
	exit(0);
}

--Boundary-00=_MdGeGinlbIdOxjL
Content-Type: text/x-csrc;
  charset="iso-8859-15";
  name="inb.c"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="inb.c"

#include <stdio.h>
#include <stdlib.h>
#include <sys/io.h>

main(int argc, char **argv)
{
	int port, length, fir;
	int val;
	unsigned char bank;

	if (argc < 3)
		exit(-1);

	port = strtoul(argv[1], NULL, 0);
	length = strtoul(argv[2], NULL, 0);

	if (iopl(3) < 0) {
		perror("iopl");
		exit(-1);
	}

	if (argc > 3) {
		fir = strtoul(argv[3], NULL, 0);
		printf("selecting bank 3 (fir at 0x%x)\n", fir);
		bank = inb(fir + 7);
		bank &= 0xf0;
		bank |= 3;
		outb(bank, fir + 7);
	}

	while (length--) {
		val = inb(port);
		if ((port & 0x7) == 0)
			printf("0x%04x:", port);
		printf(" 0x%02x", val & 0xff);
		if ((port & 0x7) == 0x7)
			printf("\n");
		port++;
	}

	exit(0);
}

--Boundary-00=_MdGeGinlbIdOxjL--
