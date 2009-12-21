Return-Path: <linux-kernel-owner+w=401wt.eu-S1757356AbZLUVIQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757356AbZLUVIQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Dec 2009 16:08:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757341AbZLUVIF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Dec 2009 16:08:05 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:43030 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757301AbZLUVHT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Dec 2009 16:07:19 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: pm list <linux-pm@lists.linux-foundation.org>
Subject: [PATCH 4/5]  PM / Runtime: Use device type and device class callbacks
Date: Mon, 21 Dec 2009 22:06:10 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.32-rjw; KDE/4.3.3; x86_64; ; )
Cc: Alan Stern <stern@rowland.harvard.edu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>
References: <200912212201.47920.rjw@sisk.pl>
In-Reply-To: <200912212201.47920.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200912212206.10446.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

The power management of some devices is handled through device types
and device classes rather than through bus types.  Since these
devices may also benefit from using the run-time power management
core, extend it so that the device type and device class run-time PM
callbacks can be taken into consideration by it if the bus type
callback is not defined.

Update the run-time PM core documentation to reflect this change.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 Documentation/power/runtime_pm.txt |  173 ++++++++++++++++++-------------------
 drivers/base/power/runtime.c       |   45 +++++++++
 2 files changed, 132 insertions(+), 86 deletions(-)

Index: linux-2.6/drivers/base/power/runtime.c
===================================================================
--- linux-2.6.orig/drivers/base/power/runtime.c
+++ linux-2.6/drivers/base/power/runtime.c
@@ -85,6 +85,19 @@ static int __pm_runtime_idle(struct devi
 		dev->bus->pm->runtime_idle(dev);
 
 		spin_lock_irq(&dev->power.lock);
+	} else if (dev->type && dev->type->pm && dev->type->pm->runtime_idle) {
+		spin_unlock_irq(&dev->power.lock);
+
+		dev->type->pm->runtime_idle(dev);
+
+		spin_lock_irq(&dev->power.lock);
+	} else if (dev->class && dev->class->pm
+	    && dev->class->pm->runtime_idle) {
+		spin_unlock_irq(&dev->power.lock);
+
+		dev->class->pm->runtime_idle(dev);
+
+		spin_lock_irq(&dev->power.lock);
 	}
 
 	dev->power.idle_notification = false;
@@ -194,6 +207,22 @@ int __pm_runtime_suspend(struct device *
 
 		spin_lock_irq(&dev->power.lock);
 		dev->power.runtime_error = retval;
+	} else if (dev->type && dev->type->pm
+	    && dev->type->pm->runtime_suspend) {
+		spin_unlock_irq(&dev->power.lock);
+
+		retval = dev->type->pm->runtime_suspend(dev);
+
+		spin_lock_irq(&dev->power.lock);
+		dev->power.runtime_error = retval;
+	} else if (dev->class && dev->class->pm
+	    && dev->class->pm->runtime_suspend) {
+		spin_unlock_irq(&dev->power.lock);
+
+		retval = dev->class->pm->runtime_suspend(dev);
+
+		spin_lock_irq(&dev->power.lock);
+		dev->power.runtime_error = retval;
 	} else {
 		retval = -ENOSYS;
 	}
@@ -359,6 +388,22 @@ int __pm_runtime_resume(struct device *d
 
 		spin_lock_irq(&dev->power.lock);
 		dev->power.runtime_error = retval;
+	} else if (dev->type && dev->type->pm
+	    && dev->type->pm->runtime_resume) {
+		spin_unlock_irq(&dev->power.lock);
+
+		retval = dev->type->pm->runtime_resume(dev);
+
+		spin_lock_irq(&dev->power.lock);
+		dev->power.runtime_error = retval;
+	} else if (dev->class && dev->class->pm
+	    && dev->class->pm->runtime_resume) {
+		spin_unlock_irq(&dev->power.lock);
+
+		retval = dev->class->pm->runtime_resume(dev);
+
+		spin_lock_irq(&dev->power.lock);
+		dev->power.runtime_error = retval;
 	} else {
 		retval = -ENOSYS;
 	}
