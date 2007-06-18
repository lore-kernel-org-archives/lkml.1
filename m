Return-Path: <linux-kernel-owner+w=401wt.eu-S1764114AbXFRPJM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764114AbXFRPJM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 11:09:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763349AbXFRPI7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 11:08:59 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:37468 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763475AbXFRPI6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 11:08:58 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Uli Luckas <u.luckas@road.de>
Subject: Re: [PATCH -mm 2/2] PM: Disable usermode helper before hibernation and suspend
Date: Mon, 18 Jun 2007 17:15:14 +0200
User-Agent: KMail/1.9.5
Cc: LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>
References: <200706042325.28965.rjw@sisk.pl> <200706172124.13550.rjw@sisk.pl> <200706181251.10170.u.luckas@road.de>
In-Reply-To: <200706181251.10170.u.luckas@road.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706181715.15017.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 18 June 2007 12:51, Uli Luckas wrote:
> On Sunday, 17. June 2007, you wrote:
> > On Friday, 15 June 2007 23:36, Rafael J. Wysocki wrote:
> > > On Friday, 15 June 2007 15:08, Uli Luckas wrote:
> > > > On Monday, 4. June 2007, Rafael J. Wysocki wrote:
> > > > > From: Rafael J. Wysocki <rjw@sisk.pl>
> > > > >
> > > > > Use a hibernation and suspend notifier to disable the user mode
> > > > > helper before a hibernation/suspend and enable it after the
> > > > > operation.
> > > >
> > > > Hi Rafael,
> > > > I have a couple of questions, regarding this patch ...
> 
> > > > 2) how does your patch prevent wait_for_completion(&done) to hang
> > > > during freezing if usermodehelper_pm_callback is called _after_ the
> > > > above check?
> > >
> > > It doesn't.  Once the helper is running, we can't distinguish it from any
> > > other user land process.
> > >
> > > Still, it narrows the window quite a bit.
> >
> > Okay, I think we can help it a bit.  Please tell me what you think of the
> > following patch (on top of 2.6.22-rc4-mm2).
> >
> Hi Rafael,
> Thanks for your work. I haven't found the time to actually test your patch but 
> in general it looks like a valid aproach.
> I think there is one problem though. You need to have your wait queue woken up 
> when you update (atomic_dec) running_helpers. Otherwise you end up always 
> waiting the full RUNNING_HELPERS_TIMEOUT.

Yeah, right.  I tend to forget about obvious things. :-(

Besides, I think that the _pm_callback need not be compiled if CONFIG_PM is
unset.  If you can, please have a look at the next version of the patch (appended).

Greetings,
Rafael


Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 kernel/kmod.c |   76 ++++++++++++++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 66 insertions(+), 10 deletions(-)

Index: linux-2.6.22-rc4-mm2/kernel/kmod.c
===================================================================
--- linux-2.6.22-rc4-mm2.orig/kernel/kmod.c
+++ linux-2.6.22-rc4-mm2/kernel/kmod.c
@@ -41,14 +41,6 @@ extern int max_threads;
 
 static struct workqueue_struct *khelper_wq;
 
-/*
- * If set, both call_usermodehelper_keys() and call_usermodehelper_pipe() exit
- * immediately returning -EBUSY.  Used for preventing user land processes from
- * being created after the user land has been frozen during a system-wide
- * hibernation or suspend operation.
- */
-static int usermodehelper_disabled;
-
 #ifdef CONFIG_KMOD
 
 /*
@@ -275,6 +267,30 @@ static void __call_usermodehelper(struct
 	}
 }
 
+#ifdef CONFIG_PM
+/*
+ * If set and if call_usermodehelper_exec() is supposed to wait, it will exit
+ * immediately returning -EBUSY (used for preventing user land processes from
+ * being created after the user land has been frozen during a system-wide
+ * hibernation or suspend operation).
+ */
+static int usermodehelper_disabled;
+
+/* Number of helpers running */
+static atomic_t running_helpers = ATOMIC_INIT(0);
+
+/*
+ * Wait queue head used by usermodehelper_pm_callback() to wait for all running
+ * helpers to finish.
+ */
+static DECLARE_WAIT_QUEUE_HEAD(running_helpers_waitq);
+
+/*
+ * Time to wait for running_helpers to become zero before the setting of
+ * usermodehelper_disabled in usermodehelper_pm_callback() fails
+ */
+#define RUNNING_HELPERS_TIMEOUT	(5 * HZ)
+
 static int usermodehelper_pm_callback(struct notifier_block *nfb,
 					unsigned long action,
 					void *ignored)
@@ -283,7 +299,15 @@ static int usermodehelper_pm_callback(st
 	case PM_HIBERNATION_PREPARE:
 	case PM_SUSPEND_PREPARE:
 		usermodehelper_disabled = 1;
-		return NOTIFY_OK;
+		wait_event_timeout(running_helpers_waitq,
+					atomic_read(&running_helpers) == 0,
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
@@ -293,6 +317,36 @@ static int usermodehelper_pm_callback(st
 	return NOTIFY_DONE;
 }
 
+static void new_helper(void)
+{
+	atomic_inc(&running_helpers);
+}
+
+static void helper_finished(void)
+{
+	if (atomic_dec_and_test(&running_helpers))
+		wake_up(&running_helpers_waitq);
+}
+
+#else /* CONFIG_PM */
+#define usermodehelper_disabled	0
+
+static inline int usermodehelper_pm_callback(struct notifier_block *nfb,
+						unsigned long action,
+						void *ignored)
+{
+	return 0;
+}
+
+static inline void new_helper(void)
+{
+}
+
+static inline void helper_finished(void)
+{
+}
+#endif /* CONFIG_PM */
+
 /**
  * call_usermodehelper_setup - prepare to call a usermode helper
  * @path - path to usermode executable
@@ -397,12 +451,13 @@ int call_usermodehelper_exec(struct subp
 	DECLARE_COMPLETION_ONSTACK(done);
 	int retval;
 
+	new_helper();
 	if (sub_info->path[0] == '\0') {
 		retval = 0;
 		goto out;
 	}
 
-	if (!khelper_wq || usermodehelper_disabled) {
+	if (!khelper_wq || (wait != UMH_NO_WAIT && usermodehelper_disabled)) {
 		retval = -EBUSY;
 		goto out;
 	}
@@ -418,6 +473,7 @@ int call_usermodehelper_exec(struct subp
 
   out:
 	call_usermodehelper_freeinfo(sub_info);
+	helper_finished();
 	return retval;
 }
 EXPORT_SYMBOL(call_usermodehelper_exec);
