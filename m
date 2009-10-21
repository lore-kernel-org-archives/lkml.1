Return-Path: <linux-kernel-owner+w=401wt.eu-S1751330AbZJUXVu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751330AbZJUXVu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Oct 2009 19:21:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750896AbZJUXVt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Oct 2009 19:21:49 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:49477 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750884AbZJUXVt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Oct 2009 19:21:49 -0400
Subject: [RFC][PATCH] Add prctl to set sibling thread names
From: john stultz <johnstul@us.ibm.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: lkml <linux-kernel@vger.kernel.org>, Mike Fulton <fultonm@ca.ibm.com>,
       Sean Foley <Sean_Foley@ca.ibm.com>, Darren Hart <dvhltc@us.ibm.com>
Content-Type: text/plain
Date: Wed, 21 Oct 2009 16:21:37 -0700
Message-Id: <1256167297.4768.14.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Taking a very raw attempt at this, I scratched out the following simple
implementation. I'd appreciate any review or suggestions for
improvements. I'm not at all certain the passing of the thread pid_t
through the unsigned long is valid, for instance, or if
same_thread_group() is the right check to make sure we only change
siblings and not tid from other processes. So any advice on better
approaches would be great.

thanks
-john

========================

Setting a thread's comm to be something unique is a very useful ability
and is helpful for debugging complicated threaded applications. However
currently the only way to set a thread name is for the thread to name
itself via the PR_SET_NAME prctl.

However, there may be situations where it would be advantageous for a
thread dispatcher to be naming the threads its managing, rather then
having the threads self-describe themselves. This sort of behavior is
available on other systems via the pthread_setname_np() interface.

This patch allows a thread to name its sibling threads via a new
PR_SET_THREAD_NAME prctrl.

Signed-off-by: John Stultz <johnstul@us.ibm.com>

diff --git a/include/linux/prctl.h b/include/linux/prctl.h
index 9311505..2726527 100644
--- a/include/linux/prctl.h
+++ b/include/linux/prctl.h
@@ -52,6 +52,7 @@
 
 #define PR_SET_NAME    15		/* Set process name */
 #define PR_GET_NAME    16		/* Get process name */
+#define PR_SET_THREAD_NAME    17	/* Set sibling thread name */
 
 /* Get/set process endian */
 #define PR_GET_ENDIAN	19
diff --git a/kernel/sys.c b/kernel/sys.c
index 255475d..d25851a 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -1506,6 +1506,27 @@ SYSCALL_DEFINE5(prctl, int, option, unsigned long, arg2, unsigned long, arg3,
 					 sizeof(comm)))
 				return -EFAULT;
 			return 0;
+		case PR_SET_THREAD_NAME:
+		{
+			struct task_struct *tsk;
+			pid_t tid;
+
+			comm[sizeof(me->comm)-1] = 0;
+			tid = (pid_t)arg2;
+			if (strncpy_from_user(comm, (char __user *)arg3,
+					      sizeof(me->comm) - 1) < 0)
+				return -EFAULT;
+
+			tsk = get_pid_task(find_get_pid(tid), PIDTYPE_PID);
+			if (!tsk)
+				return -EINVAL;
+
+			if (!same_thread_group(me, tsk))
+				return -EINVAL;
+
+			set_task_comm(tsk, comm);
+			return 0;
+		}
 		case PR_GET_ENDIAN:
 			error = GET_ENDIAN(me, arg2);
 			break;


