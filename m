Return-Path: <linux-kernel-owner+w=401wt.eu-S1757706AbXEIUYI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757706AbXEIUYI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 16:24:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755774AbXEIUXz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 16:23:55 -0400
Received: from holomorphy.com ([66.93.40.71]:37052 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755563AbXEIUXy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 16:23:54 -0400
Date: Wed, 9 May 2007 13:24:18 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: Srivatsa Vaddagiri <vatsa@in.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, Mike Galbraith <efault@gmx.de>,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Nick Piggin <npiggin@suse.de>,
       Arjan van de Ven <arjan@infradead.org>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Thomas Gleixner <tglx@linutronix.de>, caglar@pardus.org.tr,
       Willy Tarreau <w@1wt.eu>, Gene Heskett <gene.heskett@gmail.com>,
       Mark Lord <lkml@rtr.ca>, tingy@cs.umass.edu, tong.n.li@intel.com
Subject: Re: Definition of fairness (was Re: [patch] CFS scheduler, -v11)
Message-ID: <20070509202418.GE31925@holomorphy.com>
References: <20070508150431.GA26977@elte.hu> <20070509180205.GA27462@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070509180205.GA27462@in.ibm.com>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 09, 2007 at 11:32:05PM +0530, Srivatsa Vaddagiri wrote:
> 	I had a question with respect to the definition of fairness used, esp
> for tasks that are not 100% cpu hogs.
> Ex: consider two equally important tasks T1 and T2 running on same CPU and 
> whose execution nature is:
> 	T1 = 100% cpu hog
> 	T2 = 60% cpu hog (run for 600ms, sleep for 400ms)
> Over a arbitrary observation period of 10 sec, 
> 	T1 was ready to run for all 10sec
> 	T2 was ready to run for 6 sec
> Over this observation period, how much execution time should T2 get,
> under a "fair" scheduler?
> I was expecting both T2 and T1 to get 5 sec (50:50 split). Is this a
> wrong expectation of fairness?
> Anyway, results of this experiment (using testcase attached) is below.
> T2 gets way below its fair share IMO (under both cfs and sd).

It's not even feasible much of the time. Suppose your task ran for
100ms then slept for 900ms. It can't get more than 10% of the CPU in
any scheduler, work-conserving or not.

Second, anything that would credit tasks for sleep in such a manner
would flunk ringtest.c or otherwise analogues arranged to pass
feasibility checks.

Fairness applies only to running tasks. The fair share of CPU must be
granted while the task is running. As for sleep, it has to use its
fair share of CPU or lose it. The numerous of pathologies that arise
from trying to credit tasks for sleep in this fashion this are why
fairness in the orthodox sense I describe is now such a high priority.

However, it is possible to credit tasks for sleep in other ways. For
instance, EEVDF (which is very close to CFS) has a deadline parameter
expressing latency in addition to one expressing bandwidth that could,
in principle, be used for the purpose of crediting sleeping tasks. It's
not clear to me whether trying to use it for such purposes would be
sound, or, for that matter, whether tasks should receive latency
credits for sleep as opposed to other sorts of behaviors even if
utilizing the latency parameter for credits and bonuses for various
sorts of behavior is sound.


-- wli
