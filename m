Return-Path: <linux-kernel-owner+w=401wt.eu-S934519AbZLPCKj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934519AbZLPCKj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 21:10:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934495AbZLPCKh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 21:10:37 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:54872 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934489AbZLPCKd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 21:10:33 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Async suspend-resume patch w/ completions (was: Re: Async suspend-resume patch w/ rwsems)
Date: Wed, 16 Dec 2009 03:11:05 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.32-rjw; KDE/4.3.3; x86_64; ; )
Cc: Alan Stern <stern@rowland.harvard.edu>, Zhang Rui <rui.zhang@intel.com>,
       LKML <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
References: <Pine.LNX.4.44L0.0912091729530.2672-100000@iolanthe.rowland.org> <200912151203.22916.rjw@sisk.pl> <alpine.LFD.2.00.0912150722310.14385@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0912150722310.14385@localhost.localdomain>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200912160311.05915.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 15 December 2009, Linus Torvalds wrote:
> 
> On Tue, 15 Dec 2009, Rafael J. Wysocki wrote:
> > > 
> > > Give a real example that matters.
> > 
> > I'll try.  Let -> denote child-parent relationships and assume dpm_list looks
> > like this:
> 
> No. 
> 
> I mean something real - something like
> 
>  - if you run on a non-PC with two USB buses behind non-PCI controllers.
> 
>  - device xyz.
> 
> > If this applies to _resume_ only, then I agree, but the Arjan's data clearly
> > show that serio devices take much more time to suspend than USB.
> 
> I mean in general - something where you actually have hard data that some 
> device really needs anythign more than my one-liner, and really _needs_ 
> some complex infrastructure.
> 
> Not "let's imagine a case like xyz".

As I said I would, I made some measurements.

I measured the total time of suspending and resuming devices as shown by the
code added by this patch:
http://git.kernel.org/?p=linux/kernel/git/rafael/suspend-2.6.git;a=commitdiff_plain;h=c1b8fc0a8bff7707c10f31f3d26bfa88e18ccd94;hp=087dbf5f079f1b55cbd3964c9ce71268473d5b67
on two boxes, HP nx6325 and MSI Wind U100 (hardware-wise they are quite
different and the HP was running 64-bit kernel and user space).

I took four cases into consideration:
(1) synchronous suspend and resume (/sys/power/pm_async = 0)
(2) asynchronous suspend and resume as introduced by the async branch at:
    http://git.kernel.org/?p=linux/kernel/git/rafael/suspend-2.6.git;a=shortlog;h=refs/heads/async
(3) asynchronous suspend and resume like in (2), but with your one-liner setting
    the power.async_suspend flag for PCI bridges on top
(4) asynchronous suspend and resume like in (2), but with an extra patch that
    is appended on top

For those tests I set power.async_suspend for all USB devices, all serio input
devices, the ACPI battery and the USB PCI controllers (to see the impact of the
one-liner, if any).

I carried out 5 consecutive suspend-resume cycles (started from under X) on
each box in each case, and the raw data are here (all times in milliseconds):
http://www.sisk.pl/kernel/data/async-suspend.pdf

The summarized data are below (the "big" numbers are averages and the +/-
numbers are standard deviations, all in milliseconds):

			HP nx6325		MSI Wind U100

sync suspend		1482 (+/- 40)	1180 (+/- 24)
sync resume		2955 (+/- 2)	3597 (+/- 25)

async suspend		1553 (+/- 49)	1177 (+/- 32)
async resume		2692 (+/- 326)	3556  (+/- 33)

async+one-liner suspend	1600 (+/- 39)	1212 (+/- 41)
async+one-liner resume	2692 (+/- 324)	3579 (+/- 24)

async+extra suspend	1496 (+/- 37)	1217 (+/- 38)
async+extra resume	1859 (+/- 114)	1923 (+/- 35)

So, in my opinion, with the above set of "async" devices, it doesn't
make sense to do async suspend at all, because the sync suspend is actually
the fastest on both machines.

However, it surely is worth doing async _resume_ with the extra patch appended
below, because that allows us to save 1 second or more on both machines with
respect to the sync case.  The other variants of async resume also produce some
time savings, but (on the nx6325) at the expense of huge fluctuations from one
cycle to another (so they can actually be slower than the sync resume).  Only
the async resume with the extra patch is consistently better than the sync one.
The impact of the one-liner is either negligible or slightly negative.

