Return-Path: <linux-kernel-owner+w=401wt.eu-S1764098AbXHQB0b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764098AbXHQB0b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2007 21:26:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756279AbXHQB0X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Aug 2007 21:26:23 -0400
Received: from ozlabs.org ([203.10.76.45]:41023 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755789AbXHQB0V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2007 21:26:21 -0400
Subject: [PATCH] Only initialize hvc_console if needed, cleanup Kconfig help
From: Rusty Russell <rusty@rustcorp.com.au>
To: Dave Jones <davej@redhat.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Paul Mackerras <paulus@samba.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Anton Blanchard <anton@samba.org>, "Ryan S. Arnold" <rsa@us.ibm.com>
In-Reply-To: <20070816201649.GA5375@redhat.com>
References: <20070816201649.GA5375@redhat.com>
Content-Type: text/plain
Date: Fri, 17 Aug 2007 11:25:46 +1000
Message-Id: <1187313946.6449.68.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-08-16 at 16:16 -0400, Dave Jones wrote:
> asides from the needed Kconfig clarification, is it necessary for khvcd
> to run at all if the lguest module hasn't been loaded ?  Is it possible
> we can somehow delay creation of the kthread ?

It's for lguest guests, so it kind of needs to be built-in.  But yes, it
should be made to suck less.  Xen will want it too.

How's this?
==
This changes hvc_init() to be called only when someone actually uses
the hvc_console driver.

hvc_console used to only be for Power aka pSeries: now lguest and Xen
both want it built-in in case the kernel is a guest under one of
those, even though usually it will be a native boot.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

diff -r 0730da2377be drivers/char/Kconfig
--- a/drivers/char/Kconfig	Tue Aug 14 12:46:08 2007 +1000
+++ b/drivers/char/Kconfig	Fri Aug 17 09:05:12 2007 +1000
@@ -568,10 +568,10 @@ config HVC_DRIVER
 config HVC_DRIVER
 	bool
 	help
-	  Users of pSeries machines that want to utilize the hvc console front-end
-	  module for their backend console driver should select this option.
-	  It will automatically be selected if one of the back-end console drivers
-	  is selected.
+	  Generic "hypervisor virtual console" infrastructure for various
+	  hypervisors (pSeries, Xen, lguest).
+	  It will automatically be selected if one of those back-end
+	  console drivers is selected.
 
 
 config HVC_CONSOLE
diff -r 0730da2377be drivers/char/hvc_console.c
--- a/drivers/char/hvc_console.c	Tue Aug 14 12:46:08 2007 +1000
+++ b/drivers/char/hvc_console.c	Fri Aug 17 09:15:24 2007 +1000
@@ -68,6 +68,8 @@ static struct task_struct *hvc_task;
 
 /* Picks up late kicks after list walk but before schedule() */
 static int hvc_kicked;
+
+static int hvc_init(void);
 
 #ifdef CONFIG_MAGIC_SYSRQ
 static int sysrq_pressed;
@@ -754,6 +756,13 @@ struct hvc_struct __devinit *hvc_alloc(u
 	struct hvc_struct *hp;
 	int i;
 
+	/* We wait until a driver actually comes along */
+	if (!hvc_driver) {
+		int err = hvc_init();
+		if (err)
+			return ERR_PTR(err);
+	}
+
 	hp = kmalloc(ALIGN(sizeof(*hp), sizeof(long)) + outbuf_size,
 			GFP_KERNEL);
 	if (!hp)
@@ -829,16 +838,18 @@ int __devexit hvc_remove(struct hvc_stru
 	return 0;
 }
 
-/* Driver initialization.  Follow console initialization.  This is where the TTY
- * interfaces start to become available. */
-static int __init hvc_init(void)
+/* Driver initialization: called as soon as someone uses hvc_alloc(). */
+static int hvc_init(void)
 {
 	struct tty_driver *drv;
+	int err;
 
 	/* We need more than hvc_count adapters due to hotplug additions. */
 	drv = alloc_tty_driver(HVC_ALLOC_TTY_ADAPTERS);
-	if (!drv)
-		return -ENOMEM;
+	if (!drv) {
+		err = -ENOMEM;
+		goto out;
+	}
 
 	drv->owner = THIS_MODULE;
 	drv->driver_name = "hvc";
@@ -854,30 +865,43 @@ static int __init hvc_init(void)
 	 * added later. */
 	hvc_task = kthread_run(khvcd, NULL, "khvcd");
 	if (IS_ERR(hvc_task)) {
-		panic("Couldn't create kthread for console.\n");
-		put_tty_driver(drv);
-		return -EIO;
-	}
-
-	if (tty_register_driver(drv))
-		panic("Couldn't register hvc console driver\n");
-
+		printk(KERN_ERR "Couldn't create kthread for console.\n");
+		err = PTR_ERR(hvc_task);
+		goto put_tty;
+	}
+
+	err = tty_register_driver(drv);
+	if (err) {
+		printk(KERN_ERR "Couldn't register hvc console driver\n");
+		goto stop_thread;
+	}
+
+	/* FIXME: This mb() seems completely random.  Remove it. */
 	mb();
 	hvc_driver = drv;
 	return 0;
-}
-module_init(hvc_init);
+
+put_tty:
+	put_tty_driver(hvc_driver);
+stop_thread:
+	kthread_stop(hvc_task);
+	hvc_task = NULL;
+out:
+	return err;
+}
 
 /* This isn't particularly necessary due to this being a console driver
  * but it is nice to be thorough.
  */
 static void __exit hvc_exit(void)
 {
-	kthread_stop(hvc_task);
-
-	tty_unregister_driver(hvc_driver);
-	/* return tty_struct instances allocated in hvc_init(). */
-	put_tty_driver(hvc_driver);
-	unregister_console(&hvc_con_driver);
+	if (hvc_driver) {
+		kthread_stop(hvc_task);
+
+		tty_unregister_driver(hvc_driver);
+		/* return tty_struct instances allocated in hvc_init(). */
+		put_tty_driver(hvc_driver);
+		unregister_console(&hvc_con_driver);
+	}
 }
 module_exit(hvc_exit);






