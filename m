Return-Path: <linux-kernel-owner+w=401wt.eu-S1757685AbZFCTIf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757685AbZFCTIf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 15:08:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753501AbZFCTI2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 15:08:28 -0400
Received: from mail-ew0-f212.google.com ([209.85.219.212]:52193 "EHLO
	mail-ew0-f212.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753399AbZFCTIZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 15:08:25 -0400
X-Greylist: delayed 333 seconds by postgrey-1.27 at vger.kernel.org; Wed, 03 Jun 2009 15:08:24 EDT
MIME-Version: 1.0
In-Reply-To: <4A269A83.3020008@drewtech.com>
References: <c8284b5b0905281440hd2e4993re3d0d8c590713fa0@mail.gmail.com>
	 <4A1FFEFB.6050104@drewtech.com>
	 <c8284b5b0906020953o7c112b4hc264b5520cc3aed1@mail.gmail.com>
	 <4A269251.8090706@atmel.com> <4A269A83.3020008@drewtech.com>
Date: Wed, 3 Jun 2009 12:02:53 -0700
X-Google-Sender-Auth: 459a7f6a58c40bce
Message-ID: <c8284b5b0906031202u18433b52s1a0718ef627fddf0@mail.gmail.com>
Subject: Re: [PATCH][Updated] New AT91 MCI Driver that supports both MCI slots 
	used at the same time
From: Rob Emanuele <poorarm@shoreis.com>
To: Joey Oravec <joravec@drewtech.com>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>,
       linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org,
       Haavard Skinnemoen <hskinnemoen@atmel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings,

This updated patch creates a new AT91 Multimedia Card Interface
(MCI) driver that supports using both MCI slots at the same time.
I'm looking for others to test this patch on other boards within the
same family of chips.

This driver is a port the Atmel AVR32 MCI driver which uses similar silicon.

In addition it modifies the AT91SAM9G20-EK's board platform config to
support having MCI Slot A hooked to an SD Slot.  This was the board
that this was developed on. There is a compile-time config option to
support MCI Slot A on this board.  It moves the LEDs and ethernet irq
line to other GPIOs as the Slot A pins overlap those on Rev A and B
boards.  (In related news, Atmel has made AT91SAM9G20-EK rev. D
schematics available on their website that have both MCI slots
exposed.)  If you are using this on other boards and processors you will
need to create a modify your platform config accordingly.  Use the patched
board-sam9g20ek.c as an example.

Joey Oravec has mentioned that he has had better reliability with the chip
he is using (AT91SAM9261) if the MMC controller is reset before each
command.  There is a compile time option to do just that.

Joey Oravec has stated that the Read and Write Proof functionality that
prevents buffer overflows is not available on the AT91SAM9261.  This was
confirmed by Nicolas Ferre and also affects the AT91RM9200.  This new
patch excludes those register config bits.

Please comment and try it out,

Rob Emanuele


diff --git a/arch/arm/mach-at91/Kconfig b/arch/arm/mach-at91/Kconfig
index 323b47f..7f6c96a 100644
--- a/arch/arm/mach-at91/Kconfig
+++ b/arch/arm/mach-at91/Kconfig
@@ -326,6 +326,12 @@ config MTD_NAND_ATMEL_BUSWIDTH_16
 	  On AT91SAM926x boards both types of NAND flash can be present
 	  (8 and 16 bit data bus width).

+config AT91_2MMC
+	bool "Use both MMC Ports"
+	depends on MACH_AT91SAM9G20EK
+	help
+	  Select this if you have connected both MMC Slots.  Answer No if unsure.
+
 # ----------------------------------------------------------

 comment "AT91 Feature Selections"
diff --git a/arch/arm/mach-at91/at91sam9260_devices.c
b/arch/arm/mach-at91/at91sam9260_devices.c
index d74c9ac..11f8484 100644
--- a/arch/arm/mach-at91/at91sam9260_devices.c
+++ b/arch/arm/mach-at91/at91sam9260_devices.c
@@ -275,8 +275,103 @@ void __init at91_add_device_mmc(short mmc_id,
struct at91_mmc_data *data)
 	platform_device_register(&at91sam9260_mmc_device);
 }
 #else
+
+/* --------------------------------------------------------------------
+ *  MMC / SD Slot for 2nd Gen Driver
+ * -------------------------------------------------------------------- */
+
+#if defined(CONFIG_MMC_AT91GEN2) || defined(CONFIG_MMC_AT91GEN2_MODULE)
+static u64 mmc_dmamask = DMA_BIT_MASK(32);
+static struct at91_mmc_data mmc_data;
+
+static struct resource mmc_resources[] = {
+	[0] = {
+		.start	= AT91SAM9260_BASE_MCI,
+		.end	= AT91SAM9260_BASE_MCI + SZ_16K - 1,
+		.flags	= IORESOURCE_MEM,
+	},
+	[1] = {
+		.start	= AT91SAM9260_ID_MCI,
+		.end	= AT91SAM9260_ID_MCI,
+		.flags	= IORESOURCE_IRQ,
+	},
+};
+
+static struct platform_device at91sam9260_mmc_device = {
+	.name		= "at91_mci",
+	.id		= -1,
+	.dev		= {
+				.dma_mask		= &mmc_dmamask,
+				.coherent_dma_mask	= DMA_BIT_MASK(32),
+				.platform_data		= &mmc_data,
+	},
+	.resource	= mmc_resources,
+	.num_resources	= ARRAY_SIZE(mmc_resources),
+};
+
+void __init at91_add_device_mmc(short mmc_id, struct at91_mmc_data *data)
+{
+        unsigned int i;
+        unsigned int slot_count = 0;
+
+	if (!data)
+		return;
+
+        for (i = 0; i < AT91_MCI_MAX_NR_SLOTS; i++) {
+                if (data->slot[i].bus_width) {
+                        /* input/irq */
+                        if (data->slot[i].det_pin) {
+                                at91_set_gpio_input(data->slot[i].det_pin, 1);
+                                at91_set_deglitch(data->slot[i].det_pin, 1);
+                }
+                if (data->slot[i].wp_pin)
+                        at91_set_gpio_input(data->slot[i].wp_pin, 1);
+                if (data->slot[i].vcc_pin)
+                        at91_set_gpio_output(data->slot[i].vcc_pin, 0);
+
+                switch(i) {
+                case 0:
+                        /* CMD */
+                        at91_set_A_periph(AT91_PIN_PA7, 1);
+                        /* DAT0, maybe DAT1..DAT3 */
+                        at91_set_A_periph(AT91_PIN_PA6, 1);
+                        if (data->slot[i].bus_width == 4) {
+                                at91_set_A_periph(AT91_PIN_PA9, 1);
+                                at91_set_A_periph(AT91_PIN_PA10, 1);
+                                at91_set_A_periph(AT91_PIN_PA11, 1);
+                        }
+                        break;
+                case 1:
+                        /* CMD */
+                        at91_set_B_periph(AT91_PIN_PA1, 1);
+                        /* DAT0, maybe DAT1..DAT3 */
+                        at91_set_B_periph(AT91_PIN_PA0, 1);
+                        if (data->slot[i].bus_width == 4) {
+                                at91_set_B_periph(AT91_PIN_PA5, 1);
+                                at91_set_B_periph(AT91_PIN_PA4, 1);
+                                at91_set_B_periph(AT91_PIN_PA3, 1);
+                        }
+                        break;
+                default:
+                    break;
+                };
+                slot_count++;
+                }
+        }
+
+        if (slot_count) {
+                /* CLK */
+                at91_set_A_periph(AT91_PIN_PA8, 0);
+
+                mmc_data = *data;
+                platform_device_register(&at91sam9260_mmc_device);
+        }
+}
+#else
 void __init at91_add_device_mmc(short mmc_id, struct at91_mmc_data *data) {}
 #endif
+#endif
+


 /* --------------------------------------------------------------------
@@ -329,7 +424,7 @@ void __init at91_add_device_nand(struct
atmel_nand_data *data)
 	if (data->rdy_pin)
 		at91_set_gpio_input(data->rdy_pin, 1);

-	/* card detect pin */
+	/* card det pin */
 	if (data->det_pin)
 		at91_set_gpio_input(data->det_pin, 1);

