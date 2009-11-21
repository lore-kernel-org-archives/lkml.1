Return-Path: <linux-kernel-owner+w=401wt.eu-S1755902AbZKUPnh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755902AbZKUPnh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Nov 2009 10:43:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755481AbZKUPng
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Nov 2009 10:43:36 -0500
Received: from tomts10.bellnexxia.net ([209.226.175.54]:53491 "EHLO
	tomts10-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754369AbZKUPng (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Nov 2009 10:43:36 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Aq8EAJOVB0tGGN1W/2dsb2JhbACBTdIPhDwEgXA
Date: Sat, 21 Nov 2009 10:38:40 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Jason Baron <jbaron@redhat.com>, mingo@elte.hu,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, hpa@zytor.com, tglx@linutronix.de,
       rostedt@goodmis.org, andi@firstfloor.org, roland@redhat.com,
       rth@redhat.com
Subject: Re: [RFC PATCH 2/6] jump label v3 - x86: Introduce generic jump
	patching without stop_machine
Message-ID: <20091121153840.GB12100@Krystal>
References: <cover.1258580048.git.jbaron@redhat.com> <37e397b27509c378f93b9a30f1158791d1b99be7.1258580048.git.jbaron@redhat.com> <20091119002826.GB28962@Krystal> <4B073E59.2000808@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <4B073E59.2000808@redhat.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 10:37:37 up 95 days,  2:27,  3 users,  load average: 0.31, 0.30,
	0.20
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Masami Hiramatsu (mhiramat@redhat.com) wrote:
> Mathieu Desnoyers wrote:
>> * Jason Baron (jbaron@redhat.com) wrote:
>>> Add text_poke_fixup() which takes a fixup address to where a processor
>>> jumps if it hits the modifying address while code modifying.
>>> text_poke_fixup() does following steps for this purpose.
>>>
>>>   1. Setup int3 handler for fixup.
>>>   2. Put a breakpoint (int3) on the first byte of modifying region,
>>>      and synchronize code on all CPUs.
>>>   3. Modify other bytes of modifying region, and synchronize code on all CPUs.
>>>   4. Modify the first byte of modifying region, and synchronize code
>>>      on all CPUs.
>>>   5. Clear int3 handler.
>>>
>>
>> Hi Masami,
>>
>> I like the approach and the API is clean. I have intersped comments
>> below.
>>
>> Ingo: I raise a question about text_mutex vs on_each_cpu hangs I
>> experienced recently in the message below. Might be worth having a look,
>> I suspect this might have caused the hangs Paul McKenney had with his
>> past TREE RCU callback migration. I think he did take a mutex in the cpu
>> hotplug callbacks and might have used IPIs within that same lock.
>
> Hi Mathieu,
>
> I guess that the hang might happen as below;
>
> ----
> lock text_mutex
> modify code
> on_each_cpu(do_something)
>                               cpu-hotplug (down)
>                               lock cpu-hotplug mutex
>                               online_cpus is changed
>                               native_cpu_die()
>                               ->alternatives_smp_switch(0)
>                                 ->lock text_mutex -> sleep
> (wait for offlined cpu...)
> ----
>
> If this is correct, I think we can fix it as below.
>
> ----
> lock cpu-hotplug mutex

Yes, this is the solution I used in my own immediate values code too.

> lock text_mutex
> modify code
> on_each_cpu(do_something)
> unlock text_mutex
> unlock cpu-hotplug mutex
>                               cpu-hotplug (down)
>                               lock cpu-hotplug mutex
>                               online_cpus is changed
>                               native_cpu_die()
>                               ->alternatives_smp_switch(0)
>                                 ->lock text_mutex
>                                   modify code
>                                   unlock text_mutex
>                               ...
>                               unlock cpu-hotplug mutex
> ----
> Or,
> ----
> lock text_mutex
> modify code
> unlock text_mutex
> on_each_cpu(do_something)
>                               cpu-hotplug (down)
>                               lock cpu-hotplug mutex
>                               online_cpus is changed
>                               native_cpu_die()
>                               ->alternatives_smp_switch(0)
>                                 ->lock text_mutex
>                                   modify code
>                                   unlock text_mutex
>                               ...
>                               unlock cpu-hotplug mutex
> ----
> The latter needs another mutex for int3 handler and
> frequently mutex_lock/unlock in this patch.
>
> Hmm?

The simplest solution seems to be the best one IMHO. But have you been
able to reproduce the lockup ?

Mathieu

>
> Thank you,
>
> -- 
> Masami Hiramatsu
>
> Software Engineer
> Hitachi Computer Products (America), Inc.
> Software Solutions Division
>
> e-mail: mhiramat@redhat.com
>

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
