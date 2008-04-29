Return-Path: <linux-kernel-owner+w=401wt.eu-S1758762AbYD2QqD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758762AbYD2QqD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 12:46:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759516AbYD2Qpv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 12:45:51 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:36580 "EHLO
	dwalker1.mvista.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758402AbYD2Qpv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 12:45:51 -0400
Message-Id: <20080429164303.182092623@mvista.com>
User-Agent: quilt/0.46-1
Date: Tue, 29 Apr 2008 09:43:03 -0700
From: Daniel Walker <dwalker@mvista.com>
To: akpm@linux-foundation.org
Cc: paulus@samba.org, benh@kernel.crashing.org, mingo@elte.hu, matthew@wil.cx,
       linux-kernel@vger.kernel.org
Subject: [PATCH] macintosh: qindfarm_smu_sat: semaphore to mutex
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Daniel Walker <dwalker@mvista.com>

---
 drivers/macintosh/windfarm_smu_sat.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

Index: linux-2.6.25/drivers/macintosh/windfarm_smu_sat.c
===================================================================
--- linux-2.6.25.orig/drivers/macintosh/windfarm_smu_sat.c
+++ linux-2.6.25/drivers/macintosh/windfarm_smu_sat.c
@@ -13,7 +13,7 @@
 #include <linux/init.h>
 #include <linux/wait.h>
 #include <linux/i2c.h>
-#include <asm/semaphore.h>
+#include <linux/mutex.h>
 #include <asm/prom.h>
 #include <asm/smu.h>
 #include <asm/pmac_low_i2c.h>
@@ -36,7 +36,7 @@
 struct wf_sat {
 	int			nr;
 	atomic_t		refcnt;
-	struct semaphore	mutex;
+	struct mutex		mutex;
 	unsigned long		last_read; /* jiffies when cache last updated */
 	u8			cache[16];
 	struct i2c_client	i2c;
@@ -163,7 +163,7 @@ static int wf_sat_get(struct wf_sensor *
 	if (sat->i2c.adapter == NULL)
 		return -ENODEV;
 
-	down(&sat->mutex);
+	mutex_lock(&sat->mutex);
 	if (time_after(jiffies, (sat->last_read + MAX_AGE))) {
 		err = wf_sat_read_cache(sat);
 		if (err)
@@ -182,7 +182,7 @@ static int wf_sat_get(struct wf_sensor *
 	err = 0;
 
  fail:
-	up(&sat->mutex);
+	mutex_unlock(&sat->mutex);
 	return err;
 }
 
@@ -233,7 +233,7 @@ static void wf_sat_create(struct i2c_ada
 	sat->nr = -1;
 	sat->node = of_node_get(dev);
 	atomic_set(&sat->refcnt, 0);
-	init_MUTEX(&sat->mutex);
+	mutex_init(&sat->mutex);
 	sat->i2c.addr = (addr >> 1) & 0x7f;
 	sat->i2c.adapter = adapter;
 	sat->i2c.driver = &wf_sat_driver;
-- 

-- 
