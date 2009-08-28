Return-Path: <linux-kernel-owner+w=401wt.eu-S1751232AbZH1XTr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751232AbZH1XTr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Aug 2009 19:19:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751154AbZH1XTq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Aug 2009 19:19:46 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:45205 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750882AbZH1XTp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Aug 2009 19:19:45 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH 2/6] PM: Asynchronous resume of devices
Date: Sat, 29 Aug 2009 01:20:14 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.31-rc8-rjw; KDE/4.3.0; x86_64; ; )
Cc: "linux-pm" <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Len Brown <lenb@kernel.org>,
       Pavel Machek <pavel@ucw.cz>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>, Zhang Rui <rui.zhang@intel.com>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Linux PCI <linux-pci@vger.kernel.org>
References: <Pine.LNX.4.44L0.0908281548140.2865-100000@iolanthe.rowland.org> <200908290022.00446.rjw@sisk.pl>
In-Reply-To: <200908290022.00446.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200908290120.14840.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 29 August 2009, Rafael J. Wysocki wrote:
> On Friday 28 August 2009, Alan Stern wrote:
> > On Fri, 28 Aug 2009, Rafael J. Wysocki wrote:
> > 
> > > > Given this design, why bother to invoke device_resume() for the async 
> > > > devices?  Why not just start up a bunch of async threads, each of which 
> > > > calls async_resume() repeatedly until everything is finished?  (And 
> > > > rearrange async_resume() to scan the list first and do the actual 
> > > > resume second.)
> > > > 
> > > > The same goes for the noirq versions.
> > > 
> > > I thought about that, but there are a few things to figure out:
> > > - how many threads to start
> > 
> > That's a tough question.  Right now you start roughly as many threads
> > as there are async devices.  That seems like overkill.
> 
> In fact they are substantially fewer than that, for the following reasons.
> 
> First, the async framework will not start more than MAX_THREADS threads,
> which is 256 at the moment.  This number is less than the number of async
> devices to handle on an average system.
> 
> Second, no new async threads are started while the main thread is handling the
> sync devices , so the existing threads have a chance to do their job.  If
> there's a "cluster" of sync devices in dpm_list, the number of async threads
> running is likely to drop rapidly while those devices are being handled.
> (BTW, if there were no sync devices, the whole thing would be much simpler,
> but I don't think it's realistic to assume we'll be able to get rid of them any
> time soon).
> 
> Finally, but not least importantly, async threads are not started for the
> async devices that were previously handled "out of order" by the already
> running async threads (or by async threads that have already finished).  My
> testing shows that there are quite a few of them on the average.  For example,
> on the HP nx6325 typically there are as many as 580 async devices handled "out
> of order" during a _single_ suspend-resume cycle (including the "early" and
> "late" phases), while only a few (below 10) devices are waited for by at least
> one async thread.
> 
> I can try to monitor the number of asyn threads started if you're interested.

I did that out of curiousity.  To be precise, I applied the appended patch on
top of the previous ones and the maximum number of scheduled async operations
I've got so far is 14 (strangely enough, during "late" suspend).

So, that's not like there are hundreds of async threads being started.

Thanks,
Rafael


---
 drivers/base/power/main.c |    9 +++++++++
 1 file changed, 9 insertions(+)

Index: linux-2.6/drivers/base/power/main.c
===================================================================
--- linux-2.6.orig/drivers/base/power/main.c
+++ linux-2.6/drivers/base/power/main.c
@@ -53,6 +53,8 @@ static pm_message_t pm_transition;
  */
 static bool transition_started;
 
+static unsigned int nr_async;
+
 /**
  * device_pm_lock - Lock the list of active devices used by the PM core.
  */
@@ -166,6 +168,8 @@ static void dpm_reset_all(void)
 
 	list_for_each_entry(dev, &dpm_list, power.entry)
 		dpm_reset(dev);
+	printk(KERN_INFO "PM: Scheduled %d async operations\n", nr_async);
+	nr_async = 0;
 }
 
 /**
@@ -563,6 +567,7 @@ static int device_resume_noirq(struct de
 
 	if (pm_async_enabled && !pm_trace_enabled && dev->power.async_suspend) {
 		async_schedule(async_resume_noirq, dev);
+		nr_async++;
 		return 0;
 	}
 
@@ -723,6 +728,7 @@ static int device_resume(struct device *
 	if (pm_async_enabled && !pm_trace_enabled && dev->power.async_suspend) {
 		get_device(dev);
 		async_schedule(async_resume, dev);
+		nr_async++;
 		return 0;
 	}
 
@@ -968,6 +974,7 @@ static int device_suspend_noirq(struct d
 
 	if (pm_async_enabled && dev->power.async_suspend) {
 		async_schedule(async_suspend_noirq, dev);
+		nr_async++;
 		return 0;
 	}
 
@@ -1143,6 +1150,7 @@ static int device_suspend(struct device 
 	if (pm_async_enabled && dev->power.async_suspend) {
 		get_device(dev);
 		async_schedule(async_suspend, dev);
+		nr_async++;
 		return 0;
 	}
 
@@ -1247,6 +1255,7 @@ static int dpm_prepare(pm_message_t stat
 	mutex_lock(&dpm_list_mtx);
 	transition_started = true;
 	atomic_set(&async_error, 0);
+	nr_async = 0;
 	while (!list_empty(&dpm_list)) {
 		struct device *dev = to_device(dpm_list.next);
 
