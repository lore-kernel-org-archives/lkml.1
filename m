Return-Path: <linux-kernel-owner+w=401wt.eu-S932709AbYBGAOX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932709AbYBGAOX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 19:14:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932179AbYBFX6I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 18:58:08 -0500
Received: from ns1.suse.de ([195.135.220.2]:46198 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932144AbYBFX6G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 18:58:06 -0500
Date: Wed, 6 Feb 2008 15:53:21 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, Greg KH <greg@kroah.com>
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: [patch 41/73] Freezer: Fix APM emulation breakage
Message-ID: <20080206235321.GP13121@suse.de>
References: <20080206234302.769849277@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="freezer-fix-apm-emulation-breakage.patch"
In-Reply-To: <20080206235015.GA13121@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.23-stable review patch.  If anyone has any objections, please let us know.
------------------
From: Rafael J. Wysocki <rjw@sisk.pl>

The APM emulation is currently broken as a result of commit
831441862956fffa17b9801db37e6ea1650b0f69
"Freezer: make kernel threads nonfreezable by default"
that removed the PF_NOFREEZE annotations from apm_ioctl() without
adding the appropriate freezer hooks.  Fix it and remove the
unnecessary variable flags from apm_ioctl().

This problem has been fixed in the mainline by
commit cb43c54ca05c01533c45e4d3abfe8f99b7acf624
"Freezer: Fix APM emulation breakage".

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/char/apm-emulation.c |   15 ++++++++-------
 include/linux/freezer.h      |   23 +++++++++++++++++++++++
 2 files changed, 31 insertions(+), 7 deletions(-)

--- a/drivers/char/apm-emulation.c
+++ b/drivers/char/apm-emulation.c
@@ -295,7 +295,6 @@ static int
 apm_ioctl(struct inode * inode, struct file *filp, u_int cmd, u_long arg)
 {
 	struct apm_user *as = filp->private_data;
-	unsigned long flags;
 	int err = -EINVAL;
 
 	if (!as->suser || !as->writer)
@@ -331,10 +330,16 @@ apm_ioctl(struct inode * inode, struct f
 			 * Wait for the suspend/resume to complete.  If there
 			 * are pending acknowledges, we wait here for them.
 			 */
-			flags = current->flags;
+			freezer_do_not_count();
 
 			wait_event(apm_suspend_waitqueue,
 				   as->suspend_state == SUSPEND_DONE);
+
+			/*
+			 * Since we are waiting until the suspend is done, the
+			 * try_to_freeze() in freezer_count() will not trigger
+			 */
+			freezer_count();
 		} else {
 			as->suspend_state = SUSPEND_WAIT;
 			mutex_unlock(&state_lock);
@@ -362,14 +367,10 @@ apm_ioctl(struct inode * inode, struct f
 			 * Wait for the suspend/resume to complete.  If there
 			 * are pending acknowledges, we wait here for them.
 			 */
-			flags = current->flags;
-
-			wait_event_interruptible(apm_suspend_waitqueue,
+			wait_event_freezable(apm_suspend_waitqueue,
 					 as->suspend_state == SUSPEND_DONE);
 		}
 
-		current->flags = flags;
-
 		mutex_lock(&state_lock);
 		err = as->suspend_result;
 		as->suspend_state = SUSPEND_NONE;
--- a/include/linux/freezer.h
+++ b/include/linux/freezer.h
@@ -4,6 +4,7 @@
 #define FREEZER_H_INCLUDED
 
 #include <linux/sched.h>
+#include <linux/wait.h>
 
 #ifdef CONFIG_PM_SLEEP
 /*
@@ -126,6 +127,24 @@ static inline void set_freezable(void)
 	current->flags &= ~PF_NOFREEZE;
 }
 
+/*
+ * Freezer-friendly wrapper around wait_event_interruptible(), originally
+ * defined in <linux/wait.h>
+ */
+
+#define wait_event_freezable(wq, condition)				\
+({									\
+	int __retval;							\
+	do {								\
+		__retval = wait_event_interruptible(wq, 		\
+				(condition) || freezing(current));	\
+		if (__retval && !freezing(current))			\
+			break;						\
+		else if (!(condition))					\
+			__retval = -ERESTARTSYS;			\
+	} while (try_to_freeze());					\
+	__retval;							\
+})
 #else /* !CONFIG_PM_SLEEP */
 static inline int frozen(struct task_struct *p) { return 0; }
 static inline int freezing(struct task_struct *p) { return 0; }
@@ -143,6 +162,10 @@ static inline void freezer_do_not_count(
 static inline void freezer_count(void) {}
 static inline int freezer_should_skip(struct task_struct *p) { return 0; }
 static inline void set_freezable(void) {}
+
+#define wait_event_freezable(wq, condition)				\
+		wait_event_interruptible(wq, condition)
+
 #endif /* !CONFIG_PM_SLEEP */
 
 #endif	/* FREEZER_H_INCLUDED */

-- 
