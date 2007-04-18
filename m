Return-Path: <linux-kernel-owner+w=401wt.eu-S2992731AbXDRPIV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992731AbXDRPIV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 11:08:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992732AbXDRPIV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 11:08:21 -0400
Received: from static-141-230-6-89.ipcom.comunitel.net ([89.6.230.141]:37959
	"EHLO traven.no-ip.org" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S2992731AbXDRPIT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 11:08:19 -0400
Date: Wed, 18 Apr 2007 17:04:58 +0200
From: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
To: rhdt@bartol.udel.edu
Cc: len.brown@intel.com, vladimir.p.lebedev@intel.com,
       linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] SBS ACPI: convert binary semaphore to mutex
Message-ID: <20070418150458.GC6474@traven>
Mail-Followup-To: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>,
	rhdt@bartol.udel.edu, len.brown@intel.com,
	vladimir.p.lebedev@intel.com, linux-acpi@vger.kernel.org,
	linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

according to http://lwn.net/Articles/167034/ binary semaphores (which
aren't given in interrupt context or locked/unlocked in different
process contexts) should be converted to the new mutex API.

this patch converts the semaphore used by the Smart Battery System
ACPI interface driver to a mutex.

please let me know your comments if i misinterpreted the article or if
you see something wrong in the patch

--

Smart Battery System ACPI driver: convert binary semaphore to mutex

Signed-off-by: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>

--

diff --git a/drivers/acpi/sbs.c b/drivers/acpi/sbs.c
index 59640d9..7e90132 100644
--- a/drivers/acpi/sbs.c
+++ b/drivers/acpi/sbs.c
@@ -32,6 +32,7 @@
 #include <linux/acpi.h>
 #include <linux/i2c.h>
 #include <linux/delay.h>
+#include <linux/mutex.h>
 
 #include "i2c_ec.h"
 
@@ -83,7 +84,7 @@ MODULE_AUTHOR("Rich Townsend");
 MODULE_DESCRIPTION("Smart Battery System ACPI interface driver");
 MODULE_LICENSE("GPL");
 
-static struct semaphore sbs_sem;
+static DEFINE_MUTEX(sbs_mutex);
 
 #define	UPDATE_MODE		QUEUE_UPDATE_MODE
 /* REQUEST_UPDATE_MODE  QUEUE_UPDATE_MODE */
@@ -930,7 +931,7 @@ static int acpi_battery_read_info(struct seq_file *seq, void *offset)
 		return -ENODEV;
 	}
 
-	down(&sbs_sem);
+	mutex_lock(&sbs_mutex);
 
 	if (update_mode == REQUEST_UPDATE_MODE) {
 		result = acpi_sbs_update_run(battery->sbs, DATA_TYPE_INFO);
@@ -984,7 +985,7 @@ static int acpi_battery_read_info(struct seq_file *seq, void *offset)
 
       end:
 
-	up(&sbs_sem);
+	mutex_unlock(&sbs_mutex);
 
 	return result;
 }
@@ -1005,7 +1006,7 @@ static int acpi_battery_read_state(struct seq_file *seq, void *offset)
 		return -ENODEV;
 	}
 
-	down(&sbs_sem);
+	mutex_lock(&sbs_mutex);
 
 	if (update_mode == REQUEST_UPDATE_MODE) {
 		result = acpi_sbs_update_run(battery->sbs, DATA_TYPE_STATE);
@@ -1061,7 +1062,7 @@ static int acpi_battery_read_state(struct seq_file *seq, void *offset)
 
       end:
 
-	up(&sbs_sem);
+	mutex_unlock(&sbs_mutex);
 
 	return result;
 }
@@ -1081,7 +1082,7 @@ static int acpi_battery_read_alarm(struct seq_file *seq, void *offset)
 		return -ENODEV;
 	}
 
-	down(&sbs_sem);
+	mutex_lock(&sbs_mutex);
 
 	if (update_mode == REQUEST_UPDATE_MODE) {
 		result = acpi_sbs_update_run(battery->sbs, DATA_TYPE_ALARM);
@@ -1113,7 +1114,7 @@ static int acpi_battery_read_alarm(struct seq_file *seq, void *offset)
 
       end:
 
-	up(&sbs_sem);
+	mutex_unlock(&sbs_mutex);
 
 	return result;
 }
@@ -1131,7 +1132,7 @@ acpi_battery_write_alarm(struct file *file, const char __user * buffer,
 		return -ENODEV;
 	}
 
-	down(&sbs_sem);
+	mutex_lock(&sbs_mutex);
 
 	if (!acpi_battery_is_present(battery)) {
 		result = -ENODEV;
@@ -1169,7 +1170,7 @@ acpi_battery_write_alarm(struct file *file, const char __user * buffer,
 	}
 
       end:
-	up(&sbs_sem);
+	mutex_unlock(&sbs_mutex);
 
 	if (result) {
 		return result;
@@ -1221,7 +1222,7 @@ static int acpi_ac_read_state(struct seq_file *seq, void *offset)
 		return -ENODEV;
 	}
 
-	down(&sbs_sem);
+	mutex_lock(&sbs_mutex);
 
 	if (update_mode == REQUEST_UPDATE_MODE) {
 		result = acpi_sbs_update_run(sbs, DATA_TYPE_AC_STATE);
@@ -1234,7 +1235,7 @@ static int acpi_ac_read_state(struct seq_file *seq, void *offset)
 	seq_printf(seq, "state:                   %s\n",
 		   sbs->ac_present ? "on-line" : "off-line");
 
-	up(&sbs_sem);
+	mutex_unlock(&sbs_mutex);
 
 	return 0;
 }
@@ -1719,8 +1720,6 @@ static int __init acpi_sbs_init(void)
 	if (acpi_disabled)
 		return -ENODEV;
 
-	init_MUTEX(&sbs_sem);
-
 	if (capacity_mode != DEF_CAPACITY_UNIT
 	    && capacity_mode != MAH_CAPACITY_UNIT
 	    && capacity_mode != MWH_CAPACITY_UNIT) {
 
-- 
Matthias Kaehlcke
Linux Application Developer
Barcelona

      Anyone who has never made a mistake has never tried anything new
                            (Albert Einstein)
                                                                 .''`.
    using free software / Debian GNU/Linux | http://debian.org  : :'  :
                                                                `. `'`
gpg --keyserver pgp.mit.edu --recv-keys 47D8E5D4                  `-
