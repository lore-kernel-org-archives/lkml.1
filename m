Return-Path: <linux-kernel-owner+w=401wt.eu-S1755207AbZGBKic@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755207AbZGBKic (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 06:38:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752122AbZGBKiZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 06:38:25 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:40775 "EHLO
	t61.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751878AbZGBKiX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 06:38:23 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH] vt: add an event interface
To: lennart@poettering.net, linux-kernel@vger.kernel.org
Date: Thu, 02 Jul 2009 12:36:42 +0100
Message-ID: <20090702113529.4896.2321.stgit@t61.ukuu.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lennart how does this fit your needs - this replaces the existing wait
active hack with a race free one and adds other events with a proper
infrastructure for them.



From: Alan Cox <alan@linux.intel.com>

This is needed and requested in various forms for ConsoleKit, screenblank
handling and the like so do the job with a single interface. Also build the
interface so that unlike VT_WAITACTIVE and friends it won't miss events.

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/char/vt.c       |    4 +
 drivers/char/vt_ioctl.c |  181 ++++++++++++++++++++++++++++++++++-------------
 include/linux/vt.h      |   14 ++++
 include/linux/vt_kern.h |    3 +
 kernel/power/console.c  |    4 +
 5 files changed, 152 insertions(+), 54 deletions(-)


diff --git a/drivers/char/vt.c b/drivers/char/vt.c
index d9113b4..e3ddefa 100644
--- a/drivers/char/vt.c
+++ b/drivers/char/vt.c
@@ -251,7 +251,6 @@ static void notify_update(struct vc_data *vc)
 	struct vt_notifier_param param = { .vc = vc };
 	atomic_notifier_call_chain(&vt_notifier_list, VT_UPDATE, &param);
 }
-
 /*
  *	Low-Level Functions
  */
@@ -938,6 +937,7 @@ static int vc_do_resize(struct tty_struct *tty, struct vc_data *vc,
 
 	if (CON_IS_VISIBLE(vc))
 		update_screen(vc);
+	vt_event_post(VT_EVENT_RESIZE, vc->vc_num, vc->vc_num);
 	return err;
 }
 
@@ -3646,6 +3646,7 @@ void do_blank_screen(int entering_gfx)
 		blank_state = blank_vesa_wait;
 		mod_timer(&console_timer, jiffies + vesa_off_interval);
 	}
+	vt_event_post(VT_EVENT_BLANK, vc->vc_num, vc->vc_num);
 }
 EXPORT_SYMBOL(do_blank_screen);
 
@@ -3690,6 +3691,7 @@ void do_unblank_screen(int leaving_gfx)
 		console_blank_hook(0);
 	set_palette(vc);
 	set_cursor(vc);
+	vt_event_post(VT_EVENT_UNBLANK, vc->vc_num, vc->vc_num);
 }
 EXPORT_SYMBOL(do_unblank_screen);
 
