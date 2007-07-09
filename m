Return-Path: <linux-kernel-owner+w=401wt.eu-S1756632AbXGIMDH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756632AbXGIMDH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 08:03:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751865AbXGIMCy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 08:02:54 -0400
Received: from il.qumranet.com ([82.166.9.18]:51001 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755868AbXGIMCw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 08:02:52 -0400
Message-ID: <469223F1.8000904@qumranet.com>
Date: Mon, 09 Jul 2007 15:02:57 +0300
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Sasa Ostrouska <casaxa@gmail.com>, linux-kernel@vger.kernel.org,
       KVM <kvm-devel@lists.sourceforge.net>,
       kvm-devel <kvm-devel@lists.sourceforge.net>
Subject: Re: KVM-AMD OOPS
References: <dcf706c60707080915w7660a2exe629c5def78549da@mail.gmail.com> <4691BF62.2060207@goop.org> <4691DEE3.5050305@argo.co.il>
In-Reply-To: <4691DEE3.5050305@argo.co.il>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Avi Kivity wrote:
> Jeremy Fitzhardinge wrote:
>   
>> Sasa Ostrouska wrote:
>>     
>>> root@rcserver:~# modprobe kvm-amd
>>> int3: 0000 [1] PREEMPT SMP
>>> CPU 1
>>> Modules linked in: kvm_amd snd_seq_dummy snd_seq_oss
>>> snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss snd_mixer_oss
>>> nls_iso8859_1 ntfs nls_base usb_storage libusual capability commoncap
>>> lp psmouse snd_hda_intel snd_hda_codec snd_pcm snd_timer ohci_hcd
>>> ehci_hcd 8139too rtc_cmos snd soundcore snd_page_alloc usbcore k8temp
>>> mii rtc_core rtc_lib i2c_nforce2 parport_pc parport
>>> Pid: 2898, comm: modprobe Tainted: P       2.6.21.5 #1
>>> RIP: 0010:[<ffffffff80572364>]  [<ffffffff80572364>]
>>> register_cpu_notifier+0x1/0x31
>>> RSP: 0000:ffff81006e34df40  EFLAGS: 00000246
>>> RAX: 0000000000000000 RBX: 0000000000000000 RCX: 00000000c0010117
>>> RDX: 000000000000ffff RSI: ffff81006e219640 RDI: ffffffff80536510
>>> RBP: ffffffff880d8840 R08: 0000000000000000 R09: 000000000006b5f4
>>> R10: 0000000000000000 R11: 0000000000000000 R12: 00000000005296b0
>>> R13: 00007fff51fe55c0 R14: 0000000000000000 R15: 0000000000000000
>>> FS:  00002b4e58e18b00(0000) GS:ffff810002e794c0(0000)
>>> knlGS:0000000000000000
>>> CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
>>> CR2: 000000000050df64 CR3: 000000007a0f3000 CR4: 00000000000006e0
>>> Process modprobe (pid: 2898, threadinfo ffff81006e34c000, task
>>> ffff81007bc48400)
>>> Stack:  ffffffff8039e024 ffff81006e34c000 ffffffff880d8840
>>> 0000000000005e19
>>> ffffffff8024537c 0000000000000000 00007fff51fe50c0 00000000004142d0
>>> ffffffff8020967e 0000000000000206 00000000005230e0 000000000052f4c9
>>> Call Trace:
>>> [<ffffffff8039e024>] kvm_init_arch+0x90/0x145
>>> [<ffffffff8024537c>] sys_init_module+0xad/0x168
>>> [<ffffffff8020967e>] system_call+0x7e/0x83
>>>
>>>
>>> Code: cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc
>>>       
>> This is the init section poison pattern.  Looks like an init function
>> was used after the code was freed.
>>     
>
> Indeed, the function is register_cpu_notifier which is declared
> __cpuinit, which, without hotplug compiled in, is simply __init.
>
> I'll prepare a patch for this.  Meanwhile, you can work around it by
> enabling CONFIG_HOTPLUG_CPU.
>
>   

Well, this nice patch (in 2.6.21) ought to have fixed it:

commit 47e627bc8c9a70392d2049e6af5bd55fae61fe53
Author: Avi Kivity <avi@qumranet.com>
Date:   Mon Feb 12 00:54:43 2007 -0800

    [PATCH] hotplug: Allow modules to use the cpu hotplug notifiers even if !CONFIG_HOTPLUG_CPU
    
    The following patchset allows a host with running virtual machines to be
    suspended and, on at least a subset of the machines tested, resumed.  Note
    that this is orthogonal to suspending and resuming an individual guest to a
    file.
    
    A side effect of implementing suspend/resume is that cpu hotplug is now
    supported.  This should please the owners of big iron.
    
    This patch:
    
    KVM wants the cpu hotplug notifications, both for cpu hotplug itself, but more
    commonly for host suspend/resume.
    
    In order to avoid extensive #ifdefs, provide stubs when CONFIG_CPU_HOTPLUG is
    not defined.
    
    In all, we have four cases:
    
    - UP: register and unregister stubbed out
    - SMP+hotplug: full register and unregister
    - SMP, no hotplug, core: register as __init, unregister stubbed
          (cpus are brought up during core initialization)
    - SMP, no hotplug, module: register and unregister stubbed out
          (cpus cannot be brought up during module lifetime)
    
    Signed-off-by: Avi Kivity <avi@qumranet.com>
    Cc: Ingo Molnar <mingo@elte.hu>
    Cc: Rusty Russell <rusty@rustcorp.com.au>
    Cc: Oleg Nesterov <oleg@tv-sign.ru>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

diff --git a/include/linux/cpu.h b/include/linux/cpu.h
index bfb5202..769ddc6 100644
--- a/include/linux/cpu.h
+++ b/include/linux/cpu.h
@@ -49,10 +49,20 @@ struct notifier_block;
 
 #ifdef CONFIG_SMP
 /* Need to know about CPUs going up/down? */
-extern int register_cpu_notifier(struct notifier_block *nb);
 #ifdef CONFIG_HOTPLUG_CPU
+extern int register_cpu_notifier(struct notifier_block *nb);
 extern void unregister_cpu_notifier(struct notifier_block *nb);
 #else
+
+#ifndef MODULE
+extern int register_cpu_notifier(struct notifier_block *nb);
+#else
+static inline int register_cpu_notifier(struct notifier_block *nb)
+{
+	return 0;
+}
+#endif
+
 static inline void unregister_cpu_notifier(struct notifier_block *nb)
 {
 }


Please post your .config.


-- 
error compiling committee.c: too many arguments to function

