Return-Path: <linux-kernel-owner+w=401wt.eu-S1753288AbYHKOtr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753288AbYHKOtr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 10:49:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751189AbYHKOtk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 10:49:40 -0400
Received: from ms01.sssup.it ([193.205.80.99]:55965 "EHLO sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751095AbYHKOtj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 10:49:39 -0400
Subject: [RFC 0/1][PATCH] POSIX SCHED_SPORADIC implementation for tasks and
	groups
From: Dario Faggioli <raistlin@linux.it>
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>, Andrew Morton <akpm@osdl.org>,
       Ulrich Drepper <drepper@redhat.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-hfOsGKC16aP9rOIG3dfu"
Date: Mon, 11 Aug 2008 15:49:34 +0200
Message-Id: <1218462574.6450.24.camel@Palanthas>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-hfOsGKC16aP9rOIG3dfu
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi everybody,

I'm spending some time implementing the POSIX real-time SCHED_SPORADIC
scheduling policy on top of the mainline Linux kernel, and here it is
the code in its very first version.

Please, notice that it's still in preliminary status, group interface is
only a stub, and it may suffer of some issues, especially on SMP
systems.
So, why am I "releasing" it? Because, before going on, I'm interested in
hearing what do you think of it, if it is useful or not, if you think it
could be designed and written somehow different, and so on.

Also, since group and SMP scheduling are not even mentioned in the POSIX
specification, I think some discussion about them is needed if you want
(me) to go ahead on this path.

Well, all this given, let me try to briefly summarize what
SCHED_SPORADIC scheduling is, what it does mean for tasks and groups and
why I think it could be useful.

* The Sporadic Server in real-time theory
 I don't think this mail is the very right place where to go into
 details describing real-time systems theory, so I'll keep it very
 short.

 Let me just say that the so called Sporadic Server (SS), which POSIX
 SCHED_SPORADIC somehow mimics, is one of the preferred mechanisms to
 serve aperiodic or sporadic tasks in a periodic task-based fixed
 priority real-time system.
 It has been proposed by Sprunt et al. in '89 [1] to achieve two main
 goals:
 - reduce to the minimum the interference with the fixed priority
   periodic task scheduling analysis;
 - get fast (and, obviously, guaranteed!) aperiodic/sporadic response
   time, at least comparable with its competitor algorithms.
 Its main competitors were/are the Polling Server (PS) and the Deferable
 Server (DS) [2](*).
 Again, I'm not going into details of any of them but, indeed, the DS is
 not that far from what Linux now has for real-time task group
 throttling.

 As you can see below the rules the SS follows seems quite tricky, but
 the benefit it introduces could make it worthwhile to give it a
 chance! :-P

* The POSIX SCHED_SPORADIC policy
 The best source of information about the POSIX real-time (optional)
 scheduling policy called SCHED_SPORADIC is, I think, the Open Group
 specification document itself [3]. Also, the QNX documentation [4],
 since QNX supports SCHED_SPORADIC, is in my opinion very well written.

 Anyway, here they are some extracts from the POSIX specs, just in the
 case you want to look at the code but you have no time or will to go
 through the links. :-)

 "The policy is based primarily on the replenishment period =20
  (sched_ss_repl_period) and the execution capacity
  (sched_ss_init_budget)."
 "The policy is identical to SCHED_FIFO with conditions that cause
  priority to be switched between sched_priority and
  sched_ss_low_priority."
 "The priority of a thread is: if the execution capacity is greater than
  zero and the number of pending replenishment is less than
  sched_ss_max_repl, it is sched_priority; otherwise, priority shall be
  sched_ss_low_priority."
 "The modification of the available execution capacity and is done as
  follows:
  1. When a thread becomes running, its execution time shall be limited
     to at most its execution capacity.
  2. Each time the thread is inserted at the tail of the list associated
     with sched_priority -because it became runnable or because of a
     replenishment operation- the time is posted as the activation_time.
  3. When the running thread with sched_priority becomes preempted, the
     execution time consumed is subtracted from the execution capacity.
  4. When the running thread with sched_priority becomes blocked, the=20
     execution time consumed is subtracted from the execution capacity,
     and a replenishment operation is scheduled.
  5. When the running thread with sched_priority reaches its execution
     time limit, it becomes the tail of the list for
     sched_ss_low_priority. The execution time consumed is subtracted
     and a replenishment operation is scheduled.
  6. Each time a replenishment is scheduled, the replenish_amount is set
     equal to the execution time consumed since the activation_time. The
     replenishment is scheduled at activation_time plus
     sched_ss_repl_period (immediately if this is in the past).
     The number of replenishment simultaneously pending shall not be
     greater than sched_ss_max_repl.
  7. A replenishment consists of adding replenish_amount to the
     execution capacity. If the thread was sched_ss_low_priority, then
     it becomes sched_priority."

 As you can see, the scheduling policy behave exactly the same as
 SCHED_FIFO with respect to non RT tasks, but may affect which RT task
 is going to be the running one, by continuously changing the priority
 of SCHED_SPORADIC ones.