diff --git a/arch/arm/mach-at91/board-sam9g20ek.c
b/arch/arm/mach-at91/board-sam9g20ek.c
index 81439fe..038bfdd 100644
--- a/arch/arm/mach-at91/board-sam9g20ek.c
+++ b/arch/arm/mach-at91/board-sam9g20ek.c
@@ -89,7 +89,7 @@ static struct at91_udc_data __initdata ek_udc_data = {
  * SPI devices.
  */
 static struct spi_board_info ek_spi_devices[] = {
-#if !defined(CONFIG_MMC_AT91)
+#if !defined(CONFIG_MMC_AT91) && !defined(CONFIG_MMC_AT91GEN2)
 	{	/* DataFlash chip */
 		.modalias	= "mtd_dataflash",
 		.chip_select	= 1,
@@ -112,7 +112,11 @@ static struct spi_board_info ek_spi_devices[] = {
  * MACB Ethernet device
  */
 static struct at91_eth_data __initdata ek_macb_data = {
+#if defined(CONFIG_AT91_2MMC)
+	.phy_irq_pin	= AT91_PIN_PC12,
+#else
 	.phy_irq_pin	= AT91_PIN_PA7,
+#endif
 	.is_rmii	= 1,
 };

@@ -195,11 +199,30 @@ static void __init ek_add_device_nand(void)
  * MCI (SD/MMC)
  * det_pin, wp_pin and vcc_pin are not connected
  */
+#if defined(CONFIG_MMC_AT91) || defined(CONFIG_MMC_AT91_MODULE)
 static struct at91_mmc_data __initdata ek_mmc_data = {
 	.slot_b		= 1,
 	.wire4		= 1,
 };
-
+#endif
+#if defined(CONFIG_MMC_AT91GEN2) || defined(CONFIG_MMC_AT91GEN2_MODULE)
+static struct at91_mmc_data __initdata ek_mmc_data = {
+	.slot[0] = {
+#if defined(CONFIG_AT91_2MMC)
+		.bus_width	= 4,
+#else
+		.bus_width	= 0,
+#endif
+		.det_pin	= -ENODEV,
+		.wp_pin		= -ENODEV,
+	},
+	.slot[1] = {
+		.bus_width	= 4,
+		.det_pin	= -ENODEV,
+		.wp_pin		= -ENODEV,
+	},
+};
+#endif

 /*
  * LEDs
@@ -207,13 +230,21 @@ static struct at91_mmc_data __initdata ek_mmc_data = {
 static struct gpio_led ek_leds[] = {
 	{	/* "bottom" led, green, userled1 to be defined */
 		.name			= "ds5",
+#if defined(CONFIG_AT91_2MMC)
+		.gpio			= AT91_PIN_PB12,
+#else
 		.gpio			= AT91_PIN_PA6,
+#endif
 		.active_low		= 1,
 		.default_trigger	= "none",
 	},
 	{	/* "power" led, yellow */
 		.name			= "ds1",
+#if defined(CONFIG_AT91_2MMC)
+		.gpio			= AT91_PIN_PB13,
+#else
 		.gpio			= AT91_PIN_PA9,
+#endif
 		.default_trigger	= "heartbeat",
 	}
 };
diff --git a/arch/arm/mach-at91/include/mach/at91_mci.h
b/arch/arm/mach-at91/include/mach/at91_mci.h
index 550d503..c9021ea 100644
--- a/arch/arm/mach-at91/include/mach/at91_mci.h
+++ b/arch/arm/mach-at91/include/mach/at91_mci.h
@@ -35,7 +35,9 @@

 #define AT91_MCI_DTOR		0x08		/* Data Timeout Register */
 #define		AT91_MCI_DTOCYC		(0xf << 0)	/* Data Timeout Cycle Number */
+#define		AT91_MCI_DTOCYC_F(n)	((0xf & (n)) << 0)	/* Data Timeout
Cycle Number Function*/
 #define		AT91_MCI_DTOMUL		(7   << 4)	/* Data Timeout Multiplier */
+#define		AT91_MCI_DTOMUL_F(n)	(((n) & 0x7) << 4)	/* Data Timeout
Multiplier Function*/
 #define		AT91_MCI_DTOMUL_1		(0 <<  4)
 #define		AT91_MCI_DTOMUL_16		(1 <<  4)
 #define		AT91_MCI_DTOMUL_128		(2 <<  4)
@@ -80,8 +82,8 @@
 #define		AT91_MCI_BLKR_BLKLEN(n)	((0xffff & (n)) << 16)	/* Block lenght */

 #define AT91_MCI_RSPR(n)	(0x20 + ((n) * 4))	/* Response Registers 0-3 */
-#define AT91_MCR_RDR		0x30		/* Receive Data Register */
-#define AT91_MCR_TDR		0x34		/* Transmit Data Register */
+#define AT91_MCI_RDR		0x30		/* Receive Data Register */
+#define AT91_MCI_TDR		0x34		/* Transmit Data Register */

 #define AT91_MCI_SR		0x40		/* Status Register */
 #define		AT91_MCI_CMDRDY		(1 <<  0)	/* Command Ready */
@@ -110,4 +112,6 @@
 #define AT91_MCI_IDR		0x48		/* Interrupt Disable Register */
 #define AT91_MCI_IMR		0x4c		/* Interrupt Mask Register */

+#define AT91_MCI_REGS_SIZE      0x100
+
 #endif
diff --git a/arch/arm/mach-at91/include/mach/board.h
b/arch/arm/mach-at91/include/mach/board.h
index 793fe7b..8983072 100644
--- a/arch/arm/mach-at91/include/mach/board.h
+++ b/arch/arm/mach-at91/include/mach/board.h
@@ -63,6 +63,7 @@ struct at91_cf_data {
 extern void __init at91_add_device_cf(struct at91_cf_data *data);

  /* MMC / SD */
+#if defined(CONFIG_MMC_AT91) || defined(CONFIG_MMC_AT91_MODULE)
 struct at91_mmc_data {
 	u8		det_pin;	/* card detect IRQ */
 	unsigned	slot_b:1;	/* uses Slot B */
@@ -70,6 +71,25 @@ struct at91_mmc_data {
 	u8		wp_pin;		/* (SD) writeprotect detect */
 	u8		vcc_pin;	/* power switching (high == on) */
 };
+#endif
+
+#if defined(CONFIG_MMC_AT91GEN2) || defined(CONFIG_MMC_AT91GEN2_MODULE)
+#define AT91_MCI_MAX_NR_SLOTS  2
+
+struct dma_slave;
+
+struct at91_mmc_slot_pdata {
+        unsigned int            bus_width;
+        int                     det_pin;
+        int                     wp_pin;
+        int                     vcc_pin;
+};
+
+struct at91_mmc_data {
+        struct dma_slave        *dma_slave;
+        struct at91_mmc_slot_pdata   slot[AT91_MCI_MAX_NR_SLOTS];
+};
+#endif
 extern void __init at91_add_device_mmc(short mmc_id, struct
at91_mmc_data *data);

  /* Ethernet (EMAC & MACB) */
diff --git a/drivers/mmc/host/Kconfig b/drivers/mmc/host/Kconfig
index 99d4b28..ddabe75 100644
--- a/drivers/mmc/host/Kconfig
+++ b/drivers/mmc/host/Kconfig
@@ -114,6 +114,26 @@ config MMC_AT91

 	  If unsure, say N.

+config MMC_AT91GEN2
+	tristate "Atmel AT91 Multimedia Card Interface support 2nd gen"
+	depends on ARCH_AT91
+	help
+	  This selects the Atmel Multimedia Card Interface driver. If
+	  you have an AT91 platform with a Multimedia Card slot,
+	  say Y or M here.
+
+	  If unsure, say N.
+
+config MMC_AT91GEN2_ALWAYS_RESET
+	bool "Reset before every request.  Sometimes needed for buggy chips."
+	depends on MMC_AT91GEN2
+	help
+	  There are reports that some buggy controllers work better
+	  with a reset before every command.  This may improve your
+	  controller's reliability.
+
+	  If unsure, say N.
+
 config MMC_ATMELMCI
 	tristate "Atmel Multimedia Card Interface support"
 	depends on AVR32
diff --git a/drivers/mmc/host/Makefile b/drivers/mmc/host/Makefile
index dedec55..752f018 100644
--- a/drivers/mmc/host/Makefile
+++ b/drivers/mmc/host/Makefile
@@ -18,6 +18,7 @@ obj-$(CONFIG_MMC_AU1X)		+= au1xmmc.o
 obj-$(CONFIG_MMC_OMAP)		+= omap.o
 obj-$(CONFIG_MMC_OMAP_HS)	+= omap_hsmmc.o
 obj-$(CONFIG_MMC_AT91)		+= at91_mci.o
+obj-$(CONFIG_MMC_AT91GEN2)	+= at91gen2-mci.o
 obj-$(CONFIG_MMC_ATMELMCI)	+= atmel-mci.o
 obj-$(CONFIG_MMC_TIFM_SD)	+= tifm_sd.o
 obj-$(CONFIG_MMC_SPI)		+= mmc_spi.o
diff --git a/drivers/mmc/host/at91gen2-mci.c b/drivers/mmc/host/at91gen2-mci.c
new file mode 100644
index 0000000..08520dc
--- /dev/null
+++ b/drivers/mmc/host/at91gen2-mci.c
@@ -0,0 +1,1599 @@
+/*
+ * Atmel MultiMedia Card Interface driver
+ *
+ * Copyright (C) 2004-2008 Atmel Corporation
+ * Copyright (C) 2009 Rob Emanuele
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#include <linux/blkdev.h>
+#include <linux/clk.h>
+#include <linux/debugfs.h>
+#include <linux/device.h>
+#include <linux/dmaengine.h>
+#include <linux/dma-mapping.h>
+#include <linux/err.h>
+#include <linux/gpio.h>
+#include <linux/init.h>
+#include <linux/interrupt.h>
+#include <linux/ioport.h>
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/scatterlist.h>
+#include <linux/seq_file.h>
+#include <linux/stat.h>
+
+#include <linux/mmc/host.h>
+
+#include <asm/io.h>
+#include <asm/irq.h>
+#include <asm/gpio.h>
+#include <asm/unaligned.h>
+
+#include <asm/mach/mmc.h>
+#include <mach/board.h>
+#include <mach/cpu.h>
+#include <mach/at91_mci.h>
+
+#define DRIVER_NAME "at91_mci"
+
+/*
+ * Enable or disable features/registers based on
+ * whether the processor supports them
+ */
+#if !(CONFIG_ARCH_AT91RM9200 || CONFIG_ARCH_AT91SAM9261)
+#define MMC_SUPPORTS_RW_PROOF
+#endif
+
+#ifdef CONFIG_MMC_AT91GEN2_ALWAYS_RESET
+#define MMC_ALWAYS_RESET 1
+#else
+#define MMC_ALWAYS_RESET 0
+#endif
+
+
+#define AT91MCI_DATA_ERROR_FLAGS	(AT91_MCI_RINDE | AT91_MCI_RDIRE |
AT91_MCI_RCRCE	\
+				 | AT91_MCI_RENDE | AT91_MCI_RTOE | AT91_MCI_DCRCE \
+				 | AT91_MCI_DTOE | AT91_MCI_OVRE | AT91_MCI_UNRE)
+
+enum {
+	EVENT_CMD_COMPLETE = 0,
+	EVENT_XFER_COMPLETE,
+	EVENT_DATA_COMPLETE,
+	EVENT_DATA_ERROR,
+};
+
+enum at91_mci_state {
+	STATE_IDLE = 0,
+	STATE_SENDING_CMD,
+	STATE_SENDING_DATA,
+	STATE_DATA_BUSY,
+	STATE_SENDING_STOP,
+	STATE_DATA_ERROR,
+};
+
+struct at91_mci_dma {
+#ifdef CONFIG_MMC_AT91GEN2_DMA
+	struct dma_client		client;
+	struct dma_chan			*chan;
+	struct dma_async_tx_descriptor	*data_desc;
+#endif
+};
+
+/**
+ * struct at91_mci - MMC controller state shared between all slots
+ * @lock: Spinlock protecting the queue and associated data.
+ * @regs: Pointer to MMIO registers.
+ * @sg: Scatterlist entry currently being processed by PIO code, if any.
+ * @pio_offset: Offset into the current scatterlist entry.
+ * @cur_slot: The slot which is currently using the controller.
+ * @mrq: The request currently being processed on @cur_slot,
+ *	or NULL if the controller is idle.
+ * @cmd: The command currently being sent to the card, or NULL.
+ * @data: The data currently being transferred, or NULL if no data
+ *	transfer is in progress.
+ * @dma: DMA client state.
+ * @data_chan: DMA channel being used for the current data transfer.
+ * @cmd_status: Snapshot of SR taken upon completion of the current
+ *	command. Only valid when EVENT_CMD_COMPLETE is pending.
+ * @data_status: Snapshot of SR taken upon completion of the current
+ *	data transfer. Only valid when EVENT_DATA_COMPLETE or
+ *	EVENT_DATA_ERROR is pending.
+ * @stop_cmdr: Value to be loaded into CMDR when the stop command is
+ *	to be sent.
+ * @tasklet: Tasklet running the request state machine.
+ * @pending_events: Bitmask of events flagged by the interrupt handler
+ *	to be processed by the tasklet.
+ * @completed_events: Bitmask of events which the state machine has
+ *	processed.
+ * @state: Tasklet state.
+ * @queue: List of slots waiting for access to the controller.
+ * @need_clock_update: Update the clock rate before the next request.
+ * @need_reset: Reset controller before next request.
+ * @mode_reg: Value of the MR register.
+ * @bus_hz: The rate of @mck in Hz. This forms the basis for MMC bus
+ *	rate and timeout calculations.
+ * @mapbase: Physical address of the MMIO registers.
+ * @mck: The peripheral bus clock hooked up to the MMC controller.
+ * @pdev: Platform device associated with the MMC controller.
+ * @slot: Slots sharing this MMC controller.
+ *
+ * Locking
+ * =======
+ *
+ * @lock is a softirq-safe spinlock protecting @queue as well as
+ * @cur_slot, @mrq and @state. These must always be updated
+ * at the same time while holding @lock.
+ *
+ * @lock also protects mode_reg and need_clock_update since these are
+ * used to synchronize mode register updates with the queue
+ * processing.
+ *
+ * The @mrq field of struct at91_mci_slot is also protected by @lock,
+ * and must always be written at the same time as the slot is added to
+ * @queue.
+ *
+ * @pending_events and @completed_events are accessed using atomic bit
+ * operations, so they don't need any locking.
+ *
+ * None of the fields touched by the interrupt handler need any
+ * locking. However, ordering is important: Before EVENT_DATA_ERROR or
+ * EVENT_DATA_COMPLETE is set in @pending_events, all data-related
+ * interrupts must be disabled and @data_status updated with a
+ * snapshot of SR. Similarly, before EVENT_CMD_COMPLETE is set, the
+ * CMDRDY interupt must be disabled and @cmd_status updated with a
+ * snapshot of SR, and before EVENT_XFER_COMPLETE can be set, the
+ * bytes_xfered field of @data must be written. This is ensured by
+ * using barriers.
+ */
+struct at91_mci {
+	spinlock_t		lock;
+	void __iomem		*regs;
+
+	struct scatterlist	*sg;
+	unsigned int		pio_offset;
+
+	struct at91_mci_slot	*cur_slot;
+	struct mmc_request	*mrq;
+	struct mmc_command	*cmd;
+	struct mmc_data		*data;
+
+	struct at91_mci_dma	dma;
+	struct dma_chan		*data_chan;
+
+	u32			cmd_status;
+	u32			data_status;
+	u32			stop_cmdr;
+
+	struct tasklet_struct	tasklet;
+	unsigned long		pending_events;
+	unsigned long		completed_events;
+	enum at91_mci_state	state;
+	struct list_head	queue;
+
+	bool			need_clock_update;
+	bool			need_reset;
+	u32			mode_reg;
+	unsigned long		bus_hz;
+	unsigned long		mapbase;
+	struct clk		*mck;
+	struct platform_device	*pdev;
+
+	struct at91_mci_slot	*slot[AT91_MCI_MAX_NR_SLOTS];
+};
+
+/**
+ * struct at91_mci_slot - MMC slot state
+ * @mmc: The mmc_host representing this slot.
+ * @host: The MMC controller this slot is using.
+ * @sdc_reg: Value of SDCR to be written before using this slot.
+ * @mrq: mmc_request currently being processed or waiting to be
+ *	processed, or NULL when the slot is idle.
+ * @queue_node: List node for placing this node in the @queue list of
+ *	&struct at91_mci.
+ * @clock: Clock rate configured by set_ios(). Protected by host->lock.
+ * @flags: Random state bits associated with the slot.
+ * @det_pin: GPIO pin used for card detection, or negative if not
+ *	available.
+ * @wp_pin: GPIO pin used for card write protect sending, or negative
+ *	if not available.
+ * @detect_timer: Timer used for debouncing @detect_pin interrupts.
+ */
+struct at91_mci_slot {
+	struct mmc_host		*mmc;
+	struct at91_mci		*host;
+
+	u32			sdc_reg;
+
+	struct mmc_request	*mrq;
+	struct list_head	queue_node;
+
+	unsigned int		clock;
+	unsigned long		flags;
+#define AT91MCI_CARD_PRESENT	0
+#define AT91MCI_CARD_NEED_INIT	1
+#define AT91MCI_SHUTDOWN		2
+
+	int			det_pin;
+	int			wp_pin;
+
+	struct timer_list	detect_timer;
+};
+
+#define at91mci_test_and_clear_pending(host, event)		\
+	test_and_clear_bit(event, &host->pending_events)
+#define at91mci_set_completed(host, event)			\
+	set_bit(event, &host->completed_events)
+#define at91mci_set_pending(host, event)				\
+	set_bit(event, &host->pending_events)
+
+#define at91_mci_read(host, reg)	__raw_readl((host)->regs + (reg))
+#define at91_mci_write(host, reg, val)	__raw_writel((val),
(host)->regs + (reg))
+
+/*
+ * The debugfs stuff below is mostly optimized away when
+ * CONFIG_DEBUG_FS is not set.
+ */
+static int at91mci_req_show(struct seq_file *s, void *v)
+{
+	struct at91_mci_slot	*slot = s->private;
+	struct mmc_request	*mrq;
+	struct mmc_command	*cmd;
+	struct mmc_command	*stop;
+	struct mmc_data		*data;
+
+	/* Make sure we get a consistent snapshot */
+	spin_lock_bh(&slot->host->lock);
+	mrq = slot->mrq;
+
+	if (mrq) {
+		cmd = mrq->cmd;
+		data = mrq->data;
+		stop = mrq->stop;
+
+		if (cmd)
+			seq_printf(s,
+				"CMD%u(0x%x) flg %x rsp %x %x %x %x err %d\n",
+				cmd->opcode, cmd->arg, cmd->flags,
+				cmd->resp[0], cmd->resp[1], cmd->resp[2],
+				cmd->resp[2], cmd->error);
+		if (data)
+			seq_printf(s, "DATA %u / %u * %u flg %x err %d\n",
+				data->bytes_xfered, data->blocks,
+				data->blksz, data->flags, data->error);
+		if (stop)
+			seq_printf(s,
+				"CMD%u(0x%x) flg %x rsp %x %x %x %x err %d\n",
+				stop->opcode, stop->arg, stop->flags,
+				stop->resp[0], stop->resp[1], stop->resp[2],
+				stop->resp[2], stop->error);
+	}
+
+	spin_unlock_bh(&slot->host->lock);
+
+	return 0;
+}
+
+static int at91mci_req_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, at91mci_req_show, inode->i_private);
+}
+
+static const struct file_operations at91mci_req_fops = {
+	.owner		= THIS_MODULE,
+	.open		= at91mci_req_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+
+static void at91mci_show_status_reg(struct seq_file *s,
+		const char *regname, u32 value)
+{
+	static const char	*sr_bit[] = {
+		[0]	= "CMDRDY",
+		[1]	= "RXRDY",
+		[2]	= "TXRDY",
+		[3]	= "BLKE",
+		[4]	= "DTIP",
+		[5]	= "NOTBUSY",
+		[6]	= "ENDRX",
+		[7]	= "ENDTX",
+		[8]	= "SDIOIRQA",
+		[9]	= "SDIOIRQB",
+		[14]	= "RXBUFF",
+		[15]	= "TXBUFE",
+		[16]	= "RINDE",
+		[17]	= "RDIRE",
+		[18]	= "RCRCE",
+		[19]	= "RENDE",
+		[20]	= "RTOE",
+		[21]	= "DCRCE",
+		[22]	= "DTOE",
+		[30]	= "OVRE",
+		[31]	= "UNRE",
+	};
+	unsigned int		i;
+
+	seq_printf(s, "%s:\t0x%08x", regname, value);
+	for (i = 0; i < ARRAY_SIZE(sr_bit); i++) {
+		if (value & (1 << i)) {
+			if (sr_bit[i])
+				seq_printf(s, " %s", sr_bit[i]);
+			else
+				seq_puts(s, " UNKNOWN");
+		}
+	}
+	seq_putc(s, '\n');
+}
+
+static int at91mci_regs_show(struct seq_file *s, void *v)
+{
+	struct at91_mci		*host = s->private;
+	u32			*buf;
+
+	buf = kmalloc(AT91_MCI_REGS_SIZE, GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
+
+	/*
+	 * Grab a more or less consistent snapshot. Note that we're
+	 * not disabling interrupts, so IMR and SR may not be
+	 * consistent.
+	 */
+	spin_lock_bh(&host->lock);
+	clk_enable(host->mck);
+	memcpy_fromio(buf, host->regs, AT91_MCI_REGS_SIZE);
+	clk_disable(host->mck);
+	spin_unlock_bh(&host->lock);
+
+	seq_printf(s, "MR:\t0x%08x%s%s CLKDIV=%u\n",
+		   buf[AT91_MCI_MR / 4],
+		   buf[AT91_MCI_MR / 4] & AT91_MCI_RDPROOF ? " RDPROOF" : "",
+		   buf[AT91_MCI_MR / 4] & AT91_MCI_WRPROOF ? " WRPROOF" : "",
+		   buf[AT91_MCI_MR / 4] & 0xff);
+	seq_printf(s, "DTOR:\t0x%08x\n", buf[AT91_MCI_DTOR / 4]);
+	seq_printf(s, "SDCR:\t0x%08x\n", buf[AT91_MCI_SDCR / 4]);
+	seq_printf(s, "ARGR:\t0x%08x\n", buf[AT91_MCI_ARGR / 4]);
+	seq_printf(s, "BLKR:\t0x%08x BCNT=%u BLKLEN=%u\n",
+		   buf[AT91_MCI_BLKR / 4],
+		   (buf[AT91_MCI_BLKR / 4] >> 0) & 0xffff,
+		   (buf[AT91_MCI_BLKR / 4] >> 16) & 0xffff);
+
+	/* Don't read RSPR and RDR; it will consume the data there */
+
+	at91mci_show_status_reg(s, "SR", buf[AT91_MCI_SR / 4]);
+	at91mci_show_status_reg(s, "IMR", buf[AT91_MCI_IMR / 4]);
+
+	kfree(buf);
+
+	return 0;
+}
+
+static int at91mci_regs_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, at91mci_regs_show, inode->i_private);
+}
+
+static const struct file_operations at91mci_regs_fops = {
+	.owner		= THIS_MODULE,
+	.open		= at91mci_regs_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+
+static void at91mci_init_debugfs(struct at91_mci_slot *slot)
+{
+	struct mmc_host		*mmc = slot->mmc;
+	struct at91_mci		*host = slot->host;
+	struct dentry		*root;
+	struct dentry		*node;
+
+	root = mmc->debugfs_root;
+	if (!root)
+		return;
+
+	node = debugfs_create_file("regs", S_IRUSR, root, host,
+			&at91mci_regs_fops);
+	if (IS_ERR(node))
+		return;
+	if (!node)
+		goto err;
+
+	node = debugfs_create_file("req", S_IRUSR, root, slot, &at91mci_req_fops);
+	if (!node)
+		goto err;
+
+	node = debugfs_create_u32("state", S_IRUSR, root, (u32 *)&host->state);
+	if (!node)
+		goto err;
+
+	node = debugfs_create_x32("pending_events", S_IRUSR, root,
+				     (u32 *)&host->pending_events);
+	if (!node)
+		goto err;
+
+	node = debugfs_create_x32("completed_events", S_IRUSR, root,
+				     (u32 *)&host->completed_events);
+	if (!node)
+		goto err;
+
+	return;
+
+err:
+	dev_err(&mmc->class_dev, "failed to initialize debugfs for slot\n");
+}
+
+static inline unsigned int ns_to_clocks(struct at91_mci *host,
+					unsigned int ns)
+{
+	return (ns * (host->bus_hz / 1000000) + 999) / 1000;
+}
+
+static void at91mci_set_timeout(struct at91_mci *host,
+		struct at91_mci_slot *slot, struct mmc_data *data)
+{
+	static unsigned	dtomul_to_shift[] = {
+		0, 4, 7, 8, 10, 12, 16, 20
+	};
+	unsigned	timeout;
+	unsigned	dtocyc;
+	unsigned	dtomul;
+
+	timeout = ns_to_clocks(host, data->timeout_ns) + data->timeout_clks;
+
+	for (dtomul = 0; dtomul < 8; dtomul++) {
+		unsigned shift = dtomul_to_shift[dtomul];
+		dtocyc = (timeout + (1 << shift) - 1) >> shift;
+		if (dtocyc < 15)
+			break;
+	}
+
+	if (dtomul >= 8) {
+		dtomul = 7;
+		dtocyc = 15;
+	}
+
+	dev_vdbg(&slot->mmc->class_dev, "setting timeout to %u cycles\n",
+			dtocyc << dtomul_to_shift[dtomul]);
+	at91_mci_write(host, AT91_MCI_DTOR,
+		       (AT91_MCI_DTOMUL_F(dtomul) | AT91_MCI_DTOCYC_F(dtocyc)));
+}
+
+/*
+ * Return mask with command flags to be enabled for this command.
+ */
+static u32 at91mci_prepare_command(struct mmc_host *mmc,
+				 struct mmc_command *cmd)
+{
+	struct mmc_data	*data;
+	u32		cmdr;
+
+	cmd->error = -EINPROGRESS;
+
+	cmdr = AT91_MCI_CMDNB & cmd->opcode;
+
+	if (cmd->flags & MMC_RSP_PRESENT) {
+		if (cmd->flags & MMC_RSP_136)
+			cmdr |= AT91_MCI_RSPTYP_136;
+		else
+			cmdr |= AT91_MCI_RSPTYP_48;
+	}
+
+	/*
+	 * This should really be MAXLAT_5 for CMD2 and ACMD41, but
+	 * it's too difficult to determine whether this is an ACMD or
+	 * not. Better make it 64.
+	 */
+	cmdr |= AT91_MCI_MAXLAT;
+
+	if (mmc->ios.bus_mode == MMC_BUSMODE_OPENDRAIN)
+		cmdr |= AT91_MCI_OPDCMD;
+
+	data = cmd->data;
+	if (data) {
+		cmdr |= AT91_MCI_TRCMD_START;
+		if (data->flags & MMC_DATA_STREAM)
+			cmdr |= AT91_MCI_TRTYP_STREAM;
+		else if (data->blocks > 1)
+			cmdr |= AT91_MCI_TRTYP_MULTIPLE;
+		else
+			cmdr |= AT91_MCI_TRTYP_BLOCK;
+
+		if (data->flags & MMC_DATA_READ)
+			cmdr |= AT91_MCI_TRDIR;
+	}
+
+	return cmdr;
+}
+
+static void at91mci_start_command(struct at91_mci *host,
+		struct mmc_command *cmd, u32 cmd_flags)
+{
+	WARN_ON(host->cmd);
+	host->cmd = cmd;
+
+	dev_vdbg(&host->pdev->dev,
+			"start command: ARGR=0x%08x CMDR=0x%08x\n",
+			cmd->arg, cmd_flags);
+
+	at91_mci_write(host, AT91_MCI_ARGR, cmd->arg);
+	at91_mci_write(host, AT91_MCI_CMDR, cmd_flags);
+}
+
+static void send_stop_cmd(struct at91_mci *host, struct mmc_data *data)
+{
+	at91mci_start_command(host, data->stop, host->stop_cmdr);
+	at91_mci_write(host, AT91_MCI_IER, AT91_MCI_CMDRDY);
+}
+
+#ifdef CONFIG_MMC_AT91GEN2_DMA
+#error "DMA Unsupported for AT91 MMC Gen2 Driver"
+#else /* CONFIG_MMC_AT91GEN2_DMA */
+
+static int at91mci_submit_data_dma(struct at91_mci *host, struct
mmc_data *data)
+{
+	return -ENOSYS;
+}
+
+static void at91mci_stop_dma(struct at91_mci *host)
+{
+	/* Data transfer was stopped by the interrupt handler */
+	at91mci_set_pending(host, EVENT_XFER_COMPLETE);
+	at91_mci_write(host, AT91_MCI_IER, AT91_MCI_NOTBUSY);
+}
+
+#endif /* CONFIG_MMC_AT91GEN2_DMA */
+
+/*
+ * Returns a mask of interrupt flags to be enabled after the whole
+ * request has been prepared.
+ */
+static u32 at91mci_submit_data(struct at91_mci *host, struct mmc_data *data)
+{
+	u32 iflags;
+
+	data->error = -EINPROGRESS;
+
+	WARN_ON(host->data);
+	host->sg = NULL;
+	host->data = data;
+
+	iflags = AT91MCI_DATA_ERROR_FLAGS;
+	if (at91mci_submit_data_dma(host, data)) {
+		host->data_chan = NULL;
+
+		/*
+		 * Errata: MMC data write operation with less than 12
+		 * bytes is impossible.
+		 */
+		if (data->blocks * data->blksz < 12)
+			host->need_reset = true;
+
+		host->sg = data->sg;
+		host->pio_offset = 0;
+		if (data->flags & MMC_DATA_READ)
+			iflags |= AT91_MCI_RXRDY;
+		else
+			iflags |= AT91_MCI_TXRDY;
+	}
+
+	return iflags;
+}
+
+static void at91mci_start_request(struct at91_mci *host,
+		struct at91_mci_slot *slot)
+{
+	struct mmc_request	*mrq;
+	struct mmc_command	*cmd;
+	struct mmc_data		*data;
+	u32			iflags;
+	u32			cmdflags;
+
+	mrq = slot->mrq;
+	host->cur_slot = slot;
+	host->mrq = mrq;
+
+	host->pending_events = 0;
+	host->completed_events = 0;
+	host->data_status = 0;
+
+	if (host->need_reset || MMC_ALWAYS_RESET) {
+		at91_mci_write(host, AT91_MCI_CR, AT91_MCI_SWRST);
+		at91_mci_write(host, AT91_MCI_CR, AT91_MCI_MCIEN);
+		at91_mci_write(host, AT91_MCI_MR, host->mode_reg);
+		host->need_reset = false;
+	}
+	at91_mci_write(host, AT91_MCI_SDCR, slot->sdc_reg);
+
+	iflags = at91_mci_read(host, AT91_MCI_IMR);
+	if (iflags)
+		dev_warn(&slot->mmc->class_dev, "WARNING: IMR=0x%08x\n",
+				iflags);
+
+	if (unlikely(test_and_clear_bit(AT91MCI_CARD_NEED_INIT, &slot->flags))) {
+		/* Send init sequence (74 clock cycles) */
+		at91_mci_write(host, AT91_MCI_CMDR, AT91_MCI_SPCMD_INIT);
+		while (!(at91_mci_read(host, AT91_MCI_SR) & AT91_MCI_CMDRDY))
+			cpu_relax();
+	}
+	data = mrq->data;
+	if (data) {
+		at91mci_set_timeout(host, slot, data);
+
+		/* Must set block count/size before sending command */
+		at91_mci_write(host, AT91_MCI_BLKR, AT91_MCI_BLKR_BCNT(data->blocks)
+				| AT91_MCI_BLKR_BLKLEN(data->blksz));
+		dev_vdbg(&slot->mmc->class_dev, "BLKR=0x%08x\n",
+			AT91_MCI_BLKR_BCNT(data->blocks) | AT91_MCI_BLKR_BLKLEN(data->blksz));
+	}
+
+	iflags = AT91_MCI_CMDRDY;
+	cmd = mrq->cmd;
+	cmdflags = at91mci_prepare_command(slot->mmc, cmd);
+	at91mci_start_command(host, cmd, cmdflags);
+
+	if (data)
+		iflags |= at91mci_submit_data(host, data);
+
+	if (mrq->stop) {
+		host->stop_cmdr = at91mci_prepare_command(slot->mmc, mrq->stop);
+		host->stop_cmdr |= AT91_MCI_TRCMD_STOP;
+		if (!(data->flags & MMC_DATA_WRITE))
+			host->stop_cmdr |= AT91_MCI_TRDIR;
+		if (data->flags & MMC_DATA_STREAM)
+			host->stop_cmdr |= AT91_MCI_TRTYP_STREAM;
+		else
+			host->stop_cmdr |= AT91_MCI_TRTYP_MULTIPLE;
+	}
+
+	/*
+	 * We could have enabled interrupts earlier, but I suspect
+	 * that would open up a nice can of interesting race
+	 * conditions (e.g. command and data complete, but stop not
+	 * prepared yet.)
+	 */
+	at91_mci_write(host, AT91_MCI_IER, iflags);
+}
+
+static void at91mci_queue_request(struct at91_mci *host,
+		struct at91_mci_slot *slot, struct mmc_request *mrq)
+{
+	dev_vdbg(&slot->mmc->class_dev, "queue request: state=%d\n",
+			host->state);
+
+	spin_lock_bh(&host->lock);
+	slot->mrq = mrq;
+	if (host->state == STATE_IDLE) {
+		host->state = STATE_SENDING_CMD;
+		at91mci_start_request(host, slot);
+	} else {
+		list_add_tail(&slot->queue_node, &host->queue);
+	}
+	spin_unlock_bh(&host->lock);
+}
+
+static void at91mci_request(struct mmc_host *mmc, struct mmc_request *mrq)
+{
+	struct at91_mci_slot	*slot = mmc_priv(mmc);
+	struct at91_mci		*host = slot->host;
+	struct mmc_data		*data;
+
+	WARN_ON(slot->mrq);
+
+	/*
+	 * We may "know" the card is gone even though there's still an
+	 * electrical connection. If so, we really need to communicate
+	 * this to the MMC core since there won't be any more
+	 * interrupts as the card is completely removed. Otherwise,
+	 * the MMC core might believe the card is still there even
+	 * though the card was just removed very slowly.
+	 */
+	if (!test_bit(AT91MCI_CARD_PRESENT, &slot->flags)) {
+		mrq->cmd->error = -ENOMEDIUM;
+		mmc_request_done(mmc, mrq);
+		return;
+	}
+
+	/* We don't support multiple blocks of weird lengths. */
+	data = mrq->data;
+	if (data && data->blocks > 1 && data->blksz & 3) {
+		mrq->cmd->error = -EINVAL;
+		mmc_request_done(mmc, mrq);
+	}
+
+	at91mci_queue_request(host, slot, mrq);
+}
+
+static void at91mci_set_ios(struct mmc_host *mmc, struct mmc_ios *ios)
+{
+	struct at91_mci_slot	*slot = mmc_priv(mmc);
+	struct at91_mci		*host = slot->host;
+	unsigned int		i;
+
+	slot->sdc_reg &= ~AT91_MCI_SDCBUS;
+	switch (ios->bus_width) {
+	case MMC_BUS_WIDTH_4:
+		slot->sdc_reg |= AT91_MCI_SDCBUS;
+		break;
+	default:
+		break;
+	}
+
+	if (ios->clock) {
+		unsigned int clock_min = ~0U;
+		u32 clkdiv;
+
+		spin_lock_bh(&host->lock);
+		if (!host->mode_reg) {
+			clk_enable(host->mck);
+			at91_mci_write(host, AT91_MCI_CR, AT91_MCI_SWRST);
+			at91_mci_write(host, AT91_MCI_CR, AT91_MCI_MCIEN);
+		}
+
+		/*
+		 * Use mirror of ios->clock to prevent race with mmc
+		 * core ios update when finding the minimum.
+		 */
+		slot->clock = ios->clock;
+		for (i = 0; i < AT91_MCI_MAX_NR_SLOTS; i++) {
+			if (host->slot[i] && host->slot[i]->clock
+					&& host->slot[i]->clock < clock_min)
+				clock_min = host->slot[i]->clock;
+		}
+
+		/* Calculate clock divider */
+		clkdiv = DIV_ROUND_UP(host->bus_hz, 2 * clock_min) - 1;
+		if (clkdiv > 255) {
+			dev_warn(&mmc->class_dev,
+				"clock %u too slow; using %lu\n",
+				clock_min, host->bus_hz / (2 * 256));
+			clkdiv = 255;
+		}
+
+		/*
+		 * WRPROOF and RDPROOF prevent overruns/underruns by
+		 * stopping the clock when the FIFO is full/empty.
+		 * This state is not expected to last for long.
+		 */
+#ifdef MMC_SUPPORTS_RW_PROOF
+		host->mode_reg = (AT91_MCI_CLKDIV & clkdiv) | AT91_MCI_WRPROOF
+					| AT91_MCI_RDPROOF;
+#else
+		host->mode_reg = (AT91_MCI_CLKDIV & clkdiv);
+#endif
+		if (list_empty(&host->queue))
+			at91_mci_write(host, AT91_MCI_MR, host->mode_reg);
+		else
+			host->need_clock_update = true;
+
+		spin_unlock_bh(&host->lock);
+	} else {
+		bool any_slot_active = false;
+
+		spin_lock_bh(&host->lock);
+		slot->clock = 0;
+		for (i = 0; i < AT91_MCI_MAX_NR_SLOTS; i++) {
+			if (host->slot[i] && host->slot[i]->clock) {
+				any_slot_active = true;
+				break;
+			}
+		}
+		if (!any_slot_active) {
+			at91_mci_write(host, AT91_MCI_CR, AT91_MCI_MCIDIS);
+			if (host->mode_reg) {
+				at91_mci_read(host, AT91_MCI_MR);
+				clk_disable(host->mck);
+			}
+			host->mode_reg = 0;
+		}
+		spin_unlock_bh(&host->lock);
+	}
+
+	switch (ios->power_mode) {
+	case MMC_POWER_UP:
+		set_bit(AT91MCI_CARD_NEED_INIT, &slot->flags);
+		break;
+	default:
+		/*
+		 * TODO: None of the currently available AVR32-based
+		 * boards allow MMC power to be turned off. Implement
+		 * power control when this can be tested properly.
+		 *
+		 * We also need to hook this into the clock management
+		 * somehow so that newly inserted cards aren't
+		 * subjected to a fast clock before we have a chance
+		 * to figure out what the maximum rate is. Currently,
+		 * there's no way to avoid this, and there never will
+		 * be for boards that don't support power control.
+		 */
+		break;
+	}
+}
+
+static int at91mci_get_ro(struct mmc_host *mmc)
+{
+	int			read_only = -ENOSYS;
+	struct at91_mci_slot	*slot = mmc_priv(mmc);
+
+	if (gpio_is_valid(slot->wp_pin)) {
+		read_only = gpio_get_value(slot->wp_pin);
+		dev_dbg(&mmc->class_dev, "card is %s\n",
+				read_only ? "read-only" : "read-write");
+	}
+
+	return read_only;
+}
+
+static int at91mci_get_cd(struct mmc_host *mmc)
+{
+	int			present = -ENOSYS;
+	struct at91_mci_slot	*slot = mmc_priv(mmc);
+
+	if (gpio_is_valid(slot->det_pin)) {
+		present = !gpio_get_value(slot->det_pin);
+		dev_dbg(&mmc->class_dev, "card is %spresent\n",
+				present ? "" : "not ");
+	}
+
+	return present;
+}
+
+static const struct mmc_host_ops at91mci_ops = {
+	.request	= at91mci_request,
+	.set_ios	= at91mci_set_ios,
+	.get_ro		= at91mci_get_ro,
+	.get_cd		= at91mci_get_cd,
+};
+
+/* Called with host->lock held */
+static void at91mci_request_end(struct at91_mci *host, struct mmc_request *mrq)
+	__releases(&host->lock)
+	__acquires(&host->lock)
+{
+	struct at91_mci_slot	*slot = NULL;
+	struct mmc_host		*prev_mmc = host->cur_slot->mmc;
+
+	WARN_ON(host->cmd || host->data);
+
+	/*
+	 * Update the MMC clock rate if necessary. This may be
+	 * necessary if set_ios() is called when a different slot is
+	 * busy transfering data.
+	 */
+	if (host->need_clock_update)
+		at91_mci_write(host, AT91_MCI_MR, host->mode_reg);
+
+	host->cur_slot->mrq = NULL;
+	host->mrq = NULL;
+	if (!list_empty(&host->queue)) {
+		slot = list_entry(host->queue.next,
+				struct at91_mci_slot, queue_node);
+		list_del(&slot->queue_node);
+		dev_vdbg(&host->pdev->dev, "list not empty: %s is next\n",
+				mmc_hostname(slot->mmc));
+		host->state = STATE_SENDING_CMD;
+		at91mci_start_request(host, slot);
+	} else {
+		dev_vdbg(&host->pdev->dev, "list empty\n");
+		host->state = STATE_IDLE;
+	}
+
+	spin_unlock(&host->lock);
+	mmc_request_done(prev_mmc, mrq);
+	spin_lock(&host->lock);
+}
+
+static void at91mci_command_complete(struct at91_mci *host,
+			struct mmc_command *cmd)
+{
+	u32		status = host->cmd_status;
+
+	/* Read the response from the card (up to 16 bytes) */
+	cmd->resp[0] = at91_mci_read(host, AT91_MCI_RSPR(0));
+	cmd->resp[1] = at91_mci_read(host, AT91_MCI_RSPR(1));
+	cmd->resp[2] = at91_mci_read(host, AT91_MCI_RSPR(2));
+	cmd->resp[3] = at91_mci_read(host, AT91_MCI_RSPR(3));
+
+	if (status & AT91_MCI_RTOE)
+		cmd->error = -ETIMEDOUT;
+	else if ((cmd->flags & MMC_RSP_CRC) && (status & AT91_MCI_RCRCE))
+		cmd->error = -EILSEQ;
+	else if (status & (AT91_MCI_RINDE | AT91_MCI_RDIRE | AT91_MCI_RENDE))
+		cmd->error = -EIO;
+	else
+		cmd->error = 0;
+
+	if (cmd->error) {
+		dev_dbg(&host->pdev->dev,
+			"command error: status=0x%08x\n", status);
+
+		if (cmd->data) {
+			host->data = NULL;
+			at91mci_stop_dma(host);
+			at91_mci_write(host, AT91_MCI_IDR, AT91_MCI_NOTBUSY
+					| AT91_MCI_TXRDY | AT91_MCI_RXRDY
+					| AT91MCI_DATA_ERROR_FLAGS);
+		}
+	}
+}
+
+static void at91mci_detect_change(unsigned long data)
+{
+	struct at91_mci_slot	*slot = (struct at91_mci_slot *)data;
+	bool			present;
+	bool			present_old;
+
+	/*
+	 * at91mci_cleanup_slot() sets the AT91MCI_SHUTDOWN flag before
+	 * freeing the interrupt. We must not re-enable the interrupt
+	 * if it has been freed, and if we're shutting down, it
+	 * doesn't really matter whether the card is present or not.
+	 */
+	smp_rmb();
+	if (test_bit(AT91MCI_SHUTDOWN, &slot->flags))
+		return;
+
+	enable_irq(gpio_to_irq(slot->det_pin));
+	present = !gpio_get_value(slot->det_pin);
+	present_old = test_bit(AT91MCI_CARD_PRESENT, &slot->flags);
+
+	dev_vdbg(&slot->mmc->class_dev, "detect change: %d (was %d)\n",
+			present, present_old);
+
+	if (present != present_old) {
+		struct at91_mci	*host = slot->host;
+		struct mmc_request	*mrq;
+
+		dev_dbg(&slot->mmc->class_dev, "card %s\n",
+			present ? "inserted" : "removed");
+
+		spin_lock(&host->lock);
+
+		if (!present)
+			clear_bit(AT91MCI_CARD_PRESENT, &slot->flags);
+		else
+			set_bit(AT91MCI_CARD_PRESENT, &slot->flags);
+
+		/* Clean up queue if present */
+		mrq = slot->mrq;
+		if (mrq) {
+			if (mrq == host->mrq) {
+				/*
+				 * Reset controller to terminate any ongoing
+				 * commands or data transfers.
+				 */
+				at91_mci_write(host, AT91_MCI_CR, AT91_MCI_SWRST);
+				at91_mci_write(host, AT91_MCI_CR, AT91_MCI_MCIEN);
+				at91_mci_write(host, AT91_MCI_MR, host->mode_reg);
+
+				host->data = NULL;
+				host->cmd = NULL;
+
+				switch (host->state) {
+				case STATE_IDLE:
+					break;
+				case STATE_SENDING_CMD:
+					mrq->cmd->error = -ENOMEDIUM;
+					if (!mrq->data)
+						break;
+					/* fall through */
+				case STATE_SENDING_DATA:
+					mrq->data->error = -ENOMEDIUM;
+					at91mci_stop_dma(host);
+					break;
+				case STATE_DATA_BUSY:
+				case STATE_DATA_ERROR:
+					if (mrq->data->error == -EINPROGRESS)
+						mrq->data->error = -ENOMEDIUM;
+					if (!mrq->stop)
+						break;
+					/* fall through */
+				case STATE_SENDING_STOP:
+					mrq->stop->error = -ENOMEDIUM;
+					break;
+				}
+
+				at91mci_request_end(host, mrq);
+			} else {
+				list_del(&slot->queue_node);
+				mrq->cmd->error = -ENOMEDIUM;
+				if (mrq->data)
+					mrq->data->error = -ENOMEDIUM;
+				if (mrq->stop)
+					mrq->stop->error = -ENOMEDIUM;
+
+				spin_unlock(&host->lock);
+				mmc_request_done(slot->mmc, mrq);
+				spin_lock(&host->lock);
+			}
+		}
+		spin_unlock(&host->lock);
+
+		mmc_detect_change(slot->mmc, 0);
+	}
+}
+
+static void at91mci_tasklet_func(unsigned long priv)
+{
+	struct at91_mci		*host = (struct at91_mci *)priv;
+	struct mmc_request	*mrq = host->mrq;
+	struct mmc_data		*data = host->data;
+	struct mmc_command	*cmd = host->cmd;
+	enum at91_mci_state	state = host->state;
+	enum at91_mci_state	prev_state;
+	u32			status;
+
+	spin_lock(&host->lock);
+
+	state = host->state;
+
+	dev_vdbg(&host->pdev->dev,
+		"tasklet: state %u pending/completed/mask %lx/%lx/%x\n",
+		state, host->pending_events, host->completed_events,
+		at91_mci_read(host, AT91_MCI_IMR));
+
+	do {
+		prev_state = state;
+
+		switch (state) {
+		case STATE_IDLE:
+			break;
+
+		case STATE_SENDING_CMD:
+			if (!at91mci_test_and_clear_pending(host,
+						EVENT_CMD_COMPLETE))
+				break;
+
+			host->cmd = NULL;
+			at91mci_set_completed(host, EVENT_CMD_COMPLETE);
+			at91mci_command_complete(host, mrq->cmd);
+			if (!mrq->data || cmd->error) {
+				at91mci_request_end(host, host->mrq);
+				goto unlock;
+			}
+
+			prev_state = state = STATE_SENDING_DATA;
+			/* fall through */
+
+		case STATE_SENDING_DATA:
+			if (at91mci_test_and_clear_pending(host,
+						EVENT_DATA_ERROR)) {
+				at91mci_stop_dma(host);
+				if (data->stop)
+					send_stop_cmd(host, data);
+				state = STATE_DATA_ERROR;
+				break;
+			}
+
+			if (!at91mci_test_and_clear_pending(host,
+						EVENT_XFER_COMPLETE))
+				break;
+
+			at91mci_set_completed(host, EVENT_XFER_COMPLETE);
+			prev_state = state = STATE_DATA_BUSY;
+			/* fall through */
+
+		case STATE_DATA_BUSY:
+			if (!at91mci_test_and_clear_pending(host,
+						EVENT_DATA_COMPLETE))
+				break;
+
+			host->data = NULL;
+			at91mci_set_completed(host, EVENT_DATA_COMPLETE);
+			status = host->data_status;
+			if (unlikely(status & AT91MCI_DATA_ERROR_FLAGS)) {
+				if (status & AT91_MCI_DTOE) {
+					dev_dbg(&host->pdev->dev,
+							"data timeout error\n");
+					data->error = -ETIMEDOUT;
+				} else if (status & AT91_MCI_DCRCE) {
+					dev_dbg(&host->pdev->dev,
+							"data CRC error\n");
+					data->error = -EILSEQ;
+				} else {
+					dev_dbg(&host->pdev->dev,
+						"data FIFO error (status=%08x)\n",
+						status);
+					data->error = -EIO;
+				}
+			} else {
+				data->bytes_xfered = data->blocks * data->blksz;
+				data->error = 0;
+			}
+
+			if (!data->stop) {
+				at91mci_request_end(host, host->mrq);
+				goto unlock;
+			}
+
+			prev_state = state = STATE_SENDING_STOP;
+			if (!data->error)
+				send_stop_cmd(host, data);
+			/* fall through */
+
+		case STATE_SENDING_STOP:
+			if (!at91mci_test_and_clear_pending(host,
+						EVENT_CMD_COMPLETE))
+				break;
+
+			host->cmd = NULL;
+			at91mci_command_complete(host, mrq->stop);
+			at91mci_request_end(host, host->mrq);
+			goto unlock;
+
+		case STATE_DATA_ERROR:
+			if (!at91mci_test_and_clear_pending(host,
+						EVENT_XFER_COMPLETE))
+				break;
+
+			state = STATE_DATA_BUSY;
+			break;
+		}
+	} while (state != prev_state);
+
+	host->state = state;
+
+unlock:
+	spin_unlock(&host->lock);
+}
+
+static void at91mci_read_data_pio(struct at91_mci *host)
+{
+	struct scatterlist	*sg = host->sg;
+	void			*buf = sg_virt(sg);
+	unsigned int		offset = host->pio_offset;
+	struct mmc_data		*data = host->data;
+	u32			value;
+	u32			status;
+	unsigned int		nbytes = 0;
+
+	do {
+		value = at91_mci_read(host, AT91_MCI_RDR);
+		if (likely(offset + 4 <= sg->length)) {
+			put_unaligned(value, (u32 *)(buf + offset));
+
+			offset += 4;
+			nbytes += 4;
+
+			if (offset == sg->length) {
+				flush_dcache_page(sg_page(sg));
+				host->sg = sg = sg_next(sg);
+				if (!sg)
+					goto done;
+
+				offset = 0;
+				buf = sg_virt(sg);
+			}
+		} else {
+			unsigned int remaining = sg->length - offset;
+			memcpy(buf + offset, &value, remaining);
+			nbytes += remaining;
+
+			flush_dcache_page(sg_page(sg));
+			host->sg = sg = sg_next(sg);
+			if (!sg)
+				goto done;
+
+			offset = 4 - remaining;
+			buf = sg_virt(sg);
+			memcpy(buf, (u8 *)&value + remaining, offset);
+			nbytes += offset;
+		}
+
+		status = at91_mci_read(host, AT91_MCI_SR);
+		if (status & AT91MCI_DATA_ERROR_FLAGS) {
+			at91_mci_write(host, AT91_MCI_IDR, (AT91_MCI_NOTBUSY | AT91_MCI_RXRDY
+						| AT91MCI_DATA_ERROR_FLAGS));
+			host->data_status = status;
+			data->bytes_xfered += nbytes;
+			smp_wmb();
+			at91mci_set_pending(host, EVENT_DATA_ERROR);
+			tasklet_schedule(&host->tasklet);
+			return;
+		}
+	} while (status & AT91_MCI_RXRDY);
+
+	host->pio_offset = offset;
+	data->bytes_xfered += nbytes;
+
+	return;
+
+done:
+	at91_mci_write(host, AT91_MCI_IDR, AT91_MCI_RXRDY);
+	at91_mci_write(host, AT91_MCI_IER, AT91_MCI_NOTBUSY);
+	data->bytes_xfered += nbytes;
+	smp_wmb();
+	at91mci_set_pending(host, EVENT_XFER_COMPLETE);
+}
+
+static void at91mci_write_data_pio(struct at91_mci *host)
+{
+	struct scatterlist	*sg = host->sg;
+	void			*buf = sg_virt(sg);
+	unsigned int		offset = host->pio_offset;
+	struct mmc_data		*data = host->data;
+	u32			value;
+	u32			status;
+	unsigned int		nbytes = 0;
+
+	do {
+		if (likely(offset + 4 <= sg->length)) {
+			value = get_unaligned((u32 *)(buf + offset));
+			at91_mci_write(host, AT91_MCI_TDR, value);
+
+			offset += 4;
+			nbytes += 4;
+			if (offset == sg->length) {
+				host->sg = sg = sg_next(sg);
+				if (!sg)
+					goto done;
+
+				offset = 0;
+				buf = sg_virt(sg);
+			}
+		} else {
+			unsigned int remaining = sg->length - offset;
+
+			value = 0;
+			memcpy(&value, buf + offset, remaining);
+			nbytes += remaining;
+
+			host->sg = sg = sg_next(sg);
+			if (!sg) {
+				at91_mci_write(host, AT91_MCI_TDR, value);
+				goto done;
+			}
+
+			offset = 4 - remaining;
+			buf = sg_virt(sg);
+			memcpy((u8 *)&value + remaining, buf, offset);
+			at91_mci_write(host, AT91_MCI_TDR, value);
+			nbytes += offset;
+		}
+
+		status = at91_mci_read(host, AT91_MCI_SR);
+		if (status & AT91MCI_DATA_ERROR_FLAGS) {
+			at91_mci_write(host, AT91_MCI_IDR, (AT91_MCI_NOTBUSY | AT91_MCI_TXRDY
+						| AT91MCI_DATA_ERROR_FLAGS));
+			host->data_status = status;
+			data->bytes_xfered += nbytes;
+			smp_wmb();
+			at91mci_set_pending(host, EVENT_DATA_ERROR);
+			tasklet_schedule(&host->tasklet);
+			return;
+		}
+	} while (status & AT91_MCI_TXRDY);
+
+	host->pio_offset = offset;
+	data->bytes_xfered += nbytes;
+
+	return;
+
+done:
+	at91_mci_write(host, AT91_MCI_IDR, AT91_MCI_TXRDY);
+	at91_mci_write(host, AT91_MCI_IER, AT91_MCI_NOTBUSY);
+	data->bytes_xfered += nbytes;
+	smp_wmb();
+	at91mci_set_pending(host, EVENT_XFER_COMPLETE);
+}
+
+static void at91mci_cmd_interrupt(struct at91_mci *host, u32 status)
+{
+	at91_mci_write(host, AT91_MCI_IDR, AT91_MCI_CMDRDY);
+
+	host->cmd_status = status;
+	smp_wmb();
+	at91mci_set_pending(host, EVENT_CMD_COMPLETE);
+	tasklet_schedule(&host->tasklet);
+}
+
+static irqreturn_t at91mci_interrupt(int irq, void *dev_id)
+{
+	struct at91_mci		*host = dev_id;
+	u32			status, mask, pending;
+	unsigned int		pass_count = 0;
+
+	do {
+		status = at91_mci_read(host, AT91_MCI_SR);
+		mask = at91_mci_read(host, AT91_MCI_IMR);
+		pending = status & mask;
+		if (!pending)
+			break;
+
+		if (pending & AT91MCI_DATA_ERROR_FLAGS) {
+			at91_mci_write(host, AT91_MCI_IDR, AT91MCI_DATA_ERROR_FLAGS
+					| AT91_MCI_RXRDY | AT91_MCI_TXRDY);
+			pending &= at91_mci_read(host, AT91_MCI_IMR);
+
+			host->data_status = status;
+			smp_wmb();
+			at91mci_set_pending(host, EVENT_DATA_ERROR);
+			tasklet_schedule(&host->tasklet);
+		}
+		if (pending & AT91_MCI_NOTBUSY) {
+			at91_mci_write(host, AT91_MCI_IDR,
+					AT91MCI_DATA_ERROR_FLAGS | AT91_MCI_NOTBUSY);
+			if (!host->data_status)
+				host->data_status = status;
+			smp_wmb();
+			at91mci_set_pending(host, EVENT_DATA_COMPLETE);
+			tasklet_schedule(&host->tasklet);
+		}
+		if (pending & AT91_MCI_RXRDY)
+			at91mci_read_data_pio(host);
+		if (pending & AT91_MCI_TXRDY)
+			at91mci_write_data_pio(host);
+
+		if (pending & AT91_MCI_CMDRDY)
+			at91mci_cmd_interrupt(host, status);
+	} while (pass_count++ < 5);
+
+	return pass_count ? IRQ_HANDLED : IRQ_NONE;
+}
+
+static irqreturn_t at91mci_detect_interrupt(int irq, void *dev_id)
+{
+	struct at91_mci_slot	*slot = dev_id;
+
+	/*
+	 * Disable interrupts until the pin has stabilized and check
+	 * the state then. Use mod_timer() since we may be in the
+	 * middle of the timer routine when this interrupt triggers.
+	 */
+	disable_irq_nosync(irq);
+	mod_timer(&slot->detect_timer, jiffies + msecs_to_jiffies(20));
+
+	return IRQ_HANDLED;
+}
+
+static int __init at91mci_init_slot(struct at91_mci *host,
+		struct at91_mmc_slot_pdata *slot_data, unsigned int id,
+		u32 sdc_reg)
+{
+	struct mmc_host			*mmc;
+	struct at91_mci_slot		*slot;
+
+	mmc = mmc_alloc_host(sizeof(struct at91_mci_slot), &host->pdev->dev);
+	if (!mmc)
+		return -ENOMEM;
+
+	slot = mmc_priv(mmc);
+	slot->mmc = mmc;
+	slot->host = host;
+	slot->det_pin = slot_data->det_pin;
+	slot->wp_pin = slot_data->wp_pin;
+	slot->sdc_reg = sdc_reg;
+
+	mmc->ops = &at91mci_ops;
+	mmc->f_min = DIV_ROUND_UP(host->bus_hz, 512);
+	mmc->f_max = host->bus_hz / 2;
+	mmc->ocr_avail	= MMC_VDD_32_33 | MMC_VDD_33_34;
+	if (slot_data->bus_width >= 4)
+		mmc->caps |= MMC_CAP_4_BIT_DATA;
+
+	mmc->max_hw_segs = 64;
+	mmc->max_phys_segs = 64;
+	mmc->max_req_size = 32768 * 512;
+	mmc->max_blk_size = 32768;
+	mmc->max_blk_count = 512;
+
+	/* Assume card is present initially */
+	set_bit(AT91MCI_CARD_PRESENT, &slot->flags);
+	if (gpio_is_valid(slot->det_pin)) {
+		if (gpio_request(slot->det_pin, "mmc_detect")) {
+			dev_dbg(&mmc->class_dev, "no detect pin available\n");
+			slot->det_pin = -EBUSY;
+		} else if (gpio_get_value(slot->det_pin)) {
+			clear_bit(AT91MCI_CARD_PRESENT, &slot->flags);
+		}
+	}
+
+	if (!gpio_is_valid(slot->det_pin))
+		mmc->caps |= MMC_CAP_NEEDS_POLL;
+
+	if (gpio_is_valid(slot->wp_pin)) {
+		if (gpio_request(slot->wp_pin, "mmc_wp")) {
+			dev_dbg(&mmc->class_dev, "no WP pin available\n");
+			slot->wp_pin = -EBUSY;
+		}
+	}
+
+	host->slot[id] = slot;
+	mmc_add_host(mmc);
+
+	if (gpio_is_valid(slot->det_pin)) {
+		int ret;
+
+		setup_timer(&slot->detect_timer, at91mci_detect_change,
+				(unsigned long)slot);
+
+		ret = request_irq(gpio_to_irq(slot->det_pin),
+				at91mci_detect_interrupt,
+				IRQF_TRIGGER_FALLING | IRQF_TRIGGER_RISING,
+				"mmc-detect", slot);
+		if (ret) {
+			dev_dbg(&mmc->class_dev,
+				"could not request IRQ %d for detect pin\n",
+				gpio_to_irq(slot->det_pin));
+			gpio_free(slot->det_pin);
+			slot->det_pin = -EBUSY;
+		}
+	}
+
+	at91mci_init_debugfs(slot);
+
+	return 0;
+}
+
+static void __exit at91mci_cleanup_slot(struct at91_mci_slot *slot,
+		unsigned int id)
+{
+	/* Debugfs stuff is cleaned up by mmc core */
+
+	set_bit(AT91MCI_SHUTDOWN, &slot->flags);
+	smp_wmb();
+
+	mmc_remove_host(slot->mmc);
+
+	if (gpio_is_valid(slot->det_pin)) {
+		int pin = slot->det_pin;
+
+		free_irq(gpio_to_irq(pin), slot);
+		del_timer_sync(&slot->detect_timer);
+		gpio_free(pin);
+	}
+	if (gpio_is_valid(slot->wp_pin))
+		gpio_free(slot->wp_pin);
+
+	slot->host->slot[id] = NULL;
+	mmc_free_host(slot->mmc);
+}
+
+static int __init at91mci_probe(struct platform_device *pdev)
+{
+	struct at91_mmc_data		*pdata;
+	struct at91_mci			*host;
+	struct resource			*regs;
+	unsigned int			nr_slots;
+	int				irq;
+	int				ret;
+
+	printk("Probing for AT91 MMC using Gen2 Driver\n");
+
+	regs = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!regs)
+		return -ENXIO;
+	pdata = pdev->dev.platform_data;
+	if (!pdata)
+		return -ENXIO;
+	irq = platform_get_irq(pdev, 0);
+	if (irq < 0)
+		return irq;
+
+	host = kzalloc(sizeof(struct at91_mci), GFP_KERNEL);
+	if (!host)
+		return -ENOMEM;
+
+	host->pdev = pdev;
+	spin_lock_init(&host->lock);
+	INIT_LIST_HEAD(&host->queue);
+
+	host->mck = clk_get(&pdev->dev, "mci_clk");
+	if (IS_ERR(host->mck)) {
+		ret = PTR_ERR(host->mck);
+		goto err_clk_get;
+	}
+
+	ret = -ENOMEM;
+	host->regs = ioremap(regs->start, regs->end - regs->start + 1);
+	if (!host->regs)
+		goto err_ioremap;
+
+	clk_enable(host->mck);
+	at91_mci_write(host, AT91_MCI_CR, AT91_MCI_SWRST);
+	host->bus_hz = clk_get_rate(host->mck);
+	clk_disable(host->mck);
+
+	host->mapbase = regs->start;
+
+	tasklet_init(&host->tasklet, at91mci_tasklet_func, (unsigned long)host);
+
+	ret = request_irq(irq, at91mci_interrupt, 0, pdev->dev.bus_id, host);
+	if (ret)
+		goto err_request_irq;
+
+	platform_set_drvdata(pdev, host);
+
+	/* We need at least one slot to succeed */
+	nr_slots = 0;
+	ret = -ENODEV;
+	if (pdata->slot[0].bus_width) {
+		ret = at91mci_init_slot(host, &pdata->slot[0],
+				AT91_MCI_SDCSEL & 0x0, 0);
+		if (!ret)
+			nr_slots++;
+	}
+	if (pdata->slot[1].bus_width) {
+		ret = at91mci_init_slot(host, &pdata->slot[1],
+				AT91_MCI_SDCSEL & 0x1, 1);
+		if (!ret)
+			nr_slots++;
+	}
+
+	if (!nr_slots) {
+		printk(KERN_ERR "AT91 MCI controller init failed.
at91mci_init_slot error or no slots with bus_width > 0.\n");
+		goto err_init_slot;
+	}
+
+	dev_info(&pdev->dev,
+			"AT91 MCI controller at 0x%08lx irq %d, %u slots\n",
+			host->mapbase, irq, nr_slots);
+
+	return 0;
+
+err_init_slot:
+	free_irq(irq, host);
+err_request_irq:
+	iounmap(host->regs);
+err_ioremap:
+	clk_put(host->mck);
+err_clk_get:
+	kfree(host);
+	return ret;
+}
+
+static int __exit at91mci_remove(struct platform_device *pdev)
+{
+	struct at91_mci		*host = platform_get_drvdata(pdev);
+	unsigned int		i;
+
+	platform_set_drvdata(pdev, NULL);
+
+	for (i = 0; i < AT91_MCI_MAX_NR_SLOTS; i++) {
+		if (host->slot[i])
+			at91mci_cleanup_slot(host->slot[i], i);
+	}
+
+	clk_enable(host->mck);
+	at91_mci_write(host, AT91_MCI_IDR, ~0UL);
+	at91_mci_write(host, AT91_MCI_CR, AT91_MCI_MCIDIS);
+	at91_mci_read(host, AT91_MCI_SR);
+	clk_disable(host->mck);
+
+	free_irq(platform_get_irq(pdev, 0), host);
+	iounmap(host->regs);
+
+	clk_put(host->mck);
+	kfree(host);
+
+	return 0;
+}
+
+static struct platform_driver at91mci_driver = {
+	.remove		= __exit_p(at91mci_remove),
+	.driver		= {
+		.name		= DRIVER_NAME,
+	},
+};
+
+static int __init at91mci_init(void)
+{
+	return platform_driver_probe(&at91mci_driver, at91mci_probe);
+}
+
+static void __exit at91mci_exit(void)
+{
+	platform_driver_unregister(&at91mci_driver);
+}
+
+module_init(at91mci_init);
+module_exit(at91mci_exit);
+
+MODULE_DESCRIPTION("Atmel AT91 Multimedia Card Interface driver 2nd gen");
+MODULE_AUTHOR("Rob Emanuele <poorarm@shoreis.com>");
+MODULE_LICENSE("GPL v2");
+MODULE_ALIAS("platform:at91_mci");
