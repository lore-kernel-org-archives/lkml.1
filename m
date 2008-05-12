Return-Path: <linux-kernel-owner+w=401wt.eu-S1756119AbYELQjU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756119AbYELQjU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 12:39:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753371AbYELQjK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 12:39:10 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:29013 "EHLO
	dwalker1.mvista.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753049AbYELQjJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 12:39:09 -0400
Message-Id: <20080512163301.261947548@mvista.com>
User-Agent: quilt/0.46-1
Date: Mon, 12 May 2008 09:33:01 -0700
From: Daniel Walker <dwalker@mvista.com>
To: paulus@samba.org
Cc: benh@kernel.crashing.org, mingo@elte.hu, matthew@wil.cx,
       Matthias Kaehlcke <matthias@kaehlcke.net>, linux-kernel@vger.kernel.org
Subject: [PATCH] macintosh: therm_windtunnel: semaphore to mutex
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Daniel Walker <dwalker@mvista.com>

---
 drivers/macintosh/therm_windtunnel.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

Index: linux-2.6.23/drivers/macintosh/therm_windtunnel.c
===================================================================
--- linux-2.6.23.orig/drivers/macintosh/therm_windtunnel.c
+++ linux-2.6.23/drivers/macintosh/therm_windtunnel.c
@@ -62,7 +62,7 @@ static struct {
 	volatile int		running;
 	struct task_struct	*poll_task;
 	
-	struct semaphore 	lock;
+	struct mutex	 	lock;
 	struct of_device	*of_dev;
 	
 	struct i2c_client	*thermostat;
@@ -282,23 +282,23 @@ restore_regs( void )
 
 static int control_loop(void *dummy)
 {
-	down(&x.lock);
+	mutex_lock(&x.lock);
 	setup_hardware();
-	up(&x.lock);
+	mutex_unlock(&x.lock);
 
 	for (;;) {
 		msleep_interruptible(8000);
 		if (kthread_should_stop())
 			break;
 
-		down(&x.lock);
+		mutex_lock(&x.lock);
 		poll_temp();
-		up(&x.lock);
+		mutex_unlock(&x.lock);
 	}
 
-	down(&x.lock);
+	mutex_lock(&x.lock);
 	restore_regs();
-	up(&x.lock);
+	mutex_unlock(&x.lock);
 
 	return 0;
 }
@@ -485,7 +485,7 @@ g4fan_init( void )
 	const struct apple_thermal_info *info;
 	struct device_node *np;
 
-	init_MUTEX( &x.lock );
+	mutex_init(&x.lock);
 
 	if( !(np=of_find_node_by_name(NULL, "power-mgt")) )
 		return -ENODEV;
-- 

-- 
