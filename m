Return-Path: <linux-kernel-owner+w=401wt.eu-S1751250AbZG3BxW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751250AbZG3BxW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 21:53:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751120AbZG3BxW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 21:53:22 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:57023 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751023AbZG3BxV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 21:53:21 -0400
Message-ID: <4A70FD26.1010800@cn.fujitsu.com>
Date: Thu, 30 Jul 2009 09:53:42 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org,
       Li Zefan <lizf@cn.fujitsu.com>, Miao Xie <miaox@cn.fujitsu.com>,
       Paul Menage <menage@google.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Gautham R Shenoy <ego@in.ibm.com>
Subject: Re: [PATCH] cpusets: fix deadlock with cpu_down()->cpuset_lock()
References: <20090729023302.GA8899@redhat.com> <20090729212125.GA16970@redhat.com> <20090729212216.GB16970@redhat.com> <20090729230043.GA28175@redhat.com>
In-Reply-To: <20090729230043.GA28175@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov wrote:
> On 07/29, Oleg Nesterov wrote:
>> I strongly believe the bug does exist, but this patch needs the review
>> from maintainers.
> 
> Yes...
> 
>> IOW, with this patch migration_call(CPU_DEAD) runs without callback_mutex,
>> but kernel/cpuset.c always takes get_online_cpus() before callback_mutex.
> 
> Oh. I'm afraid this is not an option.
> 
> callback_mutex should nest under cgroup_mutex, but cpu hotplu pathes
> take cgroup_mutex under cpu_hotplug->lock. Lockdep won't be happy.
> 
> Oleg.
> 

We have made great effort to remove get_online_cpus() from cgroup_mutex
critical region.

We can migrate the owner of callback_mutex in migration_call(CPU_DEAD)
at first(and then take callback_mutex and migrate others).
It fixes this bug, but it can't help for your
"cpu_hotplug: don't play with current->cpus_allowed" patch.

Lai.

