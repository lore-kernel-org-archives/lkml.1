Return-Path: <linux-kernel-owner+w=401wt.eu-S1759639AbZF3AAU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759639AbZF3AAU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 20:00:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753184AbZF3AAG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 20:00:06 -0400
Received: from tango.0pointer.de ([85.214.72.216]:59170 "EHLO
	tango.0pointer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754446AbZF3AAF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 20:00:05 -0400
Date: Tue, 30 Jun 2009 02:00:04 +0200
From: Lennart Poettering <lennart@poettering.net>
To: linux-kernel@vger.kernel.org
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       William Jon McCann <jmccann@redhat.com>
Subject: [PATCH] vt: extend VT_WAITACTIVE ioctl to allow waiting until a
	specific VT becomes inactive
Message-ID: <20090630000003.GA21004@omega>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: Red Hat, Inc.
X-Campaign-1: ()  ASCII Ribbon Campaign
X-Campaign-2: /  Against HTML Email & vCards - Against Microsoft Attachments
User-Agent: Leviathan/19.8.0 [zh] (Cray 3; I; Solaris 4.711; Console)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, the VT_WAITACTIVE ioctl can be used to wait until a
specific VT becomes _active_. This is used by ConsoleKit to follow
which VT is the active one.  This patch extends this logic in a simple
way, so that it can be used to wait until a specific VT becomes
_inactive_.

If the argument passed to VT_WAITACTIVE is positive the current
behaviour (waiting until active) is exposed. However, if it is negative
the 'inverse' behaviour (waiting until inactive) is exposed.

Why all this?

Currently ConsoleKit creates 64 seperate threads, one for each
theoretical VT and calls VT_WAITACTIVE in them, once for each VT. It thus
will get a woken up once for each VT change. Having that many threads
around is certainly ugly and also racy, since multiple quick VT changes
might be processed in the wrong order. With this patch CK can simply call
VT_WAITACTIVE in a loop for whatever VT is currently considered active
and will then get a wakeup when it isn't anymore. Then it can reread the
current VT index and reenter VT_WAITACTIVE again. This allows CK to run
only one thread instead of 64 to watch the VT status and also fixes the
ordering race pointed out above.

How use this?

  /* this will wait until VT 5 is activated */
  ioctl(0, VT_WAITACTIVE, 5L);

  /* this will wait until VT 5 is deactivated again */
  ioctl(0, VT_WAITACTIVE, -5L);

ConsoleKit would probably just call it in a loop like this:

  for (;;) {
  	struct vt_stat st;
	ioctl(0, VT_GETSTATE, &st);
	printf("console %s is active.\n", st.v_active);
	ioctl(0, VT_WAITACTIVE, (signed long) - st.v_active);
  }

I tested this and it seems to work fine.

Signed-off-by: Lennart Poettering <lennart@poettering.net>
---
 drivers/char/vt_ioctl.c |   17 +++++++++++++----
 include/linux/vt_kern.h |    2 +-
 kernel/power/console.c  |    4 ++--
 3 files changed, 16 insertions(+), 7 deletions(-)

diff --git a/drivers/char/vt_ioctl.c b/drivers/char/vt_ioctl.c
index e6ce632..3fe8988 100644
--- a/drivers/char/vt_ioctl.c
+++ b/drivers/char/vt_ioctl.c
@@ -843,14 +843,22 @@ int vt_ioctl(struct tty_struct *tty, struct file * file,
 	/*
 	 * wait until the specified VT has been activated
 	 */
-	case VT_WAITACTIVE:
+	case VT_WAITACTIVE: {
+		signed long s_arg = arg;
+		bool active;
+
 		if (!perm)
 			goto eperm;
+
+		active = s_arg > 0;
+		arg = active ? s_arg : -s_arg;
+
 		if (arg == 0 || arg > MAX_NR_CONSOLES)
 			ret = -ENXIO;
 		else
-			ret = vt_waitactive(arg - 1);
+			ret = vt_waitactive(arg - 1, active);
 		break;
+	}
 
 	/*
 	 * If a vt is under process control, the kernel will not switch to it
@@ -1181,7 +1189,7 @@ static DECLARE_WAIT_QUEUE_HEAD(vt_activate_queue);
  * Sleeps until a vt is activated, or the task is interrupted. Returns
  * 0 if activation, -EINTR if interrupted by a signal handler.
  */
-int vt_waitactive(int vt)
+int vt_waitactive(int vt, bool active)
 {
 	int retval;
 	DECLARE_WAITQUEUE(wait, current);
@@ -1199,7 +1207,8 @@ int vt_waitactive(int vt)
 		 */
 		acquire_console_sem();
 		set_current_state(TASK_INTERRUPTIBLE);
-		if (vt == fg_console) {
+		if ((active && vt == fg_console) ||
+		   (!active && vt != fg_console)) {
 			release_console_sem();
 			break;
 		}
diff --git a/include/linux/vt_kern.h b/include/linux/vt_kern.h
index 2f11134..4d8a9b8 100644
--- a/include/linux/vt_kern.h
+++ b/include/linux/vt_kern.h
@@ -91,7 +91,7 @@ int con_copy_unimap(struct vc_data *dst_vc, struct vc_data *src_vc);
 #endif
 
 /* vt.c */
-int vt_waitactive(int vt);
+int vt_waitactive(int vt, bool active);
 void change_console(struct vc_data *new_vc);
 void reset_vc(struct vc_data *vc);
 extern int unbind_con_driver(const struct consw *csw, int first, int last,
diff --git a/kernel/power/console.c b/kernel/power/console.c
index a3961b2..146367e 100644
--- a/kernel/power/console.c
+++ b/kernel/power/console.c
@@ -60,7 +60,7 @@ int pm_prepare_console(void)
 	}
 	release_console_sem();
 
-	if (vt_waitactive(SUSPEND_CONSOLE)) {
+	if (vt_waitactive(SUSPEND_CONSOLE, true)) {
 		pr_debug("Suspend: Can't switch VCs.");
 		return 1;
 	}
@@ -79,7 +79,7 @@ void pm_restore_console(void)
 	set_console(orig_fgconsole);
 	release_console_sem();
 
-	if (vt_waitactive(orig_fgconsole)) {
+	if (vt_waitactive(orig_fgconsole, true)) {
 		pr_debug("Resume: Can't switch VCs.");
 		return;
 	}
-- 
1.6.3.2



Lennart

-- 
Lennart Poettering                        Red Hat, Inc.
lennart [at] poettering [dot] net         ICQ# 11060553
http://0pointer.net/lennart/           GnuPG 0x1A015CC4
