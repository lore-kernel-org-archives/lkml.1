Return-Path: <linux-kernel-owner+w=401wt.eu-S1753750AbZJYQuF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753750AbZJYQuF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Oct 2009 12:50:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753730AbZJYQuE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Oct 2009 12:50:04 -0400
Received: from casper.infradead.org ([85.118.1.10]:51889 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753726AbZJYQuD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Oct 2009 12:50:03 -0400
Date: Sun, 25 Oct 2009 09:51:09 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <peterz@infradead.org>, mingo@elte.hu,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] sched: Disable affine wakeups by default
Message-ID: <20091025095109.449bac9e@infradead.org>
In-Reply-To: <1256453725.12138.40.camel@marge.simson.net>
References: <20091024125853.35143117@infradead.org>
	<20091024130432.0c46ef27@infradead.org>
	<20091024130728.051c4d7c@infradead.org>
	<1256453725.12138.40.camel@marge.simson.net>
Organization: Intel
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.16.6; i586-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 25 Oct 2009 07:55:25 +0100
Mike Galbraith <efault@gmx.de> wrote:
> Even if you're sharing a cache, there are reasons to wake affine.  If
> the wakee can preempt the waker while it's still eligible to run,
> wakee not only eats toasty warm data, it can hand the cpu back to the
> waker so it can make more and repeat this procedure for a while
> without someone else getting in between, and trashing cache. 

and on the flipside, and this is the workload I'm looking at,
this is halving your performance roughly due to one core being totally
busy while the other one is idle.

My workload is a relatively simple situation: firefox is starting up
and talking to X. I suspect this is representative for many X using
applications in the field. The application sends commands to X, but is
not (yet) going to wait for a response, it has more work to do. 
In this case the affine behavior does not only cause latency, but it
also eats the throughput performance.

This is due to a few things that compound, but a key one is this code:

        if (sd_flag & SD_BALANCE_WAKE) {
                if (sched_feat(AFFINE_WAKEUPS) &&
                    cpumask_test_cpu(cpu, &p->cpus_allowed))
                        want_affine = 1;
                new_cpu = prev_cpu;
        }

the problem is that 

        if (affine_sd && wake_affine(affine_sd, p, sync)) {
                new_cpu = cpu;
                goto out;
        }

this then will trigger later, as long as there is any domain that has
SD_WAKE_AFFINE set ;(

(part of that problem is that the code that sets affine_sd is done
before the
               if (!(tmp->flags & sd_flag))
                        continue;
test)


The numbers you posted are for a database, and only measure throughput.
There's more to the world than just databases / throughput-only
computing, and I'm trying to find low impact ways to reduce the latency
aspect of things. One obvious candidate is hyperthreading/SMT where it
IS basically free to switch to a sibbling, so wake-affine does not
really make sense there.

-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