* POSIX SCHED_SPORADIC group scheduling
 For groups, POSIX does not say anything about them (we know group
 scheduling is out of the POSIX specs), but I think everyone can see
 that a policy like this applied to task groups could realize something
 similar to what you have and you call throttling.
 In the code below I applied the rules of SCHED_SPORADIC also to task
 groups (if configured!) with the following semantic:
 a. a task group becomes blocked iff it contains no tasks or other
    task groups to be scheduled in its runqueue;
 b. a task group unblocks/wake up when a task and/or a task group is
    queued to its runqueue;

 A said before, you are presently throttling real-time task groups by
 something very similar to the Deferrable Server.
 The main concern against DS is schedulability. In fact, when you have a
 fixed priority _periodic-task_ based real-time system, you have a
 particular subset of task sets that are schedulable, and tests exists
 to find out if a given task set is going to be schedulable (no deadline
 miss!) or not.
 Now, the problem is that, when you add a DS(-like mechanism) the subset
 of task sets that are guaranteed to be schedulable, i.e., that are
 going to pass the scheduling test, could be reduced.
 If you prefer, we can reprhase this like that: the scheduling test
 should be modified to reject more task sets than before, otherwise
 schedulability without deadline misses is no longer guaranteed.

 Conversely, while using SS, which is more or less what the code tries
 to do, thanks to the complicated but effective replenishment rules, the
 schedulable region does not decreases that much.
 More precisely, each Sporadic Servers behaves, for scheduling test
 purposes, just like it is another real-time periodic task, which is
 definitely not true for different approaches!

 Math could appear quite tricky, especially for non real-time
 theorists (which I definitely am not!! :-D)... But let me know if you
 want me to try to cut&paste them here...

