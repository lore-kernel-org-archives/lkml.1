Return-Path: <linux-kernel-owner+w=401wt.eu-S1753960AbZKUBMa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753960AbZKUBMa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 20:12:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752851AbZKUBM3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 20:12:29 -0500
Received: from mx1.redhat.com ([209.132.183.28]:65379 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752476AbZKUBM2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 20:12:28 -0500
Message-ID: <4B073E59.2000808@redhat.com>
Date: Fri, 20 Nov 2009 20:11:53 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Jason Baron <jbaron@redhat.com>, mingo@elte.hu,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, hpa@zytor.com, tglx@linutronix.de,
       rostedt@goodmis.org, andi@firstfloor.org, roland@redhat.com,
       rth@redhat.com
Subject: Re: [RFC PATCH 2/6] jump label v3 - x86: Introduce generic jump	patching
 without stop_machine
References: <cover.1258580048.git.jbaron@redhat.com> <37e397b27509c378f93b9a30f1158791d1b99be7.1258580048.git.jbaron@redhat.com> <20091119002826.GB28962@Krystal>
In-Reply-To: <20091119002826.GB28962@Krystal>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mathieu Desnoyers wrote:
> * Jason Baron (jbaron@redhat.com) wrote:
>> Add text_poke_fixup() which takes a fixup address to where a processor
>> jumps if it hits the modifying address while code modifying.
>> text_poke_fixup() does following steps for this purpose.
>>
>>   1. Setup int3 handler for fixup.
>>   2. Put a breakpoint (int3) on the first byte of modifying region,
>>      and synchronize code on all CPUs.
>>   3. Modify other bytes of modifying region, and synchronize code on all CPUs.
>>   4. Modify the first byte of modifying region, and synchronize code
>>      on all CPUs.
>>   5. Clear int3 handler.
>>
>
> Hi Masami,
>
> I like the approach and the API is clean. I have intersped comments
> below.
>
> Ingo: I raise a question about text_mutex vs on_each_cpu hangs I
> experienced recently in the message below. Might be worth having a look,
> I suspect this might have caused the hangs Paul McKenney had with his
> past TREE RCU callback migration. I think he did take a mutex in the cpu
> hotplug callbacks and might have used IPIs within that same lock.

Hi Mathieu,

I guess that the hang might happen as below;

----
lock text_mutex
modify code
on_each_cpu(do_something)
                               cpu-hotplug (down)
                               lock cpu-hotplug mutex
                               online_cpus is changed
                               native_cpu_die()
                               ->alternatives_smp_switch(0)
                                 ->lock text_mutex -> sleep
(wait for offlined cpu...)
----

If this is correct, I think we can fix it as below.

----
lock cpu-hotplug mutex
lock text_mutex
modify code
on_each_cpu(do_something)
unlock text_mutex
unlock cpu-hotplug mutex
                               cpu-hotplug (down)
                               lock cpu-hotplug mutex
                               online_cpus is changed
                               native_cpu_die()
                               ->alternatives_smp_switch(0)
                                 ->lock text_mutex
                                   modify code
                                   unlock text_mutex
                               ...
                               unlock cpu-hotplug mutex
----
Or,
----
lock text_mutex
modify code
unlock text_mutex
on_each_cpu(do_something)
                               cpu-hotplug (down)
                               lock cpu-hotplug mutex
                               online_cpus is changed
                               native_cpu_die()
                               ->alternatives_smp_switch(0)
                                 ->lock text_mutex
                                   modify code
                                   unlock text_mutex
                               ...
                               unlock cpu-hotplug mutex
----
The latter needs another mutex for int3 handler and
frequently mutex_lock/unlock in this patch.

Hmm?

Thank you,

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

