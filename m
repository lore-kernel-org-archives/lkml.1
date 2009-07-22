Return-Path: <linux-kernel-owner+w=401wt.eu-S1754595AbZGVWDi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754595AbZGVWDi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 18:03:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754456AbZGVWDi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 18:03:38 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35058 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754511AbZGVWDh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 18:03:37 -0400
Date: Wed, 22 Jul 2009 15:02:46 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: rusty@rustcorp.com.au, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] cpu_hotplug: don't affect current task's affinity
Message-Id: <20090722150246.6d28003a.akpm@linux-foundation.org>
In-Reply-To: <4A5C4626.8000000@cn.fujitsu.com>
References: <4A5C4626.8000000@cn.fujitsu.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Jul 2009 16:47:34 +0800
Lai Jiangshan <laijs@cn.fujitsu.com> wrote:

> 
> _cpu_down() changes current task's affinity and then
> recovers it at the end.
> 
> It brings two defects:
> 
> 1) The recovering will failed in some condition.
> 
> # grep Cpus_allowed_list /proc/$$/status
> Cpus_allowed_list:      0-3
> 
> # taskset -pc 2 $$
> pid 29075's current affinity list: 0-3
> pid 29075's new affinity list: 2
> 
> # grep Cpus_allowed_list /proc/$$/status
> Cpus_allowed_list:      2
> 
> # echo 0 > /sys/devices/system/cpu/cpu2/online
> 
> # grep Cpus_allowed_list /proc/$$/status
> Cpus_allowed_list:      0
> 
> In linux, tasks' "Cpus_allowed_list" which are "2" originally
> will become "0-1,3" after the cpu#2 is offlined.
> 
> This "Cpus_allowed_list:      0" is suspicionful.
> 
> 2) current task is a userspace task, the user may change
> its cpu-affinity at the same time. The user may get unexpected
> result if _cpu_down() changes current task's affinity.
> 
> Actually, we don't have to change the affinity.
> We create a kernel thread to do the works.
> 

I've rewritten the description as below.  Can you check it please?

: _cpu_down() changes the current task's affinity and then recovers it at the
: end.
: 
: It has two problems:
: 
: 1) The recovery of the current tasks's cpus_allowed will fail under
:    some conditions.
: 
:    # grep Cpus_allowed_list /proc/$$/status
:    Cpus_allowed_list:      0-3
: 
:    # taskset -pc 2 $$
:    pid 29075's current affinity list: 0-3
:    pid 29075's new affinity list: 2
: 
:    # grep Cpus_allowed_list /proc/$$/status
:    Cpus_allowed_list:      2
: 
:    # echo 0 > /sys/devices/system/cpu/cpu2/online
: 
:    # grep Cpus_allowed_list /proc/$$/status
:    Cpus_allowed_list:      0
: 
:    Here, the Cpus_allowed_list was originally "2" and has become
:    "0-1,3" after cpu #2 is offlined.
: 
:    This "Cpus_allowed_list:      0" is incorrect.
: 
: 2) If the current task is a userspace task, the user may change its
:    cpu-affinity during the CPU hot-unplugging.  This change can be
:    overwritten when _cpu_down() changes the current task's affinity.
: 
: 
: Fix all this by not changing the current tasks's affinity.  Instead we
: create a kernel thread to do the work.



I don't fully understand 1).  You say that the tasks's cpus_allowed has
become "0-1,3".  But it hasn't - it has become "0".

Are you saying that the mask is internally 0-1,3 and that the
/proc/$$/status file is incorrectly displaying it?

Or are you saying that the mask _should_ have been 0-1,3 but the kernel
incorrectly set it to "0"?


Also, it says "The recovery of the current tasks's cpus_allowed will
fail under some conditions".  What are those conditions?

Thanks.
