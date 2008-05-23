Return-Path: <linux-kernel-owner+w=401wt.eu-S1758476AbYEWNrj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758476AbYEWNrj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 09:47:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755220AbYEWNoZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 09:44:25 -0400
Received: from gw.goop.org ([64.81.55.164]:53251 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753733AbYEWNoU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 09:44:20 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 08 of 12] xen-console: add save/restore
X-Mercurial-Node: d9561e802a69a3ca269c45ba9c670250badf798f
Message-Id: <d9561e802a69a3ca269c.1211550075@localhost>
In-Reply-To: <patchbomb.1211550067@localhost>
Date: Fri, 23 May 2008 14:41:15 +0100
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       xen-devel <xen-devel@lists.xensource.com>,
       Thomas Gleixner <tglx@linutronix.de>, "Rafael J. Wysocki" <rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add code to:

 1. Deal with the console page being canonicalized.  During save, the
    console's mfn in the start_info structure is canonicalized to a pfn.
    In order to deal with that, we always use a copy of the pfn and
    indirect off that all the time.  However, we fall back to using the
    mfn if the pfn hasn't been initialized yet.

 2. Restore the console event channel, and rebind it to the existing irq.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 drivers/char/hvc_xen.c    |   25 +++++++++++++++++++++----
 include/xen/hvc-console.h |    2 ++
 2 files changed, 23 insertions(+), 4 deletions(-)

diff --git a/drivers/char/hvc_xen.c b/drivers/char/hvc_xen.c
--- a/drivers/char/hvc_xen.c
+++ b/drivers/char/hvc_xen.c
@@ -39,9 +39,14 @@
 
 /* ------------------------------------------------------------------ */
 
+static unsigned long console_pfn = ~0ul;
+
 static inline struct xencons_interface *xencons_interface(void)
 {
-	return mfn_to_virt(xen_start_info->console.domU.mfn);
+	if (console_pfn == ~0ul)
+		return mfn_to_virt(xen_start_info->console.domU.mfn);
+	else
+		return __va(console_pfn << PAGE_SHIFT);
 }
 
 static inline void notify_daemon(void)
@@ -101,18 +106,30 @@
 {
 	struct hvc_struct *hp;
 
-	if (!is_running_on_xen())
-		return 0;
+	if (!is_running_on_xen() ||
+	    is_initial_xendomain() ||
+	    !xen_start_info->console.domU.evtchn)
+		return -ENODEV;
 
 	xencons_irq = bind_evtchn_to_irq(xen_start_info->console.domU.evtchn);
 	if (xencons_irq < 0)
-		xencons_irq = 0 /* NO_IRQ */;
+		xencons_irq = 0; /* NO_IRQ */
+
 	hp = hvc_alloc(HVC_COOKIE, xencons_irq, &hvc_ops, 256);
 	if (IS_ERR(hp))
 		return PTR_ERR(hp);
 
 	hvc = hp;
+
+	console_pfn = mfn_to_pfn(xen_start_info->console.domU.mfn);
+
 	return 0;
+}
+
+void xen_console_resume(void)
+{
+	if (xencons_irq)
+		rebind_evtchn_irq(xen_start_info->console.domU.evtchn, xencons_irq);
 }
 
 static void __exit xen_fini(void)
diff --git a/include/xen/hvc-console.h b/include/xen/hvc-console.h
--- a/include/xen/hvc-console.h
+++ b/include/xen/hvc-console.h
@@ -3,6 +3,8 @@
 
 extern struct console xenboot_console;
 
+void xen_console_resume(void);
+
 void xen_raw_console_write(const char *str);
 void xen_raw_printk(const char *fmt, ...);
 