* Why SCHED_SPORADIC in Linux
 Well, I started implementing the POSIX SCHED_SPORADIC policy in the
 Linux kernel first of all for fun, as well as to get in touch with
 kernel programming, which is something that I always wanted to, and
 also because this is part of my work as a PhD Student in real-time
 systems... :-)

 This given, I decided to let all of you aware about that because of the
 following reasons:
 - it seems to me that there is some interest in this scheduling policy,
   at least from the academic and research community, e.g., our Lab
   (ReTiS Lab, Scuola Superiore Sant'Anna, Pisa [5]) or the Florida
   State University (FSU [6](**)).
   Other implementation are also been attempted but, AFAIK, code is not
   available or, if it is hanging around the Web, it is based on old=20
   versions of Linux (or RTLinux!).
 - it is a feature of the POSIX specifications that Linux is not
   supporting yet!
   Ok, it is optional, but I think it could be useful, especially
   considering that there are very few other OSs supporting it, i.e.,
   only QNX and RTEMS (and, but I'm not sure, OpenSolaris).
 - the extension of the policy to group scheduling, which is in place in
   the code, could be a valid alternative for throttling real-time task
   groups, providing different guarantees. As said, throttling using SS
   instead of DS (which is, I repeat, very similar to what you are doing
   now), could result in comparable performances but with better
   scheduling capabilities for the user, and this, I think, could be
   appreciated by the real-time systems designers.

* Schedulability Test
 A final note on the schedulability admission test.

 I have not yet implemented it, since coding the exact formulas for a
 fully-general hierarchical real-time system could be very complex and,
 more important, time consuming when executing such a code path on-line.
 So, I think that leaving this duty to the user could be a good choice,
 at least for now.

 This idea is also reinforced by thinking about the fact that the user,
 being the designer of the application, know better than us what kind of
 guarantee, so what kind of test, he needs, e.g, he knows if he is using
 hierarchical scheduling or not, and so if he needs a full hierarchical
 test or a much simpler one.

 Moreover, I think the present implementation of group scheduling, where
 groups have not "their own" priority but derive it by the tasks (and
 the task groups) they contain, does not fully adhere to what we, in
 real-time theory, call hierarchical scheduling (not in always at
 least).
 For this reason, I'm quite convinced that whatever (well known)
 scheduling test we are implementing on top of such a design, it is not
 going to work as we would have expected.
 Obviously the present implementation has the benefit of being
 transparent and behaving just like POSIX (FIFO, RR and, now,
 SPORADIC!), excepted for throttling, so I'm not complaining about
 that... Just noticing some differences.

 Summarizing, if you we to use real-time scheduling test (better, if
 we want to use one of the well known scheduling tests) I think we
 have first of all to modify the group scheduling infrastructure (giving
 a priority to each group could be sufficient), and then code a fully
 hierarchical test... And I'm not doing any of those things, not for now
 at least, in my RFC-patch. :-)


Ok, let's stop gossiping now... The code follows... It is worthless to
say that comments are not welcome... They are necessary and absolutely
needed!! :-D

Best Regards,
Dario

---
(*) There exists many other algorithms, e.g., Priority Exchange, Slack
    Stealer, etc., but they are out of our scope for now.
(**) I found out that code only yesterday! :-(
     Anyway, my patch has nothing to do with it, and the approach is
     quite a lot different, one of the biggest difference being the FSU
     code is not supporting group scheduling.

---
[1] B. Sprunt, L. Sha, and J. Lehoczky. Aperiodic Task Scheduling for
    Hard Real-Time Systems. Journal of Real-Time Systems, 1:27=E2=80=9360, =
1989
[2] J.P. Lehoczky, L. Sha, and J.K. Strosnider. Enhanced aperiodic
    responsiveness in hard real-time environments. In Proceedings of
    IEEE Real-Time Systems Symposium, pages 261=E2=80=93270, 1987
[3] The Open Group Base Specifications Issue 6
    IEEE Std 1003.1, 2004 Edition
    http://www.opengroup.org/onlinepubs/009695399/functions/xsh_chap02_08.h=
tml#tag_02_08_04_04
[4] The QNX Neutrino Microkernel
    http://www.qnx.com/developers/docs/6.3.2/neutrino/sys_arch/kernel.html#=
Sporadic_scheduling
[5] ReTiS Lab, Scuola Superiore Sant'Anna, Pisa
    http://retis.sssup.it/
[6] Florida State University
    COP 5641 - Kernel and Device Driver Programming
    http://ww2.cs.fsu.edu/~rosentha/cop5641/modifications.php

--=20
<<This happens because I choose it to happen!>>
(Raistlin Majere, DragonLance Chronicles -Dragons of Spring Drawning-)
----------------------------------------------------------------------
Dario Faggioli
GNU/Linux Registered User: #340657
Web: http://www.linux.it/~raistlin
Blog: http://blog.linux.it/raistlin
SIP Account: dario.faggioli@sipproxy.wengo.fr or
             raistlin@ekiga.net
Jabber Account: dario.faggioli@jabber.org/WengoPhone
GnuPG Key ID: 4DC83AC4
GnuPG Key Fingerprint: 2A78 AD5D B9CF A082 0836 08AD 9385 DA04 4DC8 3AC4

--=-hfOsGKC16aP9rOIG3dfu
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBIoENuk4XaBE3IOsQRAvsfAJ4n1MOLixJBo6k4BAXJEx8j4H/OsACfV3Fm
JTTHFqtsF21kIlh7iyhLbPo=
=YQSS
-----END PGP SIGNATURE-----

--=-hfOsGKC16aP9rOIG3dfu--

