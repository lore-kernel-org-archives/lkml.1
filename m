Return-Path: <linux-kernel-owner+w=401wt.eu-S1764386AbXHCWQi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764386AbXHCWQi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2007 18:16:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763433AbXHCWQ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Aug 2007 18:16:29 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:3118 "EHLO Perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763021AbXHCWQ2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2007 18:16:28 -0400
Subject: Re: + remove-current-defines-and-uses-of-pr_err-add-pr_emerg.patch
	added to -mm tree
From: Joe Perches <joe@perches.com>
To: Jean Delvare <khali@linux-fr.org>, linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, mm-commits@vger.kernel.org, adaplas@pol.net,
       greg@kroah.com, jeff@garzik.org
In-Reply-To: <tI4NY5SL.1186153543.0764100.khali@localhost>
References: <tI4NY5SL.1186153543.0764100.khali@localhost>
Content-Type: text/plain
Date: Fri, 03 Aug 2007 15:16:09 -0700
Message-Id: <1186179369.13852.36.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2-2.1mdv2007.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-08-03 at 17:05 +0200, Jean Delvare wrote: 
> Fine with me, but this first patch should still be correct per se.

Add new pr_<level> printk(KERN_<level> fmt "\n", ##arg) to kernel.h
pr_info and pr_debug are unchanged
Remove local pr_err #defines
Convert current uses of pr_err

Signed-off-by:  Joe Perches <joe@perches.com>

diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 4300bb4..6447072 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -229,20 +229,24 @@ extern void print_hex_dump_bytes(const char *prefix_str, int prefix_type,
 			void *buf, size_t len);
 #define hex_asc(x)	"0123456789abcdef"[x]
 
+#define pr_emerg(fmt, arg...)	printk(KERN_EMERG fmt "\n", ##arg)
+#define pr_alert(fmt, arg...)	printk(KERN_ALERT fmt "\n", ##arg)
+#define pr_crit(fmt, arg...)	printk(KERN_CRIT fmt "\n", ##arg)
+#define pr_err(fmt, arg...)	printk(KERN_ERR fmt "\n", ##arg)
+#define pr_warn(fmt, arg...)	printk(KERN_WARNING fmt "\n", ##arg)
+#define pr_notice(fmt, arg...)	printk(KERN_NOTICE fmt "\n", ##arg)
+#define pr_info(fmt, arg...)	printk(KERN_INFO fmt, ##arg)
+
 #ifdef DEBUG
 /* If you are writing a driver, please use dev_dbg instead */
-#define pr_debug(fmt,arg...) \
-	printk(KERN_DEBUG fmt,##arg)
+#define pr_debug(fmt, arg...)	printk(KERN_DEBUG fmt, ##arg)
 #else
-static inline int __attribute__ ((format (printf, 1, 2))) pr_debug(const char * fmt, ...)
+static inline int __attribute__ ((format (printf, 1, 2))) pr_debug(const char *fmt, ...)
 {
 	return 0;
 }
 #endif
 
-#define pr_info(fmt,arg...) \
-	printk(KERN_INFO fmt,##arg)
-
 /*
  *      Display an IP address in readable format.
  */
diff --git a/drivers/i2c/chips/menelaus.c b/drivers/i2c/chips/menelaus.c
index 48a7e2f..055a7b4 100644
--- a/drivers/i2c/chips/menelaus.c
+++ b/drivers/i2c/chips/menelaus.c
@@ -49,8 +49,7 @@
 #include <asm/arch/menelaus.h>
 
 #define DRIVER_NAME			"menelaus"
-
-#define pr_err(fmt, arg...)	printk(KERN_ERR DRIVER_NAME ": ", ## arg);
+#define PFX                             DRIVER_NAME ": "
 
 #define MENELAUS_I2C_ADDRESS		0x72
 
@@ -156,7 +155,7 @@ static int menelaus_write_reg(int reg, u8 value)
 	int val = i2c_smbus_write_byte_data(the_menelaus->client, reg, value);
 
 	if (val < 0) {
-		pr_err("write error");
+		pr_err(PFX "write error");
 		return val;
 	}
 
@@ -168,7 +167,7 @@ static int menelaus_read_reg(int reg)
 	int val = i2c_smbus_read_byte_data(the_menelaus->client, reg);
 
 	if (val < 0)
-		pr_err("read error");
+		pr_err(PFX "read error");
 
 	return val;
 }
@@ -1178,7 +1177,7 @@ static int menelaus_probe(struct i2c_client *client)
 	/* If a true probe check the device */
 	rev = menelaus_read_reg(MENELAUS_REV);
 	if (rev < 0) {
-		pr_err("device not found");
+		pr_err(PFX "device not found");
 		err = -ENODEV;
 		goto fail1;
 	}
@@ -1259,7 +1258,7 @@ static int __init menelaus_init(void)
 
 	res = i2c_add_driver(&menelaus_i2c_driver);
 	if (res < 0) {
-		pr_err("driver registration failed\n");
+		pr_err(PFX "driver registration failed");
 		return res;
 	}
 
diff --git a/drivers/net/spider_net.c b/drivers/net/spider_net.c
index 590b12c..ce0417c 100644
--- a/drivers/net/spider_net.c
+++ b/drivers/net/spider_net.c
@@ -1238,14 +1238,14 @@ spider_net_decode_one_descr(struct spider_net_card *card)
 	if (hwdescr->dmac_cmd_status & SPIDER_NET_DESCR_BAD_STATUS) {
 		dev_err(&card->netdev->dev, "bad status, cmd_status=x%08x\n",
 			       hwdescr->dmac_cmd_status);
-		pr_err("buf_addr=x%08x\n", hw_buf_addr);
-		pr_err("buf_size=x%08x\n", hwdescr->buf_size);
-		pr_err("next_descr_addr=x%08x\n", hwdescr->next_descr_addr);
-		pr_err("result_size=x%08x\n", hwdescr->result_size);
-		pr_err("valid_size=x%08x\n", hwdescr->valid_size);
-		pr_err("data_status=x%08x\n", hwdescr->data_status);
-		pr_err("data_error=x%08x\n", hwdescr->data_error);
-		pr_err("which=%ld\n", descr - card->rx_chain.ring);
+		pr_err("buf_addr=x%08x", hw_buf_addr);
+		pr_err("buf_size=x%08x", hwdescr->buf_size);
+		pr_err("next_descr_addr=x%08x", hwdescr->next_descr_addr);
+		pr_err("result_size=x%08x", hwdescr->result_size);
+		pr_err("valid_size=x%08x", hwdescr->valid_size);
+		pr_err("data_status=x%08x", hwdescr->data_status);
+		pr_err("data_error=x%08x", hwdescr->data_error);
+		pr_err("which=%ld", descr - card->rx_chain.ring);
 
 		card->spider_stats.rx_desc_error++;
 		goto bad_desc;
diff --git a/drivers/net/spider_net.h b/drivers/net/spider_net.h
index dbbdb8c..c67b11d 100644
--- a/drivers/net/spider_net.h
+++ b/drivers/net/spider_net.h
@@ -493,7 +493,4 @@ struct spider_net_card {
 	struct spider_net_descr darray[0];
 };
 
-#define pr_err(fmt,arg...) \
-	printk(KERN_ERR fmt ,##arg)
-
 #endif
diff --git a/drivers/video/omap/lcd_h3.c b/drivers/video/omap/lcd_h3.c
index 51807b4..c37b651 100644
--- a/drivers/video/omap/lcd_h3.c
+++ b/drivers/video/omap/lcd_h3.c
@@ -27,8 +27,7 @@
 #include <asm/arch/omapfb.h>
 
 #define MODULE_NAME	"omapfb-lcd_h3"
-
-#define pr_err(fmt, args...) printk(KERN_ERR MODULE_NAME ": " fmt, ## args)
+#define PFX MODULE_NAME ": "
 
 static int h3_panel_init(struct lcd_panel *panel, struct omapfb_device *fbdev)
 {
@@ -48,7 +47,7 @@ static int h3_panel_enable(struct lcd_panel *panel)
 	if (!r)
 		r = tps65010_set_gpio_out_value(GPIO2, HIGH);
 	if (r)
-		pr_err("Unable to turn on LCD panel\n");
+		pr_err(PFX "Unable to turn on LCD panel");
 
 	return r;
 }
@@ -62,7 +61,7 @@ static void h3_panel_disable(struct lcd_panel *panel)
 	if (!r)
 		tps65010_set_gpio_out_value(GPIO2, LOW);
 	if (r)
-		pr_err("Unable to turn off LCD panel\n");
+		pr_err(PFX "Unable to turn off LCD panel");
 }
 
 static unsigned long h3_panel_get_caps(struct lcd_panel *panel)
diff --git a/drivers/video/omap/lcd_inn1610.c b/drivers/video/omap/lcd_inn1610.c
index 95604ca..562a30e 100644
--- a/drivers/video/omap/lcd_inn1610.c
+++ b/drivers/video/omap/lcd_inn1610.c
@@ -26,8 +26,7 @@
 #include <asm/arch/omapfb.h>
 
 #define MODULE_NAME	"omapfb-lcd_h3"
-
-#define pr_err(fmt, args...) printk(KERN_ERR MODULE_NAME ": " fmt, ## args)
+#define PFX		MODULE_NAME ": "
 
 static int innovator1610_panel_init(struct lcd_panel *panel,
 				    struct omapfb_device *fbdev)
@@ -35,12 +34,12 @@ static int innovator1610_panel_init(struct lcd_panel *panel,
 	int r = 0;
 
 	if (omap_request_gpio(14)) {
-		pr_err("can't request GPIO 14\n");
+		pr_err(PFX "can't request GPIO 14");
 		r = -1;
 		goto exit;
 	}
 	if (omap_request_gpio(15)) {
-		pr_err("can't request GPIO 15\n");
+		pr_err(PFX "can't request GPIO 15");
 		omap_free_gpio(14);
 		r = -1;
 		goto exit;


