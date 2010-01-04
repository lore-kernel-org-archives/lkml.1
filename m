Return-Path: <linux-kernel-owner+w=401wt.eu-S1752429Ab0ADMa4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752429Ab0ADMa4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 07:30:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752218Ab0ADMay
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 07:30:54 -0500
Received: from mail.gmx.net ([213.165.64.20]:34547 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751860Ab0ADMax (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 07:30:53 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19CJMswizpCXFhnUAVDkMpIW8Gtgnxd3cWGkjUVPH
	9l8KvIyYtc5D/z
Subject: Re: [RFC][PATCH] sched: avoid huge bonus to sleepers on busy
 machines
From: Mike Galbraith <efault@gmx.de>
To: Suresh Jayaraman <sjayaraman@suse.de>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       linux-kernel@vger.kernel.org
In-Reply-To: <4B41D8E5.1000908@suse.de>
References: <1262596842-17392-1-git-send-email-sjayaraman@suse.de>
	 <1262603675.9734.36.camel@marge.simson.net>  <4B41D8E5.1000908@suse.de>
Content-Type: text/plain
Date: Mon, 04 Jan 2010 13:30:50 +0100
Message-Id: <1262608250.9734.50.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.64
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-01-04 at 17:32 +0530, Suresh Jayaraman wrote:
> On 01/04/2010 04:44 PM, Mike Galbraith wrote:
> > On Mon, 2010-01-04 at 14:50 +0530, Suresh Jayaraman wrote:
> >> As I understand the idea of sleeper fairness is to consider sleeping tasks
> >> similar to the ones on the runqueue and credit the sleepers in a way that it
> >> would get CPU as if it were running.
> >>
> >> Currently, when fair sleepers are enabled, the task that was sleeping seem to
> >> get a bonus of cfs_rq->min_vruntime - sched_latency (in most cases). While with
> >> gentle fair sleepers this effect was reduced to half, there still remains a
> >> chance that on busy machines with more number of tasks, the sleepers might get
> >> a huge undue bonus.
> > 
> > There is no bonus.  Sleepers simply get to keep some of their lag, but
> > any lag beyond sched_latency is trashed in the interest of reasonable
> > latency for non-sleepers as the sleeper preempts and tries to catch up.
> > 
> 
> Sorry, perhaps it's not a bonus, but it seems that the credit to
> sleepers due to their lag (when it was sleeping) doesn't appear to take
> in to account the number of tasks in the run_queue currently. IOW, the
> credit to sleepers is same irrespective of the number of current tasks.
> This might mean sleepers are getting an edge (since this will slow down
> current tasks) when the number of tasks is more, isn't?

As load increases, min_vruntime advances slower, so it's already scaled.
 
> Would it be a good idea to make the threshold dependent on number of
> tasks? This can help us achieve sleeper fairness with respect to the
> current context and not relevant to when the task went to sleep, I think.
> 
> Does this make sense?

In one respect it makes some sense to scale.  As load climbs, the waker
has to wait longer to get cpu, so sleepers sleep longer.  This leads to
increased wakeup peremption as load climbs.  However, if you do any kind
of scaling, you harm light threads, not their hog competition.  Any
diddling of sleeper fairness would have to be accompanied with a
preemption model change methinks.

	-Mike

