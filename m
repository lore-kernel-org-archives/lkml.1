Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756894Ab0CJQk4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 11:40:56 -0500
Received: from casper.infradead.org ([85.118.1.10]:56768 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756882Ab0CJQky convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 11:40:54 -0500
Subject: Re: Q: select_fallback_rq() && cpuset_lock()
From: Peter Zijlstra <peterz@infradead.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Lai Jiangshan <laijs@cn.fujitsu.com>,
       Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
In-Reply-To: <20100309180615.GA11681@redhat.com>
References: <20100309180615.GA11681@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 10 Mar 2010 17:40:42 +0100
Message-ID: <1268239242.5279.46.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-03-09 at 19:06 +0100, Oleg Nesterov wrote:
> Hello.
> 
> I tried to remove the deadlockable cpuset_lock() many times, but my
> attempts were ignored by cpuset maintainers ;)

Yeah, this appears to be an issue, there's no real maintainer atm, parts
are done by the sched folks, parts by the cgroup folks, and I guess
neither really knows everything..

> In particular, see http://marc.info/?l=linux-kernel&m=125261083613103

/me puts it on the to-review stack.

> But now I have another question. Since 5da9a0fb673a0ea0a093862f95f6b89b3390c31e
> cpuset_cpus_allowed_locked() is called without callback_mutex held by
> try_to_wake_up().
> 
> And, without callback_mutex held, isn't it possible to race with, say,
> update_cpumask() which changes cpuset->cpus_allowed? Yes, update_tasks_cpumask()
> should fixup task->cpus_allowed later. But isn't it possible (at least
> in theory) that try_to_wake_up() gets, say, all-zeroes in task->cpus_allowed
> after select_fallback_rq()->cpuset_cpus_allowed_locked() if we race with
> update_cpumask()->cpumask_copy() ?

Hurmm,.. good point,.. yes I think that might be possible.
p->cpus_allowed is synchronized properly, but cs->cpus_allowed is not,
bugger.

I guess the quick fix is to really bail and always use cpu_online_mask
in select_fallback_rq().