Index: linux-2.6/Documentation/power/runtime_pm.txt
===================================================================
--- linux-2.6.orig/Documentation/power/runtime_pm.txt
+++ linux-2.6/Documentation/power/runtime_pm.txt
@@ -42,80 +42,81 @@ struct dev_pm_ops {
 	...
 };
 
-The ->runtime_suspend() callback is executed by the PM core for the bus type of
-the device being suspended.  The bus type's callback is then _entirely_
-_responsible_ for handling the device as appropriate, which may, but need not
-include executing the device driver's own ->runtime_suspend() callback (from the
+The ->runtime_suspend(), ->runtime_resume() and ->runtime_idle() callbacks are
+executed by the PM core for either the bus type, or device type (if the bus
+type's callback is not defined), or device class (if the bus type's and device
+type's callbacks are not defined) of given device.  The bus type, device type
+and device class callbacks are referred to as subsystem-level callbacks in what
+follows.
+
+The subsystem-level suspend callback is _entirely_ _responsible_ for handling
+the suspend of the device as appropriate, which may, but need not include
+executing the device driver's own ->runtime_suspend() callback (from the
 PM core's point of view it is not necessary to implement a ->runtime_suspend()
-callback in a device driver as long as the bus type's ->runtime_suspend() knows
-what to do to handle the device).
+callback in a device driver as long as the subsystem-level suspend callback
+knows what to do to handle the device).
 
-  * Once the bus type's ->runtime_suspend() callback has completed successfully
+  * Once the subsystem-level suspend callback has completed successfully
     for given device, the PM core regards the device as suspended, which need
     not mean that the device has been put into a low power state.  It is
     supposed to mean, however, that the device will not process data and will
