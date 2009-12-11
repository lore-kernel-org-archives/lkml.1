Return-Path: <linux-kernel-owner+w=401wt.eu-S1762180AbZLKC3x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762180AbZLKC3x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 21:29:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754849AbZLKC3u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 21:29:50 -0500
Received: from mx1.redhat.com ([209.132.183.28]:45818 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753845AbZLKC3t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 21:29:49 -0500
Message-ID: <4B21AE87.5000009@redhat.com>
Date: Fri, 11 Dec 2009 10:29:27 +0800
From: Xiaotian Feng <dfeng@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-3.9.b4.fc12 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: damm@igel.co.jp, hsweeten@visionengravers.com, akpm@linux-foundation.org,
       venkatesh.pallipadi@intel.com, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/4] clockevents: fix clockevent_devices list corruption
 after cpu hotplug
References: <1260450459-18072-1-git-send-email-dfeng@redhat.com> <alpine.LFD.2.00.0912101431380.3089@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0912101431380.3089@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/10/2009 10:35 PM, Thomas Gleixner wrote:
> On Thu, 10 Dec 2009, Xiaotian Feng wrote:
>> I've met a list_del corruption, which was reported in
>> http://lkml.org/lkml/2009/11/27/45. But no response, so I try to debug it
>> by myself.
>>
>> After I added some printks to show all elements in clockevent_devices, I
>> found kernel hangs when I tried to resume from s2ram.
>>
>> In clockevents_register_device, clockevents_do_notify ADD is always followed
>> by clockevents_notify_released. Although clockevents_do_notify ADD will use
>> tick_check_new_device to add new devices and replace old devices to the
>> clockevents_released list, clockevents_notify_released add them back to
>> clockevent_devices list.
>>
>> My system is Quad-Core x86_64, with apic and hpet enables, after boot up,
>> the elements in clockevent_devices list is :
>> clockevent_device->lapic(3)->hpet5(3)->lapic(2)->hpet4(2)->lapic(1)->hpet3(1)-
>>    ->lapic(0)->hpet2(0)->hpet(0)
>> * () means cpu id
>>
>> But active clock_event_device is hpet2,hpet3,hpet4,hpet5. Then at s2ram stage,
>> cpu 1,2,3 is down, then notify CLOCK_EVT_NOTIFY_CPU_DEAD will calls tick_shutdown,
>> then hpet2,hpet3,hpet4,hpet5 was deleted from clockevent_device list.
>> So after s2ram, elements in clockevent_device list is:
>> clockevent_device->lapic(3)->lapic(2)->lapic(1)->lapic(0)->hpet2(0)->hpet(0)
>>
>> Then at resume stage, cpu 1,2,3 is up, it will register lapic again, and then
>> perform list_add lapic on clockevent_device list, e.g. list_add lapic(1) on
>> above list, lapic will move to the clockevent_device->next, but lapic(2)->next
>> is still point to lapic(1), the list is circular and corrupted then.
>
> Great detective work !
>
>> This patchset aims to fixes above behaviour by:
>>         - on clockevents_register_device, if notify ADD success, move new devices
>>           to the clockevent_devices list, otherwise move to clockevents_released
>>           list.
>>         - on clockevents_notify_released, same behaviour as above.
>>         - on clockevents_notify CPU_DEAD, remove related devices on dead cpu from
>>           clockevents_released list.
>>
>> It makes sure that only active devices on each cpu is on clockevent_devices list.
>> With this patchset, the list_del corruption disappeared, and suspend/resume, cpu
>> hotplug works fine on my system.
>
> I'm not happy about that churn. Why don't we simply scan the
> clockevent_devices list for leftovers of the dead CPU ?
My only thought is to make clockevent_devices list only store active 
devices on each cpu, all other inactive devices stored on 
clockevents_released, but this make things complex. Your patch is better.
>
> Untested patch below solves the same problem.
Yes, this also resolves my list_del warning. Thanks
>
> Thanks,
>
> 	tglx
> ----
> diff --git a/kernel/time/clockevents.c b/kernel/time/clockevents.c
> index 20a8920..5dd857f 100644
> --- a/kernel/time/clockevents.c
> +++ b/kernel/time/clockevents.c
> @@ -238,8 +238,9 @@ void clockevents_exchange_device(struct clock_event_device *old,
>    */
>   void clockevents_notify(unsigned long reason, void *arg)
>   {
> -	struct list_head *node, *tmp;
> +	struct clock_event_device *dev, *tmp;
>   	unsigned long flags;
> +	int cpu;
>
>   	spin_lock_irqsave(&clockevents_lock, flags);
>   	clockevents_do_notify(reason, arg);
> @@ -250,8 +251,19 @@ void clockevents_notify(unsigned long reason, void *arg)
>   		 * Unregister the clock event devices which were
>   		 * released from the users in the notify chain.
>   		 */
> -		list_for_each_safe(node, tmp,&clockevents_released)
> -			list_del(node);
> +		list_for_each_entry_safe(dev, tmp,&clockevents_released, list)
> +			list_del(&dev->list);
> +		/*
> +		 * Now check whether the CPU has left unused per cpu devices
> +		 */
> +		cpu = *((int *)arg);
> +		list_for_each_entry_safe(dev, tmp,&clockevent_devices, list) {
> +			if (cpumask_test_cpu(cpu, dev->cpumask)&&
> +			    cpumask_weight(dev->cpumask) == 1) {
> +				BUG_ON(dev->mode != CLOCK_EVT_MODE_UNUSED);
> +				list_del(&dev->list);
> +			}
> +		}
>   		break;
>   	default:
>   		break;
>
>
>

