Return-Path: <linux-kernel-owner+w=401wt.eu-S1756953AbZGDCHb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756953AbZGDCHb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 22:07:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754558AbZGDCHW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 22:07:22 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:44365 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754198AbZGDCHV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 22:07:21 -0400
Message-ID: <3f9558558c68d9e2fe00f7c7681c3764.squirrel@webmail-b.css.fujitsu.com>
In-Reply-To: <6599ad830907030852p2cd667e3m353d68448e0cdc6a@mail.gmail.com>
References: <20090702231814.3969.44308.stgit@menage.mtv.corp.google.com>
    <20090702232620.3969.16680.stgit@menage.mtv.corp.google.com>
    <20090702164649.303c4952.akpm@linux-foundation.org>
    <2f86c2480907021731h13e0bb95q94f06829eded9aa6@mail.gmail.com>
    <20090702175341.fd2e26d5.akpm@linux-foundation.org>
    <6599ad830907021808o6f3bb51eh324e4bf13544d83e@mail.gmail.com>
    <20090702183004.1e3f4315.akpm@linux-foundation.org>
    <20090703145441.f526793f.kamezawa.hiroyu@jp.fujitsu.com>
    <6599ad830907030852p2cd667e3m353d68448e0cdc6a@mail.gmail.com>
Date: Sat, 4 Jul 2009 11:07:20 +0900 (JST)
Subject: Re: [PATCH 1/2] Adds a read-only "procs" file similar to "tasks"
 that  shows only unique tgids
From: "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>
To: "Paul Menage" <menage@google.com>
Cc: "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Benjamin Blum" <bblum@google.com>,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       lizf@cn.fujitzu.com
User-Agent: SquirrelMail/1.4.16
MIME-Version: 1.0
Content-Type: text/plain;charset=iso-2022-jp
Content-Transfer-Encoding: 7bit
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Menage さんは書きました：
> On Thu, Jul 2, 2009 at 10:54 PM, KAMEZAWA
> Hiroyuki<kamezawa.hiroyu@jp.fujitsu.com> wrote:
>>
>> Why we can't do what readdir(/proc) does ? I'm sorry I misunderstand.
>> Following is an easy example.
>>
>>
>> 0. at open, inilialize f_pos to 0. f_pos is used as "pid"
>> &#160; remember "css_set with hole" as template in f_private?(or
somewhere) at open
>> &#160; ...like this.
>> --
>> &#160; struct cgroupfs_root *root = cgrp->root;
>> &#160; struct cgroup *template = kzalloc(sizeof(void*) *
CGROUP_SUBSYS_COUNT);
>>
>> &#160; for (i = 0; i < CGROUP_SUBSYS_COUNT; i++)
>> &#160; &#160; &#160; &#160;if (root->subsys_bits & (1UL << i))
>> &#160; &#160; &#160; &#160; &#160; &#160; &#160; &#160;template[i] =
&#160;cgrp->subsys[i];
>> --
>>
>>
>> 1. at read(), find task_struct of "pid" in f_pos.
>> 2. look up task_struct of "pid" and compare with f_private
>> --
>> &#160; struct cgroup *template = f_private;
>>
>> &#160; for (i = 0; i < CGROUP_SUBSYS_COUNT; i++) {
>> &#160; &#160; &#160; &#160;if (!template[i])
>> &#160; &#160; &#160; &#160; &#160; &#160; &#160; &#160;contiue;
>> &#160; &#160; &#160; &#160;if (template[i] != task_subsys_state(task, i))
>> &#160; &#160; &#160; &#160; &#160; &#160; &#160; &#160;break;
>> &#160; }
>> &#160; if (i == CGROUP_SUBSYS_COUNT)
>> &#160; &#160; &#160; &#160;print task;
>
> The problem with this is that the time taken to scan a single cgroup
> is linear in the total number of threads in the system, so if you have
> a lot of threads and a lot of cgroups (even if most of the threads are
> concentrated in a single cgroup) the time taken to scan all the tasks
> files in O(N^2) in the number of threads in the system. The current
> scheme is linear in the number of threads in a cgroup, so looking at
> all cgroups is linear in the number of threads in the system. (This
> O(N^2) problem is something that we've actually observed as an
> overhead on some busy systems at Google).
>
yes. that's a problem. but not far from 'ps' 's performance.
kmalloc() scheme can walk faster than this under heavy memory pressure ?
Anyway, above algorithm shows that it's enough to have per-cgroup bitmap
(size can be dinamically changed) rather than big table and ugly sort().
How about adding per-cgroup taskid bitmap ?
clear/set is very easy.

Thanks,
-Kame

