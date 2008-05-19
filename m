Return-Path: <linux-kernel-owner+w=401wt.eu-S1760799AbYESTHU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760799AbYESTHU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 15:07:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754758AbYESTHH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 15:07:07 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:34089 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751430AbYESTHG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 15:07:06 -0400
Subject: 2.6.24.7-rt7
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>, RT <linux-rt-users@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Gregory Haskins <ghaskins@novell.com>,
       Sven-Thorsten Dietrich <sdietrich@novell.com>
Content-Type: text/plain
Date: Mon, 19 May 2008 15:07:03 -0400
Message-Id: <1211224023.14697.71.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We are pleased to announce the 2.6.24.7-rt7 tree, which can be
downloaded from the location:

  http://rt.et.redhat.com/download/

Information on the RT patch can be found at:

  http://rt.wiki.kernel.org/index.php/Main_Page

Changes since 2.6.24.7-rt6

  **** HUGE PERFORMANCE IMPROVEMENT!!! ****

  This is the largest performance improvement to hit the RT patch
  since the removal of the global PI lock. On my 4way box
  running "hackbench 50" went from 18 seconds down to just under
  5 seconds (4.8). Vanilla 2.6.24.7 on this same box runs at 3.9 secs.
  This is the first time that the RT patched kernel is less than
  a magnitude away from mainline running this hackbench test.

  Here's a run of 10 "hackbench 50" on 2.6.24.7-rt6:

[root@bxrhel51 c]# cat hack-test-2.6.24.7-rt6-00-vanilla 
Time: 16.651
Time: 16.773
Time: 16.500
Time: 17.437
Time: 16.267
Time: 18.296
Time: 16.524
Time: 17.452
Time: 18.595
Time: 18.357


  The following patches are the reason for this great improvement!

   - lateral lock stealing (Gregory Haskins)

[root@bxrhel51 c]# cat hack-test-2.6.24.7-rt6-01-lateral-steal 
Time: 7.853
Time: 8.219
Time: 7.967
Time: 8.118
Time: 8.195
Time: 8.349
Time: 8.122
Time: 8.146
Time: 8.197
Time: 8.026

  This alone brought the times down by almost 60% All this patch was to
  do is allow an equal prio task (non-rt) to steal a lock from a pending
  owner.  This is very much similar to the problem that was recently
  discovered with generic semaphores. They forced strict fairness, but
  that hurts performance. We only do this with non-rt tasks, because RT
  tasks need to be fair otherwise we risk a task being starved, and
  even though its being starved by an equal prio RT task, I would not
  want to explain that to my customers when they have two high prio
  tasks bound to separate CPUS and one is starving the other.

  When I first wrote the code to steal lock ownership, I originally had
  lateral stealing, but notice that RT tasks were being starved by it.
  Since I cared about determinism more than performance, I killed it.
  But Gregory brought it back for SCHED_OTHER tasks.


  - rtmutex rearrange logic (Gregory Haskins)

  This patch isn't that great of performance, but sets up for adaptive
  spinlocks, as well as removes an extra xchg (but adds one, see next patch)

  - rtmutex remove double xchg (Steven Rostedt)

  This patch removes a double xchg that happens on getting the rt_mutex.
  as well as getting rid of the unneeded update_current.

  No real performance benefits here.

[root@bxrhel51 c]# cat hack-test-2.6.24.7-rt6-02-rearrange-xchg 
Time: 7.741
Time: 8.007
Time: 8.061
Time: 8.080
Time: 8.105
Time: 8.223
Time: 8.207
Time: 8.220
Time: 8.230
Time: 8.214


  - adaptive spinlocks (Gregory Haskins, Sven Deitrich,
                        Peter Morreale, and Steven Rostedt)


  I played a bit with different ways to do the adaptive spinlocks, but 
  found that guaranteeing that the highest prio task is a pain, and that
  I needed to go into the slow path to handle this. Well, the guys at
  Novell pretty much did that. But unfortunately, they did all sorts
  of funny things (adding unneeded structures, adding stuff to
  task_struct, and grabbing tasks in inappropriate places). Since I
  spent quite a bit of time trying to do this, I had a good idea of
  what was needed, so I rewrote their patch to what it should have
  been to begin with.

  Don't get me wrong, getting this to work was solely at the hands of
  the Novell guys. I just had to clean it up a bit.

  Here's the result:

[root@bxrhel51 c]# cat hack-test-2.6.24.7-rt6-03-adaptive-locks
Time: 4.752
Time: 4.830
Time: 4.896
Time: 4.858
Time: 4.801
Time: 4.885
Time: 4.794
Time: 4.883
Time: 4.852
Time: 4.911
 



to build a 2.6.24.7-rt7 tree, the following patches should be applied:

  http://www.kernel.org/pub/linux/kernel/v2.6/linux-2.6.24.tar.bz2
  http://kernel.org/pub/linux/kernel/v2.6/patch-2.6.24.7.bz2
  http://rt.et.redhat.com/download/patch-2.6.24.7-rt7.bz2


***** NOTE ******

These patches have already been ported to 2.6.25-rt. But that kernel is
still going through some needed testing.

***** NOTE *****


And like always, my RT version of Matt Mackall's ketchup will get this
for you nicely:

  http://people.redhat.com/srostedt/rt/tools/ketchup-0.9.8-rt3


The broken out patches are also available.



-- Steve



