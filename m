Return-Path: <linux-kernel-owner+w=401wt.eu-S1754477AbZAKUMO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754477AbZAKUMO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 15:12:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752650AbZAKULz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 15:11:55 -0500
Received: from relay2.sgi.com ([192.48.179.30]:54955 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752587AbZAKULx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 15:11:53 -0500
Message-ID: <496A5279.9020800@sgi.com>
Date: Sun, 11 Jan 2009 12:11:37 -0800
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Dmitry Adamushko <dmitry.adamushko@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, andeas.herrmann3@amd.com,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Andreas Mohr <andi@lisas.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [patch] Re: [Bug #12100] resume (S2R) broken by Intel microcode
 module, on A110L
References: <1229728524.5122.13.camel@earth> <20081219233006.GA17984@elte.hu>	 <20090111145615.GA26173@elte.hu> <b647ffbd0901111158r467f3358wa50f6a6e92d8129f@mail.gmail.com>
In-Reply-To: <b647ffbd0901111158r467f3358wa50f6a6e92d8129f@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dmitry Adamushko wrote:
> 2009/1/11 Ingo Molnar <mingo@elte.hu>:
>> * Ingo Molnar <mingo@elte.hu> wrote:
>>
>>> * Dmitry Adamushko <dmitry.adamushko@gmail.com> wrote:
>>>
>>>> Hi,
>>>>
>>>>
>>>> This is in response to the following bug report:
>>>>
>>>> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=12100
>>>> Subject         : resume (S2R) broken by Intel microcode module, on A110L
>>>> Submitter       : Andreas Mohr <andi@lisas.de>
>>>> Date            : 2008-11-25 08:48 (19 days old)
>>>> Handled-By      : Dmitry Adamushko <dmitry.adamushko@gmail.com>
>>> applied to tip/x86/microcode, thanks Dmitry!
>>>
>>> The fix looks right but somewhat intrusive in scope, so i'm a bit
>>> reluctant to push it towards .28 straight away - without having feedback
>>> in the bugzilla. If feedback is positive (the bug reported there goes
>>> away completely) we can cherry-pick it over into x86/urgent, ok? And in
>>> any case i've marked it as a -stable backport for .28.1.
>> hm, -tip testing just found this microcode locking lockdep splat:
>>
>> [   48.004158] SMP alternatives: switching to UP code
>> [   48.342853] CPU0 attaching NULL sched-domain.
>> [   48.344288] CPU1 attaching NULL sched-domain.
>> [   48.354696] CPU0 attaching NULL sched-domain.
>> [   48.361215] device: 'cpu1': device_unregister
>> [   48.364231] device: 'cpu1': device_create_release
>> [   48.368138]
>> [   48.368139] =======================================================
>> [   48.372039] [ INFO: possible circular locking dependency detected ]
>> [   48.372039] 2.6.29-rc1-tip-00901-g9699183-dirty #15577
>> [   48.372039] -------------------------------------------------------
>> [   48.372039] S99local/3496 is trying to acquire lock:
>> [   48.372039]  (microcode_mutex){--..}, at: [<c0118489>] microcode_fini_cpu+0x17/0x2b
>> [   48.372039]
>> [   48.372039] but task is already holding lock:
>> [   48.372039]  (&cpu_hotplug.lock){--..}, at: [<c012f508>] cpu_hotplug_begin+0x1f/0x47
>> [   48.372039]
>> [   48.372039] which lock already depends on the new lock.
>> [   48.372039]
>> [   48.372039]
>> [   48.372039] the existing dependency chain (in reverse order) is:
>> [   48.372039]
>> [   48.372039] -> #1 (&cpu_hotplug.lock){--..}:
>> [   48.372039]        [<c014d3f1>] validate_chain+0x8e9/0xb94
>> [   48.372039]        [<c014dd03>] __lock_acquire+0x667/0x6e1
>> [   48.372039]        [<c014ddda>] lock_acquire+0x5d/0x7a
>> [   48.372039]        [<c0a6fac3>] mutex_lock_nested+0xdc/0x170
>> [   48.372039]        [<c012f552>] get_online_cpus+0x22/0x34
>> [   48.372039]        [<c013ce08>] work_on_cpu+0x50/0x8a
>> [   48.372039]        [<c0118465>] microcode_init_cpu+0x25/0x32
>> [   48.372039]        [<c0118699>] mc_sysdev_add+0x91/0x9b
>> [   48.372039]        [<c04cbd09>] sysdev_driver_register+0x9b/0xea
> 
> I'll check more carefully... At the first glance, the presence of
> work_on_cpu() looks strange.
> 
> My first idea was that it's used somewhere by request_firmware() but
> even assuming some functions might have been inlined (and a call via a
> function pointer is not shown either), I don't immediately see how we
> might end up with microcode_init_cpu() -> ... -> work_on_cpu().

It was in a commit that (it appears) Ingo has reverted:

Subject: x86: cleanup remaining cpumask_t code in microcode_core.c

Impact: Reduce problem with changing current->cpus_allowed mask directly.

Use "work_on_cpu" to replace instances where set_cpus_allowed_ptr was being used.

Signed-off-by: Mike Travis <travis@sgi.com>


This work_on_cpu is to replace setting current->cpus_allowed when it's
only for one cpu.  But it has a call to get_online_cpus() that (I believe)
is just to keep from offlining the cpu the work function is running on.
And it's also the cause of the circular lock dependencies.

Thanks,
Mike


> 
> I've locked up all the use cases of work_on_cpu() in the current -tip
> (about 20), and none of them seem to explain its appearance in the
> trace. weird...
> 
> 
>>        Ingo
>>
> 

