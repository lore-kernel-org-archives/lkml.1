Return-Path: <linux-kernel-owner+w=401wt.eu-S1765626AbYBTVgo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765626AbYBTVgo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 16:36:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752841AbYBTVgg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 16:36:36 -0500
Received: from wx-out-0506.google.com ([66.249.82.230]:11735 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751299AbYBTVgf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 16:36:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=Bw8K+/i65hd0hHkp7wZIm2JeB3WSiqrdv+Wdbvr2KCXRLL3W99s81z6k6PmBmSn/zWrMJME1Cod9nBomP5eb7E+CShG6jWmkxRaOK65Mh05CB//0WMMRHJMsdPBcw2VYdPb0cMkljqvz8+gTHsbdCWzlDkHpAvoltC5ohHobssY=
Subject: [PATCH 1/2] kthread: add a missing memory barrier to kthread_stop()
From: Dmitry Adamushko <dmitry.adamushko@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Cc: Nick Piggin <nickpiggin@yahoo.com.au>, Ingo Molnar <mingo@elte.hu>,
       Rusty Russel <rusty@rustcorp.com.au>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andy Whitcroft <apw@shadowen.org>, dmitry.adamushko@gmail.com
Content-Type: text/plain
Date: Wed, 20 Feb 2008 22:36:30 +0100
Message-Id: <1203543390.6307.24.camel@earth>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dmitry Adamushko <dmitry.adamushko@gmail.com>
Subject: kthread: add a missing memory barrier to kthread_stop()
    
We must ensure that kthread_stop_info.k has been updated before
kthread's wakeup. This is required to properly support
the use of kthread_should_stop() in the main loop of kthread.
    
wake_up_process() doesn't imply a full memory barrier,
so we add an explicit one.
    
There is a requirement on how a main loop of kthread has to be orginized.
    
Namely, the sequence of events that lead to kthread being blocked (schedule())
has to be ordered as follows:
    
- set_current_state(TASK_INTERRUPTIBLE);
- if (kthread_should_stop()) break;
- schedule() or similar.
    
set_current_state() implies a full memory barrier, so this is
a matching barrier on the side of kthread_should_stop().
    
Signed-off-by: Dmitry Adamushko <dmitry.adamushko@gmail.com>


diff --git a/kernel/kthread.c b/kernel/kthread.c
index 45f8b83..86b69a0 100644
--- a/kernel/kthread.c
+++ b/kernel/kthread.c
@@ -53,6 +53,19 @@ static struct kthread_stop_info kthread_stop_info;
  * When someone calls kthread_stop() on your kthread, it will be woken
  * and this will return true.  You should then return, and your return
  * value will be passed through to kthread_stop().
+ *
+ * In order to safely use kthread_stop() for kthread, there is a requirement
+ * on how its main loop has to be orginized. Namely, the sequence of
+ * events that lead to kthread being blocked (schedule()) has to be
+ * ordered as follows:
+ *
+ * - set_current_state(TASK_INTERRUPTIBLE);
+ * - if (kthread_should_stop()) break;
+ * - schedule() or similar.
+ *
+ * set_current_state() implies a full memory barrier. kthread_stop()
+ * has a matching barrier right after an update of kthread_stop_info.k
+ * and before kthread's wakeup.
  */
 int kthread_should_stop(void)
 {
@@ -211,6 +224,15 @@ int kthread_stop(struct task_struct *k)
 
 	/* Now set kthread_should_stop() to true, and wake it up. */
 	kthread_stop_info.k = k;
+
+	/* 
+	 * We must ensure that kthread_stop_info.k has been updated before
+	 * the following wakeup. This is required to properly support the use
+	 * of kthread_should_stop() in the main loop of kthread
+	 * (see description of kthread_should_stop() for more details).
+	 */
+	smp_mb();
+
 	wake_up_process(k);
 	put_task_struct(k);
 


