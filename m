Return-Path: <linux-kernel-owner+w=401wt.eu-S1758116AbZFLLJz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758116AbZFLLJz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 07:09:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752965AbZFLLJt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 07:09:49 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:57355 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751708AbZFLLJt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 07:09:49 -0400
Subject: Re: [RFC PATCH] posix-cpu-timers: optimize calling
 thread_group_cputime()
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <20090612123903.37cfd868@dhcp-lab-109.englab.brq.redhat.com>
References: <20090612123903.37cfd868@dhcp-lab-109.englab.brq.redhat.com>
Content-Type: text/plain
Date: Fri, 12 Jun 2009 13:09:46 +0200
Message-Id: <1244804986.6691.1224.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-06-12 at 12:39 +0200, Stanislaw Gruszka wrote:
> -               times->utime = cputime_add(times->utime, t->utime);
> -               times->stime = cputime_add(times->stime, t->stime);
> -               times->sum_exec_runtime += t->se.sum_exec_runtime;
> +               if (mask & TG_CPUCLOCK_UTIME)
> +                       times->utime = cputime_add(times->utime, t->utime);
> +               if (mask & TG_CPUCLOCK_STIME)
> +                       times->stime = cputime_add(times->stime, t->stime);
> +               if (mask & TG_CPUCLOCK_SCHED)
> +                       times->sum_exec_runtime += t->se.sum_exec_runtime;

Does adding 3 branches really make it faster? Since you're bound to want
at least one, I would expect the cacheline to be hot (assuming all three
variables live in the same cacheline -- if not, they should be!), so all
you're avoiding is the addition.

