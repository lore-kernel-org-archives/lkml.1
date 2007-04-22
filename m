Return-Path: <linux-kernel-owner+w=401wt.eu-S1030477AbXDVT2S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030477AbXDVT2S (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2007 15:28:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030572AbXDVT2R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Apr 2007 15:28:17 -0400
Received: from cdma-149-98-48.msk.skylink.ru ([91.149.98.48]:46740 "EHLO
	localhost.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1030801AbXDVT2N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2007 15:28:13 -0400
Date: Sun, 22 Apr 2007 23:26:58 +0400
From: Vitaly Bordug <vitb@kernel.crashing.org>
To: "linuxppc-dev@ozlabs.org" <linuxppc-dev@ozlabs.org>
Cc: lkml <linux-kernel@vger.kernel.org>, linux-pcmcia@lists.infradead.org
Subject: Fw: [PATCH][RFC] PCMCIA support for 8xx using platform devices
Message-ID: <20070422232658.5f427fd3@localhost.localdomain>
X-Mailer: Claws Mail 2.8.1cvs91 (GTK+ 2.10.9; i686-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This utilizes PCMCIA on mpc885ads and mpc866ads from arch/powerpc. In the new approach,
direct IMMR accesses from within drivers/ were totally eliminated, that requires hardware_enable, hardware_disable, voltage_set board-specific functions to be moved over to BSP code section 
(arch/powerpc/platforms/8xx in 885 case). There is just no way to have both arch/ppc and arch/powerpc approaches to work simultaneously because of that.

It implies a bit of work to move other target's bits over to BSP region, but no ifdef hell worths it,
in addition to the fact of being moved/merged to arch/powerpc, the code would spot this problem 
anyway.

Signed-off-by: Vitaly Bordug <vitb@kernel.crashing.org>
---
This is FW of original message sent to linux-pcmcia@lists.infradead.org to attach wider audience.
Original maillist kept in loop to prevent misunderstanding...

 arch/powerpc/boot/dts/mpc885ads.dts          |   12 +
 arch/powerpc/platforms/8xx/mpc885ads.h       |    5 
 arch/powerpc/platforms/8xx/mpc885ads_setup.c |   63 +++++
 arch/powerpc/sysdev/fsl_soc.c                |   58 ++++
 drivers/pcmcia/Kconfig                       |    1 
 drivers/pcmcia/m8xx_pcmcia.c                 |  342 ++++++++++++--------------
 include/linux/fs_pcmcia_pd.h                 |   27 ++
 7 files changed, 318 insertions(+), 190 deletions(-)

diff --git a/arch/powerpc/boot/dts/mpc885ads.dts b/arch/powerpc/boot/dts/mpc885ads.dts
index 90e047a..330ac91 100644
--- a/arch/powerpc/boot/dts/mpc885ads.dts
+++ b/arch/powerpc/boot/dts/mpc885ads.dts
@@ -112,6 +112,18 @@
 			compatible = "CPM";
 		};
 
+               pcmcia@0080 {
+                       linux,phandle = <0080>;
+                       #interrupt-cells = <1>;
+                       #size-cells = <2>;
+                       compatible = "8xx";
+                       device_type = "pcmcia";
+                       reg = <80 80>;
+                       clock-frequency = <2faf080>;
+                       interrupt-parent = <ff000000>;
+                       interrupts = <d 1>;
+		};
+
 		cpm@ff000000 {
 			linux,phandle = <ff000000>;
 			#address-cells = <1>;
diff --git a/arch/powerpc/platforms/8xx/mpc885ads.h b/arch/powerpc/platforms/8xx/mpc885ads.h
index 7c31aec..4439346 100644
--- a/arch/powerpc/platforms/8xx/mpc885ads.h
+++ b/arch/powerpc/platforms/8xx/mpc885ads.h
@@ -91,5 +91,10 @@ #define PC_ENET_RENA	((ushort)0x0800)
 #define SICR_ENET_MASK	((uint)0x00ff0000)
 #define SICR_ENET_CLKRT	((uint)0x002c0000)
 
+/* Some internal interrupt registers use an 8-bit mask for the interrupt
+ * level instead of a number.
+ */
+#define mk_int_int_mask(IL) (1 << (7 - (IL/2)))
+
 #endif /* __ASM_MPC885ADS_H__ */
 #endif /* __KERNEL__ */
diff --git a/arch/powerpc/platforms/8xx/mpc885ads_setup.c b/arch/powerpc/platforms/8xx/mpc885ads_setup.c
index 394f983..1ba423f 100644
--- a/arch/powerpc/platforms/8xx/mpc885ads_setup.c
+++ b/arch/powerpc/platforms/8xx/mpc885ads_setup.c
@@ -22,6 +22,7 @@ #include <linux/root_dev.h>
 
 #include <linux/fs_enet_pd.h>
 #include <linux/fs_uart_pd.h>
+#include <linux/fs_pcmcia_pd.h>
 #include <linux/mii.h>
 
 #include <asm/delay.h>
@@ -375,6 +376,68 @@ static void init_i2c_ioports()
         setbits16(&cp->cp_pbodr, 0x0030);
 }
 
+void pcmcia_hw_setup(int slot, int enable)
+{
+	unsigned *bcsr_io;
+
+	bcsr_io = ioremap(BCSR1, sizeof(unsigned long));
+	if (enable)
+	clrbits32(bcsr_io, BCSR1_PCCEN);
+	else
+		setbits32(bcsr_io, BCSR1_PCCEN);
+
+	iounmap(bcsr_io);
+}
+
+int pcmcia_set_voltage(int slot, int vcc, int vpp)
+{
+        u32 reg = 0;
+        unsigned *bcsr_io;
+
+        bcsr_io = ioremap(BCSR1, sizeof(unsigned long));
+
+        switch(vcc) {
+                case 0:
+                        break;
+                case 33:
+                        reg |= BCSR1_PCCVCC0;
+                        break;
+                case 50:
+                        reg |= BCSR1_PCCVCC1;
+                        break;
+                default:
+                        return 1;
+        }
+
+        switch(vpp) {
+                case 0:
+                        break;
+                case 33:
+                case 50:
+                        if(vcc == vpp)
+                                reg |= BCSR1_PCCVPP1;
+                        else
+                                return 1;
+                        break;
+                case 120:
+                        if ((vcc == 33) || (vcc == 50))
+                                reg |= BCSR1_PCCVPP0;
+                        else
+                                return 1;
+                default:
+                        return 1;
+        }
+
+        /* first, turn off all power */
+        clrbits32(bcsr_io, 0x00610000);
+
+        /* enable new powersettings */
+        setbits32(bcsr_io, reg);
+
+        iounmap(bcsr_io);
+        return 0;
+}
+
 int platform_device_skip(char *model, int id)
 {
 #ifdef CONFIG_MPC8xx_SECOND_ETH_SCC3
diff --git a/arch/powerpc/sysdev/fsl_soc.c b/arch/powerpc/sysdev/fsl_soc.c
index 355c05d..753118d 100644
--- a/arch/powerpc/sysdev/fsl_soc.c
+++ b/arch/powerpc/sysdev/fsl_soc.c
@@ -26,6 +26,7 @@ #include <linux/phy.h>
 #include <linux/fsl_devices.h>
 #include <linux/fs_enet_pd.h>
 #include <linux/fs_uart_pd.h>
+#include <linux/fs_pcmcia_pd.h>
 
 #include <asm/system.h>
 #include <asm/atomic.h>
@@ -862,6 +863,8 @@ #ifdef CONFIG_8xx
 
 extern void init_scc_ioports(struct fs_platform_info*);
 extern int platform_device_skip(char *model, int id);
+extern void pcmcia_hw_setup(int slot, int enable);
+extern int pcmcia_set_voltage(int slot, int vcc, int vpp);
 
 static int __init fs_enet_mdio_of_init(void)
 {
@@ -1267,5 +1270,60 @@ err:
 
 arch_initcall(fsl_i2c_cpm_of_init);
 
+static const char *pcmcia_regs = "regs";
+static const char *pcmcia_irq = "interrupt";
+
+static int __init fsl_pcmcia_of_init(void)
+{
+	struct device_node *np;
+	unsigned int i;
+	struct platform_device *pcmcia_dev;
+	int ret;
+
+	for (np = NULL, i = 0;
+	     (np = of_find_compatible_node(np, "pcmcia", "8xx")) != NULL;
+	     i++) {
+		struct resource r[2];
+		struct fs_pcmcia_platform_data pcmcia_data;
+
+		memset(&r, 0, sizeof(r));
+		memset(&pcmcia_data, 0, sizeof(pcmcia_data));
+
+		ret = of_address_to_resource(np, 0, &r[0]);
+		if (ret)
+			goto err;
+		r[0].name = pcmcia_regs;
+
+		r[1].start = r[1].end = irq_of_parse_and_map(np, 0);
+		r[1].flags = IORESOURCE_IRQ;
+		r[1].name = pcmcia_irq;
+
+		pcmcia_data.hwirq = irq_map[r[1].start].hwirq;
+		pcmcia_data.hw_setup = pcmcia_hw_setup;
+		pcmcia_data.voltage_set = pcmcia_set_voltage;
+		pcmcia_data.bus_freq = ppc_proc_freq;
+
+		pcmcia_dev = platform_device_register_simple("m8xx-pcmcia", i, &r[0], 2);
+		if (IS_ERR(pcmcia_dev)) {
+			ret = PTR_ERR(pcmcia_dev);
+			goto err;
+		}
+		ret =
+		    platform_device_add_data(pcmcia_dev, &pcmcia_data,
+					     sizeof(struct
+						    fs_pcmcia_platform_data));
+		if (ret)
+			goto unreg;
+	}
+
+	return 0;
+
+unreg:
+	platform_device_unregister(pcmcia_dev);
+err:
+	return ret;
+}
+
+arch_initcall(fsl_pcmcia_of_init);
 
 #endif /* CONFIG_8xx */
diff --git a/drivers/pcmcia/Kconfig b/drivers/pcmcia/Kconfig
index 35f8864..c3fd55d 100644
--- a/drivers/pcmcia/Kconfig
+++ b/drivers/pcmcia/Kconfig
@@ -183,6 +183,7 @@ config PCMCIA_M8XX
         tristate "MPC8xx PCMCIA support"
         depends on PCMCIA && PPC && 8xx 
         select PCCARD_IODYN
+	select PCCARD_NONSTATIC
         help
         Say Y here to include support for PowerPC 8xx series PCMCIA
         controller.
diff --git a/drivers/pcmcia/m8xx_pcmcia.c b/drivers/pcmcia/m8xx_pcmcia.c
index 9721ed7..ddac883 100644
--- a/drivers/pcmcia/m8xx_pcmcia.c
+++ b/drivers/pcmcia/m8xx_pcmcia.c
@@ -40,10 +40,6 @@ #include <linux/types.h>
 #include <linux/fcntl.h>
 #include <linux/string.h>
 
-#include <asm/io.h>
-#include <asm/bitops.h>
-#include <asm/system.h>
-
 #include <linux/kernel.h>
 #include <linux/errno.h>
 #include <linux/slab.h>
@@ -52,10 +48,16 @@ #include <linux/ioport.h>
 #include <linux/delay.h>
 #include <linux/interrupt.h>
 #include <linux/platform_device.h>
+#include <linux/fs_pcmcia_pd.h>
 
+#include <asm/io.h>
+#include <asm/bitops.h>
+#include <asm/system.h>
+#include <asm/time.h>
 #include <asm/mpc8xx.h>
 #include <asm/8xx_immap.h>
 #include <asm/irq.h>
+#include <asm/fs_pd.h>
 
 #include <pcmcia/version.h>
 #include <pcmcia/cs_types.h>
@@ -146,27 +148,18 @@ #endif
 #define PCMCIA_MEM_WIN_BASE 0xe0000000 /* base address for memory window 0   */
 #define PCMCIA_MEM_WIN_SIZE 0x04000000 /* each memory window is 64 MByte     */
 #define PCMCIA_IO_WIN_BASE  _IO_BASE   /* base address for io window 0       */
-
-#define PCMCIA_SCHLVL PCMCIA_INTERRUPT /* Status Change Interrupt Level      */
-
 /* ------------------------------------------------------------------------- */
 
-/* 2.4.x and newer has this always in HZ */
-#define M8XX_BUSFREQ ((((bd_t *)&(__res))->bi_busfreq))
-
-static int pcmcia_schlvl = PCMCIA_SCHLVL;
+static int pcmcia_schlvl;
 
-static DEFINE_SPINLOCK(events_lock);
+static spinlock_t events_lock = SPIN_LOCK_UNLOCKED;
 
 
 #define PCMCIA_SOCKET_KEY_5V 1
 #define PCMCIA_SOCKET_KEY_LV 2
 
 /* look up table for pgcrx registers */
-static u32 *m8xx_pgcrx[2] = {
-	&((immap_t *)IMAP_ADDR)->im_pcmcia.pcmc_pgcra,
-	&((immap_t *)IMAP_ADDR)->im_pcmcia.pcmc_pgcrb
-};
+static u32 *m8xx_pgcrx[2];
 
 /*
  * This structure is used to address each window in the PCMCIA controller.
@@ -228,11 +221,16 @@ struct event_table {
 	u32 eventbit;
 };
 
+static const char driver_name[] = "m8xx-pcmcia";
+
 struct socket_info {
 	void	(*handler)(void *info, u32 events);
 	void	*info;
 
 	u32 slot;
+	pcmconf8xx_t *pcmcia;
+	struct platform_device *pdev;
+	struct fs_pcmcia_platform_data *pdata;
 
 	socket_state_t state;
 	struct pccard_mem_map mem_win[PCMCIA_MEM_WIN_NO];
@@ -404,83 +402,15 @@ static void hardware_disable(int slot)
 #endif
 
 /* MPC885ADS Boards */
-
 #if defined(CONFIG_MPC885ADS)
 
 #define PCMCIA_BOARD_MSG "MPC885ADS"
-
-static int voltage_set(int slot, int vcc, int vpp)
-{
-	u32 reg = 0;
-	unsigned *bcsr_io;
-
-	bcsr_io = ioremap(BCSR1, sizeof(unsigned long));
-
-	switch(vcc) {
-		case 0:
-			break;
-		case 33:
-			reg |= BCSR1_PCCVCC0;
-			break;
-		case 50:
-			reg |= BCSR1_PCCVCC1;
-			break;
-		default:
-			goto out_unmap;
-	}
-
-	switch(vpp) {
-		case 0:
-			break;
-		case 33:
-		case 50:
-			if(vcc == vpp)
-				reg |= BCSR1_PCCVPP1;
-			else
-				goto out_unmap;
-			break;
-		case 120:
-			if ((vcc == 33) || (vcc == 50))
-				reg |= BCSR1_PCCVPP0;
-			else
-				goto out_unmap;
-		default:
-			goto out_unmap;
-	}
-
-	/* first, turn off all power */
-	out_be32(bcsr_io, in_be32(bcsr_io) & ~(BCSR1_PCCVCC_MASK | BCSR1_PCCVPP_MASK));
-
-	/* enable new powersettings */
-	out_be32(bcsr_io, in_be32(bcsr_io) | reg);
-
-	iounmap(bcsr_io);
-	return 0;
-
-out_unmap:
-	iounmap(bcsr_io);
-	return 1;
-}
-
 #define socket_get(_slot_) PCMCIA_SOCKET_KEY_5V
 
-static void hardware_enable(int slot)
-{
-	unsigned *bcsr_io;
-
-	bcsr_io = ioremap(BCSR1, sizeof(unsigned long));
-	out_be32(bcsr_io, in_be32(bcsr_io) & ~BCSR1_PCCEN);
-	iounmap(bcsr_io);
-}
-
-static void hardware_disable(int slot)
-{
-	unsigned *bcsr_io;
-
-	bcsr_io = ioremap(BCSR1, sizeof(unsigned long));
-	out_be32(bcsr_io, in_be32(bcsr_io) |  BCSR1_PCCEN);
-	iounmap(bcsr_io);
-}
+/* These functions are defined in the board-specific code */
+#define hardware_enable(_slot_)	pdata->hw_setup(_slot_, 1)
+#define hardware_disable(_slot_) pdata->hw_setup(_slot_, 0)
+#define voltage_set(slot, vcc, vpp)	pdata->voltage_set(slot, vcc, vpp)
 
 #endif
 
@@ -541,6 +471,7 @@ #define hardware_enable(_slot_)  /* No h
 #define hardware_disable(_slot_) /* No hardware to disable */
 
 #endif /* CONFIG_MBX */
+/* Motorola MBX860 */
 
 #if defined(CONFIG_PRxK)
 #include <asm/cpld.h>
@@ -604,63 +535,22 @@ #define hardware_disable(_slot_) /* No h
 
 #endif /* CONFIG_PRxK */
 
-static void m8xx_shutdown(void)
-{
-	u32 m, i;
-	struct pcmcia_win *w;
-
-	for(i = 0; i < PCMCIA_SOCKETS_NO; i++){
-		w = (void *) &((immap_t *)IMAP_ADDR)->im_pcmcia.pcmc_pbr0;
-
-		out_be32(&((immap_t *)IMAP_ADDR)->im_pcmcia.pcmc_pscr, M8XX_PCMCIA_MASK(i));
-		out_be32(&((immap_t *)IMAP_ADDR)->im_pcmcia.pcmc_per, in_be32(&((immap_t *)IMAP_ADDR)->im_pcmcia.pcmc_per) & ~M8XX_PCMCIA_MASK(i));
-
-		/* turn off interrupt and disable CxOE */
-		out_be32(M8XX_PGCRX(i), M8XX_PGCRX_CXOE);
-
-		/* turn off memory windows */
-		for(m = 0; m < PCMCIA_MEM_WIN_NO; m++) {
-			out_be32(&w->or, 0); /* set to not valid */
-			w++;
-		}
-
-		/* turn off voltage */
-		voltage_set(i, 0, 0);
-
-		/* disable external hardware */
-		hardware_disable(i);
-	}
-
-	free_irq(pcmcia_schlvl, NULL);
-}
-
-static struct device_driver m8xx_driver = {
-        .name = "m8xx-pcmcia",
-        .bus = &platform_bus_type,
-        .suspend = pcmcia_socket_dev_suspend,
-        .resume = pcmcia_socket_dev_resume,
-};
-
-static struct platform_device m8xx_device = {
-        .name = "m8xx-pcmcia",
-        .id = 0,
-};
-
 static u32 pending_events[PCMCIA_SOCKETS_NO];
-static DEFINE_SPINLOCK(pending_event_lock);
+static spinlock_t pending_event_lock = SPIN_LOCK_UNLOCKED;
 
 static irqreturn_t m8xx_interrupt(int irq, void *dev)
 {
 	struct socket_info *s;
 	struct event_table *e;
 	unsigned int i, events, pscr, pipr, per;
+	pcmconf8xx_t	*pcmcia = socket[0].pcmcia;
 
 	dprintk("Interrupt!\n");
 	/* get interrupt sources */
 
-	pscr = in_be32(&((immap_t *)IMAP_ADDR)->im_pcmcia.pcmc_pscr);
-	pipr = in_be32(&((immap_t *)IMAP_ADDR)->im_pcmcia.pcmc_pipr);
-	per = in_be32(&((immap_t *)IMAP_ADDR)->im_pcmcia.pcmc_per);
+	pscr = in_be32(&pcmcia->pcmc_pscr);
+	pipr = in_be32(&pcmcia->pcmc_pipr);
+	per = in_be32(&pcmcia->pcmc_per);
 
 	for(i = 0; i < PCMCIA_SOCKETS_NO; i++) {
 		s = &socket[i];
@@ -724,7 +614,7 @@ #endif
 			per &= ~M8XX_PCMCIA_RDY_L(0);
 			per &= ~M8XX_PCMCIA_RDY_L(1);
 
-			out_be32(&((immap_t *)IMAP_ADDR)->im_pcmcia.pcmc_per, per);
+			out_be32(&pcmcia->pcmc_per, per);
 
 			if (events)
 				pcmcia_parse_events(&socket[i].socket, events);
@@ -732,7 +622,7 @@ #endif
 	}
 
 	/* clear the interrupt sources */
-	out_be32(&((immap_t *)IMAP_ADDR)->im_pcmcia.pcmc_pscr, pscr);
+	out_be32(&pcmcia->pcmc_pscr, pscr);
 
 	dprintk("Interrupt done.\n");
 
@@ -753,7 +643,7 @@ static u32 m8xx_get_graycode(u32 size)
 	return k;
 }
 
-static u32 m8xx_get_speed(u32 ns, u32 is_io)
+static u32 m8xx_get_speed(u32 ns, u32 is_io, u32 bus_freq)
 {
 	u32 reg, clocks, psst, psl, psht;
 
@@ -781,7 +671,7 @@ static u32 m8xx_get_speed(u32 ns, u32 is
 
 #define ADJ 180 /* 80 % longer accesstime - to be sure */
 
-	clocks = ((M8XX_BUSFREQ / 1000) * ns) / 1000;
+	clocks = ((bus_freq / 1000) * ns) / 1000;
 	clocks = (clocks * ADJ) / (100*1000);
 	if(clocks >= PCMCIA_BMT_LIMIT) {
 		printk( "Max access time limit reached\n");
@@ -806,8 +696,9 @@ static int m8xx_get_status(struct pcmcia
 	int lsock = container_of(sock, struct socket_info, socket)->slot;
 	struct socket_info *s = &socket[lsock];
 	unsigned int pipr, reg;
+	pcmconf8xx_t *pcmcia = s->pcmcia;
 
-	pipr = in_be32(&((immap_t *)IMAP_ADDR)->im_pcmcia.pcmc_pipr);
+	pipr = in_be32(&pcmcia->pcmc_pipr);
 
 	*value  = ((pipr & (M8XX_PCMCIA_CD1(lsock)
 			    | M8XX_PCMCIA_CD2(lsock))) == 0) ? SS_DETECT : 0;
@@ -915,9 +806,11 @@ static int m8xx_set_socket(struct pcmcia
 {
 	int lsock = container_of(sock, struct socket_info, socket)->slot;
 	struct socket_info *s = &socket[lsock];
+	struct fs_pcmcia_platform_data *pdata = s->pdata;
 	struct event_table *e;
 	unsigned int reg;
 	unsigned long flags;
+	pcmconf8xx_t *pcmcia = socket[0].pcmcia;
 
 	dprintk( "SetSocket(%d, flags %#3.3x, Vcc %d, Vpp %d, "
 	      "io_irq %d, csc_mask %#2.2x)\n", lsock, state->flags,
@@ -927,6 +820,7 @@ static int m8xx_set_socket(struct pcmcia
 	if(voltage_set(lsock, state->Vcc, state->Vpp))
 		return -EINVAL;
 
+
 	/* Take care of reset... */
 	if(state->flags & SS_RESET)
 		out_be32(M8XX_PGCRX(lsock), in_be32(M8XX_PGCRX(lsock)) |  M8XX_PGCRX_CXRESET); /* active high */
@@ -982,7 +876,8 @@ static int m8xx_set_socket(struct pcmcia
 		 * If io_irq is non-zero we should enable irq.
 		 */
 		if(state->io_irq) {
-			out_be32(M8XX_PGCRX(lsock), in_be32(M8XX_PGCRX(lsock)) | mk_int_int_mask(state->io_irq) << 24);
+			int hwirq = s->pdata->hwirq;
+			out_be32(M8XX_PGCRX(lsock), in_be32(M8XX_PGCRX(lsock)) | mk_int_int_mask(hwirq) << 24);
 			/*
 			 * Strange thing here:
 			 * The manual does not tell us which interrupt
@@ -1027,7 +922,7 @@ static int m8xx_set_socket(struct pcmcia
 	 * Writing ones will clear the bits.
 	 */
 
-	out_be32(&((immap_t *)IMAP_ADDR)->im_pcmcia.pcmc_pscr, reg);
+	out_be32(&pcmcia->pcmc_pscr, reg);
 
 	/*
 	 * Write the mask.
@@ -1036,15 +931,8 @@ static int m8xx_set_socket(struct pcmcia
 	 * Ones will enable the interrupt.
 	 */
 
-	/*
-	  reg |= ((immap_t *)IMAP_ADDR)->im_pcmcia.pcmc_per
-	  & M8XX_PCMCIA_MASK(lsock);
-	*/
-
-	reg |= in_be32(&((immap_t *)IMAP_ADDR)->im_pcmcia.pcmc_per) &
-		(M8XX_PCMCIA_MASK(0) | M8XX_PCMCIA_MASK(1));
-
-	out_be32(&((immap_t *)IMAP_ADDR)->im_pcmcia.pcmc_per, reg);
+	reg |= in_be32(&pcmcia->pcmc_per) & (M8XX_PCMCIA_MASK(0) | M8XX_PCMCIA_MASK(1));
+	out_be32(&pcmcia->pcmc_per, reg);
 
 	spin_unlock_irqrestore(&events_lock, flags);
 
@@ -1062,6 +950,8 @@ static int m8xx_set_io_map(struct pcmcia
 	struct socket_info *s = &socket[lsock];
 	struct pcmcia_win *w;
 	unsigned int reg, winnr;
+	pcmconf8xx_t *pcmcia = s->pcmcia;
+
 
 #define M8XX_SIZE (io->stop - io->start + 1)
 #define M8XX_BASE (PCMCIA_IO_WIN_BASE + io->start)
@@ -1086,7 +976,7 @@ #define M8XX_BASE (PCMCIA_IO_WIN_BASE + 
 
 		/* setup registers */
 
-		w = (void *) &((immap_t *)IMAP_ADDR)->im_pcmcia.pcmc_pbr0;
+		w = (void *) &pcmcia->pcmc_pbr0;
 		w += winnr;
 
 		out_be32(&w->or, 0); /* turn off window first */
@@ -1095,12 +985,13 @@ #define M8XX_BASE (PCMCIA_IO_WIN_BASE + 
 		reg <<= 27;
   		reg |= M8XX_PCMCIA_POR_IO |(lsock << 2);
 
-		reg |= m8xx_get_speed(io->speed, 1);
+		reg |= m8xx_get_speed(io->speed, 1, s->pdata->bus_freq);
 
 		if(io->flags & MAP_WRPROT)
 			reg |= M8XX_PCMCIA_POR_WRPROT;
 
-		if(io->flags & (MAP_16BIT | MAP_AUTOSZ))
+		/*if(io->flags & (MAP_16BIT | MAP_AUTOSZ))*/
+		if(io->flags & MAP_16BIT)
 			reg |= M8XX_PCMCIA_POR_16BIT;
 
 		if(io->flags & MAP_ACTIVE)
@@ -1117,7 +1008,7 @@ #define M8XX_BASE (PCMCIA_IO_WIN_BASE + 
 
 		/* setup registers */
 
-		w = (void *) &((immap_t *)IMAP_ADDR)->im_pcmcia.pcmc_pbr0;
+		w = (void *) &pcmcia->pcmc_pbr0;
 		w += winnr;
 
 		out_be32(&w->or, 0); /* turn off window */
@@ -1144,6 +1035,7 @@ static int m8xx_set_mem_map(struct pcmci
 	struct pcmcia_win *w;
 	struct pccard_mem_map *old;
 	unsigned int reg, winnr;
+	pcmconf8xx_t *pcmcia = s->pcmcia;
 
 	dprintk( "SetMemMap(%d, %d, %#2.2x, %d ns, "
 	      "%#5.5lx, %#5.5x)\n", lsock, mem->map, mem->flags,
@@ -1166,12 +1058,12 @@ static int m8xx_set_mem_map(struct pcmci
 
 	/* Setup the window in the pcmcia controller */
 
-	w = (void *) &((immap_t *)IMAP_ADDR)->im_pcmcia.pcmc_pbr0;
+	w = (void *) &pcmcia->pcmc_pbr0;
 	w += winnr;
 
 	reg |= lsock << 2;
 
-	reg |= m8xx_get_speed(mem->speed, 0);
+	reg |= m8xx_get_speed(mem->speed, 0, s->pdata->bus_freq);
 
 	if(mem->flags & MAP_ATTRIB)
 		reg |=  M8XX_PCMCIA_POR_ATTRMEM;
@@ -1236,57 +1128,69 @@ static int m8xx_sock_init(struct pcmcia_
 
 }
 
-static int m8xx_suspend(struct pcmcia_socket *sock)
+static int m8xx_sock_suspend(struct pcmcia_socket *sock)
 {
 	return m8xx_set_socket(sock, &dead_socket);
 }
 
 static struct pccard_operations m8xx_services = {
 	.init	= m8xx_sock_init,
-	.suspend = m8xx_suspend,
+	.suspend = m8xx_sock_suspend,
 	.get_status = m8xx_get_status,
 	.set_socket = m8xx_set_socket,
 	.set_io_map = m8xx_set_io_map,
 	.set_mem_map = m8xx_set_mem_map,
 };
 
-static int __init m8xx_init(void)
+static int __init m8xx_probe(struct platform_device *pdev)
 {
 	struct pcmcia_win *w;
-	unsigned int i,m;
+	unsigned int i, m, hwirq;
+	pcmconf8xx_t *pcmcia;
+	int status;
+	struct resource *r;
+	struct fs_pcmcia_platform_data *pdata = pdev->dev.platform_data;
 
 	pcmcia_info("%s\n", version);
 
-	if (driver_register(&m8xx_driver))
-		return -1;
+	r = platform_get_resource_byname(pdev, IORESOURCE_MEM, "regs");
+
+	pcmcia = ioremap(r->start, r->end - r->start + 1);
+	if(pcmcia == NULL)
+		return -EINVAL;
+
+	pcmcia_schlvl = platform_get_irq_byname(pdev,"interrupt");
+	if (pcmcia_schlvl < 0)
+		return -EINVAL;
+	hwirq = pdata->hwirq;
+
+	m8xx_pgcrx[0] = &pcmcia->pcmc_pgcra;
+	m8xx_pgcrx[1] = &pcmcia->pcmc_pgcrb;
+
 
 	pcmcia_info(PCMCIA_BOARD_MSG " using " PCMCIA_SLOT_MSG
-		    " with IRQ %u.\n", pcmcia_schlvl);
+		    " with IRQ %u  (%d). \n", pcmcia_schlvl, hwirq);
 
 	/* Configure Status change interrupt */
 
-	if(request_irq(pcmcia_schlvl, m8xx_interrupt, 0,
-			  "m8xx_pcmcia", NULL)) {
+	if(request_irq(pcmcia_schlvl, m8xx_interrupt, IRQF_SHARED,
+			  driver_name, socket)) {
 		pcmcia_error("Cannot allocate IRQ %u for SCHLVL!\n",
 			     pcmcia_schlvl);
 		return -1;
 	}
 
-	w = (void *) &((immap_t *)IMAP_ADDR)->im_pcmcia.pcmc_pbr0;
-
-	out_be32(&((immap_t *)IMAP_ADDR)->im_pcmcia.pcmc_pscr,
-		M8XX_PCMCIA_MASK(0)| M8XX_PCMCIA_MASK(1));
+	w = (void *) &pcmcia->pcmc_pbr0;
 
-	out_be32(&((immap_t *)IMAP_ADDR)->im_pcmcia.pcmc_per,
-		in_be32(&((immap_t *)IMAP_ADDR)->im_pcmcia.pcmc_per) &
-		~(M8XX_PCMCIA_MASK(0)| M8XX_PCMCIA_MASK(1)));
+	out_be32(&pcmcia->pcmc_pscr, M8XX_PCMCIA_MASK(0)| M8XX_PCMCIA_MASK(1));
+	clrbits32(&pcmcia->pcmc_per, M8XX_PCMCIA_MASK(0) | M8XX_PCMCIA_MASK(1));
 
-/* connect interrupt and disable CxOE */
+	/* connect interrupt and disable CxOE */
 
-	out_be32(M8XX_PGCRX(0), M8XX_PGCRX_CXOE | (mk_int_int_mask(pcmcia_schlvl) << 16));
-	out_be32(M8XX_PGCRX(1), M8XX_PGCRX_CXOE | (mk_int_int_mask(pcmcia_schlvl) << 16));
+	out_be32(M8XX_PGCRX(0), M8XX_PGCRX_CXOE | (mk_int_int_mask(hwirq) << 16));
+	out_be32(M8XX_PGCRX(1), M8XX_PGCRX_CXOE | (mk_int_int_mask(hwirq) << 16));
 
-/* intialize the fixed memory windows */
+	/* intialize the fixed memory windows */
 
 	for(i = 0; i < PCMCIA_SOCKETS_NO; i++){
 		for(m = 0; m < PCMCIA_MEM_WIN_NO; m++) {
@@ -1300,16 +1204,14 @@ static int __init m8xx_init(void)
 		}
 	}
 
-/* turn off voltage */
+	/* turn off voltage */
 	voltage_set(0, 0, 0);
 	voltage_set(1, 0, 0);
 
-/* Enable external hardware */
+	/* Enable external hardware */
 	hardware_enable(0);
 	hardware_enable(1);
 
-	platform_device_register(&m8xx_device);
-
 	for (i = 0 ; i < PCMCIA_SOCKETS_NO; i++) {
 		socket[i].slot = i;
 		socket[i].socket.owner = THIS_MODULE;
@@ -1317,30 +1219,90 @@ static int __init m8xx_init(void)
 		socket[i].socket.irq_mask = 0x000;
 		socket[i].socket.map_size = 0x1000;
 		socket[i].socket.io_offset = 0;
-		socket[i].socket.pci_irq = i  ? 7 : 9;
+		socket[i].socket.pci_irq = pcmcia_schlvl;
 		socket[i].socket.ops = &m8xx_services;
-		socket[i].socket.resource_ops = &pccard_iodyn_ops;
+		socket[i].socket.resource_ops = &pccard_nonstatic_ops;
 		socket[i].socket.cb_dev = NULL;
-		socket[i].socket.dev.parent = &m8xx_device.dev;
+		socket[i].socket.dev.parent = &pdev->dev;
+		socket[i].pcmcia = pcmcia;
+		socket[i].pdata = pdata;
 	}
 
-	for (i = 0; i < PCMCIA_SOCKETS_NO; i++)
-		pcmcia_register_socket(&socket[i].socket);
+	for (i = 0; i < PCMCIA_SOCKETS_NO; i++) {
+		status = pcmcia_register_socket(&socket[i].socket);
+		if (status < 0)
+			pcmcia_error("Socket register failed\n");
+	}
 
 	return 0;
 }
 
-static void __exit m8xx_exit(void)
+static int __exit m8xx_shutdown(struct platform_device *pdev)
 {
-	int i;
+	u32 m, i;
+	struct pcmcia_win *w;
+	pcmconf8xx_t *pcmcia = socket[0].pcmcia;
+	struct fs_pcmcia_platform_data *pdata = socket[0].pdata;
+
+	for(i = 0; i < PCMCIA_SOCKETS_NO; i++){
+		w = (void *) &pcmcia->pcmc_pbr0;
+
+		out_be32(&pcmcia->pcmc_pscr, M8XX_PCMCIA_MASK(i));
+		out_be32(&pcmcia->pcmc_per, in_be32(&pcmcia->pcmc_per) & ~M8XX_PCMCIA_MASK(i));
+
+		/* turn off interrupt and disable CxOE */
+		out_be32(M8XX_PGCRX(i), M8XX_PGCRX_CXOE);
 
+		/* turn off memory windows */
+		for(m = 0; m < PCMCIA_MEM_WIN_NO; m++) {
+			out_be32(&w->or, 0); /* set to not valid */
+			w++;
+		}
+
+		/* turn off voltage */
+		voltage_set(i, 0, 0);
+
+		/* disable external hardware */
+		hardware_disable(i);
+	}
 	for (i = 0; i < PCMCIA_SOCKETS_NO; i++)
 		pcmcia_unregister_socket(&socket[i].socket);
 
-	m8xx_shutdown();
+	free_irq(pcmcia_schlvl, NULL);
+
+	return 0;
+}
+
+static int m8xx_suspend(struct platform_device *pdev, pm_message_t state)
+{
+        return pcmcia_socket_dev_suspend(&pdev->dev, state);
+}
+
+static int m8xx_resume(struct platform_device *pdev)
+{
+        return pcmcia_socket_dev_resume(&pdev->dev);
+}
 
-	platform_device_unregister(&m8xx_device);
-	driver_unregister(&m8xx_driver);
+static struct platform_driver m8xx_driver = {
+	.driver = {
+		.name		= (char *) driver_name,
+		.owner		= THIS_MODULE,
+	},
+	.probe		= m8xx_probe,
+	.remove		= __exit_p(m8xx_shutdown),
+	.suspend	= m8xx_suspend,
+	.resume		= m8xx_resume,
+};
+
+
+static int __init m8xx_init(void)
+{
+	return platform_driver_register(&m8xx_driver);
+}
+
+static void __exit m8xx_exit(void)
+{
+	platform_driver_unregister(&m8xx_driver);
 }
 
 module_init(m8xx_init);
diff --git a/include/linux/fs_pcmcia_pd.h b/include/linux/fs_pcmcia_pd.h
new file mode 100644
index 0000000..2769a11
--- /dev/null
+++ b/include/linux/fs_pcmcia_pd.h
@@ -0,0 +1,27 @@
+/*
+ * Platform information definitions for the CPM Uart driver.
+ *
+ * 2007 (c) MontaVista Software, Inc.
+ * Yuri Shpilevsky <yshpilevsky@ru.mvista.com>
+ *
+ * This file is licensed under the terms of the GNU General Public License
+ * version 2. This program is licensed "as is" without any warranty of any
+ * kind, whether express or implied.
+ */
+
+#ifndef FS_PCMCIA_PD_H
+#define FS_PCMCIA_PD_H
+
+#include <linux/version.h>
+#include <asm/types.h>
+
+struct fs_pcmcia_platform_data {
+	void(*hw_setup)(int slot, int enable);
+	int(*voltage_set)(int slot, int vcc, int vpp);
+
+	/* device specific information */
+	int hwirq;
+	u32 bus_freq;
+};
+
+#endif


-- 
Sincerely, 
Vitaly


-- 
Sincerely, 
Vitaly

_______________________________________________
Linux PCMCIA reimplementation list
http://lists.infradead.org/mailman/listinfo/linux-pcmcia


-- 
Sincerely, Vitaly

