Return-Path: <linux-kernel-owner+w=401wt.eu-S1760508AbYJITJx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760508AbYJITJx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 15:09:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754703AbYJITJp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 15:09:45 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:64192 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754894AbYJITJo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 15:09:44 -0400
Message-ID: <48EE56F3.9000001@2net.co.uk>
Date: Thu, 09 Oct 2008 20:09:39 +0100
From: Chris <chris@2net.co.uk>
Reply-To: chris@2net.co.uk
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [RFC] Kernel condition variables
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX19nViHchD2DR40wFp/w946YR/JGT3SCGMUv0oL
 5pfLnVRPaUVo1LN0Za/giDLJRAH7WgodpQaqO17yrTiAX/Zapo
 OtuY2ysgS30BZX603/nHlJclQBz0IB1fwxY1OYvpzI=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I would like to propose an addition to kernel synchronisation that does
something similar to a user-space POSIX condition variable. I have
included a rough patch below.

Why might this be a good idea? Right now if you have some code that is
waiting for a condition to become true and you want to protect the
evaluation of the condition you have to do something like this

Consumer:
	mutex_lock (&lock);
	while (!condition) {
		mutex_unlock (&lock);
		wait_event (wq, condition);
		mutex_lock (&lock);
	}
	/* do whatever */
	mutex_unlock (&lock);

Producer:
	mutex_lock (&lock);
	/* modify the condition: may be as simple as... */
	condition = 1;
	mutex_unlock (&lock);
	wake_up (&wq);

This is guaranteed against races because (a) wait_event checks the
condition and puts the task to sleep atomically and (b) we re-test the
condition with the mutex locked to make sure that multiple tasks have
not been released from the event and the first one to run has negated
the condition again, leaving the others with nothing to do but not
sleeping on the wait queue.

Here it is with my cond_wait instead of wait_event. The only change is
that the condition is tested first with the lock held in traditional
condvar style.

Consumer:
	mutex_lock (&lock);
	while (!condition)
		cond_wait (&wq, &lock);
	/* do whatever */
	mutex_unlock (&lock);

Producer:
	mutex_lock (&lock);
	/* modify the condition: may be as simple as... */
	condition = 1;
	mutex_unlock (&lock);
	wake_up (&wq);

cond_wait puts the task to sleep and then releases the mutex. When it
wakes up, the mutex is locked once more. This implementation is neater
and the condition is evaluated fewer times. But, the main difference is
that the condition variable makes you think through the locking
requirements, whereas wait_event allows you to be lazy.

Of course, there would have to be a family of cond_waits with variants
for interruptible sleep, timeout, and spin lock instead of mutex.

Here is the patch.


--- wait.h.orig	2008-10-08 16:53:48.000000000 +0100
+++ wait.h	2008-10-08 17:04:55.000000000 +0100
@@ -513,6 +513,26 @@ static inline int wait_on_bit_lock(void
  		return 0;
  	return out_of_line_wait_on_bit_lock(word, bit, action, mode);
  }
+
+/**
+ * cond_wait - wait for a condition to become true. The condition
+ * is tested before this call with the mutex locked.
+ * @wq: the wait queue to sleep on
+ * @mutex: a *locked* mutex
+ */
+void cond_wait (wait_queue_head_t *wq, struct mutex *mutex)
+{
+	DEFINE_WAIT(__wait);
+
+	prepare_to_wait(wq, &__wait, TASK_UNINTERRUPTIBLE);
+	mutex_unlock (mutex);
+	schedule();
+	mutex_lock (mutex);
+	finish_wait(wq, &__wait);
+}
  	
  #endif /* __KERNEL__ */


-- 
Chris Simmonds                   Embedded Linux engineer
2net Limited                     http://www.2net.co.uk/


