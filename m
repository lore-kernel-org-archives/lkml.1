Return-Path: <linux-kernel-owner+w=401wt.eu-S1767293AbXECAsx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767293AbXECAsx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 20:48:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767295AbXECAsx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 20:48:53 -0400
Received: from holomorphy.com ([66.93.40.71]:44960 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767293AbXECAsw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 20:48:52 -0400
Date: Wed, 2 May 2007 17:49:29 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: Al Boldi <a1426z@gawab.com>
Cc: linux-kernel@vger.kernel.org, ck@vds.kolivas.org
Subject: Re: [ck] [REPORT] 2.6.21.1 vs 2.6.21-sd046 vs 2.6.21-cfs-v6
Message-ID: <20070503004929.GA19966@holomorphy.com>
References: <200705030211.39345.a1426z@gawab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200705030211.39345.a1426z@gawab.com>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Con Kolivas wrote:
>> Looks good, thanks. Ingo's been hard at work since then and has v8 out by
>> now. SD has not changed so you wouldn't need to do the whole lot of tests
>> on SD again unless you don't trust some of the results.

On Thu, May 03, 2007 at 02:11:39AM +0300, Al Boldi wrote:
> Well, I tried cfs-v8 and it still shows some nice regressions wrt 
> mainline/sd.  SD's nice-levels look rather solid, implying fairness.

That's odd. The ->load_weight changes should've improved that quite
a bit. There may be something slightly off in how lag is computed,
or maybe the O(n) lag issue Ying Tang spotted is biting you.

Also, I should say that the nice number affairs don't imply fairness
per se. The way that works is that when tasks have "weights" (like
nice levels in UNIX) the definition of fairness changes so that each
task gets shares of CPU bandwidth proportional to its weight instead
of one share for one task.

It takes a bit closer inspection than feel tests to see if weighted
fairness is properly implemented. One thing to try is running a number
of identical CPU hogs at the same time at different nice levels for a
fixed period of time (e.g. 1 or 2 minutes) so they're in competition
with each other and seeing what percent of the CPU each gets. From
there you can figure out how many shares each is getting for its nice
level. Trying different mixtures of nice levels and different numbers
of tasks should give consistent results for the shares of CPU bandwidth
the CPU hogs get for being at a particular nice level. A scheduler gets
"bonus points" (i.e. is considered better at prioritizing) for the user
being able to specify how the weightings come out. The finer-grained
the control, the more bonus points.

Maybe con might want to take a stab at having users be able to specify
the weights for each nice level individually.

CFS actually has a second set of weights for tasks, namely the
timeslice for a given task. At the moment, they're all equal. It should
be the case that the shorter the timeslice a given task has, the less
latency it gets. So there is a fair amount of room for it to manuever
with respect to feel tests. It really needs to be done numerically to
get results we can be sure mean something.

The way this goes is task t_i gets a percent of the CPU p_i when the
tasks t_1, t_2, ..., t_n are all competing, and task t_i has nice level
n_i. The share corresponding to nice level n_i is then

          p_i
  w_i = -------
        sum p_j

One thing to check for is that if two tasks have the same nice level
that their weights come out about equal. So for t_i and t_j, if n_i
= n_j then you check that at least approximately, w_i = w_j, or even
p_i = p_j, since we're not starting and stopping tasks in the midst of
the test. Also, you can't simplify sum p_j to 1, since the set of tasks
may not be the only things running.

The other thing to do is try a different number of tasks with a
different mix of nice levels. The weight w_i for a given nice
level n_i should be the same even in a different mix of tasks
and nice levels if the nice levels are the same.

If this sounds too far out, there's nothing to worry about. You can
just run the different numbers of tasks with different mixes of nice
levels and post the %cpu numbers. Or if that's still a bit far out
for you, a test that does all this is eventually going to get written.


-- wli
