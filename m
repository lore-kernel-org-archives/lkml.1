Return-Path: <linux-kernel-owner+w=401wt.eu-S1756339AbZGHGYl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756339AbZGHGYl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 02:24:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751540AbZGHGYc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 02:24:32 -0400
Received: from viefep18-int.chello.at ([62.179.121.38]:11715 "EHLO
	viefep18-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751229AbZGHGYc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 02:24:32 -0400
X-SourceIP: 213.93.53.227
Subject: Re: [PATCH/RFC] sched: Remove SYSTEM_RUNNING checks from
 cond_resched*()
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Anton Vorontsov <avorontsov@ru.mvista.com>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
In-Reply-To: <20090708005000.GA12380@redhat.com>
References: <20090707235812.GA12824@oksana.dev.rtsoft.ru>
	 <20090708005000.GA12380@redhat.com>
Content-Type: text/plain
Date: Wed, 08 Jul 2009 08:24:23 +0200
Message-Id: <1247034263.9777.24.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-07-08 at 02:50 +0200, Oleg Nesterov wrote:

> 	/*
> 	 * It is valid to assume CPU-locality during early bootup:
> 	 */
> 	if (system_state != SYSTEM_RUNNING)
> 		goto out;
> 
> this doesn't look right, smp_init() is called before we set
> SYSTEM_RUNNING.

The thing is, there's also ton's of code that might end up calling
cond_resched() and co before the scheduler is fully initialized. Doing
so would indeed mess things up.

Also, by definition we'd have to call smp_init() before SYSTEM_RUNNING,
because you simply cannot declare a system up and running when your core
functionality isn't initialized.

So I'd really rather preserve these checks -- I can even remember
running into some of these things a while back, but memory isn't
providing specific cases.

> Hmm, and
> 
> 	/*
> 	 * Kernel threads bound to a single CPU can safely use
> 	 * smp_processor_id():
> 	 */
> 	if (cpumask_equal(&current->cpus_allowed, cpumask_of(this_cpu)))
> 		goto out;
> 
> perhaps this should use PF_THREAD_BOUND ?

That might predate PF_THREAD_BOUND, also I think this is more generic,
and I think we used it for that set_affinity dance we did Rusty 'fixed'
a while back.