Now, what does the extra patch do?  Exactly the thing I was talking about, it
starts all async suspends and resumes upfront.

So, it looks like we both were wrong.  I was wrong, because I thought the
extra patch would help suspend, but not resume, while in fact it appears to
help resume big time.  You were wrong, because you thought that the one-liner
would have positive impact, while in fact it doesn't.

Concluding, at this point I'd opt for implementing asynchronous resume alone,
_without_ asynchronous suspend, which is more complicated and doesn't really
give us any time savings.  At the same time, I'd implement the asynchronous
resume in such a way that all of the async resume threads would be started
before the synchronous suspend thread, because that would give us the best
results.

Rafael

---
 drivers/base/power/main.c |   48 +++++++++++++++++++++++++++++-----------------
 1 file changed, 31 insertions(+), 17 deletions(-)

Index: linux-2.6/drivers/base/power/main.c
===================================================================
--- linux-2.6.orig/drivers/base/power/main.c
+++ linux-2.6/drivers/base/power/main.c
@@ -523,14 +523,9 @@ static void async_resume(void *data, asy
 
 static int device_resume(struct device *dev)
 {
-	INIT_COMPLETION(dev->power.completion);
-
-	if (pm_async_enabled && dev->power.async_suspend
-	    && !pm_trace_is_enabled()) {
-		get_device(dev);
-		async_schedule(async_resume, dev);
+	if (dev->power.async_suspend && pm_async_enabled
+	    && !pm_trace_is_enabled())
 		return 0;
-	}
 
 	return __device_resume(dev, pm_transition, false);
 }
@@ -545,14 +540,28 @@ static int device_resume(struct device *
 static void dpm_resume(pm_message_t state)
 {
 	struct list_head list;
+	struct device *dev;
 	ktime_t starttime = ktime_get();
 
 	INIT_LIST_HEAD(&list);
 	mutex_lock(&dpm_list_mtx);
 	pm_transition = state;
-	while (!list_empty(&dpm_list)) {
-		struct device *dev = to_device(dpm_list.next);
 
+	list_for_each_entry(dev, &dpm_list, power.entry) {
+		if (dev->power.status < DPM_OFF)
+			continue;
+
+		INIT_COMPLETION(dev->power.completion);
+
+		if (dev->power.async_suspend && pm_async_enabled
+		    && !pm_trace_is_enabled()) {
+			get_device(dev);
+			async_schedule(async_resume, dev);
+		}
+	}
+
+	while (!list_empty(&dpm_list)) {
+		dev = to_device(dpm_list.next);
 		get_device(dev);
 		if (dev->power.status >= DPM_OFF) {
 			int error;
@@ -809,13 +818,8 @@ static void async_suspend(void *data, as
 
 static int device_suspend(struct device *dev)
 {
-	INIT_COMPLETION(dev->power.completion);
-
-	if (pm_async_enabled && dev->power.async_suspend) {
-		get_device(dev);
-		async_schedule(async_suspend, dev);
+	if (pm_async_enabled && dev->power.async_suspend)
 		return 0;
-	}
 
 	return __device_suspend(dev, pm_transition, false);
 }
@@ -827,6 +831,7 @@ static int device_suspend(struct device 
 static int dpm_suspend(pm_message_t state)
 {
 	struct list_head list;
+	struct device *dev;
 	ktime_t starttime = ktime_get();
 	int error = 0;
 
@@ -834,9 +839,18 @@ static int dpm_suspend(pm_message_t stat
 	mutex_lock(&dpm_list_mtx);
 	pm_transition = state;
 	async_error = 0;
-	while (!list_empty(&dpm_list)) {
-		struct device *dev = to_device(dpm_list.prev);
 
+	list_for_each_entry_reverse(dev, &dpm_list, power.entry) {
+		INIT_COMPLETION(dev->power.completion);
+
+		if (pm_async_enabled && dev->power.async_suspend) {
+			get_device(dev);
+			async_schedule(async_suspend, dev);
+		}
+	}
+
+	while (!list_empty(&dpm_list)) {
+		dev = to_device(dpm_list.prev);
 		get_device(dev);
 		mutex_unlock(&dpm_list_mtx);
 
