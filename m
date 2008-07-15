Return-Path: <linux-kernel-owner+w=401wt.eu-S932273AbYGOAA5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932273AbYGOAA5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 20:00:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932337AbYGOAAg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 20:00:36 -0400
Received: from py-out-1112.google.com ([64.233.166.176]:59140 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932169AbYGOAAd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 20:00:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=LgRUIPTaUguUQ/053E3OhaBSZyYj25ywMGiGKcoqC3jP4UE3IM0eGuEc2/ojZua3DT
         R2EZt5VaSJYaMSQzl7wUd2QpBTi+c1jM0RVhXxAXc6D7kfbY7JGN0j7yceazKBrOENAq
         w97EEjlvBhaJgC4NHkDjpY/jHMj3p4/ojlj5Q=
Message-ID: <b647ffbd0807141700s20e54fbewafb3d3e296e57f53@mail.gmail.com>
Date: Tue, 15 Jul 2008 02:00:32 +0200
From: "Dmitry Adamushko" <dmitry.adamushko@gmail.com>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Subject: Re: current linux-2.6.git: cpusets completely broken
Cc: "Vegard Nossum" <vegard.nossum@gmail.com>,
       "Paul Menage" <menage@google.com>,
       "Max Krasnyansky" <maxk@qualcomm.com>, "Paul Jackson" <pj@sgi.com>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>, miaox@cn.fujitsu.com,
       rostedt@goodmis.org, "Thomas Gleixner" <tglx@linutronix.de>,
       "Ingo Molnar" <mingo@elte.hu>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.LFD.1.10.0807141602250.3017@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080712031736.GA3040@damson.getinternet.no>
	 <alpine.LFD.1.10.0807112026390.2875@woody.linux-foundation.org>
	 <b647ffbd0807120304o7a500dc9oce761e51c9dce908@mail.gmail.com>
	 <alpine.LFD.1.10.0807121254490.2875@woody.linux-foundation.org>
	 <alpine.LFD.1.10.0807121411350.2875@woody.linux-foundation.org>
	 <b647ffbd0807141538g2004f245m5f54ec962f475ba5@mail.gmail.com>
	 <alpine.LFD.1.10.0807141602250.3017@woody.linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/7/15 Linus Torvalds <torvalds@linux-foundation.org>:
>
> On Tue, 15 Jul 2008, Dmitry Adamushko wrote:
>>
>> cpu_clear(cpu, cpu_active_map); _alone_ does not guarantee that after
>> its completion, no new tasks can appear on (be migrated to) 'cpu'.
>
> But I think we should make it do that.
>
> I do realize that we "queue" processes, but that's part of the whole
> complexity. More importantly, the people who do that kind of asynchronous
> queueing don't even really care - *if* they cared about the process
> _having_ to show up on the destination core, they'd be waiting
> synchronously and re-trying (which they do).
>
> So by doing the test for cpu_active_map not at queuing time, but at the
> time when we actually try to do the migration,
> we can now also make that
> cpu_active_map be totally serialized.
>
> (Of course, anybody who clears the bit does need to take the runqueue lock
> of that CPU too, but cpu_down() will have to do that as it does the
> "migrate away live tasks" anyway, so that's not a problem)

The 'synchronization' point occurs even earlier - when cpu_down() ->
__stop_machine_run() gets called (as I described in my previous mail).

My point was that if it's ok to have a _delayed_ synchronization
point, having it not immediately after cpu_clear(cpu, cpu_active_map)
but when the "runqueue lock" is taken a bit later (as you pointed out
above) or __stop_machine_run() gets executed (which is a sync point,
scheduling-wise),

then we can implement the proper synchronization (hotplugging vs.
task-migration) with cpu_online_map (no need for cpu_active_map).

Note, currently, _not_ all places in the scheduler where an actual
migration (not just queuing requests) takes place do the test for
cpu_offline(). Instead, they (blindly) rely on the assumption that if
a cpu is available via sched-domains, then it's guaranteed to be
online (and can be migrated to).

Provided all those places had cpu_offline() (additionally) in place,
the bug which has been discussed in this thread would _not_ happen
and, moreover, we would _not_ need to do all the fancy "attach NULL
domains" sched-domain manipulations (which depend on DOWN_PREPARE,
DOWN and other hotpluging events). We would only need to rebuild
domains once upon CPU_DOWN (on success).

p.s. hope my point is more understandable now (or it's clear that I'm
missing something at this late hour :^)


>
>                Linus
>

-- 
Best regards,
Dmitry Adamushko
