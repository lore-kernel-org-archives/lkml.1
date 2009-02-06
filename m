Return-Path: <linux-kernel-owner+w=401wt.eu-S1752617AbZBFPMH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752617AbZBFPMH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 10:12:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754817AbZBFPLr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 10:11:47 -0500
Received: from styx.suse.cz ([82.119.242.94]:33813 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753187AbZBFPLp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 10:11:45 -0500
Date: Fri, 6 Feb 2009 16:11:43 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: "Andrew S. Johnson" <andy@asjohnson.com>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: [Bug #12426] TMDC Joystick no longer works in kernel 2.6.28
In-Reply-To: <200902060809.21985.andy@asjohnson.com>
Message-ID: <alpine.LNX.1.10.0902061609450.11630@jikos.suse.cz>
References: <a47yn9c9JrF.A.hz.L5YiJB@chimera> <alpine.LRH.1.10.0902041453190.22097@twin.jikos.cz> <200902050234.56056.rjw@sisk.pl> <200902060809.21985.andy@asjohnson.com>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 6 Feb 2009, Andrew S. Johnson wrote:

> > > > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12426
> > > > Subject		: TMDC Joystick no longer works in kernel 2.6.28
> > > > Submitter	: Andrew S. Johnson <andy@asjohnson.com>
> > > > Date		: 2009-01-10 21:53 (26 days old)
> > > > References	:
> > > > http://marc.info/?l=linux-kernel&m=123162486415366&w=4
> > > I asked [1] the Submitter some time ago to check whether
> > > reverting a particular commit fixes the issue, but never heard
> > > back.
> > > [1] http://lkml.org/lkml/2009/1/26/70
> > Rejected as "insufficient data" and closed.
> I never received the email referring to a particular commit because I am 
> not subscribed to LKML.  

I CCed you, but your ISP blacklisted both of my SMTP servers I have tried 
for no apparent reason.

> The commit revert seemed to work OK on gameport.c, but I get an error 
> that gameport.h requires merge resolution.

Please try the patch below. It's not a simple revert of 6902c0be, needed 
some manual tweaking.

diff --git a/drivers/input/gameport/gameport.c b/drivers/input/gameport/gameport.c
index ebf4be5..5f2e729 100644
--- a/drivers/input/gameport/gameport.c
+++ b/drivers/input/gameport/gameport.c
@@ -231,7 +231,6 @@ static void gameport_find_driver(struct gameport *gameport)
 enum gameport_event_type {
 	GAMEPORT_REGISTER_PORT,
 	GAMEPORT_REGISTER_DRIVER,
-	GAMEPORT_ATTACH_DRIVER,
 };
 
 struct gameport_event {
@@ -246,12 +245,11 @@ static LIST_HEAD(gameport_event_list);
 static DECLARE_WAIT_QUEUE_HEAD(gameport_wait);
 static struct task_struct *gameport_task;
 
-static int gameport_queue_event(void *object, struct module *owner,
-				enum gameport_event_type event_type)
+static void gameport_queue_event(void *object, struct module *owner,
+			      enum gameport_event_type event_type)
 {
 	unsigned long flags;
 	struct gameport_event *event;
-	int retval = 0;
 
 	spin_lock_irqsave(&gameport_event_lock, flags);
 
@@ -270,34 +268,24 @@ static int gameport_queue_event(void *object, struct module *owner,
 		}
 	}
 
-	event = kmalloc(sizeof(struct gameport_event), GFP_ATOMIC);
-	if (!event) {
-		printk(KERN_ERR
-			"gameport: Not enough memory to queue event %d\n",
-			event_type);
-		retval = -ENOMEM;
-		goto out;
-	}
-
-	if (!try_module_get(owner)) {
-		printk(KERN_WARNING
-			"gameport: Can't get module reference, dropping event %d\n",
-			event_type);
-		kfree(event);
-		retval = -EINVAL;
-		goto out;
-	}
-
-	event->type = event_type;
-	event->object = object;
-	event->owner = owner;
+	if ((event = kmalloc(sizeof(struct gameport_event), GFP_ATOMIC))) {
+		if (!try_module_get(owner)) {
+			printk(KERN_WARNING "gameport: Can't get module reference, dropping event %d\n", event_type);
+			kfree(event);
+			goto out;
+		}
 
-	list_add_tail(&event->node, &gameport_event_list);
-	wake_up(&gameport_wait);
+		event->type = event_type;
+		event->object = object;
+		event->owner = owner;
 
+		list_add_tail(&event->node, &gameport_event_list);
+		wake_up(&gameport_wait);
+	} else {
+		printk(KERN_ERR "gameport: Not enough memory to queue event %d\n", event_type);
+	}
 out:
 	spin_unlock_irqrestore(&gameport_event_lock, flags);
-	return retval;
 }
 
 static void gameport_free_event(struct gameport_event *event)
@@ -390,10 +378,9 @@ static void gameport_handle_event(void)
 }
 
 /*
- * Remove all events that have been submitted for a given object,
- * be it a gameport port or a driver.
+ * Remove all events that have been submitted for a given gameport port.
  */
-static void gameport_remove_pending_events(void *object)
+static void gameport_remove_pending_events(struct gameport *gameport)
 {
 	struct list_head *node, *next;
 	struct gameport_event *event;
@@ -403,7 +390,7 @@ static void gameport_remove_pending_events(void *object)
 
 	list_for_each_safe(node, next, &gameport_event_list) {
 		event = list_entry(node, struct gameport_event, node);
-		if (event->object == object) {
+		if (event->object == gameport) {
 			list_del_init(node);
 			gameport_free_event(event);
 		}
@@ -717,40 +704,10 @@ static void gameport_add_driver(struct gameport_driver *drv)
 			drv->driver.name, error);
 }
 
-int __gameport_register_driver(struct gameport_driver *drv, struct module *owner,
-				const char *mod_name)
+void __gameport_register_driver(struct gameport_driver *drv, struct module *owner)
 {
-	int error;
-
 	drv->driver.bus = &gameport_bus;
-	drv->driver.owner = owner;
-	drv->driver.mod_name = mod_name;
-
-	/*
-	 * Temporarily disable automatic binding because probing
-	 * takes long time and we are better off doing it in kgameportd
-	 */
-	drv->ignore = 1;
-
-	error = driver_register(&drv->driver);
-	if (error) {
-		printk(KERN_ERR
-			"gameport: driver_register() failed for %s, error: %d\n",
-			drv->driver.name, error);
-		return error;
-	}
-
-	/*
-	 * Reset ignore flag and let kgameportd bind the driver to free ports
-	 */
-	drv->ignore = 0;
-	error = gameport_queue_event(drv, NULL, GAMEPORT_ATTACH_DRIVER);
-	if (error) {
-		driver_unregister(&drv->driver);
-		return error;
-	}
-
-	return 0;
+	gameport_queue_event(drv, owner, GAMEPORT_REGISTER_DRIVER);
 }
 
 void gameport_unregister_driver(struct gameport_driver *drv)
@@ -758,9 +715,7 @@ void gameport_unregister_driver(struct gameport_driver *drv)
 	struct gameport *gameport;
 
 	mutex_lock(&gameport_mutex);
-
 	drv->ignore = 1;	/* so gameport_find_driver ignores it */
-	gameport_remove_pending_events(drv);
 
 start_over:
 	list_for_each_entry(gameport, &gameport_list, node) {
@@ -773,7 +728,6 @@ start_over:
 	}
 
 	driver_unregister(&drv->driver);
-
 	mutex_unlock(&gameport_mutex);
 }
 
diff --git a/drivers/input/joystick/a3d.c b/drivers/input/joystick/a3d.c
index 6489f40..92498d4 100644
--- a/drivers/input/joystick/a3d.c
+++ b/drivers/input/joystick/a3d.c
@@ -414,7 +414,8 @@ static struct gameport_driver a3d_drv = {
 
 static int __init a3d_init(void)
 {
-	return gameport_register_driver(&a3d_drv);
+	gameport_register_driver(&a3d_drv);
+	return 0;
 }
 
 static void __exit a3d_exit(void)
diff --git a/drivers/input/joystick/adi.c b/drivers/input/joystick/adi.c
index 89c4c08..d1ca8a1 100644
--- a/drivers/input/joystick/adi.c
+++ b/drivers/input/joystick/adi.c
@@ -572,7 +572,8 @@ static struct gameport_driver adi_drv = {
 
 static int __init adi_init(void)
 {
-	return gameport_register_driver(&adi_drv);
+	gameport_register_driver(&adi_drv);
+	return 0;
 }
 
 static void __exit adi_exit(void)
diff --git a/drivers/input/joystick/analog.c b/drivers/input/joystick/analog.c
index 356b3a2..708c5ae 100644
--- a/drivers/input/joystick/analog.c
+++ b/drivers/input/joystick/analog.c
@@ -761,7 +761,9 @@ static struct gameport_driver analog_drv = {
 static int __init analog_init(void)
 {
 	analog_parse_options();
-	return gameport_register_driver(&analog_drv);
+	gameport_register_driver(&analog_drv);
+
+	return 0;
 }
 
 static void __exit analog_exit(void)
diff --git a/drivers/input/joystick/cobra.c b/drivers/input/joystick/cobra.c
index 3497b87..639b975 100644
--- a/drivers/input/joystick/cobra.c
+++ b/drivers/input/joystick/cobra.c
@@ -263,7 +263,8 @@ static struct gameport_driver cobra_drv = {
 
 static int __init cobra_init(void)
 {
-	return gameport_register_driver(&cobra_drv);
+	gameport_register_driver(&cobra_drv);
+	return 0;
 }
 
 static void __exit cobra_exit(void)
diff --git a/drivers/input/joystick/gf2k.c b/drivers/input/joystick/gf2k.c
index 67c207f..cb6eef1 100644
--- a/drivers/input/joystick/gf2k.c
+++ b/drivers/input/joystick/gf2k.c
@@ -375,7 +375,8 @@ static struct gameport_driver gf2k_drv = {
 
 static int __init gf2k_init(void)
 {
-	return gameport_register_driver(&gf2k_drv);
+	gameport_register_driver(&gf2k_drv);
+	return 0;
 }
 
 static void __exit gf2k_exit(void)
diff --git a/drivers/input/joystick/grip.c b/drivers/input/joystick/grip.c
index fc55899..684e07c 100644
--- a/drivers/input/joystick/grip.c
+++ b/drivers/input/joystick/grip.c
@@ -426,7 +426,8 @@ static struct gameport_driver grip_drv = {
 
 static int __init grip_init(void)
 {
-	return gameport_register_driver(&grip_drv);
+	gameport_register_driver(&grip_drv);
+	return 0;
 }
 
 static void __exit grip_exit(void)
diff --git a/drivers/input/joystick/grip_mp.c b/drivers/input/joystick/grip_mp.c
index 2d47baf..8279481 100644
--- a/drivers/input/joystick/grip_mp.c
+++ b/drivers/input/joystick/grip_mp.c
@@ -689,7 +689,8 @@ static struct gameport_driver grip_drv = {
 
 static int __init grip_init(void)
 {
-	return gameport_register_driver(&grip_drv);
+	gameport_register_driver(&grip_drv);
+	return 0;
 }
 
 static void __exit grip_exit(void)
diff --git a/drivers/input/joystick/guillemot.c b/drivers/input/joystick/guillemot.c
index 4058d4b..25ec3fa 100644
--- a/drivers/input/joystick/guillemot.c
+++ b/drivers/input/joystick/guillemot.c
@@ -283,7 +283,8 @@ static struct gameport_driver guillemot_drv = {
 
 static int __init guillemot_init(void)
 {
-	return gameport_register_driver(&guillemot_drv);
+	gameport_register_driver(&guillemot_drv);
+	return 0;
 }
 
 static void __exit guillemot_exit(void)
diff --git a/drivers/input/joystick/interact.c b/drivers/input/joystick/interact.c
index 2478289..8c3290b 100644
--- a/drivers/input/joystick/interact.c
+++ b/drivers/input/joystick/interact.c
@@ -317,7 +317,8 @@ static struct gameport_driver interact_drv = {
 
 static int __init interact_init(void)
 {
-	return gameport_register_driver(&interact_drv);
+	gameport_register_driver(&interact_drv);
+	return 0;
 }
 
 static void __exit interact_exit(void)
diff --git a/drivers/input/joystick/joydump.c b/drivers/input/joystick/joydump.c
index cd894a0..2a1b82c 100644
--- a/drivers/input/joystick/joydump.c
+++ b/drivers/input/joystick/joydump.c
@@ -161,7 +161,8 @@ static struct gameport_driver joydump_drv = {
 
 static int __init joydump_init(void)
 {
-	return gameport_register_driver(&joydump_drv);
+	gameport_register_driver(&joydump_drv);
+	return 0;
 }
 
 static void __exit joydump_exit(void)
diff --git a/drivers/input/joystick/sidewinder.c b/drivers/input/joystick/sidewinder.c
index ca13a6b..7b4865f 100644
--- a/drivers/input/joystick/sidewinder.c
+++ b/drivers/input/joystick/sidewinder.c
@@ -818,7 +818,8 @@ static struct gameport_driver sw_drv = {
 
 static int __init sw_init(void)
 {
-	return gameport_register_driver(&sw_drv);
+	gameport_register_driver(&sw_drv);
+	return 0;
 }
 
 static void __exit sw_exit(void)
diff --git a/drivers/input/joystick/tmdc.c b/drivers/input/joystick/tmdc.c
index d6c6098..60c37bc 100644
--- a/drivers/input/joystick/tmdc.c
+++ b/drivers/input/joystick/tmdc.c
@@ -438,7 +438,8 @@ static struct gameport_driver tmdc_drv = {
 
 static int __init tmdc_init(void)
 {
-	return gameport_register_driver(&tmdc_drv);
+	gameport_register_driver(&tmdc_drv);
+	return 0;
 }
 
 static void __exit tmdc_exit(void)
diff --git a/include/linux/gameport.h b/include/linux/gameport.h
index 0cd825f..f64e29c 100644
--- a/include/linux/gameport.h
+++ b/include/linux/gameport.h
@@ -146,11 +146,10 @@ static inline void gameport_unpin_driver(struct gameport *gameport)
 	mutex_unlock(&gameport->drv_mutex);
 }
 
-int __gameport_register_driver(struct gameport_driver *drv,
-				struct module *owner, const char *mod_name);
-static inline int __must_check gameport_register_driver(struct gameport_driver *drv)
+void __gameport_register_driver(struct gameport_driver *drv, struct module *owner);
+static inline void gameport_register_driver(struct gameport_driver *drv)
 {
-	return __gameport_register_driver(drv, THIS_MODULE, KBUILD_MODNAME);
+	__gameport_register_driver(drv, THIS_MODULE);
 }
 
 void gameport_unregister_driver(struct gameport_driver *drv);
