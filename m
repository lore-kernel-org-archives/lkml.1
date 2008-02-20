Return-Path: <linux-kernel-owner+w=401wt.eu-S933886AbYBTVjq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933886AbYBTVjq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 16:39:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755667AbYBTVji
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 16:39:38 -0500
Received: from fg-out-1718.google.com ([72.14.220.152]:44773 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751847AbYBTVjh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 16:39:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=SI0oSP7Mn5GiThVBFQfXt0GvSA3rWRUFXODclcc7LWdEHzVGnlcZCZ3MJIZ1PW2duZVjwvMdIW5739sRAtv7xCSaeGJyOHUplHD5CjG4Diyy35sMxYvwSB0lBXB4oW4swxcAQc1KibO2YQHrUpmlSByvpaiA3zL/sLgk3B3vms0=
Subject: [PATCH 2/2] kthread: call wake_up_process() whithout the lock
	being held
From: Dmitry Adamushko <dmitry.adamushko@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Cc: Nick Piggin <nickpiggin@yahoo.com.au>, Ingo Molnar <mingo@elte.hu>,
       Rusty Russel <rusty@rustcorp.com.au>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andy Whitcroft <apw@shadowen.org>, dmitry.adamushko@gmail.com
Content-Type: text/plain
Date: Wed, 20 Feb 2008 22:39:32 +0100
Message-Id: <1203543572.6307.28.camel@earth>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dmitry Adamushko <dmitry.adamushko@gmail.com>
Subject: kthread: call wake_up_process() whithout the lock being held
    
- from the POV of synchronization, there should be no need to call wake_up_process()
with the 'kthread_create_lock' being held;
    
- moreover, in order to support a lockless check for list_empty(&kthread_create_list)
in kthreadd() :
    
 	set_current_state(TASK_INTERRUPTIBLE);
    	if (list_empty(&kthread_create_list))
    		schedule();
    
we must ensure that a modification of the list (i.e. list_add_tail()) has been completed
by the moment a state of the task is checked in try_to_wake_up().
i.e. they must not be re-ordered.
    
wake_up_process() (i.e. try_to_wake_up() effectively) doesn't provide a full mb.
By moving wake_up_process() out of the locked section, we get an UNLOCK/LOCK
pair (LOCK is in try_to_wake_up()) which is guaranteed to act as a full mb.
    
Signed-off-by: Dmitry Adamushko <dmitry.adamushko@gmail.com>


diff --git a/kernel/kthread.c b/kernel/kthread.c
index d7a7897..ec68e0f 100644
--- a/kernel/kthread.c
+++ b/kernel/kthread.c
@@ -158,9 +158,9 @@ struct task_struct *kthread_create(int (*threadfn)(void *data),
 
 	spin_lock(&kthread_create_lock);
 	list_add_tail(&create.list, &kthread_create_list);
-	wake_up_process(kthreadd_task);
 	spin_unlock(&kthread_create_lock);
 
+	wake_up_process(kthreadd_task);
 	wait_for_completion(&create.done);
 
 	if (!IS_ERR(create.result)) {


