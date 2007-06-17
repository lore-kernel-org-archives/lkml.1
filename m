Return-Path: <linux-kernel-owner+w=401wt.eu-S1762444AbXFQTR2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762444AbXFQTR2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2007 15:17:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761867AbXFQTRQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jun 2007 15:17:16 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:34298 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759983AbXFQTRO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2007 15:17:14 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Uli Luckas <u.luckas@road.de>
Subject: Re: [PATCH -mm 2/2] PM: Disable usermode helper before hibernation and suspend
Date: Sun, 17 Jun 2007 21:24:13 +0200
User-Agent: KMail/1.9.5
Cc: LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>
References: <200706042325.28965.rjw@sisk.pl> <200706151508.53191.u.luckas@road.de> <200706152336.46278.rjw@sisk.pl>
In-Reply-To: <200706152336.46278.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706172124.13550.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 15 June 2007 23:36, Rafael J. Wysocki wrote:
> On Friday, 15 June 2007 15:08, Uli Luckas wrote:
> > On Monday, 4. June 2007, Rafael J. Wysocki wrote:
> > > From: Rafael J. Wysocki <rjw@sisk.pl>
> > >
> > > Use a hibernation and suspend notifier to disable the user mode helper
> > > before a hibernation/suspend and enable it after the operation.
> > >
> > Hi Rafael,
> > I have a couple of questions, regarding this patch ...
> > > -	if (!khelper_wq)
> > > +	if (!khelper_wq || usermodehelper_disabled)
> > >  		return -EBUSY;
> > 1) how about not returning -EBUSY here, if (wait == UMH_NO_WAIT)?
> 
> Yes, this would make sense.

I know why I didn't do that from the start: my patch was against -rc4 and
UMH_NO_WAIT is mm-only.

> > 2) how does your patch prevent wait_for_completion(&done) to hang during
> >    freezing if usermodehelper_pm_callback is called _after_ the above check?
> 
> It doesn't.  Once the helper is running, we can't distinguish it from any other
> user land process.
> 
> Still, it narrows the window quite a bit.

Okay, I think we can help it a bit.  Please tell me what you think of the
following patch (on top of 2.6.22-rc4-mm2).

Greetings,
Rafael


Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 kernel/kmod.c |   24 ++++++++++++++++++++++--
 1 file changed, 22 insertions(+), 2 deletions(-)

Index: linux-2.6.22-rc4-mm2/kernel/kmod.c
===================================================================
--- linux-2.6.22-rc4-mm2.orig/kernel/kmod.c
+++ linux-2.6.22-rc4-mm2/kernel/kmod.c
@@ -49,6 +49,15 @@ static struct workqueue_struct *khelper_
  */
 static int usermodehelper_disabled;
 
+/* Number of helpers running */
+static atomic_t running_helpers = ATOMIC_INIT(0);
+
+/*
+ * Time to wait for running_helpers to become zero before the setting of
+ * usermodehelper_disabled in usermodehelper_pm_callback() fails
+ */
+#define RUNNING_HELPERS_TIMEOUT	(5 * HZ)
+
 #ifdef CONFIG_KMOD
 
 /*
@@ -279,11 +288,20 @@ static int usermodehelper_pm_callback(st
 					unsigned long action,
 					void *ignored)
 {
+	DECLARE_WAIT_QUEUE_HEAD_ONSTACK(waiting);
+
 	switch (action) {
 	case PM_HIBERNATION_PREPARE:
 	case PM_SUSPEND_PREPARE:
 		usermodehelper_disabled = 1;
-		return NOTIFY_OK;
+		wait_event_timeout(waiting, atomic_read(&running_helpers) == 0,
+					RUNNING_HELPERS_TIMEOUT);
+		if (atomic_read(&running_helpers) == 0) {
+			return NOTIFY_OK;
+		} else {
+			usermodehelper_disabled = 0;
+			return NOTIFY_BAD;
+		}
 	case PM_POST_HIBERNATION:
 	case PM_POST_SUSPEND:
 		usermodehelper_disabled = 0;
@@ -397,12 +415,13 @@ int call_usermodehelper_exec(struct subp
 	DECLARE_COMPLETION_ONSTACK(done);
 	int retval;
 
+	atomic_inc(&running_helpers);
 	if (sub_info->path[0] == '\0') {
 		retval = 0;
 		goto out;
 	}
 
-	if (!khelper_wq || usermodehelper_disabled) {
+	if (!khelper_wq || (wait != UMH_NO_WAIT && usermodehelper_disabled)) {
 		retval = -EBUSY;
 		goto out;
 	}
@@ -418,6 +437,7 @@ int call_usermodehelper_exec(struct subp
 
   out:
 	call_usermodehelper_freeinfo(sub_info);
+	atomic_dec(&running_helpers);
 	return retval;
 }
 EXPORT_SYMBOL(call_usermodehelper_exec);
