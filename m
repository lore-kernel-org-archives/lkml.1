Return-Path: <linux-kernel-owner+w=401wt.eu-S935121AbXEWRAv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935121AbXEWRAv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 13:00:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759042AbXEWRAl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 13:00:41 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:49438 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1762742AbXEWRAk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 13:00:40 -0400
Date: Wed, 23 May 2007 13:00:38 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Andrew Morton <akpm@linux-foundation.org>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Pavel Machek <pavel@ucw.cz>,
       USB development list <linux-usb-devel@lists.sourceforge.net>,
       Oleg Nesterov <oleg@tv-sign.ru>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.22-rc2-mm1
In-Reply-To: <20070523085424.2aa27c57.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.44L0.0705231249570.3673-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 May 2007, Andrew Morton wrote:

> > > > This is intermittently getting resume-from-RAM failures.  It is not
> > > > sufficiently repeatable to be able to bisect.
> > > > 
> > > > [ 1381.119362] PM: Preparing system for mem sleep
> > > > [ 2331.798452] Stopping tasks ... 
> > > > [ 2351.760431] Stopping kernel threads timed out after 20 seconds (2 tasks refusing to freeze):
> > > > [ 2351.762385]  ksuspend_usbd
> > > > [ 2351.764374]  khubd
> > > > [ 2351.766338] Restarting tasks ... done.
> > > 
> > > Hmm, that seems to be related to usb-fix-suspend-to-ram.patch (probably one of
> > > the threads is waiting for a completion by some other thread that has been
> > > frozen already).
> > 
> > Is it possible to get an Alt-SysRq-T stack trace during those 20 
> > seconds?  Knowing what those threads are waiting for would be a big 
> > help.

> The trace is at http://userweb.kernel.org/~akpm/tasks.txt.  Interesting
> bits are
> 
> [  144.201264] khubd         D 00400005     0   160      2 (L-TLB)
> [  144.204358]        c207fe78 00000046 90399a85 00400005 00000246 c207fe60 c25b0cc4 c206f4cc 
> [  144.204539]        00000286 00000000 769e4cea 0040000a 90399a85 00400005 c32713c0 c207fed4 
> [  144.207754]        00000001 c207fe94 c207febc c02e8e1b 00000000 00000000 00000000 00000000 
> [  144.210934] Call Trace:
> [  144.217012]  [<c02e8e1b>] wait_for_completion+0x68/0x91
> [  144.220090]  [<c011824f>] default_wake_function+0x0/0x9
> [  144.223158]  [<c0127a41>] flush_cpu_workqueue+0x4d/0x55
> [  144.226223]  [<c0127a69>] wq_barrier_func+0x0/0x8
> [  144.229269]  [<c026343d>] usb_release_dev+0x28/0x63
> [  144.232340]  [<c0233011>] device_release+0x37/0x7c
> [  144.235431]  [<c01cb6c7>] kobject_cleanup+0x3d/0x54
> [  144.238520]  [<c01cb6de>] kobject_release+0x0/0x8
> [  144.241631]  [<c01cc2a7>] kref_put+0x75/0x82
> [  144.244699]  [<c0265482>] hub_thread+0x376/0xa74
> [  144.247768]  [<c01180c2>] pick_next_task_fair+0xf2/0x12a
> [  144.250815]  [<c0116af1>] __wake_up_common+0x31/0x4f
> [  144.253864]  [<c012a259>] autoremove_wake_function+0x0/0x35
> [  144.256902]  [<c026510c>] hub_thread+0x0/0xa74
> [  144.259944]  [<c012a102>] kthread+0x36/0x5c
> [  144.262891]  [<c012a0cc>] kthread+0x0/0x5c
> [  144.265757]  [<c010464b>] kernel_thread_helper+0x7/0x10
> [  144.268716]  =======================
> 
> 
> [  144.137704] ksuspend_usbd D 00400005     0   157      2 (L-TLB)
> [  144.140830]        c2085f18 00000046 9072767a 00400005 c20626f0 c010449b c3182118 c206288c 
> [  144.141011]        c3182120 c3182120 76d728df 0040000a 9072767a 00400005 c3271200 c3182118 
> [  144.144263]        c3182120 00000246 c20626f0 c02ea1c9 00000000 00000000 00000000 00000000 
> [  144.147576] Call Trace:
> [  144.153929]  [<c010449b>] common_interrupt+0x23/0x28
> [  144.157245]  [<c02ea1c9>] __down+0xba/0xc6
> [  144.160528]  [<c011824f>] default_wake_function+0x0/0x9
> [  144.163832]  [<c02664fc>] hcd_resume_work+0x0/0x43
> [  144.167126]  [<c02e9fd3>] __down_failed+0x7/0xc
> [  144.170372]  [<c0266518>] hcd_resume_work+0x1c/0x43
> [  144.173603]  [<c01278cf>] run_workqueue+0x6d/0xdf
> [  144.176780]  [<c0127b4c>] worker_thread+0x0/0xd0
> [  144.179885]  [<c0127b4c>] worker_thread+0x0/0xd0
> [  144.182930]  [<c0127c12>] worker_thread+0xc6/0xd0
> [  144.185964]  [<c012a259>] autoremove_wake_function+0x0/0x35
> [  144.189056]  [<c012a102>] kthread+0x36/0x5c
> [  144.192118]  [<c012a0cc>] kthread+0x0/0x5c
> [  144.195153]  [<c010464b>] kernel_thread_helper+0x7/0x10


Okay, it's clear that the two threads are in deadlock.  It's not clear 
how the deadlock arose to begin with -- apparently there was a remote 
wakeup request for a root hub at the same time as a device below that 
root hub was disconnected, which doesn't make much sense.

Anyway, this looks like a good place to use cancel_work_sync().  The 
patch below is highly untested, so Andrew, you're the guinea pig.  :-)
If it seems to help, I'll submit it with a proper Changelog entry.

Alan Stern


Index: usb-2.6/drivers/usb/core/hub.c
===================================================================
--- usb-2.6.orig/drivers/usb/core/hub.c
+++ usb-2.6/drivers/usb/core/hub.c
@@ -1294,6 +1294,7 @@ void usb_disconnect(struct usb_device **
 	*pdev = NULL;
 	spin_unlock_irq(&device_state_lock);
 
+#ifdef	CONFIG_USB_SUSPEND
 	/* Synchronize with the ksuspend thread to prevent any more
 	 * autosuspend requests from being submitted, and decrement
 	 * the parent's count of unsuspended children.
@@ -1303,6 +1304,10 @@ void usb_disconnect(struct usb_device **
 		usb_autosuspend_device(udev->parent);
 	usb_pm_unlock(udev);
 
+	cancel_delayed_work(&udev->autosuspend);
+	cancel_work_sync(&udev->autosuspend.work);
+#endif
+
 	put_device(&udev->dev);
 }
 
Index: usb-2.6/drivers/usb/core/usb.c
===================================================================
--- usb-2.6.orig/drivers/usb/core/usb.c
+++ usb-2.6/drivers/usb/core/usb.c
@@ -184,10 +184,6 @@ static void usb_release_dev(struct devic
 
 	udev = to_usb_device(dev);
 
-#ifdef	CONFIG_USB_SUSPEND
-	cancel_delayed_work(&udev->autosuspend);
-	flush_workqueue(ksuspend_usb_wq);
-#endif
 	usb_destroy_configuration(udev);
 	usb_put_hcd(bus_to_hcd(udev->bus));
 	kfree(udev->product);

