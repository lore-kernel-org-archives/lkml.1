Return-Path: <linux-kernel-owner+w=401wt.eu-S1758357AbZCYQwX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758357AbZCYQwX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 12:52:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753971AbZCYQvv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 12:51:51 -0400
Received: from mail-bw0-f169.google.com ([209.85.218.169]:35152 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751756AbZCYQvs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 12:51:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=FsZDuhAjzenxWcplSKuE9wx2KJE+fwm0P20M7FzDU5AYTfht+hU0hrYJWAE4vkvGe9
         3NeNvocX+mTcqODfgYXm3JDVCSWz9901wbfVUTb3OqBV1fM118r+C69KuXMp9fI/2X04
         fRc2V9PgBzBpMClxqAMTcamzX5EI/I8Ddi54Y=
MIME-Version: 1.0
Date: Wed, 25 Mar 2009 12:51:44 -0400
Message-ID: <8044b6ad0903250951w3b843e6etd6ec866404dbe455@mail.gmail.com>
Subject: [PATCH] ioctl interface to wait on VT switch
From: "D. Matt Placek" <dmattplacek@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the 2.6.29 kernel which adds an ioctl to the VT
interface which allows an application to wait on any VT switch, rather
than having to wait on switching to a specific VT.  This would be a
big help for the ConsoleKit, which currently creates 60+ threads where
each thread is asleep waiting for a switch to one of every possible
VT.  It would be great if we could get this included in the kernel- or
if there is a better approach feedback is invited.  It would simply be
nice not to have to spawn 60 threads just to wait for a console
switch, and this is a pretty minor addition to the VT system.


diff -U 3 -r linux-2.6.29-rc8/drivers/char/vt_ioctl.c
patched-linux-2.6.29-rc8/drivers/char/vt_ioctl.c
--- linux-2.6.29-rc8/drivers/char/vt_ioctl.c	2009-03-12 22:39:28.000000000 -0400
+++ patched-linux-2.6.29-rc8/drivers/char/vt_ioctl.c	2009-03-25
12:35:42.000000000 -0400
@@ -41,6 +41,8 @@
 #define VT_IS_IN_USE(i)	(console_driver->ttys[i] &&
console_driver->ttys[i]->count)
 #define VT_BUSY(i)	(VT_IS_IN_USE(i) || i == fg_console ||
vc_cons[i].d == sel_cons)

+#define WAIT_ANY_CONSOLE -1234
+
 /*
  * Console (vt and kd) routines, as defined by USL SVR4 manual, and by
  * experimentation and study of X386 SYSV handling.
@@ -846,6 +848,13 @@
 			ret = vt_waitactive(arg - 1);
 		break;

+
+	case VT_WAITSWITCH:
+		if (!perm)
+			goto eperm;
+      ret = vt_waitactive(WAIT_ANY_CONSOLE);
+		break;
+
 	/*
 	 * If a vt is under process control, the kernel will not switch to it
 	 * immediately, but postpone the operation until the process calls this
@@ -1202,6 +1211,11 @@
 		if (signal_pending(current))
 			break;
 		schedule();
+
+      if (vt == WAIT_ANY_CONSOLE) {
+         retval = 0;
+         break;
+      }
 	}
 	remove_wait_queue(&vt_activate_queue, &wait);
 	__set_current_state(TASK_RUNNING);
diff -U 3 -r linux-2.6.29-rc8/include/linux/vt.h
patched-linux-2.6.29-rc8/include/linux/vt.h
--- linux-2.6.29-rc8/include/linux/vt.h	2009-03-12 22:39:28.000000000 -0400
+++ patched-linux-2.6.29-rc8/include/linux/vt.h	2009-03-24
11:16:31.000000000 -0400
@@ -73,5 +73,6 @@
 #define VT_LOCKSWITCH   0x560B  /* disallow vt switching */
 #define VT_UNLOCKSWITCH 0x560C  /* allow vt switching */
 #define VT_GETHIFONTMASK 0x560D  /* return hi font mask */
+#define VT_WAITSWITCH    0x560E	/* wait for change in active vt */

 #endif /* _LINUX_VT_H */
