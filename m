Return-Path: <linux-kernel-owner+w=401wt.eu-S934163AbYD2Pjd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934163AbYD2Pjd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 11:39:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765412AbYD2PjE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 11:39:04 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:13342 "EHLO
	dwalker1.mvista.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S934023AbYD2PjB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 11:39:01 -0400
Message-Id: <20080429153516.091218419@mvista.com>
User-Agent: quilt/0.46-1
Date: Tue, 29 Apr 2008 08:35:16 -0700
From: Daniel Walker <dwalker@mvista.com>
To: akpm@linux-foundation.org
Cc: paulus@samba.org, benh@kernel.crashing.org, mingo@elte.hu, matthew@wil.cx,
       linux-kernel@vger.kernel.org
Subject: [PATCH] macintosh: therm_pm72: driver_lock semaphore to mutex
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Daniel Walker <dwalker@mvista.com>

---
 drivers/macintosh/therm_pm72.c |   31 ++++++++++++++++---------------
 1 file changed, 16 insertions(+), 15 deletions(-)

Index: linux-2.6.24/drivers/macintosh/therm_pm72.c
===================================================================
--- linux-2.6.24.orig/drivers/macintosh/therm_pm72.c
+++ linux-2.6.24/drivers/macintosh/therm_pm72.c
@@ -122,6 +122,7 @@
 #include <linux/kmod.h>
 #include <linux/i2c.h>
 #include <linux/kthread.h>
+#include <linux/mutex.h>
 #include <asm/prom.h>
 #include <asm/machdep.h>
 #include <asm/io.h>
@@ -169,7 +170,7 @@ static int				rackmac;
 static s32				dimm_output_clamp;
 static int 				fcu_rpm_shift;
 static int				fcu_tickle_ticks;
-static DECLARE_MUTEX(driver_lock);
+static DEFINE_MUTEX(driver_lock);
 
 /*
  * We have 3 types of CPU PID control. One is "split" old style control
@@ -729,9 +730,9 @@ static void fetch_cpu_pumps_minmax(void)
 static ssize_t show_##name(struct device *dev, struct device_attribute *attr, char *buf)	\
 {								\
 	ssize_t r;						\
-	down(&driver_lock);					\
+	mutex_lock(&driver_lock);					\
 	r = sprintf(buf, "%d.%03d", FIX32TOPRINT(data));	\
-	up(&driver_lock);					\
+	mutex_unlock(&driver_lock);					\
 	return r;						\
 }
 #define BUILD_SHOW_FUNC_INT(name, data)				\
@@ -1803,11 +1804,11 @@ static int main_control_loop(void *x)
 {
 	DBG("main_control_loop started\n");
 
-	down(&driver_lock);
+	mutex_lock(&driver_lock);
 
 	if (start_fcu() < 0) {
 		printk(KERN_ERR "kfand: failed to start FCU\n");
-		up(&driver_lock);
+		mutex_unlock(&driver_lock);
 		goto out;
 	}
 
@@ -1822,14 +1823,14 @@ static int main_control_loop(void *x)
 
 	fcu_tickle_ticks = FCU_TICKLE_TICKS;
 
-	up(&driver_lock);
+	mutex_unlock(&driver_lock);
 
 	while (state == state_attached) {
 		unsigned long elapsed, start;
 
 		start = jiffies;
 
-		down(&driver_lock);
+		mutex_lock(&driver_lock);
 
 		/* Tickle the FCU just in case */
 		if (--fcu_tickle_ticks < 0) {
@@ -1861,7 +1862,7 @@ static int main_control_loop(void *x)
 			do_monitor_slots(&slots_state);
 		else
 			do_monitor_drives(&drives_state);
-		up(&driver_lock);
+		mutex_unlock(&driver_lock);
 
 		if (critical_state == 1) {
 			printk(KERN_WARNING "Temperature control detected a critical condition\n");
@@ -2019,13 +2020,13 @@ static void detach_fcu(void)
  */
 static int therm_pm72_attach(struct i2c_adapter *adapter)
 {
-	down(&driver_lock);
+	mutex_lock(&driver_lock);
 
 	/* Check state */
 	if (state == state_detached)
 		state = state_attaching;
 	if (state != state_attaching) {
-		up(&driver_lock);
+		mutex_unlock(&driver_lock);
 		return 0;
 	}
 
@@ -2054,7 +2055,7 @@ static int therm_pm72_attach(struct i2c_
 		state = state_attached;
 		start_control_loops();
 	}
-	up(&driver_lock);
+	mutex_unlock(&driver_lock);
 
 	return 0;
 }
@@ -2065,16 +2066,16 @@ static int therm_pm72_attach(struct i2c_
  */
 static int therm_pm72_detach(struct i2c_adapter *adapter)
 {
-	down(&driver_lock);
+	mutex_lock(&driver_lock);
 
 	if (state != state_detached)
 		state = state_detaching;
 
 	/* Stop control loops if any */
 	DBG("stopping control loops\n");
-	up(&driver_lock);
+	mutex_unlock(&driver_lock);
 	stop_control_loops();
-	down(&driver_lock);
+	mutex_lock(&driver_lock);
 
 	if (u3_0 != NULL && !strcmp(adapter->name, "u3 0")) {
 		DBG("lost U3-0, disposing control loops\n");
@@ -2090,7 +2091,7 @@ static int therm_pm72_detach(struct i2c_
 	if (u3_0 == NULL && u3_1 == NULL)
 		state = state_detached;
 
-	up(&driver_lock);
+	mutex_unlock(&driver_lock);
 
 	return 0;
 }
-- 

-- 
