Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030796Ab0B0U2O (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Feb 2010 15:28:14 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:55610 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030784Ab0B0U2N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Feb 2010 15:28:13 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: pm list <linux-pm@lists.linux-foundation.org>
Subject: [PATCH] PM / Runtime: Document power.runtime_auto and related functions
Date: Sat, 27 Feb 2010 21:30:38 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.33-git-rjw; KDE/4.3.5; x86_64; ; )
Cc: Alan Stern <stern@rowland.harvard.edu>,
       LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201002272130.38639.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

The power.runtime_auto device flag and the helper functions
pm_runtime_allow() and pm_runtime_forbid() used to modify it are a
part of the run-time power management framework and therefore they
should be described in Documentation/power/runtime_pm.txt.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 Documentation/power/runtime_pm.txt |   28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

Index: linux-2.6/Documentation/power/runtime_pm.txt
===================================================================
--- linux-2.6.orig/Documentation/power/runtime_pm.txt
+++ linux-2.6/Documentation/power/runtime_pm.txt
@@ -224,6 +224,12 @@ defined in include/linux/pm.h:
       RPM_SUSPENDED, which means that each device is initially regarded by the
       PM core as 'suspended', regardless of its real hardware status
 
+  unsigned int runtime_auto;
+    - if set, indicates that the user space has allowed the device driver to
+      power manage the device at run time via the /sys/devices/.../power/control
+      interface; it may only be modified with the help of the pm_runtime_allow()
+      and pm_runtime_forbid() helper functions
+
 All of the above fields are members of the 'power' member of 'struct device'.
 
 4. Run-time PM Device Helper Functions
@@ -329,6 +335,16 @@ drivers/base/power/runtime.c and include
       'power.runtime_error' is set or 'power.disable_depth' is greater than
       zero)
 
+  void pm_runtime_allow(struct device *dev);
+    - set the power.runtime_auto flag for the device and decrease its usage
+      counter (used by the /sys/devices/.../power/control interface to
+      effectively allow the device to be power managed at run time)
+
+  void pm_runtime_forbid(struct device *dev);
+    - unset the power.runtime_auto flag for the device and increase its usage
+      counter (used by the /sys/devices/.../power/control interface to
+      effectively prevent the device from being power managed at run time)
+
 It is safe to execute the following helper functions from interrupt context:
 
 pm_request_idle()
@@ -382,6 +398,18 @@ may be desirable to suspend the device a
 finished, so the PM core uses pm_runtime_idle_sync() to invoke the
 subsystem-level idle callback for the device at that time.
 
+The user space can effectively disallow the driver of the device to power manage
+it at run time by changing the value of its /sys/devices/.../power/control
+attribute to "on", which causes pm_runtime_forbid() to be called.  In principle,
+this mechanism may also be used by the driver to effectively turn off the
+run-time power management of the device until the user space turns it on.
+Namely, during the initialization the driver can make sure that the run-time PM
+status of the device is 'active' and call pm_runtime_forbid().  It should be
+noted, however, that if the user space has already intentionally changed the
+value of /sys/devices/.../power/control to "auto" to allow the driver to power
+manage the device at run time, the driver may confuse it by using
+pm_runtime_forbid() this way.
+
 6. Run-time PM and System Sleep
 
 Run-time PM and system sleep (i.e., system suspend and hibernation, also known