-    not communicate with the CPU(s) and RAM until its bus type's
-    ->runtime_resume() callback is executed for it.  The run-time PM status of
-    a device after successful execution of its bus type's ->runtime_suspend()
-    callback is 'suspended'.
-
-  * If the bus type's ->runtime_suspend() callback returns -EBUSY or -EAGAIN,
-    the device's run-time PM status is supposed to be 'active', which means that
-    the device _must_ be fully operational afterwards.
-
-  * If the bus type's ->runtime_suspend() callback returns an error code
-    different from -EBUSY or -EAGAIN, the PM core regards this as a fatal
-    error and will refuse to run the helper functions described in Section 4
-    for the device, until the status of it is directly set either to 'active'
-    or to 'suspended' (the PM core provides special helper functions for this
-    purpose).
-
-In particular, if the driver requires remote wakeup capability for proper
-functioning and device_run_wake() returns 'false' for the device, then
-->runtime_suspend() should return -EBUSY.  On the other hand, if
-device_run_wake() returns 'true' for the device and the device is put
-into a low power state during the execution of its bus type's
-->runtime_suspend(), it is expected that remote wake-up (i.e. hardware mechanism
-allowing the device to request a change of its power state, such as PCI PME)
-will be enabled for the device.  Generally, remote wake-up should be enabled
-for all input devices put into a low power state at run time.
-
-The ->runtime_resume() callback is executed by the PM core for the bus type of
-the device being woken up.  The bus type's callback is then _entirely_
-_responsible_ for handling the device as appropriate, which may, but need not
-include executing the device driver's own ->runtime_resume() callback (from the
-PM core's point of view it is not necessary to implement a ->runtime_resume()
-callback in a device driver as long as the bus type's ->runtime_resume() knows
-what to do to handle the device).
-
-  * Once the bus type's ->runtime_resume() callback has completed successfully,
-    the PM core regards the device as fully operational, which means that the
-    device _must_ be able to complete I/O operations as needed.  The run-time
-    PM status of the device is then 'active'.
-
-  * If the bus type's ->runtime_resume() callback returns an error code, the PM
-    core regards this as a fatal error and will refuse to run the helper
-    functions described in Section 4 for the device, until its status is
-    directly set either to 'active' or to 'suspended' (the PM core provides
-    special helper functions for this purpose).
-
-The ->runtime_idle() callback is executed by the PM core for the bus type of
-given device whenever the device appears to be idle, which is indicated to the
-PM core by two counters, the device's usage counter and the counter of 'active'
-children of the device.
+    not communicate with the CPU(s) and RAM until the subsystem-level resume
+    callback is executed for it.  The run-time PM status of a device after
+    successful execution of the subsystem-level suspend callback is 'suspended'.
+
+  * If the subsystem-level suspend callback returns -EBUSY or -EAGAIN,
+    the device's run-time PM status is 'active', which means that the device
+    _must_ be fully operational afterwards.
+
+  * If the subsystem-level suspend callback returns an error code different
+    from -EBUSY or -EAGAIN, the PM core regards this as a fatal error and will
+    refuse to run the helper functions described in Section 4 for the device,
+    until the status of it is directly set either to 'active', or to 'suspended'
+    (the PM core provides special helper functions for this purpose).
+
+In particular, if the driver requires remote wake-up capability (i.e. hardware
+mechanism allowing the device to request a change of its power state, such as
+PCI PME) for proper functioning and device_run_wake() returns 'false' for the
+device, then ->runtime_suspend() should return -EBUSY.  On the other hand, if
+device_run_wake() returns 'true' for the device and the device is put into a low
+power state during the execution of the subsystem-level suspend callback, it is
+expected that remote wake-up will be enabled for the device.  Generally, remote
+wake-up should be enabled for all input devices put into a low power state at
+run time.
+
+The subsystem-level resume callback is _entirely_ _responsible_ for handling the
+resume of the device as appropriate, which may, but need not include executing
+the device driver's own ->runtime_resume() callback (from the PM core's point of
+view it is not necessary to implement a ->runtime_resume() callback in a device
+driver as long as the subsystem-level resume callback knows what to do to handle
+the device).
+
+  * Once the subsystem-level resume callback has completed successfully, the PM
+    core regards the device as fully operational, which means that the device
+    _must_ be able to complete I/O operations as needed.  The run-time PM status
+    of the device is then 'active'.
+
+  * If the subsystem-level resume callback returns an error code, the PM core
+    regards this as a fatal error and will refuse to run the helper functions
+    described in Section 4 for the device, until its status is directly set
+    either to 'active' or to 'suspended' (the PM core provides special helper
+    functions for this purpose).
+
+The subsystem-level idle callback is executed by the PM core whenever the device
+appears to be idle, which is indicated to the PM core by two counters, the
+device's usage counter and the counter of 'active' children of the device.
 
   * If any of these counters is decreased using a helper function provided by
     the PM core and it turns out to be equal to zero, the other counter is
     checked.  If that counter also is equal to zero, the PM core executes the
-    device bus type's ->runtime_idle() callback (with the device as an
-    argument).
+    subsystem-level idle callback with the device as an argument.
 
-The action performed by a bus type's ->runtime_idle() callback is totally
-dependent on the bus type in question, but the expected and recommended action
-is to check if the device can be suspended (i.e. if all of the conditions
-necessary for suspending the device are satisfied) and to queue up a suspend
-request for the device in that case.  The value returned by this callback is
-ignored by the PM core.
+The action performed by a subsystem-level idle callback is totally dependent on
+the subsystem in question, but the expected and recommended action is to check
+if the device can be suspended (i.e. if all of the conditions necessary for
+suspending the device are satisfied) and to queue up a suspend request for the
+device in that case.  The value returned by this callback is ignored by the PM
+core.
 
 The helper functions provided by the PM core, described in Section 4, guarantee
 that the following constraints are met with respect to the bus type's run-time
@@ -238,41 +239,41 @@ drivers/base/power/runtime.c and include
       removing the device from device hierarchy
 
   int pm_runtime_idle(struct device *dev);
-    - execute ->runtime_idle() for the device's bus type; returns 0 on success
-      or error code on failure, where -EINPROGRESS means that ->runtime_idle()
-      is already being executed
+    - execute the subsystem-level idle callback for the device; returns 0 on
+      success or error code on failure, where -EINPROGRESS means that
+      ->runtime_idle() is already being executed
 
   int pm_runtime_suspend(struct device *dev);
