Return-Path: <linux-kernel-owner+w=401wt.eu-S1757567AbYH3Cs6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757567AbYH3Cs6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 22:48:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753540AbYH3Css
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 22:48:48 -0400
Received: from netrider.rowland.org ([192.131.102.5]:2670 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752755AbYH3Csr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 22:48:47 -0400
Date: Fri, 29 Aug 2008 22:48:46 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Frans Pop <elendil@planet.nl>
cc: Kernel development list <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>
Subject: Re: [regression] usb: sometimes dead keyboard after boot (was: new
 errors during device detection)
In-Reply-To: <Pine.LNX.4.44L0.0808291209260.4447-100000@netrider.rowland.org>
Message-ID: <Pine.LNX.4.44L0.0808292246520.17486-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 29 Aug 2008, Alan Stern wrote:

> > Does this sound at all logical and feasible?
> 
> The first proposal is feasible; I can write a patch to implement it.  
> How much it will end up helping anything isn't clear, though.

Here's the promised patch.  Be warned, I haven't tested it at all.

Alan Stern


Index: usb-2.6/drivers/usb/core/hcd.h
===================================================================
--- usb-2.6.orig/drivers/usb/core/hcd.h
+++ usb-2.6/drivers/usb/core/hcd.h
@@ -486,4 +486,7 @@ static inline void usbmon_urb_complete(s
  */
 extern struct rw_semaphore ehci_cf_port_reset_rwsem;
 
+/* This is also for use by khubd and ehci-hcd. */
+extern void usb_wait_for_khubd_idle(void);
+
 #endif /* __KERNEL__ */
Index: usb-2.6/drivers/usb/core/hub.c
===================================================================
--- usb-2.6.orig/drivers/usb/core/hub.c
+++ usb-2.6/drivers/usb/core/hub.c
@@ -3097,6 +3097,16 @@ loop:
         } /* end while (1) */
 }
 
+/* Let ehci-hcd know when khubd is idle */
+static int khubd_active;
+static DECLARE_WAIT_QUEUE_HEAD(khubd_wqh);
+
+void usb_wait_for_khubd_idle(void)
+{
+	wait_event(khubd_wqh, !khubd_active);
+}
+EXPORT_SYMBOL_GPL(usb_wait_for_khubd_idle);
+
 static int hub_thread(void *__unused)
 {
 	/* khubd needs to be freezable to avoid intefering with USB-PERSIST
@@ -3107,7 +3117,11 @@ static int hub_thread(void *__unused)
 	set_freezable();
 
 	do {
+		khubd_active = 1;
 		hub_events();
+		khubd_active = 0;
+		wake_up_all(&khubd_wqh);
+
 		wait_event_freezable(khubd_wait,
 				!list_empty(&hub_event_list) ||
 				kthread_should_stop());
Index: usb-2.6/drivers/usb/host/ehci-hcd.c
===================================================================
--- usb-2.6.orig/drivers/usb/host/ehci-hcd.c
+++ usb-2.6/drivers/usb/host/ehci-hcd.c
@@ -604,7 +604,13 @@ static int ehci_run (struct usb_hcd *hcd
 	 * guarantees that no resets are in progress.  After we set CF,
 	 * a short delay lets the hardware catch up; new resets shouldn't
 	 * be started before the port switching actions could complete.
+	 *
+	 * In an attempt to avoid unwanted initialization error messages
+	 * for devices attached to companion controllers, we will wait
+	 * until khubd is idle before beginning.  This isn't truly a
+	 * general solution but it should help during system bootup.
 	 */
+	usb_wait_for_khubd_idle();
 	down_write(&ehci_cf_port_reset_rwsem);
 	hcd->state = HC_STATE_RUNNING;
 	ehci_writel(ehci, FLAG_CF, &ehci->regs->configured_flag);

