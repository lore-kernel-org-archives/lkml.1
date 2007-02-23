Return-Path: <linux-kernel-owner+w=401wt.eu-S933272AbXBWXSV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933272AbXBWXSV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Feb 2007 18:18:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933283AbXBWXRv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Feb 2007 18:17:51 -0500
Received: from cantor2.suse.de ([195.135.220.15]:35261 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933272AbXBWXRk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Feb 2007 18:17:40 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 6/9] power management: fix struct layout and docs
Date: Fri, 23 Feb 2007 15:15:53 -0800
Message-Id: <11722725722238-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.0.1
In-Reply-To: <1172272569255-git-send-email-gregkh@suse.de>
References: <20070223231426.GA20498@kroah.com> <11722725561867-git-send-email-gregkh@suse.de> <11722725592291-git-send-email-gregkh@suse.de> <11722725623183-git-send-email-gregkh@suse.de> <1172272565581-git-send-email-gregkh@suse.de> <1172272569255-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Johannes Berg <johannes@sipsolutions.net>

Because the pm ops in powermac are obviously not using them as intended, I
added documentation for it in kernel-doc format.

Reordering the fields in struct pm_ops not only makes the output of kernel-doc
make more sense but also removes a hole from the structure on 64-bit
platforms.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Cc: "Randy.Dunlap" <rdunlap@xenotime.net>
Cc: Rafael J. Wysocki <rjw@sisk.pl>
Cc: Pavel Macheck <pavel@ucw.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 include/linux/pm.h |   37 +++++++++++++++++++++++++++++++++++--
 1 files changed, 35 insertions(+), 2 deletions(-)

diff --git a/include/linux/pm.h b/include/linux/pm.h
index 070394e..21db05a 100644
--- a/include/linux/pm.h
+++ b/include/linux/pm.h
@@ -120,15 +120,48 @@ typedef int __bitwise suspend_disk_method_t;
 #define	PM_DISK_TESTPROC	((__force suspend_disk_method_t) 6)
 #define	PM_DISK_MAX		((__force suspend_disk_method_t) 7)
 
+/**
+ * struct pm_ops - Callbacks for managing platform dependent suspend states.
+ * @valid: Callback to determine whether the given state can be entered.
+ * 	If %CONFIG_SOFTWARE_SUSPEND is set then %PM_SUSPEND_DISK is
+ *	always valid and never passed to this call.
+ *	If not assigned, all suspend states are advertised as valid
+ *	in /sys/power/state (but can still be rejected by prepare or enter.)
+ *
+ * @prepare: Prepare the platform for the given suspend state. Can return a
+ *	negative error code if necessary.
+ *
+ * @enter: Enter the given suspend state, must be assigned. Can return a
+ *	negative error code if necessary.
+ *
+ * @finish: Called when the system has left the given state and all devices
+ *	are resumed. The return value is ignored.
+ *
+ * @pm_disk_mode: Set to the disk method that the user should be able to
+ *	configure for suspend-to-disk. Since %PM_DISK_SHUTDOWN,
+ *	%PM_DISK_REBOOT, %PM_DISK_TEST and %PM_DISK_TESTPROC
+ *	are always allowed, currently only %PM_DISK_PLATFORM
+ *	makes sense. If the user then choses %PM_DISK_PLATFORM,
+ *	the @prepare call will be called before suspending to disk
+ *	(if present), the @enter call should be present and will
+ *	be called after all state has been saved and the machine
+ *	is ready to be shut down/suspended/..., and the @finish
+ *	callback is called after state has been restored. All
+ *	these calls are called with %PM_SUSPEND_DISK as the state.
+ */
 struct pm_ops {
-	suspend_disk_method_t pm_disk_mode;
 	int (*valid)(suspend_state_t state);
 	int (*prepare)(suspend_state_t state);
 	int (*enter)(suspend_state_t state);
 	int (*finish)(suspend_state_t state);
+	suspend_disk_method_t pm_disk_mode;
 };
 
-extern void pm_set_ops(struct pm_ops *);
+/**
+ * pm_set_ops - set platform dependent power management ops
+ * @pm_ops: The new power management operations to set.
+ */
+extern void pm_set_ops(struct pm_ops *pm_ops);
 extern struct pm_ops *pm_ops;
 extern int pm_suspend(suspend_state_t state);
 
-- 
1.5.0.1

