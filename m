Return-Path: <linux-kernel-owner+w=401wt.eu-S1760122AbYHAVq0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760122AbYHAVq0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 17:46:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756292AbYHAVqK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 17:46:10 -0400
Received: from smtp.opengridcomputing.com ([209.198.142.2]:53152 "EHLO
	smtp.opengridcomputing.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754754AbYHAVqI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 17:46:08 -0400
Message-ID: <48938464.2080505@opengridcomputing.com>
Date: Fri, 01 Aug 2008 16:47:16 -0500
From: Steve Wise <swise@opengridcomputing.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: BUG on booting 2.6.27-rc1
References: <48937891.2040606@opengridcomputing.com> <48937CDA.6020700@goop.org>
In-Reply-To: <48937CDA.6020700@goop.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

That patch did it!

Thanks,

Steve.


Jeremy Fitzhardinge wrote:
> Steve Wise wrote:
>> Anybody seen this?
>>
>> Its on x86_64, FC7 distro quad core cpu.  I have 2 similar systems, 
>> and one boots up ok but the other hits this on -rc1 right off the bat.
>>
>>
>>
>>
>> Starting udev: ------------[ cut here ]------------
>> kernel BUG at kernel/stop_machine.c:151!
>> invalid opcode: 0000 [1] SMP
>> CPU 0
>> Modules linked in: dm_snapshot dm_zero dm_mirror dm_log dm_mod 
>> pata_jmicron ata_generic ata_piix libata sd_mod scsi_mod ext3 jbd 
>> mbcache [last unloaded: scsi_wait_scan]
>> Pid: 960, comm: modprobe Not tainted 2.6.27-rc1 #7
>> RIP: 0010:[<ffffffff8105be33>]  [<ffffffff8105be33>] 
>> __stop_machine+0x134/0x1ea
>> RSP: 0018:ffff88012e5dbd68  EFLAGS: 00010286
>> RAX: 00000000fffffff3 RBX: ffff88012b9b1d40 RCX: 0000000000000206
>
> RAX = -EACCES
>
> Presumably that's being returned from security_task_setscheduler(), 
> since it doesn't otherwise appear in __sched_setscheduler().  We 
> probably shouldn't call that if !user.
>
> diff -r 4f507097262d kernel/sched.c
> --- a/kernel/sched.c    Fri Aug 01 13:14:44 2008 -0700
> +++ b/kernel/sched.c    Fri Aug 01 14:13:59 2008 -0700
> @@ -4998,19 +4998,21 @@
>             return -EPERM;
>     }
>
> -#ifdef CONFIG_RT_GROUP_SCHED
> -    /*
> -     * Do not allow realtime tasks into groups that have no runtime
> -     * assigned.
> -     */
> -    if (user
> -        && rt_policy(policy) && 
> task_group(p)->rt_bandwidth.rt_runtime == 0)
> -        return -EPERM;
> -#endif
> -
> -    retval = security_task_setscheduler(p, policy, param);
> -    if (retval)
> -        return retval;
> +    if (user) {
> +#ifdef CONFIG_RT_GROUP_SCHED
> +        /*
> +         * Do not allow realtime tasks into groups that have no runtime
> +         * assigned.
> +         */
> +        if (rt_policy(policy) && 
> task_group(p)->rt_bandwidth.rt_runtime == 0)
> +            return -EPERM;
> +#endif
> +
> +        retval = security_task_setscheduler(p, policy, param);
> +        if (retval)
> +            return retval;
> +    }
> +
>     /*
>      * make sure no PI-waiters arrive (or leave) while we are
>      * changing the priority of the task:
>
>
>
>    J
> -- 
> To unsubscribe from this list: send the line "unsubscribe 
> linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

