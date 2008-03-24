Return-Path: <linux-kernel-owner+w=401wt.eu-S1759998AbYCXRgJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759998AbYCXRgJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2008 13:36:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754730AbYCXRf4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Mar 2008 13:35:56 -0400
Received: from e28smtp01.in.ibm.com ([59.145.155.1]:59563 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755935AbYCXRfz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2008 13:35:55 -0400
Message-ID: <47E7E5D0.9020904@linux.vnet.ibm.com>
Date: Mon, 24 Mar 2008 23:03:04 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Paul Menage <menage@google.com>
CC: linux-mm@kvack.org, Hugh Dickins <hugh@veritas.com>,
       Sudhir Kumar <skumar@linux.vnet.ibm.com>,
       YAMAMOTO Takashi <yamamoto@valinux.co.jp>, lizf@cn.fujitsu.com,
       linux-kernel@vger.kernel.org, taka@valinux.co.jp,
       David Rientjes <rientjes@google.com>,
       Pavel Emelianov <xemul@openvz.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [RFC][-mm] Memory controller add mm->owner
References: <20080324140142.28786.97267.sendpatchset@localhost.localdomain> <6599ad830803240803s5160101bi2bf68b36085f777f@mail.gmail.com> <47E7D51E.4050304@linux.vnet.ibm.com> <6599ad830803240934g2a70d904m1ca5548f8644c906@mail.gmail.com>
In-Reply-To: <6599ad830803240934g2a70d904m1ca5548f8644c906@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Menage wrote:
> On Mon, Mar 24, 2008 at 9:21 AM, Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
>>  > Also, if mm->owner exits but mm is still alive (unlikely, but could
>>  > happen with weird custom threading libraries?) then we need to
>>  > reassign mm->owner to one of the other users of the mm (by looking
>>  > first in the thread group, then among the parents/siblings/children,
>>  > and then among all processes as a last resort?)
>>  >
>>
>>  The comment in __exit_signal states that
>>
>>  "The group leader stays around as a zombie as long
>>   as there are other threads.  When it gets reaped,
>>   the exit.c code will add its counts into these totals."
> 
> Ah, that's useful to know.
> 
>>  Given that the thread group leader stays around, do we need to reassign
>>  mm->owner? Do you do anything special in cgroups like cleanup the
>>  task_struct->css->subsys_state on exit?
>>
> 
> OK, so we don't need to handle this for NPTL apps - but for anything
> still using LinuxThreads or manually constructed clone() calls that
> use CLONE_VM without CLONE_PID, this could still be an issue. 

CLONE_PID?? Do you mean CLONE_THREAD?

For the case you mentioned, mm->owner is a moving target and we don't want to
spend time finding the successor, that can be expensive when threads start
exiting one-by-one quickly and when the number of threads are high. I wonder if
there is an efficient way to find mm->owner in that case.

(Also I
> guess there's the case of someone holding a reference to the mm via a
> /proc file?)
> 

Yes, but in that case we'll not be charging/uncharging anything to that mm or
the cgroup to which the mm belongs.

>>  >>  -       rcu_read_lock();
>>  >>  -       mem = rcu_dereference(mm->mem_cgroup);
>>  >>  +       mem = mem_cgroup_from_task(mm->owner);
>>  >
>>  > I think we still need the rcu_read_lock(), since mm->owner can move
>>  > cgroups any time.
>>  >
>>
>>  OK, so cgroup task movement is protected by RCU, right? I'll check for all
>>  mm->owner uses.
>>
> 
> Yes - cgroup_attach() uses synchronize_rcu() before release the cgroup
> mutex. So although you can't guarantee that the cgroup set won't
> change if you're just using RCU, you can't guarantee that you're
> addressing a still-valid non-destroyed (and of course non-freed)
> cgroup set.
> 

Yes, I understand that part of RCU.

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
