Return-Path: <linux-kernel-owner+w=401wt.eu-S935714AbZLQE2Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935714AbZLQE2Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 23:28:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936477AbZLQE1k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 23:27:40 -0500
Received: from kroah.org ([198.145.64.141]:55733 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935328AbZLQEEx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 23:04:53 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Wed Dec 16 19:56:55 2009
Message-Id: <20091217035654.875765876@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 16 Dec 2009 19:56:29 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Ian Campbell <Ian.Campbell@citrix.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [092/151] xen: call clock resume notifier on all CPUs
In-Reply-To: <20091217040208.GA26571@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Ian Campbell <Ian.Campbell@citrix.com>

commit f6eafe3665bcc374c66775d58312d1c06c55303f upstream.

tick_resume() is never called on secondary processors. Presumably this
is because they are offlined for suspend on native and so this is
normally taken care of in the CPU onlining path. Under Xen we keep all
CPUs online over a suspend.

This patch papers over the issue for me but I will investigate a more
generic, less hacky, way of doing to the same.

tick_suspend is also only called on the boot CPU which I presume should
be fixed too.

Signed-off-by: Ian Campbell <Ian.Campbell@citrix.com>
Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/xen/suspend.c |   15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

--- a/arch/x86/xen/suspend.c
+++ b/arch/x86/xen/suspend.c
@@ -1,4 +1,5 @@
 #include <linux/types.h>
+#include <linux/clockchips.h>
 
 #include <xen/interface/xen.h>
 #include <xen/grant_table.h>
@@ -46,7 +47,19 @@ void xen_post_suspend(int suspend_cancel
 
 }
 
+static void xen_vcpu_notify_restore(void *data)
+{
+	unsigned long reason = (unsigned long)data;
+
+	/* Boot processor notified via generic timekeeping_resume() */
+	if ( smp_processor_id() == 0)
+		return;
+
+	clockevents_notify(reason, NULL);
+}
+
 void xen_arch_resume(void)
 {
-	/* nothing */
+	smp_call_function(xen_vcpu_notify_restore,
+			       (void *)CLOCK_EVT_NOTIFY_RESUME, 1);
 }


