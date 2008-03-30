Return-Path: <linux-kernel-owner+w=401wt.eu-S1756496AbYC3Wlz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756496AbYC3Wlz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2008 18:41:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755783AbYC3Wkm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Mar 2008 18:40:42 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:53023 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755701AbYC3Wki (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2008 18:40:38 -0400
Date: Mon, 31 Mar 2008 01:40:25 +0300
From: Adrian Bunk <bunk@kernel.org>
To: ralf@linux-mips.org
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Subject: [2.6 patch] mips: remove MIPS_XXS1500
Message-ID: <20080330224025.GF28445@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

MIPS_XXS1500 has several compile problems like e.g. the
#include <asm/keyboard.h> in arch/mips/au1000/xxs1500/board_setup.c 
having been broken by the removal of this header back in February 2004.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 arch/mips/Makefile                     |    6 
 arch/mips/au1000/Kconfig               |    6 
 arch/mips/au1000/xxs1500/Makefile      |    9 -
 arch/mips/au1000/xxs1500/board_setup.c |   90 -----------
 arch/mips/au1000/xxs1500/init.c        |   63 --------
 arch/mips/au1000/xxs1500/irqmap.c      |   66 --------
 drivers/pcmcia/Makefile                |    1 
 drivers/pcmcia/au1000_generic.c        |    4 
 drivers/pcmcia/au1000_xxs1500.c        |  191 -------------------------
 9 files changed, 436 deletions(-)

42b527239af5ad2acfc98fba35699f241dac796e diff --git a/arch/mips/Makefile b/arch/mips/Makefile
index 72097da..88e4cd6 100644
--- a/arch/mips/Makefile
+++ b/arch/mips/Makefile
@@ -270,12 +270,6 @@ libs-$(CONFIG_MIPS_MTX1)	+= arch/mips/au1000/mtx-1/
 load-$(CONFIG_MIPS_MTX1)	+= 0xffffffff80100000
 
 #
-# MyCable eval board
-#
-libs-$(CONFIG_MIPS_XXS1500)	+= arch/mips/au1000/xxs1500/
-load-$(CONFIG_MIPS_XXS1500)	+= 0xffffffff80100000
-
-#
 # Cobalt Server
 #
 core-$(CONFIG_MIPS_COBALT)	+= arch/mips/cobalt/
diff --git a/arch/mips/au1000/Kconfig b/arch/mips/au1000/Kconfig
index 1fe97cc..61b3122 100644
--- a/arch/mips/au1000/Kconfig
+++ b/arch/mips/au1000/Kconfig
@@ -97,12 +97,6 @@ config MIPS_PB1550
 	select MIPS_DISABLE_OBSOLETE_IDE
 	select SYS_SUPPORTS_LITTLE_ENDIAN
 
-config MIPS_XXS1500
-	bool "MyCable XXS1500 board"
-	select DMA_NONCOHERENT
-	select SOC_AU1500
-	select SYS_SUPPORTS_LITTLE_ENDIAN
-
 endchoice
 
 config SOC_AU1000
diff --git a/arch/mips/au1000/xxs1500/Makefile b/arch/mips/au1000/xxs1500/Makefile
deleted file mode 100644
index 44d7f70..0000000
--- a/arch/mips/au1000/xxs1500/Makefile
+++ /dev/null
@@ -1,9 +0,0 @@
-#
-#  Copyright 2003 MontaVista Software Inc.
-#  Author: MontaVista Software, Inc.
-#     	ppopov@mvista.com or source@mvista.com
-#
-# Makefile for MyCable XXS1500 board.
-#
-
-lib-y := init.o board_setup.o irqmap.o
diff --git a/arch/mips/au1000/xxs1500/board_setup.c b/arch/mips/au1000/xxs1500/board_setup.c
deleted file mode 100644
index a9237f4..0000000
--- a/arch/mips/au1000/xxs1500/board_setup.c
+++ /dev/null
@@ -1,90 +0,0 @@
-/*
- * Copyright 2000-2003 MontaVista Software Inc.
- * Author: MontaVista Software, Inc.
- *         	ppopov@mvista.com or source@mvista.com
- *
- *  This program is free software; you can redistribute  it and/or modify it
- *  under  the terms of  the GNU General  Public License as published by the
- *  Free Software Foundation;  either version 2 of the  License, or (at your
- *  option) any later version.
- *
- *  THIS  SOFTWARE  IS PROVIDED   ``AS  IS'' AND   ANY  EXPRESS OR IMPLIED
- *  WARRANTIES,   INCLUDING, BUT NOT  LIMITED  TO, THE IMPLIED WARRANTIES OF
- *  MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN
- *  NO  EVENT  SHALL   THE AUTHOR  BE    LIABLE FOR ANY   DIRECT, INDIRECT,
- *  INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
- *  NOT LIMITED   TO, PROCUREMENT OF  SUBSTITUTE GOODS  OR SERVICES; LOSS OF
- *  USE, DATA,  OR PROFITS; OR  BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
- *  ANY THEORY OF LIABILITY, WHETHER IN  CONTRACT, STRICT LIABILITY, OR TORT
- *  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
- *  THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
- *
- *  You should have received a copy of the  GNU General Public License along
- *  with this program; if not, write  to the Free Software Foundation, Inc.,
- *  675 Mass Ave, Cambridge, MA 02139, USA.
- */
-#include <linux/init.h>
-#include <linux/sched.h>
-#include <linux/ioport.h>
-#include <linux/mm.h>
-#include <linux/console.h>
-#include <linux/delay.h>
-
-#include <asm/cpu.h>
-#include <asm/bootinfo.h>
-#include <asm/irq.h>
-#include <asm/keyboard.h>
-#include <asm/mipsregs.h>
-#include <asm/reboot.h>
-#include <asm/pgtable.h>
-#include <asm/au1000.h>
-
-void board_reset(void)
-{
-	/* Hit BCSR.SYSTEM_CONTROL[SW_RST] */
-	au_writel(0x00000000, 0xAE00001C);
-}
-
-void __init board_setup(void)
-{
-	u32 pin_func;
-
-	// set multiple use pins (UART3/GPIO) to UART (it's used as UART too)
-	pin_func = au_readl(SYS_PINFUNC) & (u32)(~SYS_PF_UR3);
-	pin_func |= SYS_PF_UR3;
-	au_writel(pin_func, SYS_PINFUNC);
-
-	// enable UART
-	au_writel(0x01, UART3_ADDR+UART_MOD_CNTRL); // clock enable (CE)
-	mdelay(10);
-	au_writel(0x03, UART3_ADDR+UART_MOD_CNTRL); // CE and "enable"
-	mdelay(10);
-
-	// enable DTR = USB power up
-	au_writel(0x01, UART3_ADDR+UART_MCR); //? UART_MCR_DTR is 0x01???
-
-#ifdef CONFIG_PCMCIA_XXS1500
-	/* setup pcmcia signals */
-	au_writel(0, SYS_PININPUTEN);
-
-	/* gpio 0, 1, and 4 are inputs */
-	au_writel(1 | (1<<1) | (1<<4), SYS_TRIOUTCLR);
-
-	/* enable GPIO2 if not already enabled */
-	au_writel(1, GPIO2_ENABLE);
-	/* gpio2 208/9/10/11 are inputs */
-	au_writel((1<<8) | (1<<9) | (1<<10) | (1<<11), GPIO2_DIR);
-
-	/* turn off power */
-	au_writel((au_readl(GPIO2_PINSTATE) & ~(1<<14))|(1<<30), GPIO2_OUTPUT);
-#endif
-
-
-#ifdef CONFIG_PCI
-#if defined(__MIPSEB__)
-	au_writel(0xf | (2<<6) | (1<<4), Au1500_PCI_CFG);
-#else
-	au_writel(0xf, Au1500_PCI_CFG);
-#endif
-#endif
-}
diff --git a/arch/mips/au1000/xxs1500/init.c b/arch/mips/au1000/xxs1500/init.c
deleted file mode 100644
index 7e6878c..0000000
--- a/arch/mips/au1000/xxs1500/init.c
+++ /dev/null
@@ -1,63 +0,0 @@
-/*
- * BRIEF MODULE DESCRIPTION
- *	XXS1500 board setup
- *
- * Copyright 2003 MontaVista Software Inc.
- * Author: MontaVista Software, Inc.
- *         	ppopov@mvista.com or source@mvista.com
- *
- *  This program is free software; you can redistribute  it and/or modify it
- *  under  the terms of  the GNU General  Public License as published by the
- *  Free Software Foundation;  either version 2 of the  License, or (at your
- *  option) any later version.
- *
- *  THIS  SOFTWARE  IS PROVIDED   ``AS  IS'' AND   ANY  EXPRESS OR IMPLIED
- *  WARRANTIES,   INCLUDING, BUT NOT  LIMITED  TO, THE IMPLIED WARRANTIES OF
- *  MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN
- *  NO  EVENT  SHALL   THE AUTHOR  BE    LIABLE FOR ANY   DIRECT, INDIRECT,
- *  INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
- *  NOT LIMITED   TO, PROCUREMENT OF  SUBSTITUTE GOODS  OR SERVICES; LOSS OF
- *  USE, DATA,  OR PROFITS; OR  BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
- *  ANY THEORY OF LIABILITY, WHETHER IN  CONTRACT, STRICT LIABILITY, OR TORT
- *  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
- *  THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
- *
- *  You should have received a copy of the  GNU General Public License along
- *  with this program; if not, write  to the Free Software Foundation, Inc.,
- *  675 Mass Ave, Cambridge, MA 02139, USA.
- */
-#include <linux/init.h>
-#include <linux/mm.h>
-#include <linux/sched.h>
-#include <linux/bootmem.h>
-#include <linux/string.h>
-#include <linux/kernel.h>
-
-#include <asm/addrspace.h>
-#include <asm/bootinfo.h>
-
-#include <prom.h>
-
-const char *get_system_type(void)
-{
-	return "XXS1500";
-}
-
-void __init prom_init(void)
-{
-	unsigned char *memsize_str;
-	unsigned long memsize;
-
-	prom_argc = fw_arg0;
-	prom_argv = (char **) fw_arg1;
-	prom_envp = (char **) fw_arg2;
-
-	prom_init_cmdline();
-
-	memsize_str = prom_getenv("memsize");
-	if (!memsize_str)
-		memsize = 0x04000000;
-	else
-		memsize = simple_strtol(memsize_str, NULL, 0);
-	add_memory_region(0, memsize, BOOT_MEM_RAM);
-}
diff --git a/arch/mips/au1000/xxs1500/irqmap.c b/arch/mips/au1000/xxs1500/irqmap.c
deleted file mode 100644
index 3893492..0000000
--- a/arch/mips/au1000/xxs1500/irqmap.c
+++ /dev/null
@@ -1,66 +0,0 @@
-/*
- * BRIEF MODULE DESCRIPTION
- *	Au1xxx irq map table
- *
- * Copyright 2003 Embedded Edge, LLC
- *		dan@embeddededge.com
- *
- *  This program is free software; you can redistribute	 it and/or modify it
- *  under  the terms of	 the GNU General  Public License as published by the
- *  Free Software Foundation;  either version 2 of the	License, or (at your
- *  option) any later version.
- *
- *  THIS  SOFTWARE  IS PROVIDED	  ``AS	IS'' AND   ANY	EXPRESS OR IMPLIED
- *  WARRANTIES,	  INCLUDING, BUT NOT  LIMITED  TO, THE IMPLIED WARRANTIES OF
- *  MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN
- *  NO	EVENT  SHALL   THE AUTHOR  BE	 LIABLE FOR ANY	  DIRECT, INDIRECT,
- *  INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
- *  NOT LIMITED	  TO, PROCUREMENT OF  SUBSTITUTE GOODS	OR SERVICES; LOSS OF
- *  USE, DATA,	OR PROFITS; OR	BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
- *  ANY THEORY OF LIABILITY, WHETHER IN	 CONTRACT, STRICT LIABILITY, OR TORT
- *  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
- *  THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
- *
- *  You should have received a copy of the  GNU General Public License along
- *  with this program; if not, write  to the Free Software Foundation, Inc.,
- *  675 Mass Ave, Cambridge, MA 02139, USA.
- */
-#include <linux/errno.h>
-#include <linux/init.h>
-#include <linux/irq.h>
-#include <linux/kernel_stat.h>
-#include <linux/module.h>
-#include <linux/signal.h>
-#include <linux/sched.h>
-#include <linux/types.h>
-#include <linux/interrupt.h>
-#include <linux/ioport.h>
-#include <linux/timex.h>
-#include <linux/slab.h>
-#include <linux/random.h>
-#include <linux/delay.h>
-#include <linux/bitops.h>
-
-#include <asm/bootinfo.h>
-#include <asm/io.h>
-#include <asm/mipsregs.h>
-#include <asm/system.h>
-#include <asm/au1000.h>
-
-struct au1xxx_irqmap __initdata au1xxx_irq_map[] = {
-	{ AU1500_GPIO_204, INTC_INT_HIGH_LEVEL, 0},
-	{ AU1500_GPIO_201, INTC_INT_LOW_LEVEL, 0 },
-	{ AU1500_GPIO_202, INTC_INT_LOW_LEVEL, 0 },
-	{ AU1500_GPIO_203, INTC_INT_LOW_LEVEL, 0 },
-	{ AU1500_GPIO_205, INTC_INT_LOW_LEVEL, 0 },
-	{ AU1500_GPIO_207, INTC_INT_LOW_LEVEL, 0 },
-
-	{ AU1000_GPIO_0, INTC_INT_LOW_LEVEL, 0 },
-	{ AU1000_GPIO_1, INTC_INT_LOW_LEVEL, 0 },
-	{ AU1000_GPIO_2, INTC_INT_LOW_LEVEL, 0 },
-	{ AU1000_GPIO_3, INTC_INT_LOW_LEVEL, 0 },
-	{ AU1000_GPIO_4, INTC_INT_LOW_LEVEL, 0 }, /* CF interrupt */
-	{ AU1000_GPIO_5, INTC_INT_LOW_LEVEL, 0 },
-};
-
-int __initdata au1xxx_nr_irqs = ARRAY_SIZE(au1xxx_irq_map);
diff --git a/drivers/pcmcia/Makefile b/drivers/pcmcia/Makefile
index 6f6478b..e7623e0 100644
--- a/drivers/pcmcia/Makefile
+++ b/drivers/pcmcia/Makefile
@@ -52,7 +52,6 @@ au1x00_ss-$(CONFIG_MIPS_DB1100)			+= au1000_db1x00.o
 au1x00_ss-$(CONFIG_MIPS_DB1200)			+= au1000_db1x00.o
 au1x00_ss-$(CONFIG_MIPS_DB1500)			+= au1000_db1x00.o
 au1x00_ss-$(CONFIG_MIPS_DB1550)			+= au1000_db1x00.o
-au1x00_ss-$(CONFIG_MIPS_XXS1500)		+= au1000_xxs1500.o
 
 sa1111_cs-y					+= sa1111_generic.o
 sa1111_cs-$(CONFIG_ASSABET_NEPONSET)		+= sa1100_neponset.o
diff --git a/drivers/pcmcia/au1000_generic.c b/drivers/pcmcia/au1000_generic.c
index b693367..398e3f2 100644
--- a/drivers/pcmcia/au1000_generic.c
+++ b/drivers/pcmcia/au1000_generic.c
@@ -407,7 +407,6 @@ int au1x00_pcmcia_socket_probe(struct device *dev, struct pcmcia_low_level *ops,
 			skt->phys_attr = AU1X_SOCK0_PSEUDO_PHYS_ATTR;
 			skt->phys_mem = AU1X_SOCK0_PSEUDO_PHYS_MEM;
 		}
-#ifndef CONFIG_MIPS_XXS1500
 		else  {
 			skt->virt_io = (void *)
 				(ioremap((phys_t)AU1X_SOCK1_IO, 0x1000) -
@@ -415,7 +414,6 @@ int au1x00_pcmcia_socket_probe(struct device *dev, struct pcmcia_low_level *ops,
 			skt->phys_attr = AU1X_SOCK1_PSEUDO_PHYS_ATTR;
 			skt->phys_mem = AU1X_SOCK1_PSEUDO_PHYS_MEM;
 		}
-#endif
 		pcmcia_base_vaddrs[i] = (u32 *)skt->virt_io;
 		ret = ops->hw_init(skt);
 
@@ -453,12 +451,10 @@ out_err:
 			iounmap(skt->virt_io + (u32)mips_io_port_base);
 			skt->virt_io = NULL;
 		}
-#ifndef CONFIG_MIPS_XXS1500
 		else {
 			iounmap(skt->virt_io + (u32)mips_io_port_base);
 			skt->virt_io = NULL;
 		}
-#endif
 		ops->hw_shutdown(skt);
 
 	}
diff --git a/drivers/pcmcia/au1000_xxs1500.c b/drivers/pcmcia/au1000_xxs1500.c
deleted file mode 100644
index ce9d5c4..0000000
--- a/drivers/pcmcia/au1000_xxs1500.c
+++ /dev/null
@@ -1,191 +0,0 @@
-/*
- *
- * MyCable board specific pcmcia routines.
- *
- * Copyright 2003 MontaVista Software Inc.
- * Author: Pete Popov, MontaVista Software, Inc.
- *         	ppopov@mvista.com or source@mvista.com
- *
- * ########################################################################
- *
- *  This program is free software; you can distribute it and/or modify it
- *  under the terms of the GNU General Public License (Version 2) as
- *  published by the Free Software Foundation.
- *
- *  This program is distributed in the hope it will be useful, but WITHOUT
- *  ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
- *  FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
- *  for more details.
- *
- *  You should have received a copy of the GNU General Public License along
- *  with this program; if not, write to the Free Software Foundation, Inc.,
- *  59 Temple Place - Suite 330, Boston MA 02111-1307, USA.
- *
- * ########################################################################
- *
- *
- */
-#include <linux/module.h>
-#include <linux/init.h>
-#include <linux/delay.h>
-#include <linux/ioport.h>
-#include <linux/kernel.h>
-#include <linux/tqueue.h>
-#include <linux/timer.h>
-#include <linux/mm.h>
-#include <linux/proc_fs.h>
-#include <linux/types.h>
-
-#include <pcmcia/cs_types.h>
-#include <pcmcia/cs.h>
-#include <pcmcia/ss.h>
-#include <pcmcia/bulkmem.h>
-#include <pcmcia/cistpl.h>
-#include <pcmcia/bus_ops.h>
-#include "cs_internal.h"
-
-#include <asm/io.h>
-#include <asm/irq.h>
-#include <asm/system.h>
-
-#include <asm/au1000.h>
-#include <asm/au1000_pcmcia.h>
-
-#define PCMCIA_MAX_SOCK		0
-#define PCMCIA_NUM_SOCKS	(PCMCIA_MAX_SOCK + 1)
-#define PCMCIA_IRQ		AU1000_GPIO_4
-
-#if 0
-#define DEBUG(x,args...)	printk(__FUNCTION__ ": " x,##args)
-#else
-#define DEBUG(x,args...)
-#endif
-
-static int xxs1500_pcmcia_init(struct pcmcia_init *init)
-{
-	return PCMCIA_NUM_SOCKS;
-}
-
-static int xxs1500_pcmcia_shutdown(void)
-{
-	/* turn off power */
-	au_writel(au_readl(GPIO2_PINSTATE) | (1<<14)|(1<<30),
-			GPIO2_OUTPUT);
-	au_sync_delay(100);
-
-	/* assert reset */
-	au_writel(au_readl(GPIO2_PINSTATE) | (1<<4)|(1<<20),
-			GPIO2_OUTPUT);
-	au_sync_delay(100);
-	return 0;
-}
-
-
-static int
-xxs1500_pcmcia_socket_state(unsigned sock, struct pcmcia_state *state)
-{
-	u32 inserted; u32 vs;
-	unsigned long gpio, gpio2;
-
-	if(sock > PCMCIA_MAX_SOCK) return -1;
-
-	gpio = au_readl(SYS_PINSTATERD);
-	gpio2 = au_readl(GPIO2_PINSTATE);
-
-	vs = gpio2 & ((1<<8) | (1<<9));
-	inserted = (!(gpio & 0x1) && !(gpio & 0x2));
-
-	state->ready = 0;
-	state->vs_Xv = 0;
-	state->vs_3v = 0;
-	state->detect = 0;
-
-	if (inserted) {
-		switch (vs) {
-			case 0:
-			case 1:
-			case 2:
-				state->vs_3v=1;
-				break;
-			case 3: /* 5V */
-			default:
-				/* return without setting 'detect' */
-				printk(KERN_ERR "au1x00_cs: unsupported VS\n",
-						vs);
-				return;
-		}
-		state->detect = 1;
-	}
-
-	if (state->detect) {
-		state->ready = 1;
-	}
-
-	state->bvd1= gpio2 & (1<<10);
-	state->bvd2 = gpio2 & (1<<11);
-	state->wrprot=0;
-	return 1;
-}
-
-
-static int xxs1500_pcmcia_get_irq_info(struct pcmcia_irq_info *info)
-{
-
-	if(info->sock > PCMCIA_MAX_SOCK) return -1;
-	info->irq = PCMCIA_IRQ;
-	return 0;
-}
-
-
-static int
-xxs1500_pcmcia_configure_socket(const struct pcmcia_configure *configure)
-{
-
-	if(configure->sock > PCMCIA_MAX_SOCK) return -1;
-
-	DEBUG("Vcc %dV Vpp %dV, reset %d\n",
-			configure->vcc, configure->vpp, configure->reset);
-
-	switch(configure->vcc){
-		case 33: /* Vcc 3.3V */
-			/* turn on power */
-			DEBUG("turn on power\n");
-			au_writel((au_readl(GPIO2_PINSTATE) & ~(1<<14))|(1<<30),
-					GPIO2_OUTPUT);
-			au_sync_delay(100);
-			break;
-		case 50: /* Vcc 5V */
-		default: /* what's this ? */
-			printk(KERN_ERR "au1x00_cs: unsupported VCC\n");
-		case 0:  /* Vcc 0 */
-			/* turn off power */
-			au_sync_delay(100);
-			au_writel(au_readl(GPIO2_PINSTATE) | (1<<14)|(1<<30),
-					GPIO2_OUTPUT);
-			break;
-	}
-
-	if (!configure->reset) {
-		DEBUG("deassert reset\n");
-		au_writel((au_readl(GPIO2_PINSTATE) & ~(1<<4))|(1<<20),
-				GPIO2_OUTPUT);
-		au_sync_delay(100);
-		au_writel((au_readl(GPIO2_PINSTATE) & ~(1<<5))|(1<<21),
-				GPIO2_OUTPUT);
-	}
-	else {
-		DEBUG("assert reset\n");
-		au_writel(au_readl(GPIO2_PINSTATE) | (1<<4)|(1<<20),
-				GPIO2_OUTPUT);
-	}
-	au_sync_delay(100);
-	return 0;
-}
-
-struct pcmcia_low_level xxs1500_pcmcia_ops = {
-	xxs1500_pcmcia_init,
-	xxs1500_pcmcia_shutdown,
-	xxs1500_pcmcia_socket_state,
-	xxs1500_pcmcia_get_irq_info,
-	xxs1500_pcmcia_configure_socket
-};

