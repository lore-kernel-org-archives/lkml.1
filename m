Return-Path: <linux-kernel-owner+w=401wt.eu-S932610AbXLPXoc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932610AbXLPXoc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2007 18:44:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761776AbXLPXoY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Dec 2007 18:44:24 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:49626 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758948AbXLPXoX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2007 18:44:23 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Greg KH <greg@kroah.com>
Subject: Re: [stable] Linux 2.6.23.10
Date: Mon, 17 Dec 2007 01:03:46 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Chuck Ebbert <cebbert@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, stable@kernel.org
References: <20071214194952.GA15765@kroah.com> <200712150355.41763.rjw@sisk.pl> <20071215041200.GA3987@kroah.com>
In-Reply-To: <20071215041200.GA3987@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712170103.47097.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, 15 of December 2007, Greg KH wrote:
> On Sat, Dec 15, 2007 at 03:55:40AM +0100, Rafael J. Wysocki wrote:
> > On Saturday, 15 of December 2007, Rafael J. Wysocki wrote:
> > > On Saturday, 15 of December 2007, Chuck Ebbert wrote:
> > > > On 12/14/2007 08:52 PM, Rafael J. Wysocki wrote:
> > > > > On Saturday, 15 of December 2007, Chuck Ebbert wrote:
> > > > >> On 12/14/2007 02:49 PM, Greg Kroah-Hartman wrote:
> > > > >>>       Freezer: Fix APM emulation breakage
> > > > >> drivers/char/apm-emulation.c: In function 'apm_ioctl':
> > > > >> drivers/char/apm-emulation.c:370: error: implicit declaration of function 'wait_event_freezable'
> > > > >> make[2]: *** [drivers/char/apm-emulation.o] Error 1
> > > > >> make[1]: *** [drivers/char] Error 2
> > > > > 
> > > > > This is my fault, sorry.
> > > > > 
> > > > > I though the 2.6.24-rc fix would be suitable for 2.6.23.x, but that's not the
> > > > > case.
> > > > > 
> > > > > Greg, please revert the "Freezer: Fix APM emulation breakage" patch, I'll
> > > > > prepare a separate fix suitable for -stable.
> > > > > 
> > > > 
> > > > It works if you add the changes to freezer.h made in commit
> > > > e42837bcd35b75bb59ae5d3e62f87be1aeeb05c3
> > > 
> > > Yes, exactly, but a new patch is needed anyway.
> > > 
> > > Hmm, perhaps it's better to add a new patch on top of "Freezer: Fix APM
> > > emulation breakage"?  Would that be preferred?
> > 
> > For convenience, below is the patch that should fix the breakage when applied
> > on top of the "Freezer: Fix APM emulation breakage" patch.
> 
> Can you send me a whole new patch that works properly for the next
> 2.6.23-stable release?

Appended.

Thanks,
Rafael


---
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
---
 drivers/char/apm-emulation.c |   15 ++++++++-------
 include/linux/freezer.h      |   23 +++++++++++++++++++++++
 2 files changed, 31 insertions(+), 7 deletions(-)

Index: linux-2.6.23.y/include/linux/freezer.h
===================================================================
--- linux-2.6.23.y.orig/include/linux/freezer.h
+++ linux-2.6.23.y/include/linux/freezer.h
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
Index: linux-2.6.23.y/drivers/char/apm-emulation.c
===================================================================
--- linux-2.6.23.y.orig/drivers/char/apm-emulation.c
+++ linux-2.6.23.y/drivers/char/apm-emulation.c
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
