Return-Path: <linux-kernel-owner+w=401wt.eu-S1754257Ab0AMCIu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754257Ab0AMCIu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jan 2010 21:08:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752403Ab0AMCIu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jan 2010 21:08:50 -0500
Received: from mx1.redhat.com ([209.132.183.28]:41240 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751500Ab0AMCIt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jan 2010 21:08:49 -0500
Message-ID: <4B4D2AD3.9000902@redhat.com>
Date: Wed, 13 Jan 2010 10:07:15 +0800
From: Xiaotian Feng <dfeng@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Lightning/1.0pre Thunderbird/3.0
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>, mrb74@gmx.at
CC: bugzilla-daemon@bugzilla.kernel.org, bugme-daemon@bugzilla.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, stable@kernel.org,
       linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [Bugme-new] [Bug 15005] New: Segmentation fault when shutting
 down
References: <bug-15005-10286@http.bugzilla.kernel.org/> <20100112140754.fe75f501.akpm@linux-foundation.org>
In-Reply-To: <20100112140754.fe75f501.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm not sure, but I can't see the start of the seg fault. Is it a kernel 
NULL pointer deref or trigger the BUG?
Mind to try patch in http://bugzilla.kernel.org/show_bug.cgi?id=15037?



On 01/13/2010 06:07 AM, Andrew Morton wrote:
>
> (switched to email.  Please respond via emailed reply-to-all, not via the
> bugzilla web interface).
>
> On Thu, 7 Jan 2010 20:59:20 GMT
> bugzilla-daemon@bugzilla.kernel.org wrote:
>
>> http://bugzilla.kernel.org/show_bug.cgi?id=15005
>>
>>             Summary: Segmentation fault when shutting down
>>             Product: ACPI
>>             Version: 2.5
>>      Kernel Version: 2.6.32.3
>>            Platform: All
>>          OS/Version: Linux
>>                Tree: Mainline
>>              Status: NEW
>>            Severity: blocking
>>            Priority: P1
>>           Component: Power-Off
>>          AssignedTo: acpi_power-off@kernel-bugs.osdl.org
>>          ReportedBy: mrb74@gmx.at
>>          Regression: Yes
>>
>>
>> Created an attachment (id=24479)
>>   -->  (http://bugzilla.kernel.org/attachment.cgi?id=24479)
>> Screenshot of segmentation fault
>>
>> Currently compiled newest kernel 2.6.32.3 for Atom based netbook (datacask
>> Jupiter 1014a). Compiled the kernel with optimizations for Atom CPUs and also
>> with optimizations for i586.
>> When shutting down the system the kernel produces a segmentation fault at the
>> end of the shutdown process. Powering off fails. Both kernel fail with the same
>> error.
>> Last working kernel was 2.6.32.2.
>>
>
> It's a shutdown-time oops in clockevents_notify().  A 2.6.32.2 ->
> 2.6.32.3 regression.
>
> 2.6.32.3 included this prime suspect:
>
> : commit fa3f5a5c1c8e6a2cbc7e21755ea7c215f8cf0577
> : Author: Thomas Gleixner<tglx@linutronix.de>
> : Date:   Thu Dec 10 15:35:10 2009 +0100
> :
> :     clockevents: Prevent clockevent_devices list corruption on cpu hotplug
> :
> :     commit bb6eddf7676e1c1f3e637aa93c5224488d99036f upstream.
> :
> : which
>
> So we may well have the same regression in 2.6.33-rcX.
>
> Martin, can you please check whether the below revert fixes things up?
>
> Thanks.
>
>
> From: Andrew Morton<akpm@linux-foundation.org>
>
> Revert
>
> : commit bb6eddf7676e1c1f3e637aa93c5224488d99036f
> : Author:     Thomas Gleixner<tglx@linutronix.de>
> : AuthorDate: Thu Dec 10 15:35:10 2009 +0100
> : Commit:     Thomas Gleixner<tglx@linutronix.de>
> : CommitDate: Fri Dec 11 10:28:08 2009 +0100
> :
> :     clockevents: Prevent clockevent_devices list corruption on cpu hotplug
>
> due to the regression reported in
> http://bugzilla.kernel.org/show_bug.cgi?id=15005
>
> Cc: Xiaotian Feng<dfeng@redhat.com>
> Cc: Thomas Gleixner<tglx@linutronix.de>
> Cc: "Rafael J. Wysocki"<rjw@sisk.pl>
> Reported-by: Martin Bammer<mrb74@gmx.at>
> Cc:<stable@kernel.org>
> Signed-off-by: Andrew Morton<akpm@linux-foundation.org>
> ---
>
>   kernel/time/clockevents.c |   18 +++---------------
>   1 file changed, 3 insertions(+), 15 deletions(-)
>
> diff -puN kernel/time/clockevents.c~revert-clockevents-prevent-clockevent_devices-list-corruption-on-cpu-hotplug kernel/time/clockevents.c
> --- a/kernel/time/clockevents.c~revert-clockevents-prevent-clockevent_devices-list-corruption-on-cpu-hotplug
> +++ a/kernel/time/clockevents.c
> @@ -238,9 +238,8 @@ void clockevents_exchange_device(struct
>    */
>   void clockevents_notify(unsigned long reason, void *arg)
>   {
> -	struct clock_event_device *dev, *tmp;
> +	struct list_head *node, *tmp;
>   	unsigned long flags;
> -	int cpu;
>
>   	raw_spin_lock_irqsave(&clockevents_lock, flags);
>   	clockevents_do_notify(reason, arg);
> @@ -251,19 +250,8 @@ void clockevents_notify(unsigned long re
>   		 * Unregister the clock event devices which were
>   		 * released from the users in the notify chain.
>   		 */
> -		list_for_each_entry_safe(dev, tmp,&clockevents_released, list)
> -			list_del(&dev->list);
> -		/*
> -		 * Now check whether the CPU has left unused per cpu devices
> -		 */
> -		cpu = *((int *)arg);
> -		list_for_each_entry_safe(dev, tmp,&clockevent_devices, list) {
> -			if (cpumask_test_cpu(cpu, dev->cpumask)&&
> -			    cpumask_weight(dev->cpumask) == 1) {
> -				BUG_ON(dev->mode != CLOCK_EVT_MODE_UNUSED);
> -				list_del(&dev->list);
> -			}
> -		}
> +		list_for_each_safe(node, tmp,&clockevents_released)
> +			list_del(node);
>   		break;
>   	default:
>   		break;
> _
>
>

