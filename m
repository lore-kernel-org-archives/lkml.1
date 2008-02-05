Return-Path: <linux-kernel-owner+w=401wt.eu-S1761121AbYBEW0S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761121AbYBEW0S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 17:26:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758849AbYBEW0I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 17:26:08 -0500
Received: from gir.skynet.ie ([193.1.99.77]:42899 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756579AbYBEW0H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 17:26:07 -0500
Date: Tue, 5 Feb 2008 22:26:04 +0000
From: Mel Gorman <mel@csn.ul.ie>
To: Andi Kleen <ak@suse.de>
Cc: tglx@linutronix.de, mingo@elte.hu, linux-kernel@vger.kernel.org,
       apw@shadowen.org
Subject: Re: [PATCH] [1/2] Move NUMAQ io handling into arch/x86/pci/numa.c
Message-ID: <20080205222603.GB4207@csn.ul.ie>
References: <20080201608.475239056@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20080201608.475239056@suse.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andi,

On (01/02/08 18:08), Andi Kleen didst pronounce:
> 
> numa.c is the only user of the {in,out}*_quad functions. And it has only a few call
> sites. Change them to open code the magic NUMAQ port access.
> 
> Only compile tested
> 

This failed a boot-test on one of the quad machines. Before the patches I see

qla1280: QLA1040 found on PCI bus 0, dev 11
scsi(0:0): Resetting SCSI BUS
scsi0 : QLogic QLA1040 PCI to SCSI Host Adapter
       Firmware version:  7.65.06, Driver version 3.26
scsi 0:0:0:0: Direct-Access     IBM      DGHS18X          0360 PQ: 0 ANSI: 3
scsi(0:0:0:0): Sync: period 10, offset 12, Wide
scsi 0:0:1:0: Direct-Access     IBM      DGHS18X          0360 PQ: 0 ANSI: 3
scsi(0:0:1:0): Sync: period 10, offset 12, Wide
scsi 0:0:2:0: Direct-Access     IBM      DGHS18X          0360 PQ: 0 ANSI: 3
scsi(0:0:2:0): Sync: period 10, offset 12, Wide
scsi 0:0:3:0: Direct-Access     IBM OEM  DCHS09X          5454 PQ: 0 ANSI: 2
scsi(0:0:3:0): Sync: period 10, offset 12, Wide
scsi 0:0:4:0: Direct-Access     IBM OEM  DCHS09X          5454 PQ: 0 ANSI: 2
scsi(0:0:4:0): Sync: period 10, offset 12, Wide
qla1280: QLA1040 found on PCI bus 2, dev 11
scsi(1:0): Resetting SCSI BUS
scsi1 : QLogic QLA1040 PCI to SCSI Host Adapter
       Firmware version:  7.65.06, Driver version 3.26
qla1280: QLA1040 found on PCI bus 4, dev 11
scsi(2:0): Resetting SCSI BUS
scsi2 : QLogic QLA1040 PCI to SCSI Host Adapter
       Firmware version:  7.65.06, Driver version 3.26
qla1280: QLA1040 found on PCI bus 6, dev 11
scsi(3:0): Resetting SCSI BUS
scsi3 : QLogic QLA1040 PCI to SCSI Host Adapter
       Firmware version:  7.65.06, Driver version 3.26

After both patches are applied, it looks like

qla1280: QLA1040 found on PCI bus 0, dev 11
qla1280: Unable to map I/O memory
qla1280: QLA1040 found on PCI bus 2, dev 11
qla1280: Unable to map I/O memory
qla1280: QLA1040 found on PCI bus 4, dev 11
qla1280: Unable to map I/O memory
qla1280: QLA1040 found on PCI bus 6, dev 11
qla1280: Unable to map I/O memory

and of course the root device is not found. Comments on patch and fix is below.


> Signed-off-by: Andi Kleen <ak@suse.de>
> 
> Index: linux/arch/x86/pci/numa.c
> ===================================================================
> --- linux.orig/arch/x86/pci/numa.c
> +++ linux/arch/x86/pci/numa.c
> @@ -5,36 +5,62 @@
>  #include <linux/pci.h>
>  #include <linux/init.h>
>  #include <linux/nodemask.h>
> +#include <mach_apic.h>
>  #include "pci.h"
>  
> +#define XQUAD_PORTIO_BASE 0xfe400000

There is still a definition in include/asm-x86/io_32.h . Is this
intentional?

> +#define XQUAD_PORTIO_QUAD 0x40000  /* 256k per quad. */
> +

Similarly in io_32.h

>  #define BUS2QUAD(global) (mp_bus_id_to_node[global])
>  #define BUS2LOCAL(global) (mp_bus_id_to_local[global])
>  #define QUADLOCAL2BUS(quad,local) (quad_local_to_mp_bus_id[quad][local])
>  
> +extern void *xquad_portio;    /* Where the IO area was mapped */

Does the extern need to be here when you've added it (minus the comment)
to mach_apic.h later in the patch?

> +#define XQUAD_PORT_ADDR(port, quad) (xquad_portio + (XQUAD_PORTIO_QUAD*quad) + port)
> +
>  #define PCI_CONF1_MQ_ADDRESS(bus, devfn, reg) \
>  	(0x80000000 | (BUS2LOCAL(bus) << 16) | (devfn << 8) | (reg & ~3))
>  
> +static void write_cf8(unsigned bus, unsigned devfn, unsigned reg)
> +{
> +	unsigned val = PCI_CONF1_MQ_ADDRESS(bus, devfn, reg);
> +	if (xquad_portio)
> +		writel(val, XQUAD_PORT_ADDR(0xcf8, BUS2QUAD(bus)));
> +	else
> +		outl(val, 0xCF8);
> +}

Other than a case change for 0xcf8, this looks equivilant. xquad_portio
should be set and I see in the dmesg;

Before: xquad_portio vaddr 0xf8800000, len 00100000
After:  xquad_portio vaddr 0xf8800000, len 00100000


> +
>  static int pci_conf1_mq_read(unsigned int seg, unsigned int bus,
>  			     unsigned int devfn, int reg, int len, u32 *value)
>  {
>  	unsigned long flags;
> +	void *adr __iomem = XQUAD_PORT_ADDR(0xcfc, BUS2QUAD(bus));
>  

It shouldn't matter but for clarity should this value only be calculated
when xquad_portio is set?

>  	if (!value || (bus >= MAX_MP_BUSSES) || (devfn > 255) || (reg > 255))
>  		return -EINVAL;
>  
>  	spin_lock_irqsave(&pci_config_lock, flags);
>  
> -	outl_quad(PCI_CONF1_MQ_ADDRESS(bus, devfn, reg), 0xCF8, BUS2QUAD(bus));
> +	write_cf8(bus, devfn, reg);

Before
	writel(PCI_CONF1_MQ_ADDRESS(bus, devfn, reg), XQUAD_PORT_ADDR(0xCF8, BUS2QUAD(bus)))
After
	writel(PCI_CONF1_MQ_ADDRESS(bus, devfn, reg), XQUAD_PORT_ADDR(0xcf8, BUS2QUAD(bus)))

No problem there.

>  
>  	switch (len) {
>  	case 1:
> -		*value = inb_quad(0xCFC + (reg & 3), BUS2QUAD(bus));
> +		if (xquad_portio)
> +			*value = readb(adr + (reg & 3));
> +		else
> +			*value = inb(0xCFC + (reg & 3));
>  		break;

Before
	readb(XQUAD_PORT_ADDR(0xCFC + (reg & 3), BUS2QUAD(bus)))
After
	readb(XQUAD_PORT_ADDR(0xcfc, BUS2QUAD(bus)) + (reg & 3))

Not exactly equivilant but does it matter?

#define XQUAD_PORT_ADDR(port, quad) (xquad_portio + (XQUAD_PORTIO_QUAD*quad) + port)

Before
	readb(xquad_portio + (XQUAD_PORTIO_QUAD*BUS2QUAD(bus)) + 0xCFC + (reg & 3))
After
	readb(xquad_portio + (XQUAD_PORTIO_QUAD*BUS2QUAD(bus)) + 0xcfc + (reg & 3))

Apparently no actual difference.

>  	case 2:
> -		*value = inw_quad(0xCFC + (reg & 2), BUS2QUAD(bus));
> +		if (xquad_portio)
> +			*value = readw(adr + (reg & 2));
> +		else
> +			*value = inw(0xCFC + (reg & 2));
>  		break;
>  	case 4:
> -		*value = inl_quad(0xCFC, BUS2QUAD(bus));
> +		if (xquad_portio)
> +			*value = readl(adr);
> +		else
> +			*value = inl(0xCFC);
>  		break;
>  	}
>  
> @@ -47,23 +73,33 @@ static int pci_conf1_mq_write(unsigned i
>  			      unsigned int devfn, int reg, int len, u32 value)
>  {
>  	unsigned long flags;
> +	void *adr __iomem = XQUAD_PORT_ADDR(0xcfc, BUS2QUAD(bus));
>  
>  	if ((bus >= MAX_MP_BUSSES) || (devfn > 255) || (reg > 255)) 
>  		return -EINVAL;
>  
>  	spin_lock_irqsave(&pci_config_lock, flags);
>  
> -	outl_quad(PCI_CONF1_MQ_ADDRESS(bus, devfn, reg), 0xCF8, BUS2QUAD(bus));
> +	write_cf8(bus, devfn, reg);
>  

Same as above so should be ok.

>  	switch (len) {
>  	case 1:
> -		outb_quad((u8)value, 0xCFC + (reg & 3), BUS2QUAD(bus));
> +		if (xquad_portio)
> +			writeb(value, adr + (reg & 3));
> +		else
> +			outb((u8)value, 0xCFC + (reg & 3));
>  		break;

Before
	writeb((u8)value, XQUAD_PORT_ADDR(0xCFC + (reg & 3), BUS2QUAD(bus)))
After
	writeb(value, XQUAD_PORT_ADDR(0xcfc, BUS2QUAD(bus)) + (reg & 3))

The only difference is the explicit cast and the signature of writeb()
should have forced that cast anyway

>  	case 2:
> -		outw_quad((u16)value, 0xCFC + (reg & 2), BUS2QUAD(bus));
> +		if (xquad_portio)
> +			writew(value, adr + (reg & 2));
> +		else
> +			outw((u16)value, 0xCFC + (reg & 2));
>  		break;
>  	case 4:
> -		outl_quad((u32)value, 0xCFC, BUS2QUAD(bus));
> +		if (xquad_portio)
> +			writel(value, adr + reg);
> +		else
> +			outl((u32)value, 0xCFC);
>  		break;

(adr + reg) is not equivilant to 0xCFC here. This is the source of the
boot breakage. Fix is below

>  	}
>  
> Index: linux/include/asm-x86/mach-numaq/mach_apic.h
> ===================================================================
> --- linux.orig/include/asm-x86/mach-numaq/mach_apic.h
> +++ linux/include/asm-x86/mach-numaq/mach_apic.h
> @@ -109,6 +109,8 @@ static inline int mpc_apic_id(struct mpc
>  	return logical_apicid;
>  }
>  
> +extern void *xquad_portio;
> +
>  static inline void setup_portio_remap(void)
>  {
>  	int num_quads = num_online_nodes();
> 

Patch to fix boot problem as follows
====================================

Fix for "x86: move NUMAQ io handling into arch/x86/pci/numa.c"

The intention of commit c7e844f0415252c7e1a2153a97e7a0c511d61ada was to
replace a number of outl_quad() calls with a writel() equivilant. One of
the changes was not equivilant. This patch corrects it.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
---
 arch/x86/pci/numa.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/pci/numa.c b/arch/x86/pci/numa.c
index 55270c2..ecbcd51 100644
--- a/arch/x86/pci/numa.c
+++ b/arch/x86/pci/numa.c
@@ -97,7 +97,7 @@ static int pci_conf1_mq_write(unsigned int seg, unsigned int bus,
 		break;
 	case 4:
 		if (xquad_portio)
-			writel(value, adr + reg);
+			writel(value, adr);
 		else
 			outl((u32)value, 0xCFC);
 		break;
-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
