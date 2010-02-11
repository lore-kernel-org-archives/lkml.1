Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756736Ab0BKSHl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Feb 2010 13:07:41 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:36202 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756692Ab0BKSHi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Feb 2010 13:07:38 -0500
X-Authority-Analysis: v=1.0 c=1 a=E4HFgPPYjKMA:10 a=yQdBAQUQAAAA:8 a=fQNXxm6INBMH9yZbKGcA:9 a=ayIzHu-loFK6ywLu7zwA:7 a=AVSsjB0I-ShpPGRNTLC9NqnE4SoA:4 a=IcxpeKGZWnEA:10 a=khOY8d4Kz8cA:10
X-Cloudmark-Score: 0
X-Originating-IP: 65.28.92.235
Date: Thu, 11 Feb 2010 12:07:35 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Bernhard Schiffner <bernhard@schiffner-limbach.de>,
       linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: [PATCH] staging: r8187se: Change to use common eeprom routines in EEPROM_93CX
Message-ID: <4b744767.Ro0tNpOT7EsZVlBG%Larry.Finger@lwfinger.net>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The TODO list includes switching this driver to use the common EEPROM
routines in EEPROM_93CX.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Tested by: Bernhard Schiffner <bernhard@schiffner-limbach.de>
---

Greg,

This change is one of the steps to make an MMIO trace for this driver
look like the mainline version that we are developing.

The delete of drivers/staging/rtl8187se/r8180_93cx6.c is handled here
in the normal diff manner. You may wish to change that to a 'git rm'.

Larry
---

 linux-2.6/drivers/staging/rtl8187se/r8180_93cx6.c |  146 ----------------------
 linux-2.6/drivers/staging/rtl8187se/Kconfig       |    1
 linux-2.6/drivers/staging/rtl8187se/Makefile      |    1
 linux-2.6/drivers/staging/rtl8187se/TODO          |    1
 linux-2.6/drivers/staging/rtl8187se/r8180_93cx6.h |   15 --
 linux-2.6/drivers/staging/rtl8187se/r8180_core.c  |   68 +++++++---
 6 files changed, 60 insertions(+), 172 deletions(-)

Index: linux-2.6/drivers/staging/rtl8187se/Makefile
===================================================================
--- linux-2.6.orig/drivers/staging/rtl8187se/Makefile
+++ linux-2.6/drivers/staging/rtl8187se/Makefile
@@ -18,7 +18,6 @@ EXTRA_CFLAGS += -DENABLE_LPS
 
 r8187se-objs :=			\
 		r8180_core.o		\
-		r8180_93cx6.o		\
 		r8180_wx.o		\
 		r8180_rtl8225z2.o	\
 		r8185b_init.o		\
Index: linux-2.6/drivers/staging/rtl8187se/r8180_93cx6.h
===================================================================
--- linux-2.6.orig/drivers/staging/rtl8187se/r8180_93cx6.h
+++ linux-2.6/drivers/staging/rtl8187se/r8180_93cx6.h
@@ -45,13 +45,10 @@
 
 #define	EPROM_TXPW_OFDM_CH1_2 0x20
 
-//#define	EPROM_TXPW_CH1_2 0x10
-#define  EPROM_TXPW_CH1_2 0x30
-#define	EPROM_TXPW_CH3_4 0x11
-#define	EPROM_TXPW_CH5_6 0x12
-#define	EPROM_TXPW_CH7_8 0x13
-#define	EPROM_TXPW_CH9_10 0x14
-#define	EPROM_TXPW_CH11_12 0x15
-#define	EPROM_TXPW_CH13_14 0x16
+#define	EPROM_TXPW_CH1_2 0x30
+
+#define RTL818X_EEPROM_CMD_READ		(1 << 0)
+#define RTL818X_EEPROM_CMD_WRITE	(1 << 1)
+#define RTL818X_EEPROM_CMD_CK		(1 << 2)
+#define RTL818X_EEPROM_CMD_CS		(1 << 3)
 
-u32 eprom_read(struct net_device *dev,u32 addr); //reads a 16 bits word
Index: linux-2.6/drivers/staging/rtl8187se/r8180_core.c
===================================================================
--- linux-2.6.orig/drivers/staging/rtl8187se/r8180_core.c
+++ linux-2.6/drivers/staging/rtl8187se/r8180_core.c
@@ -31,6 +31,7 @@
 #undef DUMMY_RX
 
 #include <linux/syscalls.h>
+#include <linux/eeprom_93cx6.h>
 
 #include "r8180_hw.h"
 #include "r8180.h"
