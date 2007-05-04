Return-Path: <linux-kernel-owner+w=401wt.eu-S1754523AbXEDM0o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754523AbXEDM0o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 08:26:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754379AbXEDM0o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 08:26:44 -0400
Received: from tango.0pointer.de ([85.214.72.216]:54666 "EHLO
	tango.0pointer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754139AbXEDM0l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 08:26:41 -0400
X-Greylist: delayed 621 seconds by postgrey-1.27 at vger.kernel.org; Fri, 04 May 2007 08:26:41 EDT
Date: Fri, 4 May 2007 14:16:19 +0200
From: Lennart Poettering <mzxreary@0pointer.de>
To: len.brown@intel.com
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] acpi,msi-laptop: Fall back to EC polling mode for MSI laptop specific EC commands
Message-ID: <20070504121617.GA23312@tango.0pointer.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: .phi.
X-Campaign-1: ()  ASCII Ribbon Campaign
X-Campaign-2: /  Against HTML Email & vCards - Against Microsoft Attachments
X-Disclaimer-1: Diese Nachricht wurde mit einer elektronischen 
X-Disclaimer-2: Datenverarbeitungsanlage erstellt und bedarf daher 
X-Disclaimer-3: keiner Unterschrift.
User-Agent: Leviathan/19.8.0 [zh] (Cray 3; I; Solaris 4.711; Console)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lennart Poettering <mzxreary@0pointer.de>

The ACPI EC that is used in MSI laptops knows some non-standard
commands for changing the screen brighntess and a few other things,
which are used by the msi-laptop.c driver. Unfortunately for these
commands no GPE events for IBF and OBF are triggered. Since nowadays
the EC code uses the ec_intr=1 mode by default, this causes these
operations to timeout, although they don't fail. In result, all
operations that you can do with the msi-laptop.c driver take more or
less 1s to complete, which is awfully slow.

In one of the more recent kernels (2.6.20?) the EC subsystem has been
revamped. With that change the EC timeout has been increased. before
that increase the MSI EC accesses were slow -- but not *that* slow,
hence I took notice of this limitation of the MSI EC hardware only very
recently.

The standard EC operations on the MSI EC as defined in the ACPI spec
support GPE events properly.

The following patch adds a new argument "force_poll" to the
ec_transaction() function (and friends). If set to 1, the function
will poll for IBF/OBF even if ec_intr=1 is enabled. If set to 0 the
current behaviour is used. The msi-laptop driver is modified to make
use of this new flag, so that OBF/IBF is polled for the special MSI EC
transactions -- but only for them.

Patch is against Linus' current git kernel. Should also apply against
Len's current linux-acpi kernel.

Len, please merge!

Signed-off-by: Lennart Poettering <mzxreary@0pointer.de>
---
 drivers/acpi/ec.c         |   39 +++++++++++++++++++++++----------------
 drivers/misc/msi-laptop.c |   12 ++++++------
 include/linux/acpi.h      |    3 ++-
 3 files changed, 31 insertions(+), 23 deletions(-)

diff --git a/drivers/acpi/ec.c b/drivers/acpi/ec.c
index e08cf98..82f496c 100644
--- a/drivers/acpi/ec.c
+++ b/drivers/acpi/ec.c
@@ -147,9 +147,10 @@ static inline int acpi_ec_check_status(struct acpi_ec *ec, enum ec_event event,
 	return 0;
 }
 
