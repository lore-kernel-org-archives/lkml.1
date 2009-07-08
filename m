Return-Path: <linux-kernel-owner+w=401wt.eu-S1756400AbZGHP4O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756400AbZGHP4O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 11:56:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754090AbZGHP4A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 11:56:00 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:40213 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753958AbZGHP4A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 11:56:00 -0400
Subject: Re: possible migration bug with hotplug cpu
From: Peter Zijlstra <peterz@infradead.org>
To: Lucas De Marchi <lucas.de.marchi@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
In-Reply-To: <193b0f820907080848m5b72e2a9l52944ae3de785d90@mail.gmail.com>
References: <193b0f820907080848m5b72e2a9l52944ae3de785d90@mail.gmail.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Wed, 08 Jul 2009 17:55:56 +0200
Message-Id: <1247068556.9777.58.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-07-08 at 17:48 +0200, Lucas De Marchi wrote:
> I was doing some analysis with the number of migrations in my application and
> I think there's a bug in this accounting or even worse, in the migrations
> mechanism when used together with cpu hotplug.
> 
> I turned off all CPUs except one using the hotplug mechanism, after what I
> launghed my application that has 8 threads. Before they finish they print the
> file /proc/<tid>/sched. I have only 1 online CPU and there are ~ 200
> migrations per thread. The function set_task_cpu is responsible for updating
> the migrations counter and is called by 9 other functions. With some tests I
> discovered that 95% of these migrations come from try_to_wake_up and the other
> 5% from pull_task and __migrate_task.
> 
> Looking at try_to_wake_up:
> 
> ....
> 	cpu = task_cpu(p);
> 	orig_cpu = cpu;
> 	this_cpu = smp_processor_id();
> 
> #ifdef CONFIG_SMP
> 	if (unlikely(task_running(rq, p)))
> 		goto out_activate;
> 
> 	cpu = p->sched_class->select_task_rq(p, sync);  //<<<<===
> 	if (cpu != orig_cpu) {                          //<<<<===
> 		set_task_cpu(p, cpu);
> ....
> 
> p->sched_class->select_task_rq(p, sync)  is returning a different cpu of
> task_cpu(p) even if I have only 1 online CPU. In my tests this behavior is
> similar for rt and normal tasks. For RT, the only possible problem could be on
> find_lowest_rq, but I'm still rying to find out why. Since you have more
> experience with this code, if you could give it a look I'd appreciate.
> 
> Is there any obscure reason why this behavior could be right?

If the task last ran on a now unplugged cpu this would be correct, is
this indeed what happens?