diff --git a/drivers/char/vt_ioctl.c b/drivers/char/vt_ioctl.c
index 7539bed..c70eec8 100644
--- a/drivers/char/vt_ioctl.c
+++ b/drivers/char/vt_ioctl.c
@@ -61,6 +61,129 @@ extern struct tty_driver *console_driver;
 static void complete_change_console(struct vc_data *vc);
 
 /*
+ *	User space VT_EVENT handlers
+ */
+
+struct vt_event_wait {
+	struct list_head list;
+	struct vt_event event;
+	int done;
+};
+
+static LIST_HEAD(vt_events);
+static DEFINE_SPINLOCK(vt_event_lock);
+static DECLARE_WAIT_QUEUE_HEAD(vt_event_waitqueue);
+
+/**
+ *	vt_event_post
+ *	@event: the event that occurred
+ *	@old: old console
+ *	@new: new console
+ *
+ *	Post an VT event to interested VT handlers
+ */
+
+void vt_event_post(unsigned int event, unsigned int old, unsigned int new)
+{
+	struct list_head *pos, *head;
+	unsigned long flags;
+	int wake = 0;
+
+	spin_lock_irqsave(&vt_event_lock, flags);
+	head = &vt_events;
+
+	list_for_each(pos, head) {
+		struct vt_event_wait *ve = list_entry(pos,
+						struct vt_event_wait, list);
+		if (ve->event.event != event)
+			continue;
+		ve->event.old = old;
+		ve->event.new = new;
+		wake = 1;
+		ve->done = 1;
+	}
+	spin_unlock_irqrestore(&vt_event_lock, flags);
+	if (wake)
+		wake_up_interruptible(&vt_event_waitqueue);
+}
+
+/**
+ *	vt_event_wait		-	wait for an event
+ *	@vw: our event
+ *
+ *	Waits for an event to occur which completes our vt_event_wait
+ *	structure. On return the structure has wv->done set to 1 for success
+ *	or 0 if some event such as a signal ended the wait.
+ */
+
+static void vt_event_wait(struct vt_event_wait *vw)
+{
+	unsigned long flags;
+	/* Prepare the event */
+	INIT_LIST_HEAD(&vw->list);
+	vw->done = 0;
+	/* Queue our event */
+	spin_lock_irqsave(&vt_event_lock, flags);
+	list_add(&vw->list, &vt_events);
+	spin_unlock_irqrestore(&vt_event_lock, flags);
+	/* Wait for it to pass */
+	wait_event_interruptible(vt_event_waitqueue, vw->done);
+	/* Dequeue it */
+	spin_lock_irqsave(&vt_event_lock, flags);
+	list_del(&vw->list);
+	spin_unlock_irqrestore(&vt_event_lock, flags);
+}
+
+/**
+ *	vt_event_wait_ioctl	-	event ioctl handler
+ *	@arg: argument to ioctl
+ *
+ *	Implement the VT_WAITEVENT ioctl using the VT event interface
+ */
+
+static int vt_event_wait_ioctl(unsigned long arg)
+{
+	struct vt_event_wait vw;
+
+	if (copy_from_user(&vw.event, (void __user *)arg, sizeof(struct vt_event)))
+		return -EFAULT;
+	/* Highest supported event for now */
+	if(vw.event.event > VT_MAX_EVENT)
+		return -EINVAL;
+
+	vt_event_wait(&vw);
+	/* If it occurred report it */
+	if (vw.done) {
+		if(copy_to_user((void __user *)arg, &vw.event, sizeof(struct vt_event)))
+			return -EFAULT;
+		return 0;
+	}
+	return -EINTR;
+}
+
+/**
+ *	vt_event_wait_internal	-	internal event handler
+ *	@event: event code
+ *	@n: new console
+ *
+ *	Internal helper for event waits. Used to implement the legacy
+ *	event waiting ioctls in terms of events
+ */
+
+int vt_event_wait_internal(int event, int n)
+{
+	struct vt_event_wait vw;
+
+	vw.event.event = event;
+	do {
+		vt_event_wait(&vw);
+		if(vw.done == 0)
+			return -EINTR;
+	} while(n != -1 && n != vw.event.new);
+	return 0;
+}
+
+/*
  * these are the valid i/o ports we're allowed to change. they map all the
  * video ports
  */
@@ -359,6 +482,8 @@ do_unimap_ioctl(int cmd, struct unimapdesc __user *user_ud, int perm, struct vc_
 	return 0;
 }
 
