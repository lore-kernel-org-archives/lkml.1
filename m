Return-Path: <linux-kernel-owner+w=401wt.eu-S1030988AbXDYNvE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030988AbXDYNvE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 09:51:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031000AbXDYNvD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 09:51:03 -0400
Received: from static-141-230-6-89.ipcom.comunitel.net ([89.6.230.141]:57338
	"EHLO traven.no-ip.org" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1030988AbXDYNvB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 09:51:01 -0400
Date: Wed, 25 Apr 2007 15:53:57 +0200
From: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
To: rlove@rlove.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] use mutex instead of semaphore in hdaps driver
Message-ID: <20070425135357.GM6798@traven>
Mail-Followup-To: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>,
	rlove@rlove.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

the hdaps driver uses a semaphore as mutex. use the mutex API
instead of the (binary) semaphore

Signed-off-by: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>

--
diff --git a/drivers/hwmon/hdaps.c b/drivers/hwmon/hdaps.c
index bf759ea..f8e4952 100644
--- a/drivers/hwmon/hdaps.c
+++ b/drivers/hwmon/hdaps.c
@@ -71,10 +71,10 @@ static u8 km_activity;
 static int rest_x;
 static int rest_y;
 
-static DECLARE_MUTEX(hdaps_sem);
+static DEFINE_MUTEX(hdaps_mtx);
 
 /*
- * __get_latch - Get the value from a given port.  Callers must hold hdaps_sem.
+ * __get_latch - Get the value from a given port.  Callers must hold hdaps_mtx.
  */
 static inline u8 __get_latch(u16 port)
 {
@@ -83,7 +83,7 @@ static inline u8 __get_latch(u16 port)
 
 /*
  * __check_latch - Check a port latch for a given value.  Returns zero if the
- * port contains the given value.  Callers must hold hdaps_sem.
+ * port contains the given value.  Callers must hold hdaps_mtx.
  */
 static inline int __check_latch(u16 port, u8 val)
 {
@@ -94,7 +94,7 @@ static inline int __check_latch(u16 port, u8 val)
 
 /*
  * __wait_latch - Wait up to 100us for a port latch to get a certain value,
- * returning zero if the value is obtained.  Callers must hold hdaps_sem.
+ * returning zero if the value is obtained.  Callers must hold hdaps_mtx.
  */
 static int __wait_latch(u16 port, u8 val)
 {
@@ -111,7 +111,7 @@ static int __wait_latch(u16 port, u8 val)
 
 /*
  * __device_refresh - request a refresh from the accelerometer.  Does not wait
- * for refresh to complete.  Callers must hold hdaps_sem.
+ * for refresh to complete.  Callers must hold hdaps_mtx.
  */
 static void __device_refresh(void)
 {
@@ -125,7 +125,7 @@ static void __device_refresh(void)
 /*
  * __device_refresh_sync - request a synchronous refresh from the
  * accelerometer.  We wait for the refresh to complete.  Returns zero if
- * successful and nonzero on error.  Callers must hold hdaps_sem.
+ * successful and nonzero on error.  Callers must hold hdaps_mtx.
  */
 static int __device_refresh_sync(void)
 {
@@ -135,7 +135,7 @@ static int __device_refresh_sync(void)
 
 /*
  * __device_complete - indicate to the accelerometer that we are done reading
- * data, and then initiate an async refresh.  Callers must hold hdaps_sem.
+ * data, and then initiate an async refresh.  Callers must hold hdaps_mtx.
  */
 static inline void __device_complete(void)
 {
@@ -153,7 +153,7 @@ static int hdaps_readb_one(unsigned int port, u8 *val)
 {
 	int ret;
 
-	down(&hdaps_sem);
+	mutex_lock(&hdaps_mtx);
 
 	/* do a sync refresh -- we need to be sure that we read fresh data */
 	ret = __device_refresh_sync();
@@ -164,7 +164,7 @@ static int hdaps_readb_one(unsigned int port, u8 *val)
 	__device_complete();
 
 out:
-	up(&hdaps_sem);
+	mutex_unlock(&hdaps_mtx);
 	return ret;
 }
 
@@ -199,9 +199,9 @@ static int hdaps_read_pair(unsigned int port1, unsigned int port2,
 {
 	int ret;
 
-	down(&hdaps_sem);
+	mutex_lock(&hdaps_mtx);
 	ret = __hdaps_read_pair(port1, port2, val1, val2);
-	up(&hdaps_sem);
+	mutex_unlock(&hdaps_mtx);
 
 	return ret;
 }
@@ -214,7 +214,7 @@ static int hdaps_device_init(void)
 {
 	int total, ret = -ENXIO;
 
-	down(&hdaps_sem);
+	mutex_lock(&hdaps_mtx);
 
 	outb(0x13, 0x1610);
 	outb(0x01, 0x161f);
@@ -280,7 +280,7 @@ static int hdaps_device_init(void)
 	}
 
 out:
-	up(&hdaps_sem);
+	mutex_unlock(&hdaps_mtx);
 	return ret;
 }
 
@@ -314,7 +314,7 @@ static struct platform_driver hdaps_driver = {
 };
 
 /*
- * hdaps_calibrate - Set our "resting" values.  Callers must hold hdaps_sem.
+ * hdaps_calibrate - Set our "resting" values.  Callers must hold hdaps_mtx.
  */
 static void hdaps_calibrate(void)
 {
@@ -326,7 +326,7 @@ static void hdaps_mousedev_poll(unsigned long unused)
 	int x, y;
 
 	/* Cannot sleep.  Try nonblockingly.  If we fail, try again later. */
-	if (down_trylock(&hdaps_sem)) {
+	if (mutex_trylock(&hdaps_mtx)) {
 		mod_timer(&hdaps_timer,jiffies + HDAPS_POLL_PERIOD);
 		return;
 	}
@@ -341,7 +341,7 @@ static void hdaps_mousedev_poll(unsigned long unused)
 	mod_timer(&hdaps_timer, jiffies + HDAPS_POLL_PERIOD);
 
 out:
-	up(&hdaps_sem);
+	mutex_unlock(&hdaps_mtx);
 }
 
 
@@ -421,9 +421,9 @@ static ssize_t hdaps_calibrate_store(struct device *dev,
 				     struct device_attribute *attr,
 				     const char *buf, size_t count)
 {
-	down(&hdaps_sem);
+	mutex_lock(&hdaps_mtx);
 	hdaps_calibrate();
-	up(&hdaps_sem);
+	mutex_unlock(&hdaps_mtx);
 
 	return count;
 }

-- 
Matthias Kaehlcke
Linux Application Developer
Barcelona


  The salvation of mankind lies only in making everything the concern of all
                         (Alexander Solzhenitsyn)
                                                                 .''`.
    using free software / Debian GNU/Linux | http://debian.org  : :'  :
                                                                `. `'`
gpg --keyserver pgp.mit.edu --recv-keys 47D8E5D4                  `-
