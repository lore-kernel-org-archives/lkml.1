Return-Path: <linux-kernel-owner+w=401wt.eu-S1756142AbZA0BEx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756142AbZA0BEx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 20:04:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754272AbZA0BEa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 20:04:30 -0500
Received: from wf-out-1314.google.com ([209.85.200.174]:56993 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754017AbZA0BE3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 20:04:29 -0500
Subject: [PATCH] x86: i2c rtc instead of cmos rtc
From: Ed Swierk <eswierk@aristanetworks.com>
To: a.zummo@towertech.it, rtc-linux@googlegroups.com, tglx@linutronix.de,
       mingo@redhat.com, linux-kernel@vger.kernel.org
Content-Type: text/plain
Date: Mon, 26 Jan 2009 17:04:23 -0800
Message-Id: <1233018263.14510.112.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 (2.24.3-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allows the user to ignore the cmos real-time clock normally found on x86
boards, and to use an i2c rtc in its place.  This is intended to be used
with with CONFIG_RTC_HCTOSYS=y to set the system clock from the rtc
automatically during boot, and with CONFIG_RTC_SYSTOHC=y to have ntpd
update the rtc (see separate patch).

Passing rtc.cmos=0 on the kernel command line ignores the cmos rtc, and
passing a parameter like rtc.i2c=ds1339,1,0x68 enables the i2c rtc named
ds1339 on i2c bus 1, device address 0x68.  The appropriate driver must
be compiled into the kernel to be available when the initcall is
triggered (device_initcall_sync to ensure the i2c device has already
been added).

Signed-off-by: Ed Swierk <eswierk@aristanetworks.com>

---
Index: linux-2.6.28.2/arch/x86/kernel/rtc.c
===================================================================
--- linux-2.6.28.2.orig/arch/x86/kernel/rtc.c
+++ linux-2.6.28.2/arch/x86/kernel/rtc.c
@@ -220,6 +220,9 @@ static struct platform_device rtc_device
 	.num_resources	= ARRAY_SIZE(rtc_resources),
 };
 
+static int cmos = 1;
+module_param(cmos, bool, 0);
+
 static __init int add_rtc_cmos(void)
 {
 #ifdef CONFIG_PNP
@@ -228,7 +231,11 @@ static __init int add_rtc_cmos(void)
 	struct pnp_dev *dev;
 	struct pnp_id *id;
 	int i;
+#endif
 
+	if (!cmos)
+		return 0;
+#ifdef CONFIG_PNP
 	pnp_for_each_dev(dev) {
 		for (id = dev->id; id; id = id->next) {
 			for (i = 0; i < ARRAY_SIZE(ids); i++) {
@@ -245,3 +252,41 @@ static __init int add_rtc_cmos(void)
 	return 0;
 }
 device_initcall(add_rtc_cmos);
+
+#include <linux/i2c.h>
+
+static char *i2c[3] = { NULL, NULL, NULL };
+module_param_array(i2c, charp, NULL, 0);
+
+static int setup_rtc_i2c(void)
+{
+	struct i2c_adapter *adapter;
+	struct i2c_board_info info = {};
+	int adapter_id;
+	unsigned short addrs[] = { 0, I2C_CLIENT_END };
+	struct i2c_client *c;
+	unsigned long num;
+
+	if (!i2c[0] || !i2c[1] || !i2c[2])
+		return 0;
+
+	strlcpy(info.type, i2c[0], I2C_NAME_SIZE);
+	if (strict_strtoul(i2c[1], 0, &num))
+		return 0;
+	adapter_id = num;
+	if (strict_strtoul(i2c[2], 0, &num))
+		return 0;
+	addrs[0] = num;
+
+	adapter = i2c_get_adapter(adapter_id);
+	if (!adapter)
+		return 0;
+
+	c = i2c_new_probed_device(adapter, &info, addrs);
+	if (c && c->driver == NULL) {
+		i2c_unregister_device(c);
+	}
+	i2c_put_adapter(adapter);
+	return 0;
+}
+device_initcall_sync(setup_rtc_i2c);


