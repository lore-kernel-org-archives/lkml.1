Return-Path: <linux-kernel-owner+w=401wt.eu-S1754615AbXFXUUL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754615AbXFXUUL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2007 16:20:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752230AbXFXUT4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jun 2007 16:19:56 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:36900 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751433AbXFXUTz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2007 16:19:55 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: [RC][PATCH -mm] PM: Prevent frozen user mode helpers from failing the freezing of tasks
Date: Sun, 24 Jun 2007 22:26:38 +0200
User-Agent: KMail/1.9.5
Cc: LKML <linux-kernel@vger.kernel.org>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Uli Luckas <u.luckas@road.de>,
       pm list <linux-pm@lists.linux-foundation.org>
References: <200706221647.50509.rjw@sisk.pl> <200706222347.55717.rjw@sisk.pl> <20070624170514.GA21757@elf.ucw.cz>
In-Reply-To: <20070624170514.GA21757@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706242226.39665.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sunday, 24 June 2007 19:05, Pavel Machek wrote:
> Hi!
> 
> > > > Special thanks to Uli Luckas <u.luckas@road.de> for reviewing the previous
> > > > versions of this patch and for very useful comments.
> > > ...
> > > > Reviewed-by: Pavel Machek <pavel@ucw.cz>
> > > 
> > > Eh, not sure this header is worth anything. Sometimes I'm lazy and
> > > stop when I see first problem.
> > > 
> > > >  	switch (action) {
> > > >  	case PM_HIBERNATION_PREPARE:
> > > >  	case PM_SUSPEND_PREPARE:
> > > >  		usermodehelper_disabled = 1;
> > > > -		return NOTIFY_OK;
> > > > +		retval = wait_event_timeout(running_helpers_waitq,
> > > > +					atomic_read(&running_helpers) == 0,
> > > 
> > > Are you sure here? What happens when atomic variable changes between
> > > the atomic_read and the function call?
> > 
> > Er, this is a macro. :-)
> > 
> > In fact we rely only on atomic_read(&running_helpers) being still zero after
> > helper_finished() has woken us up, but I think that's acceptable.
> > 
> > IOW, if the wait_event_timeout() returns with retval different from zero, this
> > means that atomic_read(&running_helpers) returned zero at one point after
> > we'd set usermodehelper_disabled, which is enough.  OTOH, if it doesn't
> 
> Ok, can you write short comment explaining that? /* We have set
> usermodehelper_disabled, so any new usermode helpers are not a problem
> */.

OK, please have a look at the updated patch below.

Greetings,
Rafael

---
From: Rafael J. Wysocki <rjw@sisk.pl>

At present, if a user mode helper is running while usermodehelper_pm_callback()
is executed, the helper may be frozen and the completion in
call_usermodehelper_exec() won't be completed until user space processes are
thawed.  As a result, the freezing of kernel threads may fail, which is not
desirable.

Prevent this from happening by introducing a counter of running user mode
helpers and allowing usermodehelper_pm_callback() to succeed for
action = PM_HIBERNATION_PREPARE or action = PM_SUSPEND_PREPARE only if there
are no helpers running.  [Namely, usermodehelper_pm_callback() waits for at most
RUNNING_HELPERS_TIMEOUT for the number of running helpers to become zero and
fails if that doesn't happen.]

Special thanks to Uli Luckas <u.luckas@road.de> for reviewing the previous
versions of this patch and for very useful comments.

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
@@ -275,15 +267,54 @@ static void __call_usermodehelper(struct
 	}
 }
 
+#ifdef CONFIG_PM
+/*
+ * If set, call_usermodehelper_exec() will exit immediately returning -EBUSY
+ * (used for preventing user land processes from being created after the user
+ * land has been frozen during a system-wide hibernation or suspend operation).
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
 {
+	long retval;
+
 	switch (action) {
 	case PM_HIBERNATION_PREPARE:
 	case PM_SUSPEND_PREPARE:
 		usermodehelper_disabled = 1;
-		return NOTIFY_OK;
+		/*
+		 * From now on call_usermodehelper_exec() won't start any new
+		 * helpers, so it is sufficient if running_helpers turns out to
+		 * be zero at one point (it may be increased later, but that
+		 * doesn't matter).
+		 */
+		retval = wait_event_timeout(running_helpers_waitq,
+					atomic_read(&running_helpers) == 0,
+					RUNNING_HELPERS_TIMEOUT);
+		if (retval) {
+			return NOTIFY_OK;
+		} else {
+			usermodehelper_disabled = 0;
+			return NOTIFY_BAD;
+		}
 	case PM_POST_HIBERNATION:
 	case PM_POST_SUSPEND:
 		usermodehelper_disabled = 0;
@@ -293,6 +324,29 @@ static int usermodehelper_pm_callback(st
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
+static void register_pm_notifier_callback(void)
+{
+	pm_notifier(usermodehelper_pm_callback, 0);
+}
+#else /* CONFIG_PM */
+#define usermodehelper_disabled	0
+
+static inline void new_helper(void) {}
+static inline void helper_finished(void) {}
+static inline void register_pm_notifier_callback(void) {}
+#endif /* CONFIG_PM */
+
 /**
  * call_usermodehelper_setup - prepare to call a usermode helper
  * @path - path to usermode executable
@@ -397,6 +451,7 @@ int call_usermodehelper_exec(struct subp
 	DECLARE_COMPLETION_ONSTACK(done);
 	int retval;
 
+	new_helper();
 	if (sub_info->path[0] == '\0') {
 		retval = 0;
 		goto out;
@@ -418,6 +473,7 @@ int call_usermodehelper_exec(struct subp
 
   out:
 	call_usermodehelper_freeinfo(sub_info);
+	helper_finished();
 	return retval;
 }
 EXPORT_SYMBOL(call_usermodehelper_exec);
@@ -459,5 +515,5 @@ void __init usermodehelper_init(void)
 {
 	khelper_wq = create_singlethread_workqueue("khelper");
 	BUG_ON(!khelper_wq);
-	pm_notifier(usermodehelper_pm_callback, 0);
+	register_pm_notifier_callback();
 }
