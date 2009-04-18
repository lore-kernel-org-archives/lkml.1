Return-Path: <linux-kernel-owner+w=401wt.eu-S1756779AbZDRSsc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756779AbZDRSsc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Apr 2009 14:48:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754098AbZDRSsV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Apr 2009 14:48:21 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:45386 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755133AbZDRSsU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Apr 2009 14:48:20 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Russell King <rmk+lkml@arm.linux.org.uk>, Len Brown <lenb@kernel.org>
Subject: [PATCH] PM/Suspend: Introduce two new platform callbacks to avoid breakage (Re: 900af0d breaks some embedded suspend/resume)
Date: Sat, 18 Apr 2009 20:47:47 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc2-rjw; KDE/4.2.2; x86_64; ; )
Cc: Linux Kernel List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>
References: <20090417231009.GB6900@flint.arm.linux.org.uk> <200904181626.10388.rjw@sisk.pl> <20090418144132.GC7148@flint.arm.linux.org.uk>
In-Reply-To: <20090418144132.GC7148@flint.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904182047.48009.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 18 April 2009, Russell King wrote:
> On Sat, Apr 18, 2009 at 04:26:09PM +0200, Rafael J. Wysocki wrote:
> > On Saturday 18 April 2009, Russell King wrote:
> > > On Sat, Apr 18, 2009 at 03:23:35PM +0200, Rafael J. Wysocki wrote:
> > > > The patchset in question had been discussed quite extensively before it was
> > > > merged and it's a pity none of the people caring for the affected platforms
> > > > took part in those discussions.  That would allow us to avoid the breakage.
> > > 
> > > Maybe on some list, but not everyone is subscribed to a million and one
> > > mailing lists.  I don't have enough time to read those which I'm currently
> > > subscribed to, so I definitely don't want any more.
> > > 
> > > > > or provide alternative equivalent functionality where the platform code is
> > > > > notified of the PM event prior to the late suspend callback being issued.
> > > > 
> > > > There is the .begin() callback that could be used, but if you need the
> > > > platform to be notified _just_ prior to the late suspend callback, then the
> > > > only thing I can think of at the moment is the appended patch.
> > > > 
> > > > It shouldn't break anything in theory, because the majority of drivers put
> > > > their devices into low power states in the "regular" suspend callbacks anyway.
> > > 
> > > Okay, my requirement is:
> > > 
> > > What I need to be able to do is to suspend most devices on the host side
> > > which may involve talking to a separate microcontroller via I2C to shut
> > > down power to peripherals.
> > > 
> > > Once that's complete, I then need to inform this microcontroller via I2C
> > > that we're going to be entering suspend mode, and wait for it to acknowledge
> > > that (after it's done its own suspend preparations).  At that point I can
> > > shutdown the I2C controller, and enter suspend mode.
> > 
> > Would it be an option to use a sysdev for that?
> 
> No, sysdevs are shut down after IRQs are turned off and the I2C driver
> has been shut down.  The I2C driver needs IRQs to work in slave mode,
> and we need slave mode to work.
> 
> > This patch undoes some previous changes, but I'm not too comfortable with
> > it, because I think that putting devices into low power states after
> > .prepare() may not work on some ACPI systems.  Since devices should
> > generally be put into low power states during the "late" suspend (ie.
> > when their interrupt handlers are not invoked), it may be quite
> > inconvenient.
> 
> Maybe we need yet more levels of callbacks? :P

In fact, as a minimal fix that doesn't invalidate the testing of current Linus'
tree already done in this cycle, I'd like to apply the appended patch.

It adds two new platform suspend callbacks so that we can avoid the apparent
conflict between ACPI and the other platforms.  Details are in the changelog.

If Len doesn't object, I'd like this one to go to 2.6.30, but I'm going to
clean up the platform suspend and hibernation callbacks eventually.

Thanks,
Rafael

---
From: Rafael J. Wysocki <rjw@sisk.pl>
Subject: PM/Suspend: Introduce two new platform callbacks to avoid breakage

Commit 900af0d973856d6feb6fc088c2d0d3fde57707d3 (PM: Change suspend
code ordering) changed the ordering of suspend code in such a way
that the platform .prepare() callback is now executed after the
device drivers' late suspend callbacks have run.  Unfortunately, this
turns out to break ARM platforms that need to talk via I2C to power
control devices during the .prepare() callback.

For this reason introduce two new platform suspend callbacks,
.prepare_late() and .wake(), that will be called just prior to
disabling non-boot CPUs and right after bringing them back on line,
respectively, and use them instead of .prepare() and .finish() for
ACPI suspend.  Make the PM core execute the .prepare() and .finish()
platform suspend callbacks where they were executed previously (that
is, right after calling the regular suspend methods provided by
device drivers and right before executing their regular resume
methods, respectively).

It is not necessary to make analogous changes to the hibernation
code and data structures at the moment, because they are only used
by ACPI platforms.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Reported-by: Russell King <rmk+kernel@arm.linux.org.uk>
---
 drivers/acpi/sleep.c    |    8 ++++----
 include/linux/suspend.h |   36 ++++++++++++++++++++++++++----------
 kernel/power/main.c     |   24 +++++++++++++++++-------
 3 files changed, 47 insertions(+), 21 deletions(-)

Index: linux-2.6/kernel/power/main.c
===================================================================
--- linux-2.6.orig/kernel/power/main.c
+++ linux-2.6/kernel/power/main.c
@@ -291,20 +291,26 @@ static int suspend_enter(suspend_state_t
 
 	device_pm_lock();
 
+	if (suspend_ops->prepare) {
+		error = suspend_ops->prepare();
+		if (error)
+			goto Done;
+	}
+
 	error = device_power_down(PMSG_SUSPEND);
 	if (error) {
 		printk(KERN_ERR "PM: Some devices failed to power down\n");
-		goto Done;
+		goto Platfrom_finish;
 	}
 
-	if (suspend_ops->prepare) {
-		error = suspend_ops->prepare();
+	if (suspend_ops->prepare_late) {
+		error = suspend_ops->prepare_late();
 		if (error)
 			goto Power_up_devices;
 	}
 
 	if (suspend_test(TEST_PLATFORM))
-		goto Platfrom_finish;
+		goto Platform_wake;
 
 	error = disable_nonboot_cpus();
 	if (error || suspend_test(TEST_CPUS))
@@ -326,13 +332,17 @@ static int suspend_enter(suspend_state_t
  Enable_cpus:
 	enable_nonboot_cpus();
 
- Platfrom_finish:
-	if (suspend_ops->finish)
-		suspend_ops->finish();
+ Platform_wake:
+	if (suspend_ops->wake)
+		suspend_ops->wake();
 
  Power_up_devices:
 	device_power_up(PMSG_RESUME);
 
+ Platfrom_finish:
+	if (suspend_ops->finish)
+		suspend_ops->finish();
+
  Done:
 	device_pm_unlock();
 
Index: linux-2.6/include/linux/suspend.h
===================================================================
--- linux-2.6.orig/include/linux/suspend.h
+++ linux-2.6/include/linux/suspend.h
@@ -58,10 +58,17 @@ typedef int __bitwise suspend_state_t;
  *	by @begin().
  *	@prepare() is called right after devices have been suspended (ie. the
  *	appropriate .suspend() method has been executed for each device) and
- *	before the nonboot CPUs are disabled (it is executed with IRQs enabled).
- *	This callback is optional.  It returns 0 on success or a negative
- *	error code otherwise, in which case the system cannot enter the desired
- *	sleep state (@enter() and @finish() will not be called in that case).
+ *	before device drivers' late suspend callbacks are executed.  It returns
+ *	0 on success or a negative error code otherwise, in which case the
+ *	system cannot enter the desired sleep state (@prepare_late(), @enter(),
+ *	@wake(), and @finish() will not be called in that case).
+ *
+ * @prepare_late: Finish preparing the platform for entering the system sleep
+ *	state indicated by @begin().
+ *	@prepare_late is called before disabling nonboot CPUs and after
+ *	device drivers' late suspend callbacks have been executed.  It returns
+ *	0 on success or a negative error code otherwise, in which case the
+ *	system cannot enter the desired sleep state (@enter() and @wake()).
  *
  * @enter: Enter the system sleep state indicated by @begin() or represented by
  *	the argument if @begin() is not implemented.
@@ -69,19 +76,26 @@ typedef int __bitwise suspend_state_t;
  *	error code otherwise, in which case the system cannot enter the desired
  *	sleep state.
  *
- * @finish: Called when the system has just left a sleep state, right after
- *	the nonboot CPUs have been enabled and before devices are resumed (it is
- *	executed with IRQs enabled).
+ * @wake: Called when the system has just left a sleep state, right after
+ *	the nonboot CPUs have been enabled and before device drivers' early
+ *	resume callbacks are executed.
+ *	This callback is optional, but should be implemented by the platforms
+ *	that implement @prepare_late().  If implemented, it is always called
+ *	after @enter(), even if @enter() fails.
+ *
+ * @finish: Finish wake-up of the platform.
+ *	@finish is called right prior to calling device drivers' regular suspend
+ *	callbacks.
  *	This callback is optional, but should be implemented by the platforms
  *	that implement @prepare().  If implemented, it is always called after
- *	@enter() (even if @enter() fails).
+ *	@enter() and @wake(), if implemented, even if any of them fails.
  *
  * @end: Called by the PM core right after resuming devices, to indicate to
  *	the platform that the system has returned to the working state or
  *	the transition to the sleep state has been aborted.
  *	This callback is optional, but should be implemented by the platforms
- *	that implement @begin(), but platforms implementing @begin() should
- *	also provide a @end() which cleans up transitions aborted before
+ *	that implement @begin().  Accordingly, platforms implementing @begin()
+ *	should also provide a @end() which cleans up transitions aborted before
  *	@enter().
  *
  * @recover: Recover the platform from a suspend failure.
@@ -93,7 +107,9 @@ struct platform_suspend_ops {
 	int (*valid)(suspend_state_t state);
 	int (*begin)(suspend_state_t state);
 	int (*prepare)(void);
+	int (*prepare_late)(void);
 	int (*enter)(suspend_state_t state);
+	void (*wake)(void);
 	void (*finish)(void);
 	void (*end)(void);
 	void (*recover)(void);
Index: linux-2.6/drivers/acpi/sleep.c
===================================================================
--- linux-2.6.orig/drivers/acpi/sleep.c
+++ linux-2.6/drivers/acpi/sleep.c
@@ -300,9 +300,9 @@ static int acpi_suspend_state_valid(susp
 static struct platform_suspend_ops acpi_suspend_ops = {
 	.valid = acpi_suspend_state_valid,
 	.begin = acpi_suspend_begin,
-	.prepare = acpi_pm_prepare,
+	.prepare_late = acpi_pm_prepare,
 	.enter = acpi_suspend_enter,
-	.finish = acpi_pm_finish,
+	.wake = acpi_pm_finish,
 	.end = acpi_pm_end,
 };
 
@@ -328,9 +328,9 @@ static int acpi_suspend_begin_old(suspen
 static struct platform_suspend_ops acpi_suspend_ops_old = {
 	.valid = acpi_suspend_state_valid,
 	.begin = acpi_suspend_begin_old,
-	.prepare = acpi_pm_disable_gpes,
+	.prepare_late = acpi_pm_disable_gpes,
 	.enter = acpi_suspend_enter,
-	.finish = acpi_pm_finish,
+	.wake = acpi_pm_finish,
 	.end = acpi_pm_end,
 	.recover = acpi_pm_finish,
 };
