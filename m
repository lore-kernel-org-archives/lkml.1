Return-Path: <linux-kernel-owner+w=401wt.eu-S1753218AbXKVMr5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753218AbXKVMr5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2007 07:47:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752128AbXKVMrs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Nov 2007 07:47:48 -0500
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:55546 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751780AbXKVMrr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2007 07:47:47 -0500
Message-ID: <47457A68.7090901@bull.net>
Date: Thu, 22 Nov 2007 13:47:36 +0100
From: Gilles Carry <Gilles.Carry@bull.net>
User-Agent: Mozilla Thunderbird 1.0 (X11/20041206)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, libc-alpha@sources.redhat.com
Cc: Tim Chavez <tinytim@us.ibm.com>, Darren Hart <dvhltc@us.ibm.com>,
       Sripathi Kodi <sripathik@in.ibm.com>,
       Venkata Jagana <jagana@us.ibm.com>,
       =?ISO-8859-1?Q?S=E9bastien_Dugu=E9?= <sebastien.dugue@bull.net>,
       Jean-Pierre Dion <jean-pierre.dion@bull.net>,
       Gilles Carry <Gilles.Carry@bull.net>
Subject: RFC for PI condvars (requeue PI is back!)
X-MIMETrack: Itemize by SMTP Server on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 22/11/2007 13:54:57,
	Serialize by Router on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 22/11/2007 13:54:59,
	Serialize complete at 22/11/2007 13:54:59
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

A few months ago, the futex requeue pi patch was rejected because of some flaws.

I am now working on a PI-only implementation of condvars.
After some preliminary investigations, I would like to read your comments and
thoughts before I get too deeply into this. Please correct me if I am wrong
somewhere.

Source code: kernel/futex.c

Cond wait/signal/broadcast rely on a double futex system.
- The first (internal: cond->__data.__futex) where the waiters are pushed into
 (cond_wait) and popped out one by one (cond_signal). Let's call it Ftx_int.
- And the second (cond->__data.__mutex from the external mutex) where the
 broadcasted waiters are requeued to and then all popped out from,
 sequentially. Let's call it Ftx_ext.

Currently, condition variables only use non-pi futexes which causes a fifo
thread-wakening order.
To have priority-ordered thread wakening when broadcasting, we still need the
"requeue to PI" functionality. So Ftx_ext must be PI.
Also, pthread_cond_signal has yet no PI implementation. Users may expect a
consistent behaviour when using a unique PI condvars for signals and
broadcasts: priority order. This is why Ftx_int must also be PI.

Ftx_int:
- is only used as a stack and never needs to be owned in any way.
 pthread_cond_wait uses it to push in waiters (futex_wait).
- pthread_cond_signal uses it to pop out waiters (futex_wake) and wakening
 must be prio-ordered; this is why we need a PI-futex.

Ftx_ext:
- is used both by user to protect pthread_cond_* calls and by broadcast which
 requeues waiters to it.
- pthread_cond_broadcast uses it to requeue waiters from Ftx_int and
 eventually wake first waiter depending on Ftx_ext ownership:
       - not owned: make first waiter owner of Ftx_ext and wake it
       - externally owned: do nothing. The mutex unlocking (Ftx_ext) mechanism
	will wake the next waiter according to priority order.

>From all this, we can deduce the required new futex features to implement
wait/signal/broadcast PI conditions are: wait, wake and requeue.


Existing and wanted pi-futex features
-------------------------------------
FUTEX_LOCK_PI (existing)
	Try to get ownership of a futex.
	Queue as a waiter if fail to get ownership.
	Try to get ownership again when awakened.
FUTEX_WAIT_PI (wanted)
	Push self onto a futex and sleep but does not try to get ownership
	of the futex.
FUTEX_UNLOCK_PI (existing)
	Must be owner of futex. Release ownership and wake first waiter.
FUTEX_WAKE_PI (wanted)
	No need to be owner of futex. Wake first waiter.
FUTEX_REQUEUE_CMP_PI (wanted)
	Move waiters from a futex to another (f1->f2), wake and give
	onwership to first waiter if f2 not already owned.

Implementation
--------------
To make the code more maintainable and avoid redundancies, I'm thinking of
modifying the existing functions in order to match the new requirements:
- FUTEX_WAIT_PI calls futex_lock_pi in which the locking is disabled by a new
 argument in the function prototype,
- FUTEX_WAKE_PI calls futex_unlock_pi in which the unlocking of futex is
 disabled by a new argument in the function prototype.
Of course, the modifications of futex_lock_pi and futex_unlock_pi do not break
the behaviour when used in the original way.
- FUTEX_REQUEUE_CMP_PI uses a new function futex_requeue_cmp_pi which uses parts
of the above mentionned functions.


Rt_mutex needed new features
----------------------------
Source code: kernel/rtmutex.c
futex_*_pi functions map on rt_mutex calls which had to be modified in a
similar manneer:
- futex_lock_pi (wait) uses rt_mutex_enqueue, based on the modifed
 rt_mutex_slowlock.
- futex_unlock_pi (wake) uses rt_mutex_wake, based on the modifed
 rt_mutex_slowunlock.
- futex_cmp_requeue_pi uses rt_mutex_requeue (not impelmented yet) and
 rt_mutex_try2give_lock, based on the modified try_to_take_rt_mutex.


Libc modifications
------------------
Source code: glibc's nptl/pthread_cond_*
All functions pthread_cond* should be modified to handle these new features.


Libc interface modification
---------------------------
Condition's internal futex is currently non-pi. If we want priority order
wakeup, we must use a pi-futex. This could be guessed automatically when
calling pthread_cond_wait for the first time since second argument of the
function is the external mutex. We could then, at first call, choose an
internal futex of the same type as the external. Unfortunately,
pthread_cond_broadcast and pthread_cond_signal can be called before the very
first pthread_cond_wait and don't have the external mutex as argument. The
result would be a mess. The only solution is to have the user choose the type
of futex at pthread_cond_init. This must be the subject of an RFC because the
interface needs to be changed. (cond_attr stuff)



Thank-you for reading and commenting.

Gilles.

-- 