+
+
 /*
  * We handle the console-specific ioctl's here.  We allow the
  * capability to modify any console, not just the fg_console. 
@@ -850,7 +975,7 @@ int vt_ioctl(struct tty_struct *tty, struct file * file,
 		if (arg == 0 || arg > MAX_NR_CONSOLES)
 			ret = -ENXIO;
 		else
-			ret = vt_waitactive(arg - 1);
+			ret = vt_event_wait_internal(VT_EVENT_SWITCH, arg);
 		break;
 
 	/*
@@ -1158,6 +1283,9 @@ int vt_ioctl(struct tty_struct *tty, struct file * file,
 		ret = put_user(vc->vc_hi_font_mask,
 					(unsigned short __user *)arg);
 		break;
+	case VT_WAITEVENT:
+		ret = vt_event_wait_ioctl(arg);
+		break;
 	default:
 		ret = -ENOIOCTLCMD;
 	}
@@ -1169,54 +1297,6 @@ eperm:
 	goto out;
 }
 
-/*
- * Sometimes we want to wait until a particular VT has been activated. We
- * do it in a very simple manner. Everybody waits on a single queue and
- * get woken up at once. Those that are satisfied go on with their business,
- * while those not ready go back to sleep. Seems overkill to add a wait
- * to each vt just for this - usually this does nothing!
- */
-static DECLARE_WAIT_QUEUE_HEAD(vt_activate_queue);
-
-/*
- * Sleeps until a vt is activated, or the task is interrupted. Returns
- * 0 if activation, -EINTR if interrupted by a signal handler.
- */
-int vt_waitactive(int vt)
-{
-	int retval;
-	DECLARE_WAITQUEUE(wait, current);
-
-	add_wait_queue(&vt_activate_queue, &wait);
-	for (;;) {
-		retval = 0;
-
-		/*
-		 * Synchronize with redraw_screen(). By acquiring the console
-		 * semaphore we make sure that the console switch is completed
-		 * before we return. If we didn't wait for the semaphore, we
-		 * could return at a point where fg_console has already been
-		 * updated, but the console switch hasn't been completed.
-		 */
-		acquire_console_sem();
-		set_current_state(TASK_INTERRUPTIBLE);
-		if (vt == fg_console) {
-			release_console_sem();
-			break;
-		}
-		release_console_sem();
-		retval = -ERESTARTNOHAND;
-		if (signal_pending(current))
-			break;
-		schedule();
-	}
-	remove_wait_queue(&vt_activate_queue, &wait);
-	__set_current_state(TASK_RUNNING);
-	return retval;
-}
-
-#define vt_wake_waitactive() wake_up(&vt_activate_queue)
-
 void reset_vc(struct vc_data *vc)
 {
 	vc->vc_mode = KD_TEXT;
@@ -1261,6 +1341,7 @@ void vc_SAK(struct work_struct *work)
 static void complete_change_console(struct vc_data *vc)
 {
 	unsigned char old_vc_mode;
+	int old = fg_console;
 
 	last_console = fg_console;
 
@@ -1324,7 +1405,7 @@ static void complete_change_console(struct vc_data *vc)
 	/*
 	 * Wake anyone waiting for their VT to activate
 	 */
-	vt_wake_waitactive();
+	vt_event_post(VT_EVENT_SWITCH, old, vc->vc_num);
 	return;
 }
 
diff --git a/include/linux/vt.h b/include/linux/vt.h
index 02c1c02..ba2c0f1 100644
--- a/include/linux/vt.h
+++ b/include/linux/vt.h
@@ -74,4 +74,18 @@ struct vt_consize {
 #define VT_UNLOCKSWITCH 0x560C  /* allow vt switching */
 #define VT_GETHIFONTMASK 0x560D  /* return hi font mask */
 
+struct vt_event {
+	unsigned int event;
+#define VT_EVENT_SWITCH		0	/* Console switch */
+#define VT_EVENT_BLANK		1	/* Screen blank */
+#define VT_EVENT_UNBLANK	2	/* Screen unblank */
+#define VT_EVENT_RESIZE		3	/* Resize display */
+#define VT_MAX_EVENT		3
+	unsigned int old;		/* Old console */
+	unsigned int new;		/* New console (if changing) */
+	unsigned int pad[4];		/* Padding for expansion */
+};
+
+#define VT_WAITEVENT	0x560E	/* Wait for an event */
+
 #endif /* _LINUX_VT_H */
diff --git a/include/linux/vt_kern.h b/include/linux/vt_kern.h
index 2f11134..5d78fc4 100644
--- a/include/linux/vt_kern.h
+++ b/include/linux/vt_kern.h
@@ -91,7 +91,8 @@ int con_copy_unimap(struct vc_data *dst_vc, struct vc_data *src_vc);
 #endif
 
 /* vt.c */
-int vt_waitactive(int vt);
+void vt_event_post(unsigned int event, unsigned int old, unsigned int new);
+int vt_event_wait_internal(int event, int n);
 void change_console(struct vc_data *new_vc);
 void reset_vc(struct vc_data *vc);
 extern int unbind_con_driver(const struct consw *csw, int first, int last,
diff --git a/kernel/power/console.c b/kernel/power/console.c
index a3961b2..0e41600 100644
--- a/kernel/power/console.c
+++ b/kernel/power/console.c
@@ -60,7 +60,7 @@ int pm_prepare_console(void)
 	}
 	release_console_sem();
 
-	if (vt_waitactive(SUSPEND_CONSOLE)) {
+	if (vt_event_wait_internal(VT_EVENT_SWITCH, SUSPEND_CONSOLE)) {
 		pr_debug("Suspend: Can't switch VCs.");
 		return 1;
 	}
@@ -79,7 +79,7 @@ void pm_restore_console(void)
 	set_console(orig_fgconsole);
 	release_console_sem();
 
-	if (vt_waitactive(orig_fgconsole)) {
+	if (vt_event_wait_internal(VT_EVENT_SWITCH, orig_fgconsole)) {
 		pr_debug("Resume: Can't switch VCs.");
 		return;
 	}

