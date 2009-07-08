Return-Path: <linux-kernel-owner+w=401wt.eu-S1756971AbZGHQjx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756971AbZGHQjx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 12:39:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754388AbZGHQjp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 12:39:45 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:45856 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754169AbZGHQjp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 12:39:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=jIeIYGYAi9EvKd5Q7cekDl3oeN/FtDO/5U/rcs5xIuW6RBN0TqjH6jHlWkfyOApe/b
         rA6AR+YluO7mbDqxdaVtgyg9eygvsRkE80G6Ye69JN8wSkOZBhnKn/HLlCXPmEV6eroV
         14JkyYUDtp8enPRydn0uTV1uVujN177+erV8Q=
MIME-Version: 1.0
In-Reply-To: <193b0f820907080905u643e90ddi42a719e6163b0bc@mail.gmail.com>
References: <193b0f820907080848m5b72e2a9l52944ae3de785d90@mail.gmail.com> 
	<1247068556.9777.58.camel@twins> <193b0f820907080905u643e90ddi42a719e6163b0bc@mail.gmail.com>
From: Lucas De Marchi <lucas.de.marchi@gmail.com>
Date: Wed, 8 Jul 2009 18:39:21 +0200
Message-ID: <193b0f820907080939sf0bec93n16ee4b5aca6e1a7a@mail.gmail.com>
Subject: Re: possible migration bug with hotplug cpu
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Following a piece of /proc/<pid>/sched, for RT tasks, running with only one
processor online:

se.wait_count                      :                 1466
sched_info.bkl_count               :                    0
se.nr_migrations                   :                  289  <<=========
se.nr_migrations_cold              :                    0
se.nr_failed_migrations_affine     :                    0
se.nr_failed_migrations_running    :                    7
se.nr_failed_migrations_hot        :                    3
se.nr_forced_migrations            :                    1
se.nr_forced2_migrations           :                   86
se.nr_wakeups                      :               151347
se.nr_wakeups_sync                 :                  298
se.nr_wakeups_migrate              :                  265
se.nr_wakeups_local                :               150516
se.nr_wakeups_remote               :                  831
se.nr_wakeups_affine               :                  253
se.nr_wakeups_affine_attempts      :                 1092
se.nr_wakeups_passive              :                    8
se.nr_wakeups_idle                 :                    0
avg_atom                           :             0.002887
avg_per_cpu                        :             1.498609
nr_switches                        :               150001
nr_voluntary_switches              :               150001
nr_involuntary_switches            :                    0
se.load.weight                     :               177522
policy                             :                    1
prio                               :                   89  <<=========
clock-delta                        :                   84


At  http://pastebin.com/pastebin.php?dl=m7c226875  there's the
/proc/sched_debug before and after running the test.


Lucas De Marchi


On Wed, Jul 8, 2009 at 18:05, Lucas De Marchi <lucas.de.marchi@gmail.com> wrote:
>
> No, because the tasks are executed only after the CPUs become offline.
>
> Lucas De Marchi
>
>
> On Wed, Jul 8, 2009 at 17:55, Peter Zijlstra <peterz@infradead.org> wrote:
> >
> > On Wed, 2009-07-08 at 17:48 +0200, Lucas De Marchi wrote:
> > > I was doing some analysis with the number of migrations in my application and
> > > I think there's a bug in this accounting or even worse, in the migrations
> > > mechanism when used together with cpu hotplug.
> > >
> > > I turned off all CPUs except one using the hotplug mechanism, after what I
> > > launghed my application that has 8 threads. Before they finish they print the
> > > file /proc/<tid>/sched. I have only 1 online CPU and there are ~ 200
> > > migrations per thread. The function set_task_cpu is responsible for updating
> > > the migrations counter and is called by 9 other functions. With some tests I
> > > discovered that 95% of these migrations come from try_to_wake_up and the other
> > > 5% from pull_task and __migrate_task.
> > >
> > > Looking at try_to_wake_up:
> > >
> > > ....
> > >       cpu = task_cpu(p);
> > >       orig_cpu = cpu;
> > >       this_cpu = smp_processor_id();
> > >
> > > #ifdef CONFIG_SMP
> > >       if (unlikely(task_running(rq, p)))
> > >               goto out_activate;
> > >
> > >       cpu = p->sched_class->select_task_rq(p, sync);  //<<<<===
> > >       if (cpu != orig_cpu) {                          //<<<<===
> > >               set_task_cpu(p, cpu);
> > > ....
> > >
> > > p->sched_class->select_task_rq(p, sync)  is returning a different cpu of
> > > task_cpu(p) even if I have only 1 online CPU. In my tests this behavior is
> > > similar for rt and normal tasks. For RT, the only possible problem could be on
> > > find_lowest_rq, but I'm still rying to find out why. Since you have more
> > > experience with this code, if you could give it a look I'd appreciate.
> > >
> > > Is there any obscure reason why this behavior could be right?
> >
> > If the task last ran on a now unplugged cpu this would be correct, is
> > this indeed what happens?
