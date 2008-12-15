Return-Path: <linux-kernel-owner+w=401wt.eu-S1752968AbYLOCN3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752968AbYLOCN3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2008 21:13:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751597AbYLOCNU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Dec 2008 21:13:20 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:57900 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751325AbYLOCNU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2008 21:13:20 -0500
Message-ID: <4945BCED.9010904@cn.fujitsu.com>
Date: Mon, 15 Dec 2008 10:11:57 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: Paul Menage <menage@google.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] sched: fix another race when reading /proc/sched_debug
References: <494234B0.5@cn.fujitsu.com>	<20081212100044.GB18152@elte.hu>	<4944754F.8050503@cn.fujitsu.com>	<1229258890.17130.9.camel@lappy.programming.kicks-ass.net>	<6599ad830812141347k5d7e7e08vfc17855ea0ac981c@mail.gmail.com>	<4945B546.5040301@cn.fujitsu.com> <20081215105053.89263708.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20081215105053.89263708.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KAMEZAWA Hiroyuki wrote:
> On Mon, 15 Dec 2008 09:39:18 +0800
> Li Zefan <lizf@cn.fujitsu.com> wrote:
> 
>> Paul Menage wrote:
>>> I sent out some patches last week (search for hierarchy_mutex) that would
>>> mean that you'd only need to take a subsystem-local lock to keep a cgroup
>>> alive. People seemed to like them so I'll tweak them based on feedback and
>>> send them on to Andrew.
>>>
>> Unfortunately, AFAICS the proposed hierarchy_mutex can't solve this bug. :(
>>
> Hmm ? how about this way if cgroup->dentry is problem ?
> 

Sounds feasable, though the resulting code might a bit tricky.

> at creation:
>   - cpu_cgroup_populate() should record "tg" that "this cgroup has valid dentry"

This avoids /proc/sched_debug accessing invalid cgrp dentry while a cgroup is
being created.

> at deletion
>   - css_tryget() will be useful to avoid the race.

And this avoids accessing a dead task_group.

Since css_tryget() is a 2.6.29 material, I think we can have this bug fixed for
2.6.28 by holding cgroup_lock, and try to remove the global lock for 2.6.29 ?