-    - execute ->runtime_suspend() for the device's bus type; returns 0 on
+    - execute the subsystem-level suspend callback for the device; returns 0 on
       success, 1 if the device's run-time PM status was already 'suspended', or
       error code on failure, where -EAGAIN or -EBUSY means it is safe to attempt
       to suspend the device again in future
 
   int pm_runtime_resume(struct device *dev);
-    - execute ->runtime_resume() for the device's bus type; returns 0 on
+    - execute the subsystem-leve resume callback for the device; returns 0 on
       success, 1 if the device's run-time PM status was already 'active' or
       error code on failure, where -EAGAIN means it may be safe to attempt to
       resume the device again in future, but 'power.runtime_error' should be
       checked additionally
 
   int pm_request_idle(struct device *dev);
-    - submit a request to execute ->runtime_idle() for the device's bus type
-      (the request is represented by a work item in pm_wq); returns 0 on success
-      or error code if the request has not been queued up
+    - submit a request to execute the subsystem-level idle callback for the
+      device (the request is represented by a work item in pm_wq); returns 0 on
+      success or error code if the request has not been queued up
 
   int pm_schedule_suspend(struct device *dev, unsigned int delay);
-    - schedule the execution of ->runtime_suspend() for the device's bus type
-      in future, where 'delay' is the time to wait before queuing up a suspend
-      work item in pm_wq, in milliseconds (if 'delay' is zero, the work item is
-      queued up immediately); returns 0 on success, 1 if the device's PM
+    - schedule the execution of the subsystem-level suspend callback for the
+      device in future, where 'delay' is the time to wait before queuing up a
+      suspend work item in pm_wq, in milliseconds (if 'delay' is zero, the work
+      item is queued up immediately); returns 0 on success, 1 if the device's PM
       run-time status was already 'suspended', or error code if the request
       hasn't been scheduled (or queued up if 'delay' is 0); if the execution of
       ->runtime_suspend() is already scheduled and not yet expired, the new
       value of 'delay' will be used as the time to wait
 
   int pm_request_resume(struct device *dev);
-    - submit a request to execute ->runtime_resume() for the device's bus type
-      (the request is represented by a work item in pm_wq); returns 0 on
+    - submit a request to execute the subsystem-level resume callback for the
+      device (the request is represented by a work item in pm_wq); returns 0 on
       success, 1 if the device's run-time PM status was already 'active', or
       error code if the request hasn't been queued up
 
@@ -303,12 +304,12 @@ drivers/base/power/runtime.c and include
       run-time PM callbacks described in Section 2
 
   int pm_runtime_disable(struct device *dev);
-    - prevent the run-time PM helper functions from running the device bus
-      type's run-time PM callbacks, make sure that all of the pending run-time
-      PM operations on the device are either completed or canceled; returns
-      1 if there was a resume request pending and it was necessary to execute
-      ->runtime_resume() for the device's bus type to satisfy that request,
-      otherwise 0 is returned
+    - prevent the run-time PM helper functions from running subsystem-level
+      run-time PM callbacks for the device, make sure that all of the pending
+      run-time PM operations on the device are either completed or canceled;
+      returns 1 if there was a resume request pending and it was necessary to
+      execute the subsystem-level resume callback for the device to satisfy that
+      request, otherwise 0 is returned
 
   void pm_suspend_ignore_children(struct device *dev, bool enable);
     - set/unset the power.ignore_children flag of the device
@@ -378,5 +379,5 @@ pm_runtime_suspend() or pm_runtime_idle(
 they will fail returning -EAGAIN, because the device's usage counter is
 incremented by the core before executing ->probe() and ->remove().  Still, it
 may be desirable to suspend the device as soon as ->probe() or ->remove() has
-finished, so the PM core uses pm_runtime_idle_sync() to invoke the device bus
-type's ->runtime_idle() callback at that time.
+finished, so the PM core uses pm_runtime_idle_sync() to invoke the
+subsystem-level idle callback for the device at that time.

