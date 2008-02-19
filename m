Return-Path: <linux-kernel-owner+w=401wt.eu-S1763626AbYBSWw3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763626AbYBSWw3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 17:52:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762806AbYBSWwO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 17:52:14 -0500
Received: from wa-out-1112.google.com ([209.85.146.181]:37618 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762252AbYBSWwM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 17:52:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=tPAAKxDLB/Kwo6n+4imm8/WY+ClWehAugA46LTQ90iTez91Zx7OVG6CUBZp2zcPW17ki707U3+IohvARRP0OCuMH4r+95hXDzhB48M2r3LuW6uK8Y+fR6Lw/n8emM5DUdK489SUQWiHVuHhFN153d+VPsfTGi8hvWAdyMTqbB+E=
Message-ID: <b647ffbd0802191452j33d04868xcc36bdd36a1ecb07@mail.gmail.com>
Date: Tue, 19 Feb 2008 23:52:11 +0100
From: "Dmitry Adamushko" <dmitry.adamushko@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Re: [PATCH, RFC] kthread: (possibly) a missing memory barrier in kthread_stop()
Cc: "Nick Piggin" <nickpiggin@yahoo.com.au>, "Ingo Molnar" <mingo@elte.hu>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Rusty Russel" <rusty@rustcorp.com.au>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       "Andy Whitcroft" <apw@shadowen.org>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
       "Linus Torvalds" <torvalds@linux-foundation.org>
In-Reply-To: <b647ffbd0802190541k1428623fv23f000642c75d43b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1203375817.7619.73.camel@earth>
	 <200802191744.45281.nickpiggin@yahoo.com.au>
	 <1203413060.10858.82.camel@lappy>
	 <b647ffbd0802190541k1428623fv23f000642c75d43b@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

humm... following the same logic, there is also a problem in kthread.c.

(1) the main loop of kthreadd() :

                set_current_state(TASK_INTERRUPTIBLE);
                if (list_empty(&kthread_create_list))
                        schedule();

and

(2) kthread_create() does:

spin_lock(&kthread_create_lock);
list_add_tail(&create.list, &kthread_create_list);
wake_up_process(kthreadd_task);
spin_unlock(&kthread_create_lock);

provided,

- (1) doesn't want to take the 'kthread_create_lock' in order to do a
check for list_empty(&kthread_create_list)
[ which can be possible if list_empty() results in a single word-size
aligned read op. -- which is guaranteed to be atomic on any arch, iirc
]

and

- (1) and (2) can run in parallel.

then it's crucial that a modification of the list (i.e.
list_add_tail()) is completed by the moment a state of the task
(kthreadd_task->state) is checked in try_to_wake_up(). i.e. they must
not be re-ordered.

which makes me think that try_to_wake_up() could be better off just
acting as a full mb.

otherwise, a possible fix would be:

this way we get a pair of UNLOCK/LOCK which is guaranteed to be a full mb
(the LOCK is in try_to_wake_up())

[ moreover, there seems to be no need to call wake_up_process() with
'kthread_create_lock' being held ]

--- a/kernel/kthread.c
+++ b/kernel/kthread.c
@@ -145,8 +145,8 @@ struct task_struct *kthread_create(int
(*threadfn)(void *data),

        spin_lock(&kthread_create_lock);
        list_add_tail(&create.list, &kthread_create_list);
-       wake_up_process(kthreadd_task);
        spin_unlock(&kthread_create_lock);
+       wake_up_process(kthreadd_task);

        wait_for_completion(&create.done);


-- 
Best regards,
Dmitry Adamushko
