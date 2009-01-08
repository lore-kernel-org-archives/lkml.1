Return-Path: <linux-kernel-owner+w=401wt.eu-S1756272AbZAHFNn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756272AbZAHFNn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 00:13:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750837AbZAHFNe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 00:13:34 -0500
Received: from yx-out-2324.google.com ([74.125.44.28]:23671 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750821AbZAHFNd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 00:13:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=MlOAK1ccK7pv/3ViX5LGL7Nk+9bWwYdV/f34oNWyLr6I3Ld3Qj4fx7a6Rd36EgbOIF
         eWGDBJr+ZSef2o/D4nFwz3V5u5hPpzKtnWLd8sYXDay2DV7eq+1wGZSkXGEGaYHTlt1t
         2zyu98LiKpUmYcOuOZUxVDgblFR6k+UrmzQTs=
Message-ID: <49658B77.7010407@gmail.com>
Date: Wed, 07 Jan 2009 21:13:27 -0800
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081126)
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>
CC: Heiko Carstens <heiko.carstens@de.ibm.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org,
       Jeff Chua <jeff.chua.linux@gmail.com>
Subject: Re: [PATCH] stop_machine/cpu hotplug: fix disable_nonboot_cpus
References: <4963F368.7080909@gmail.com>	 <84144f020901062248j5d406656wb21130d914c7749d@mail.gmail.com>	 <84144f020901070030k6fb888f6n84255078e4885d28@mail.gmail.com>	 <20090107091534.GA4633@osiris.boeblingen.de.ibm.com>	 <1231319946.14720.7.camel@penberg-laptop>	 <b6a2187b0901070336u1cb0bc94i1e47a68d8ea671c@mail.gmail.com>	 <20090107122728.GB4633@osiris.boeblingen.de.ibm.com>	 <b6a2187b0901070551r5bb86dbfye96c2c92e7b78087@mail.gmail.com>	 <20090107151946.GA25560@osiris.boeblingen.de.ibm.com> <c62985530901070730j7515a106x2a56a6d8a14fbbc5@mail.gmail.com>
In-Reply-To: <c62985530901070730j7515a106x2a56a6d8a14fbbc5@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frédéric Weisbecker wrote:
> 2009/1/7 Heiko Carstens <heiko.carstens@de.ibm.com>:
>   
>> From: Heiko Carstens <heiko.carstens@de.ibm.com>
>>
>> disable_nonboot_cpus calls _cpu_down. But _cpu_down requires that the
>> caller already created the stop_machine workqueue (like cpu_down does).
>> Otherwise a call to stop_machine will lead to accesses to random memory
>> regions.
>>
>> When introducing this new interface (9ea09af3bd3090e8349ca2899ca2011bd94cda85
>> "stop_machine: introduce stop_machine_create/destroy") I missed the second
>> call site of _cpu_down.
>> So add the missing stop_machine_create/destroy calls to disable_nonboot_cpus
>> as well.
>>
>> Fixes suspend-to-ram/disk and also this bug:
>>
>> [  286.547348] BUG: unable to handle kernel paging request at 6b6b6b6b
>> [  286.548940] IP: [<c0150ca4>] __stop_machine+0x88/0xe3
>> [  286.550598] Oops: 0002 [#1] SMP
>> [  286.560580] Pid: 3273, comm: halt Not tainted (2.6.28-06127-g238c6d5
>> [  286.560580] EIP: is at __stop_machine+0x88/0xe3
>> [  286.560580] Process halt (pid: 3273, ti=f1a28000 task=f4530f30
>> [  286.560580] Call Trace:
>> [  286.560580]  [<c03d04e4>] ? _cpu_down+0x10f/0x234
>> [  286.560580]  [<c012a57e>] ? disable_nonboot_cpus+0x58/0xdc
>> [  286.560580]  [<c01360c0>] ? kernel_poweroff+0x22/0x39
>> [  286.560580]  [<c0136301>] ? sys_reboot+0xde/0x14c
>> [  286.560580]  [<c01331b2>] ? complete_signal+0x179/0x191
>> [  286.560580]  [<c0133396>] ? send_signal+0x1cc/0x1e1
>> [  286.560580]  [<c03de418>] ? _spin_unlock_irqrestore+0x2d/0x3c
>> [  286.560580]  [<c0133b65>] ? group_send_signal_info+0x58/0x61
>> [  286.560580]  [<c0133b9e>] ? kill_pid_info+0x30/0x3a
>> [  286.560580]  [<c0133d49>] ? sys_kill+0x75/0x13a
>> [  286.560580]  [<c01a06cb>] ? mntput_no_expire+ox1f/0x101
>> [  286.560580]  [<c019b3b3>] ? dput+0x1e/0x105
>> [  286.560580]  [<c018ef87>] ?  __fput+0x150/0x158
>> [  286.560580]  [<c0157abf>] ? audit_syscall_entry+0x137/0x159
>> [  286.560580]  [<c010329f>] ? sysenter_do_call+0x12/0x34
>>
>> Reported-by: "Justin P. Mattock" <justinmattock@gmail.com>
>> Reviewed-by: Pekka Enberg <penberg@cs.helsinki.fi>
>> Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
>> ---
>>  kernel/cpu.c |    6 +++++-
>>  1 file changed, 5 insertions(+), 1 deletion(-)
>>
>> Index: linux-2.6/kernel/cpu.c
>> ===================================================================
>> --- linux-2.6.orig/kernel/cpu.c
>> +++ linux-2.6/kernel/cpu.c
>> @@ -379,8 +379,11 @@ static cpumask_var_t frozen_cpus;
>>
>>  int disable_nonboot_cpus(void)
>>  {
>> -       int cpu, first_cpu, error = 0;
>> +       int cpu, first_cpu, error;
>>
>> +       error = stop_machine_create();
>> +       if (error)
>> +               return error;
>>        cpu_maps_update_begin();
>>        first_cpu = cpumask_first(cpu_online_mask);
>>        /* We take down all of the non-boot CPUs in one shot to avoid races
>> @@ -409,6 +412,7 @@ int disable_nonboot_cpus(void)
>>                printk(KERN_ERR "Non-boot CPUs are not disabled\n");
>>        }
>>        cpu_maps_update_done();
>> +       stop_machine_destroy();
>>        return error;
>>  }
>>
>>     
>
>
> That should explain why suspend to disk failed on my box yesterday on
> the processors stage...
> Thanks!
>
>   
I hate to ask this, but I'm going to
anyway:
 when running
gdb /usr/src/linux/vmlinux
(hoping to see if gdb will catch the bug);
I keep getting:
Program terminated with signal SIGKILL, Killed.
The program no longer exists.
You can't do that without a process to debug.

if i do a:
(gdb) disassemble __stop_machine
(as described in Documentation);
I'll see a bit of info.

How do I start/or figure out a process
to debug? i.g. under the bug message
that I wrote down, it says Pid: 3273
entering that in (gdb) r 3273
results in a SIGKILL.

regards;

Justin P. Mattock



