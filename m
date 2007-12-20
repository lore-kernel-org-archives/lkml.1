Return-Path: <linux-kernel-owner+w=401wt.eu-S1763353AbXLTQ4y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763353AbXLTQ4y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 11:56:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754975AbXLTQ4n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 11:56:43 -0500
Received: from vervifontaine.sonytel.be ([80.88.33.193]:44796 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755056AbXLTQ4m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 11:56:42 -0500
Date: Thu, 20 Dec 2007 17:56:35 +0100 (CET)
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: Linux/PPC Development <linuxppc-dev@ozlabs.org>
cc: Linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: [patch/rfc 3/7] ps3: Use the HVs storage device notification
 mechanism properly
In-Reply-To: <20071128143438.302492000@pademelon.sonytel.be>
Message-ID: <Pine.LNX.4.62.0712201752330.26998@pademelon.sonytel.be>
References: <20071128143142.580732000@pademelon.sonytel.be>
 <20071128143438.302492000@pademelon.sonytel.be>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-584337861-455048145-1198169558=:26998"
Content-ID: <Pine.LNX.4.62.0712201752410.26998@pademelon.sonytel.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---584337861-455048145-1198169558=:26998
Content-Type: TEXT/PLAIN; CHARSET=UTF-8
Content-Transfer-Encoding: 8BIT
Content-ID: <Pine.LNX.4.62.0712201752411.26998@pademelon.sonytel.be>

On Wed, 28 Nov 2007, Geert Uytterhoeven wrote:
> From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
> 
> ps3: Use the HV's storage device notification mechanism properly
> 
> The hypervisor has a storage device notification mechanism to wait until a
> storage device is ready. Unfortunately the storage device probing code used
> this mechanism in an incorrect way, needing a polling loop and handling of
> devices that are not yet ready.
> 
> This change corrects this by:
>   - First waiting for the reception of an asynchronous notification that a new
>     storage device became ready,
>   - Then looking up the storage device in the device repository.

The PS3 storage probe thread left the storage notification device open on
shutdown, so the device open would fail with LV1_BUSY when the second stage
kexec kernel tried to open the device.

To fix this:
  - Replace the call to wait_for_completion_interruptible() by a call to
    wait_event_interruptible() that also checks kthread_should_stop(),
  - Install a reboot notifier that stops the storage probe thread on shutdown.

---
Question: Does there exist a better way to achieve this?

To do: ps3_probe_thread() may still exit prematurely in case of an error,
       causing the call to kthread_stop() to hang on shutdown later.
       The setup code in ps3_probe_thread() can easily be moved outside the
       kthread, but what to do in case of an error in the do/while loop? Just
       sleep until woken up by kthread_stop()?

 arch/powerpc/platforms/ps3/device-init.c |   29 +++++++++++++++++++++++++++--
 1 files changed, 27 insertions(+), 2 deletions(-)

--- a/arch/powerpc/platforms/ps3/device-init.c
+++ b/arch/powerpc/platforms/ps3/device-init.c
@@ -23,6 +23,7 @@
 #include <linux/kernel.h>
 #include <linux/kthread.h>
 #include <linux/init.h>
+#include <linux/reboot.h>
 
 #include <asm/firmware.h>
 #include <asm/lv1call.h>
@@ -565,8 +566,9 @@ static int ps3_notification_read_write(s
 	}
 	pr_debug("%s:%u: notification %s issued\n", __func__, __LINE__, op);
 
-	res = wait_for_completion_interruptible(&dev->done);
-	if (res) {
+	res = wait_event_interruptible(dev->done.wait,
+				       dev->done.done || kthread_should_stop());
+	if (res || kthread_should_stop()) {
 		pr_debug("%s:%u: interrupted %s\n", __func__, __LINE__, op);
 		return res;
 	}
@@ -707,6 +709,26 @@ fail_free:
 }
 
 /**
+ * ps3_stop_probe_thread - Stops the background probe thread.
+ *
+ */
+
+static struct task_struct *probe_task;
+
+static int ps3_stop_probe_thread(struct notifier_block *nb, unsigned long code,
+				 void *data)
+{
+	if (probe_task)
+		kthread_stop(probe_task);
+	return 0;
+}
+
+static struct notifier_block nb = {
+	.notifier_call = ps3_stop_probe_thread
+};
+
+
+/**
  * ps3_start_probe_thread - Starts the background probe thread.
  *
  */
@@ -748,6 +770,9 @@ static int __init ps3_start_probe_thread
 		return result;
 	}
 
+	probe_task = task;
+	register_reboot_notifier(&nb);
+
 	pr_debug(" <- %s:%d\n", __func__, __LINE__);
 	return 0;
 }

With kind regards,
 
Geert Uytterhoeven
Software Architect

Sony Network and Software Technology Center Europe
The Corporate Village · Da Vincilaan 7-D1 · B-1935 Zaventem · Belgium
 
Phone:    +32 (0)2 700 8453	
Fax:      +32 (0)2 700 8622	
E-mail:   Geert.Uytterhoeven@sonycom.com	
Internet: http://www.sony-europe.com/
 	
Sony Network and Software Technology Center Europe	
A division of Sony Service Centre (Europe) N.V.	
Registered office: Technologielaan 7 · B-1840 Londerzeel · Belgium	
VAT BE 0413.825.160 · RPR Brussels	
Fortis Bank Zaventem · Swift GEBABEBB08A · IBAN BE39001382358619
---584337861-455048145-1198169558=:26998--
