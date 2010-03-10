Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753002Ab0CJT0Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 14:26:24 -0500
Received: from casper.infradead.org ([85.118.1.10]:49357 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751635Ab0CJT0X convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 14:26:23 -0500
Subject: Re: [PATCHSET] cpuhog: implement and use cpuhog
From: Peter Zijlstra <peterz@infradead.org>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, rusty@rustcorp.com.au, sivanich@sgi.com,
       heiko.carstens@de.ibm.com, torvalds@linux-foundation.org, mingo@elte.hu,
       dipankar@in.ibm.com, josh@freedesktop.org, paulmck@linux.vnet.ibm.com,
       oleg@redhat.com, akpm@linux-foundation.org
In-Reply-To: <1268063603-7425-1-git-send-email-tj@kernel.org>
References: <1268063603-7425-1-git-send-email-tj@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 10 Mar 2010 20:25:55 +0100
Message-ID: <1268249155.5279.128.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-03-09 at 00:53 +0900, Tejun Heo wrote:
> Hello, all.
> 
> This patchset implements cpuhog which is a simplistic cpu
> monopolization mechanism and reimplements stop_machine() and replaces
> migration_thread with it.
> 
> This allows stop_machine() to be simpler and much more efficient on
> very large machines without using more resources while also making the
> rather messy overloaded migration_thread usages cleaner.
> 
> This should solve the slow boot problem[1] caused by repeated
> stop_machine workqueue creation/destruction reported by Dimitri
> Sivanich.
> 
> The patchset is currently on top of v2.6.33 and contains the following
> patches.
> 
>  0001-cpuhog-implement-cpuhog.patch
>  0002-stop_machine-reimplement-using-cpuhog.patch
>  0003-scheduler-replace-migration_thread-with-cpuhog.patch
>  0004-scheduler-kill-paranoia-check-in-synchronize_sched_e.patch
> 
> 0001 implements cpuhog.  0002 converts stop_machine.  0003 converts
> migration users and 0004 removes paranoia checks in
> synchronize_sched_expedited().  0004 is done separately so that 0003
> can serve as a debug/bisection point.
> 
> Tested cpu on/offlining, shutdown, all migration usage paths including
> RCU torture test at 0003 and 004 and everything seems to work fine
> here.  Dimitri, can you please test whether this solves the problem
> you're seeing there?

cpuhog as a name doesn't work for me, stop-machine had a name that
described its severity and impact, cpuhog makes me think of while(1);.

Can't we keep the stop_machine name and make that a workqueue interface
like you propose?

That way we'd end up with something like:

kernel/stop_machine.c
  int stop_cpu(int cpu, stop_fn_t fn, void *arg)
  int stop_machine(struct cpumask *mask, stop_fn_t fn, void *arg)

alternatively, something like schedule_primary_work*() might work I
guess.