@@ -2675,6 +2676,36 @@ static void rtl8180_link_detect_init(pli
 }
 //YJ,add,080828,end
 
+static void rtl8187se_eeprom_register_read(struct eeprom_93cx6 *eeprom)
+{
+	struct net_device *dev = eeprom->data;
+	u8 reg = read_nic_byte(dev, EPROM_CMD);
+
+	eeprom->reg_data_in = reg & RTL818X_EEPROM_CMD_WRITE;
+	eeprom->reg_data_out = reg & RTL818X_EEPROM_CMD_READ;
+	eeprom->reg_data_clock = reg & RTL818X_EEPROM_CMD_CK;
+	eeprom->reg_chip_select = reg & RTL818X_EEPROM_CMD_CS;
+}
+
+static void rtl8187se_eeprom_register_write(struct eeprom_93cx6 *eeprom)
+{
+	struct net_device *dev = eeprom->data;
+	u8 reg = 2 << 6;
+
+	if (eeprom->reg_data_in)
+		reg |= RTL818X_EEPROM_CMD_WRITE;
+	if (eeprom->reg_data_out)
+		reg |= RTL818X_EEPROM_CMD_READ;
+	if (eeprom->reg_data_clock)
+		reg |= RTL818X_EEPROM_CMD_CK;
+	if (eeprom->reg_chip_select)
+		reg |= RTL818X_EEPROM_CMD_CS;
+
+	write_nic_byte(dev, EPROM_CMD, reg);
+	read_nic_byte(dev, EPROM_CMD);
+	udelay(10);
+}
+
 short rtl8180_init(struct net_device *dev)
 {
 	struct r8180_priv *priv = ieee80211_priv(dev);
@@ -2683,8 +2714,16 @@ short rtl8180_init(struct net_device *de
 	u32 usValue;
 	u16 tmpu16;
 	int i, j;
+	struct eeprom_93cx6 eeprom;
+	u16 eeprom_val;
+
+	eeprom.data = dev;
+	eeprom.register_read = rtl8187se_eeprom_register_read;
+	eeprom.register_write = rtl8187se_eeprom_register_write;
+	eeprom.width = PCI_EEPROM_WIDTH_93C46;
 
-	priv->channel_plan = eprom_read(dev, EEPROM_COUNTRY_CODE>>1) & 0xFF;
+	eeprom_93cx6_read(&eeprom, EEPROM_COUNTRY_CODE>>1, &eeprom_val);
+	priv->channel_plan = eeprom_val & 0xFF;
 	if(priv->channel_plan > COUNTRY_CODE_GLOBAL_DOMAIN){
 		printk("rtl8180_init:Error channel plan! Set to default.\n");
 		priv->channel_plan = 0;
@@ -2913,7 +2952,8 @@ short rtl8180_init(struct net_device *de
 	// just for sync 85
 	priv->enable_gpio0 = 0;
 
-	usValue = eprom_read(dev, EEPROM_SW_REVD_OFFSET);
+	eeprom_93cx6_read(&eeprom, EEPROM_SW_REVD_OFFSET, &eeprom_val);
+	usValue = eeprom_val;
 	DMESG("usValue is 0x%x\n",usValue);
 	//3Read AntennaDiversity
 
@@ -2953,20 +2993,16 @@ short rtl8180_init(struct net_device *de
 	else
 		priv->epromtype=EPROM_93c46;
 
-	dev->dev_addr[0]=eprom_read(dev,MAC_ADR) & 0xff;
-	dev->dev_addr[1]=(eprom_read(dev,MAC_ADR) & 0xff00)>>8;
-	dev->dev_addr[2]=eprom_read(dev,MAC_ADR+1) & 0xff;
-	dev->dev_addr[3]=(eprom_read(dev,MAC_ADR+1) & 0xff00)>>8;
-	dev->dev_addr[4]=eprom_read(dev,MAC_ADR+2) & 0xff;
-	dev->dev_addr[5]=(eprom_read(dev,MAC_ADR+2) & 0xff00)>>8;
+	eeprom_93cx6_multiread(&eeprom, 0x7, (__le16 *)
+			       dev->dev_addr, 3);
 
 	for(i=1,j=0; i<14; i+=2,j++){
-		word = eprom_read(dev,EPROM_TXPW_CH1_2 + j);
+		eeprom_93cx6_read(&eeprom, EPROM_TXPW_CH1_2 + j, &word);
 		priv->chtxpwr[i]=word & 0xff;
 		priv->chtxpwr[i+1]=(word & 0xff00)>>8;
 	}
 	for (i = 1, j = 0; i < 14; i += 2, j++) {
-		word = eprom_read(dev, EPROM_TXPW_OFDM_CH1_2 + j);
+		eeprom_93cx6_read(&eeprom, EPROM_TXPW_OFDM_CH1_2 + j, &word);
 		priv->chtxpwr_ofdm[i] = word & 0xff;
 		priv->chtxpwr_ofdm[i+1] = (word & 0xff00)>>8;
 	}
@@ -2975,7 +3011,7 @@ short rtl8180_init(struct net_device *de
 
 	// By SD3 SY's request. Added by Roger, 2007.12.11.
 
-	tmpu16 = eprom_read(dev, EEPROM_RSV>>1);
+	eeprom_93cx6_read(&eeprom, EEPROM_RSV>>1, &tmpu16);
 
 		// Crystal calibration for Xin and Xout resp.
 		priv->XtalCal_Xout = tmpu16 & EEPROM_XTAL_CAL_XOUT_MASK; // 0~7.5pF
@@ -2988,17 +3024,19 @@ short rtl8180_init(struct net_device *de
 		if((tmpu16 & EEPROM_THERMAL_METER_ENABLE)>>13)
 			priv->bTxPowerTrack = true;
 
-	word = eprom_read(dev,EPROM_TXPW_BASE);
+	eeprom_93cx6_read(&eeprom, EPROM_TXPW_BASE, &word);
 	priv->cck_txpwr_base = word & 0xf;
 	priv->ofdm_txpwr_base = (word>>4) & 0xf;
 
-	version = eprom_read(dev,EPROM_VERSION);
+	eeprom_93cx6_read(&eeprom, EPROM_VERSION, &version);
 	DMESG("EEPROM version %x",version);
 	priv->rcr_csense = 3;
 
-	priv->cs_treshold = (eprom_read(dev, ENERGY_TRESHOLD) & 0xff00) >> 8;
+	eeprom_93cx6_read(&eeprom, ENERGY_TRESHOLD, &eeprom_val);
+	priv->cs_treshold = (eeprom_val & 0xff00) >> 8;
 
-	priv->rf_chip = 0xff & eprom_read(dev, RFCHIPID);
+	eeprom_93cx6_read(&eeprom, RFCHIPID, &eeprom_val);
+	priv->rf_chip = 0xff & eeprom_val;
 
 	priv->rf_chip = RF_ZEBRA4;
 	priv->rf_sleep = rtl8225z4_rf_sleep;
Index: linux-2.6/drivers/staging/rtl8187se/Kconfig
===================================================================
--- linux-2.6.orig/drivers/staging/rtl8187se/Kconfig
+++ linux-2.6/drivers/staging/rtl8187se/Kconfig
@@ -3,6 +3,7 @@ config R8187SE
 	depends on PCI && WLAN
 	select WIRELESS_EXT
 	select WEXT_PRIV
+	select EEPROM_93CX6
 	default N
 	---help---
 	  If built as a module, it will be called r8187se.ko.
Index: linux-2.6/drivers/staging/rtl8187se/TODO
===================================================================
--- linux-2.6.orig/drivers/staging/rtl8187se/TODO
+++ linux-2.6/drivers/staging/rtl8187se/TODO
@@ -5,7 +5,6 @@ TODO:
 - switch to use shared "librtl" instead of private ieee80211 stack
 - switch to use LIB80211
 - switch to use MAC80211
-- switch to use EEPROM_93CX6
 - use kernel coding style
 - checkpatch.pl fixes
 - sparse fixes
Index: linux-2.6/drivers/staging/rtl8187se/r8180_93cx6.c
===================================================================
--- linux-2.6.orig/drivers/staging/rtl8187se/r8180_93cx6.c
+++ /dev/null
@@ -1,146 +0,0 @@
-/*
-   This files contains card eeprom (93c46 or 93c56) programming routines,
-   memory is addressed by 16 bits words.
-
-   This is part of rtl8180 OpenSource driver.
-   Copyright (C) Andrea Merello 2004  <andreamrl@tiscali.it>
-   Released under the terms of GPL (General Public Licence)
-
-   Parts of this driver are based on the GPL part of the
-   official realtek driver.
-
-   Parts of this driver are based on the rtl8180 driver skeleton
-   from Patric Schenke & Andres Salomon.
-
-   Parts of this driver are based on the Intel Pro Wireless 2100 GPL driver.
-
-   We want to tanks the Authors of those projects and the Ndiswrapper
-   project Authors.
-*/
-
-#include "r8180_93cx6.h"
-
-void eprom_cs(struct net_device *dev, short bit)
-{
-	if(bit)
-		write_nic_byte(dev, EPROM_CMD,
-			       (1<<EPROM_CS_SHIFT) | \
-			       read_nic_byte(dev, EPROM_CMD)); //enable EPROM
-	else
-		write_nic_byte(dev, EPROM_CMD, read_nic_byte(dev, EPROM_CMD)\
-			       &~(1<<EPROM_CS_SHIFT)); //disable EPROM
-
-	force_pci_posting(dev);
-	udelay(EPROM_DELAY);
-}
-
-
-void eprom_ck_cycle(struct net_device *dev)
-{
-	write_nic_byte(dev, EPROM_CMD,
-		       (1<<EPROM_CK_SHIFT) | read_nic_byte(dev,EPROM_CMD));
-	force_pci_posting(dev);
-	udelay(EPROM_DELAY);
-	write_nic_byte(dev, EPROM_CMD,
-		       read_nic_byte(dev, EPROM_CMD) &~ (1<<EPROM_CK_SHIFT));
-	force_pci_posting(dev);
-	udelay(EPROM_DELAY);
-}
-
-
-void eprom_w(struct net_device *dev,short bit)
-{
-	if(bit)
-		write_nic_byte(dev, EPROM_CMD, (1<<EPROM_W_SHIFT) | \
-			       read_nic_byte(dev,EPROM_CMD));
-	else
-		write_nic_byte(dev, EPROM_CMD, read_nic_byte(dev,EPROM_CMD)\
-			       &~(1<<EPROM_W_SHIFT));
-
-	force_pci_posting(dev);
-	udelay(EPROM_DELAY);
-}
-
-
-short eprom_r(struct net_device *dev)
-{
-	short bit;
-
-	bit=(read_nic_byte(dev, EPROM_CMD) & (1<<EPROM_R_SHIFT) );
-	udelay(EPROM_DELAY);
-
-	if(bit) return 1;
-	return 0;
-}
-
-
-void eprom_send_bits_string(struct net_device *dev, short b[], int len)
-{
-	int i;
-
-	for(i=0; i<len; i++){
-		eprom_w(dev, b[i]);
-		eprom_ck_cycle(dev);
-	}
-}
-
-
-u32 eprom_read(struct net_device *dev, u32 addr)
-{
-	struct r8180_priv *priv = ieee80211_priv(dev);
-	short read_cmd[]={1,1,0};
-	short addr_str[8];
-	int i;
-	int addr_len;
-	u32 ret;
-
-	ret=0;
-        //enable EPROM programming
-	write_nic_byte(dev, EPROM_CMD,
-		       (EPROM_CMD_PROGRAM<<EPROM_CMD_OPERATING_MODE_SHIFT));
-	force_pci_posting(dev);
-	udelay(EPROM_DELAY);
-
-	if (priv->epromtype==EPROM_93c56){
-		addr_str[7]=addr & 1;
-		addr_str[6]=addr & (1<<1);
-		addr_str[5]=addr & (1<<2);
-		addr_str[4]=addr & (1<<3);
-		addr_str[3]=addr & (1<<4);
-		addr_str[2]=addr & (1<<5);
-		addr_str[1]=addr & (1<<6);
-		addr_str[0]=addr & (1<<7);
-		addr_len=8;
-	}else{
-		addr_str[5]=addr & 1;
-		addr_str[4]=addr & (1<<1);
-		addr_str[3]=addr & (1<<2);
-		addr_str[2]=addr & (1<<3);
-		addr_str[1]=addr & (1<<4);
-		addr_str[0]=addr & (1<<5);
-		addr_len=6;
-	}
-	eprom_cs(dev, 1);
-	eprom_ck_cycle(dev);
-	eprom_send_bits_string(dev, read_cmd, 3);
-	eprom_send_bits_string(dev, addr_str, addr_len);
-
-	//keep chip pin D to low state while reading.
-	//I'm unsure if it is necessary, but anyway shouldn't hurt
-	eprom_w(dev, 0);
-
-	for(i=0;i<16;i++){
-		//eeprom needs a clk cycle between writing opcode&adr
-		//and reading data. (eeprom outs a dummy 0)
-		eprom_ck_cycle(dev);
-		ret |= (eprom_r(dev)<<(15-i));
-	}
-
-	eprom_cs(dev, 0);
-	eprom_ck_cycle(dev);
-
-	//disable EPROM programming
-	write_nic_byte(dev, EPROM_CMD,
-		       (EPROM_CMD_NORMAL<<EPROM_CMD_OPERATING_MODE_SHIFT));
-	return ret;
-}