-static int acpi_ec_wait(struct acpi_ec *ec, enum ec_event event, unsigned count)
+static int acpi_ec_wait(struct acpi_ec *ec, enum ec_event event,
+                        unsigned count, int force_poll)
 {
-	if (acpi_ec_mode == EC_POLL) {
+	if (unlikely(force_poll) || acpi_ec_mode == EC_POLL) {
 		unsigned long delay = jiffies + msecs_to_jiffies(ACPI_EC_DELAY);
 		while (time_before(jiffies, delay)) {
 			if (acpi_ec_check_status(ec, event, 0))
@@ -173,14 +174,15 @@ static int acpi_ec_wait(struct acpi_ec *ec, enum ec_event event, unsigned count)
 
 static int acpi_ec_transaction_unlocked(struct acpi_ec *ec, u8 command,
 					const u8 * wdata, unsigned wdata_len,
-					u8 * rdata, unsigned rdata_len)
+					u8 * rdata, unsigned rdata_len,
+					int force_poll)
 {
 	int result = 0;
 	unsigned count = atomic_read(&ec->event_count);
 	acpi_ec_write_cmd(ec, command);
 
 	for (; wdata_len > 0; --wdata_len) {
-		result = acpi_ec_wait(ec, ACPI_EC_EVENT_IBF_0, count);
+		result = acpi_ec_wait(ec, ACPI_EC_EVENT_IBF_0, count, force_poll);
 		if (result) {
 			printk(KERN_ERR PREFIX
 			       "write_cmd timeout, command = %d\n", command);
@@ -191,7 +193,7 @@ static int acpi_ec_transaction_unlocked(struct acpi_ec *ec, u8 command,
 	}
 
 	if (!rdata_len) {
-		result = acpi_ec_wait(ec, ACPI_EC_EVENT_IBF_0, count);
+		result = acpi_ec_wait(ec, ACPI_EC_EVENT_IBF_0, count, force_poll);
 		if (result) {
 			printk(KERN_ERR PREFIX
 			       "finish-write timeout, command = %d\n", command);
@@ -202,7 +204,7 @@ static int acpi_ec_transaction_unlocked(struct acpi_ec *ec, u8 command,
 	}
 
 	for (; rdata_len > 0; --rdata_len) {
-		result = acpi_ec_wait(ec, ACPI_EC_EVENT_OBF_1, count);
+		result = acpi_ec_wait(ec, ACPI_EC_EVENT_OBF_1, count, force_poll);
 		if (result) {
 			printk(KERN_ERR PREFIX "read timeout, command = %d\n",
 			       command);
@@ -217,7 +219,8 @@ static int acpi_ec_transaction_unlocked(struct acpi_ec *ec, u8 command,
 
 static int acpi_ec_transaction(struct acpi_ec *ec, u8 command,
 			       const u8 * wdata, unsigned wdata_len,
-			       u8 * rdata, unsigned rdata_len)
+			       u8 * rdata, unsigned rdata_len,
+			       int force_poll)
 {
 	int status;
 	u32 glk;
@@ -240,7 +243,7 @@ static int acpi_ec_transaction(struct acpi_ec *ec, u8 command,
 	/* Make sure GPE is enabled before doing transaction */
 	acpi_enable_gpe(NULL, ec->gpe, ACPI_NOT_ISR);
 
-	status = acpi_ec_wait(ec, ACPI_EC_EVENT_IBF_0, 0);
+	status = acpi_ec_wait(ec, ACPI_EC_EVENT_IBF_0, 0, 0);
 	if (status) {
 		printk(KERN_DEBUG PREFIX
 		       "input buffer is not empty, aborting transaction\n");
@@ -249,7 +252,8 @@ static int acpi_ec_transaction(struct acpi_ec *ec, u8 command,
 
 	status = acpi_ec_transaction_unlocked(ec, command,
 					      wdata, wdata_len,
-					      rdata, rdata_len);
+					      rdata, rdata_len,
+					      force_poll);
 
       end:
 
@@ -267,12 +271,12 @@ static int acpi_ec_transaction(struct acpi_ec *ec, u8 command,
 int acpi_ec_burst_enable(struct acpi_ec *ec)
 {
 	u8 d;
-	return acpi_ec_transaction(ec, ACPI_EC_BURST_ENABLE, NULL, 0, &d, 1);
+	return acpi_ec_transaction(ec, ACPI_EC_BURST_ENABLE, NULL, 0, &d, 1, 0);
 }
 
 int acpi_ec_burst_disable(struct acpi_ec *ec)
 {
-	return acpi_ec_transaction(ec, ACPI_EC_BURST_DISABLE, NULL, 0, NULL, 0);
+	return acpi_ec_transaction(ec, ACPI_EC_BURST_DISABLE, NULL, 0, NULL, 0, 0);
 }
 
 static int acpi_ec_read(struct acpi_ec *ec, u8 address, u8 * data)
@@ -281,7 +285,7 @@ static int acpi_ec_read(struct acpi_ec *ec, u8 address, u8 * data)
 	u8 d;
 
 	result = acpi_ec_transaction(ec, ACPI_EC_COMMAND_READ,
-				     &address, 1, &d, 1);
+				     &address, 1, &d, 1, 0);
 	*data = d;
 	return result;
 }
@@ -290,7 +294,7 @@ static int acpi_ec_write(struct acpi_ec *ec, u8 address, u8 data)
 {
 	u8 wdata[2] = { address, data };
 	return acpi_ec_transaction(ec, ACPI_EC_COMMAND_WRITE,
-				   wdata, 2, NULL, 0);
+				   wdata, 2, NULL, 0, 0);
 }
 
 /*
@@ -349,13 +353,15 @@ EXPORT_SYMBOL(ec_write);
 
 int ec_transaction(u8 command,
 		   const u8 * wdata, unsigned wdata_len,
-		   u8 * rdata, unsigned rdata_len)
+		   u8 * rdata, unsigned rdata_len,
+		   int force_poll)
 {
 	if (!first_ec)
 		return -ENODEV;
 
 	return acpi_ec_transaction(first_ec, command, wdata,
-				   wdata_len, rdata, rdata_len);
+				   wdata_len, rdata, rdata_len,
+				   force_poll);
 }
 
 EXPORT_SYMBOL(ec_transaction);
@@ -374,7 +380,7 @@ static int acpi_ec_query(struct acpi_ec *ec, u8 * data)
 	 * bit to be cleared (and thus clearing the interrupt source).
 	 */
 
-	result = acpi_ec_transaction(ec, ACPI_EC_COMMAND_QUERY, NULL, 0, &d, 1);
+	result = acpi_ec_transaction(ec, ACPI_EC_COMMAND_QUERY, NULL, 0, &d, 1, 0);
 	if (result)
 		return result;
 
@@ -410,6 +416,7 @@ static u32 acpi_ec_gpe_handler(void *data)
 	acpi_status status = AE_OK;
 	u8 value;
 	struct acpi_ec *ec = data;
+
 	atomic_inc(&ec->event_count);
 
 	if (acpi_ec_mode == EC_INTR) {
diff --git a/drivers/misc/msi-laptop.c b/drivers/misc/msi-laptop.c
index 68c4b58..41e901f 100644
--- a/drivers/misc/msi-laptop.c
+++ b/drivers/misc/msi-laptop.c
@@ -85,7 +85,7 @@ static int set_lcd_level(int level)
 	buf[0] = 0x80;
 	buf[1] = (u8) (level*31);
 
-	return ec_transaction(MSI_EC_COMMAND_LCD_LEVEL, buf, sizeof(buf), NULL, 0);
+	return ec_transaction(MSI_EC_COMMAND_LCD_LEVEL, buf, sizeof(buf), NULL, 0, 1);
 }
 
 static int get_lcd_level(void)
@@ -93,7 +93,7 @@ static int get_lcd_level(void)
 	u8 wdata = 0, rdata;
 	int result;
 
-	result = ec_transaction(MSI_EC_COMMAND_LCD_LEVEL, &wdata, 1, &rdata, 1);
+	result = ec_transaction(MSI_EC_COMMAND_LCD_LEVEL, &wdata, 1, &rdata, 1, 1);
 	if (result < 0)
 		return result;
 
@@ -105,7 +105,7 @@ static int get_auto_brightness(void)
 	u8 wdata = 4, rdata;
 	int result;
 
-	result = ec_transaction(MSI_EC_COMMAND_LCD_LEVEL, &wdata, 1, &rdata, 1);
+	result = ec_transaction(MSI_EC_COMMAND_LCD_LEVEL, &wdata, 1, &rdata, 1, 1);
 	if (result < 0)
 		return result;
 
@@ -119,14 +119,14 @@ static int set_auto_brightness(int enable)
 
 	wdata[0] = 4;
 
-	result = ec_transaction(MSI_EC_COMMAND_LCD_LEVEL, wdata, 1, &rdata, 1);
+	result = ec_transaction(MSI_EC_COMMAND_LCD_LEVEL, wdata, 1, &rdata, 1, 1);
 	if (result < 0)
 		return result;
 
 	wdata[0] = 0x84;
 	wdata[1] = (rdata & 0xF7) | (enable ? 8 : 0);
 
-	return ec_transaction(MSI_EC_COMMAND_LCD_LEVEL, wdata, 2, NULL, 0);
+	return ec_transaction(MSI_EC_COMMAND_LCD_LEVEL, wdata, 2, NULL, 0, 1);
 }
 
 static int get_wireless_state(int *wlan, int *bluetooth)
@@ -134,7 +134,7 @@ static int get_wireless_state(int *wlan, int *bluetooth)
 	u8 wdata = 0, rdata;
 	int result;
 
-	result = ec_transaction(MSI_EC_COMMAND_WIRELESS, &wdata, 1, &rdata, 1);
+	result = ec_transaction(MSI_EC_COMMAND_WIRELESS, &wdata, 1, &rdata, 1, 1);
 	if (result < 0)
 		return -1;
 
diff --git a/include/linux/acpi.h b/include/linux/acpi.h
index 8bcfaa4..fccd8b5 100644
--- a/include/linux/acpi.h
+++ b/include/linux/acpi.h
@@ -182,7 +182,8 @@ extern int ec_read(u8 addr, u8 *val);
 extern int ec_write(u8 addr, u8 val);
 extern int ec_transaction(u8 command,
                           const u8 *wdata, unsigned wdata_len,
-                          u8 *rdata, unsigned rdata_len);
+                          u8 *rdata, unsigned rdata_len,
+			  int force_poll);
 
 #endif /*CONFIG_ACPI_EC*/
