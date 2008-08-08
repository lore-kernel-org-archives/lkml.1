Return-Path: <linux-kernel-owner+w=401wt.eu-S1757192AbYHHCPX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757192AbYHHCPX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 22:15:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754549AbYHHCPL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 22:15:11 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:62966 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754458AbYHHCPJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 22:15:09 -0400
Message-ID: <489BABD0.7030607@cn.fujitsu.com>
Date: Fri, 08 Aug 2008 10:13:36 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Max Krasnyansky <maxk@qualcomm.com>
CC: mingo@elte.hu, akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       jeff.chua.linux@gmail.com
Subject: Re: [PATCH] Resurect proper handling of maxcpus= kernel option
References: <1218052854-5020-1-git-send-email-Krasnyansky@qualcomm.com> <489A7359.8090607@cn.fujitsu.com> <489B2F0B.7020304@qualcomm.com>
In-Reply-To: <489B2F0B.7020304@qualcomm.com>
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Max Krasnyansky wrpte:
> Li Zefan wrote:
>> Max.Krasnyansky@qualcomm.com wrote:
>>> From: Max Krasnyansky <maxk@qualcomm.com>
>>>
>>> For some reason we had redundant parsers registered for maxcpus=. 
>>> One in init/main.c and another in arch/x86/smpboot.c
>>> So I nuked the one in arch/x86.
>>>
>>> Also 64-bit kernels used to handle maxcpus= as documented in
>>> Documentation/cpu-hotplug.txt. CPUs with 'id > maxcpus' are initialized
>>> but not booted. 32-bit version for some reason ignored them even though
>>> all the infrastructure for booting them later is there.
>>>
>>> In the current mainline both 64 and 32 bit versions are broken. I'm
>>> too lazy to look through git history but I'm guessing it happened as
>>> part of the i386 and x86_64 unification.
>>>
>>> This patch restores the correct behaviour. I've tested x86_64 version on
>>> 4- and 8- way Core2 and 2-way Opteron based machines. Various config
>>> combinations SMP, !SMP, CPU_HOTPLUG, !CPU_HOTPLUG.
>>> Booted with maxcpus=1 and maxcpus=4, etc. Everything is working as expected.
>>>
>>> I cannot test 32-bit version (no 32-bit machines here).
>>>
>> I booted my 2-core x86_32 box with maxcpus=1, and saw cpu1 was offline,
>> and then I got softlockup BUG immediately when I onlined cpu1:
>>
>> SMP alternatives: switching to SMP code
>> CPU 1 irqstacks, hard=c078c000 soft=c076c000
>> Booting processor 1/1 ip 6000
>> Initializing CPU#1
>> Calibrating delay using timer specific routine.. 5600.37 BogoMIPS (lpj=2800188)
>> CPU: Trace cache: 12K uops, L1 D cache: 16K
>> CPU: L2 cache: 1024K
>> CPU: Physical Processor ID: 0
>> CPU: Processor Core ID: 1
>> Intel machine check architecture supported.
>> Intel machine check reporting enabled on CPU#1.
>> CPU1: Intel P4/Xeon Extended MCE MSRs (24) available
>> CPU1: Thermal monitoring enabled
>> CPU1: Intel(R) Pentium(R) D CPU 2.80GHz stepping 04
>> checking TSC synchronization [CPU#0 -> CPU#1]: passed.
>> Switched to high resolution mode on CPU 1
>> BUG: soft lockup - CPU#1 stuck for 216s! [events/0:0]
>> Modules linked in: bridge stp llc autofs4 dm_mirror dm_log dm_mod snd_intel8x0 snd_ac97_codec ac97_bus snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss snd_pcm snd_timer snd soundcore r8169 snd_page_alloc sg button sata_sis pata_sis ata_generic libata sd_mod scsi_mod ext3 jbd mbcache uhci_hcd ohci_hcd ehci_hcd [last unloaded: scsi_wait_scan]
>> irq event stamp: 156
>> hardirqs last  enabled at (155): [<c044407f>] trace_hardirqs_on+0xb/0xd
>> hardirqs last disabled at (156): [<c04eee88>] trace_hardirqs_off_thunk+0xc/0x10
>> softirqs last  enabled at (152): [<c042c2f3>] __do_softirq+0xe3/0xe9
>> softirqs last disabled at (95): [<c04058eb>] do_softirq+0x65/0xb4
>>
>> Pid: 0, comm: events/0 Not tainted (2.6.27-rc1 #224)
>> EIP: 0060:[<c04088ba>] EFLAGS: 00000246 CPU: 1
>> EIP is at mwait_idle+0x3c/0x4a
>> EAX: 00000000 EBX: e3e48008 ECX: 00000000 EDX: 00000000
>> ESI: 00000000 EDI: 00000000 EBP: e3e48f9c ESP: e3e48f98
>>  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
>> CR0: 8005003b CR2: 00000000 CR3: 00768000 CR4: 000006d0
>> DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
>> DR6: ffff0ff0 DR7: 00000400
>>  [<c0402591>] cpu_idle+0xbf/0xdf
>>  [<c05fb737>] start_secondary+0x16b/0x170
>>  =======================
>>
>>
>> 216s should be the time since the machine booted up.
>>
>>
>> (maybe off-topic)
>> I never succeed to offline cpu1, it caused the kernel to hang
>> whenver I offlined cpu1
> 
> This is unrelated to the patch that I sent. In fact looks like the patch
> actually worked for you. In the sense that it did the right thing,
> initialized cpus but did not boot them.
> 
> As far as the soft-lockup goes you might want to try different configs.
> ie Disable features you do not need. For example cpusets hotplug path in
> the current mainline is unsafe (the patch is in review). Also for me if
> ftrace is enabled onlining a cpu causes immediate reboot. So I'd say
> start disabling features and see which one cases the problem.
> 

Yes, the patch works for me, and the soft-lockup is another different issue.
Thx for the explanation. :)

