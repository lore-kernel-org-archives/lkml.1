Return-Path: <linux-kernel-owner+w=401wt.eu-S1758585AbYAYOeq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758585AbYAYOeq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 09:34:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758140AbYAYOee
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 09:34:34 -0500
Received: from mail0.scram.de ([78.47.204.202]:51100 "EHLO mail0.scram.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758134AbYAYOec (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 09:34:32 -0500
X-Spam-Score: -2.933
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
 *  2.7 TVD_SUBJ_WIPE_DEBT TVD_SUBJ_WIPE_DEBT
 * -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
 *      [score: 0.0000]
 * -1.2 AWL AWL: From: address is in the auto white-list
Message-ID: <4799F349.9090102@scram.de>
Date: Fri, 25 Jan 2008 15:33:45 +0100
From: Jochen Friedrich <jochen@scram.de>
User-Agent: Mozilla-Thunderbird 2.0.0.9 (X11/20080110)
MIME-Version: 1.0
To: "Garzik, Jeff" <jgarzik@pobox.com>
CC: Vitaly Bordug <vitb@kernel.crashing.org>,
       Scott Wood <scottwood@freescale.com>,
       Kumar Gala <galak@kernel.crashing.org>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       "Kernel, Linux" <linux-kernel@vger.kernel.org>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       linuxppc-dev list <linuxppc-dev@ozlabs.org>, linux-m68k@vger.kernel.org
Subject: [PATCH] [NET]: Remove PowerPC code from fec.c
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fec.c is only used on M68k Coldfire CPUs. Remove leftover
PowerPC code from this driver.

Signed-off-by: Jochen Friedrich <jochen@scram.de>
---
 drivers/net/fec.c |  136 +---------------------------------------------------
 1 files changed, 3 insertions(+), 133 deletions(-)

diff --git a/drivers/net/fec.c b/drivers/net/fec.c
index 0fbf1bb..0499cbb 100644
--- a/drivers/net/fec.c
+++ b/drivers/net/fec.c
@@ -23,6 +23,9 @@
  *
  * Bug fixes and cleanup by Philippe De Muyter (phdm@macqel.be)
  * Copyright (c) 2004-2006 Macq Electronique SA.
+ *
+ * This driver is now only used on ColdFire processors. Remove conditional
+ * Powerpc code.
  */
 
 #include <linux/module.h>
@@ -49,17 +52,9 @@
 #include <asm/pgtable.h>
 #include <asm/cacheflush.h>
 
-#if defined(CONFIG_M523x) || defined(CONFIG_M527x) || \
-    defined(CONFIG_M5272) || defined(CONFIG_M528x) || \
-    defined(CONFIG_M520x) || defined(CONFIG_M532x)
 #include <asm/coldfire.h>
 #include <asm/mcfsim.h>
 #include "fec.h"
-#else
-#include <asm/8xx_immap.h>
-#include <asm/mpc8xx.h>
-#include "commproc.h"
-#endif
 
 #if defined(CONFIG_FEC2)
 #define	FEC_MAX_PORTS	2
@@ -1223,14 +1218,9 @@ static phy_info_t const * const phy_info[] = {
 
 /* ------------------------------------------------------------------------- */
 #if !defined(CONFIG_M532x)
-#ifdef CONFIG_RPXCLASSIC
-static void
-mii_link_interrupt(void *dev_id);
-#else
 static irqreturn_t
 mii_link_interrupt(int irq, void * dev_id);
 #endif
-#endif
 
 #if defined(CONFIG_M5272)
 /*
@@ -1800,121 +1790,6 @@ static void __inline__ fec_uncache(unsigned long addr)
 /* ------------------------------------------------------------------------- */
 
 
-#else
-
-/*
- *	Code specific to the MPC860T setup.
- */
-static void __inline__ fec_request_intrs(struct net_device *dev)
-{
-	volatile immap_t *immap;
-
-	immap = (immap_t *)IMAP_ADDR;	/* pointer to internal registers */
-
-	if (request_8xxirq(FEC_INTERRUPT, fec_enet_interrupt, 0, "fec", dev) != 0)
-		panic("Could not allocate FEC IRQ!");
-
-#ifdef CONFIG_RPXCLASSIC
-	/* Make Port C, bit 15 an input that causes interrupts.
-	*/
-	immap->im_ioport.iop_pcpar &= ~0x0001;
-	immap->im_ioport.iop_pcdir &= ~0x0001;
-	immap->im_ioport.iop_pcso &= ~0x0001;
-	immap->im_ioport.iop_pcint |= 0x0001;
-	cpm_install_handler(CPMVEC_PIO_PC15, mii_link_interrupt, dev);
-
-	/* Make LEDS reflect Link status.
-	*/
-	*((uint *) RPX_CSR_ADDR) &= ~BCSR2_FETHLEDMODE;
-#endif
-#ifdef CONFIG_FADS
-	if (request_8xxirq(SIU_IRQ2, mii_link_interrupt, 0, "mii", dev) != 0)
-		panic("Could not allocate MII IRQ!");
-#endif
-}
-
-static void __inline__ fec_get_mac(struct net_device *dev)
-{
-	bd_t *bd;
-
-	bd = (bd_t *)__res;
-	memcpy(dev->dev_addr, bd->bi_enetaddr, ETH_ALEN);
-
-#ifdef CONFIG_RPXCLASSIC
-	/* The Embedded Planet boards have only one MAC address in
-	 * the EEPROM, but can have two Ethernet ports.  For the
-	 * FEC port, we create another address by setting one of
-	 * the address bits above something that would have (up to
-	 * now) been allocated.
-	 */
-	dev->dev_adrd[3] |= 0x80;
-#endif
-}
-
-static void __inline__ fec_set_mii(struct net_device *dev, struct fec_enet_private *fep)
-{
-	extern uint _get_IMMR(void);
-	volatile immap_t *immap;
-	volatile fec_t *fecp;
-
-	fecp = fep->hwp;
-	immap = (immap_t *)IMAP_ADDR;	/* pointer to internal registers */
-
-	/* Configure all of port D for MII.
-	*/
-	immap->im_ioport.iop_pdpar = 0x1fff;
-
-	/* Bits moved from Rev. D onward.
-	*/
-	if ((_get_IMMR() & 0xffff) < 0x0501)
-		immap->im_ioport.iop_pddir = 0x1c58;	/* Pre rev. D */
-	else
-		immap->im_ioport.iop_pddir = 0x1fff;	/* Rev. D and later */
-
-	/* Set MII speed to 2.5 MHz
-	*/
-	fecp->fec_mii_speed = fep->phy_speed =
-		((bd->bi_busfreq * 1000000) / 2500000) & 0x7e;
-}
-
-static void __inline__ fec_enable_phy_intr(void)
-{
-	volatile fec_t *fecp;
-
-	fecp = fep->hwp;
-
-	/* Enable MII command finished interrupt
-	*/
-	fecp->fec_ivec = (FEC_INTERRUPT/2) << 29;
-}
-
-static void __inline__ fec_disable_phy_intr(void)
-{
-}
-
-static void __inline__ fec_phy_ack_intr(void)
-{
-}
-
-static void __inline__ fec_localhw_setup(void)
-{
-	volatile fec_t *fecp;
-
-	fecp = fep->hwp;
-	fecp->fec_r_hash = PKT_MAXBUF_SIZE;
-	/* Enable big endian and don't care about SDMA FC.
-	*/
-	fecp->fec_fun_code = 0x78000000;
-}
-
-static void __inline__ fec_uncache(unsigned long addr)
-{
-	pte_t *pte;
-	pte = va_to_pte(mem_addr);
-	pte_val(*pte) |= _PAGE_NO_CACHE;
-	flush_tlb_page(init_mm.mmap, mem_addr);
-}
-
 #endif
 
 /* ------------------------------------------------------------------------- */
@@ -2126,13 +2001,8 @@ mii_discover_phy(uint mii_reg, struct net_device *dev)
 
 /* This interrupt occurs when the PHY detects a link change.
 */
-#ifdef CONFIG_RPXCLASSIC
-static void
-mii_link_interrupt(void *dev_id)
-#else
 static irqreturn_t
 mii_link_interrupt(int irq, void * dev_id)
-#endif
 {
 	struct	net_device *dev = dev_id;
 	struct fec_enet_private *fep = netdev_priv(dev);
-- 
1.5.3.8


