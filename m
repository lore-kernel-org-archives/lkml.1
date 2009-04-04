Return-Path: <linux-kernel-owner+w=401wt.eu-S1754272AbZDDPmq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754272AbZDDPmq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Apr 2009 11:42:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751518AbZDDPmg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Apr 2009 11:42:36 -0400
Received: from tomts40.bellnexxia.net ([209.226.175.97]:63221 "EHLO
	tomts40-srv.bellnexxia.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751501AbZDDPmf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Apr 2009 11:42:35 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AlwFAO4c10lMQW1W/2dsb2JhbACBUspNhA8G
Date: Sat, 4 Apr 2009 11:42:30 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>,
       systemtap-ml <systemtap@sources.redhat.com>
Subject: Re: [BUG][-tip] kprobes on module functions hits kernel BUG in
	text_poke on x86-32
Message-ID: <20090404154230.GB2451@Krystal>
References: <49D76FFF.6020202@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <49D76FFF.6020202@redhat.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 11:35:38 up 35 days, 12:01,  1 user,  load average: 0.63, 0.51,
	0.39
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Masami Hiramatsu (mhiramat@redhat.com) wrote:
> Hi,
> 
> I found text_poke() problem on x86-32 with the latest-tip tree.
> When I put a kprobe on a module function, text_poke() hit a BUG.
> 
> This bug can be reproduced on x86-32, but not on x86-64.
> And inserting kprobes on a kernel-core function is OK.
> 
> Thank you,
> 

Hi Masami,

OK, so text_poke safety net saves the day :)

Basically, what we have here is the BUG_ON I have put :

       for (i = 0; i < len; i++)
                BUG_ON(((char *)addr)[i] != ((char *)opcode)[i]);

Which checks that the modification is really preceivable in the kernel
code, triggers this bug. Only for modules you say.

It might not be this, but.. let's try something simple (this could be
completely unrelated, but won't take long to test): can you try to add a
vmalloc_sync_all() at the beginning of text_poke ? This would make sure
that lazily-populated TLB entries, which include module code and data on
x86, will be populated. I wonder if we hit this problem because
vmalloc_to_page would be returning a mapping to a yet unpopulated TLB
entry, if it is ever possible.

If that's not this, then I guess we have some problem with setting a
fixmap to a page returned by vmalloc on x86 32.

Mathieu


> ------------[ cut here ]------------
> kernel BUG at /home/mhiramat/ksrc/linux-2.6-tip/arch/x86/kernel/alternative.c:543!
> invalid opcode: 0000 [#1] SMP DEBUG_PAGEALLOC
> last sysfs file: /sys/devices/pci0000:00/0000:00:03.0/0000:02:00.0/net/eth0/broadcast
> Modules linked in: probe_bench(+) netconsole configfs sunrpc ipt_REJECT nf_conntrack_ipv4 nf_defrag_ipv4 xt_state
> nf_conntrack iptable_filter ip_tables ip6table_filter ip6_tables ipv6 cpufreq_ondemand powernow_k8 dm_mirror
> dm_region_hash dm_log dm_multipath uinput snd_hda_codec_idt snd_hda_intel snd_hda_codec snd_hwdep snd_seq_dummy
> snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss snd_mixer_oss snd_pcm snd_timer snd soundcore dcdbas
> i2c_nforce2 pcspkr tg3 snd_page_alloc rtc_cmos rtc_core i2c_core libphy rtc_lib ata_generic pata_acpi sata_nv [last
> unloaded: scsi_wait_scan]
> 
> Pid: 5411, comm: insmod Not tainted (2.6.29-tip #8) OptiPlex 740
> EIP: 0060:[<c06e97ef>] EFLAGS: 00210893 CPU: 0
> EIP is at text_poke+0x168/0x1a4
> EAX: 00040f55 EBX: 00020800 ECX: f45d8f03 EDX: 00000000
> ESI: f45d8f04 EDI: ffc58001 EBP: f45d8ef8 ESP: f45d8ed8
>  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
> Process insmod (pid: 5411, ti=f45d8000 task=f4490000 task.ti=f45d8000)
> Stack:
>  00000001 f45d8f03 f8464000 00200286 00000000 00000000 00000000 f846492c
>  f45d8f04 c06ea30d cc46492c f45d8f30 c06eb4bb 000000d8 f8464934 f84647e4
>  f84647e4 00936fc0 f45d8f30 f84647e4 fffffffc 00936fc0 f45d8f40 f8464110
> Call Trace:
>  [<f8464000>] ? dummy_function+0x0/0xb [probe_bench]
>  [<c06ea30d>] ? arch_arm_kprobe+0x1a/0x1c
>  [<c06eb4bb>] ? register_kprobe+0x3b8/0x40a
>  [<f8464110>] ? install_probe+0x31/0x13d [probe_bench]
>  [<c040304f>] ? do_one_initcall+0x4a/0x11a
>  [<f84640df>] ? install_probe+0x0/0x13d [probe_bench]
>  [<c044b8fe>] ? up_read+0x16/0x2c
>  [<c044c14e>] ? __blocking_notifier_call_chain+0x40/0x4c
>  [<c045e5e4>] ? sys_init_module+0x89/0x18c
>  [<c0407b44>] ? sysenter_do_call+0x12/0x38
> Code: 00 00 6a 00 ff 15 04 83 85 c0 58 5a e8 86 82 d3 ff 90 b8 01 00 00 00 0f a2 31 d2 eb 13 8b 4d e8 8a 04 11 8b 4d e4
> 3a 04 11 74 04 <0f> 0b eb fe 42 3b 55 e0 72 e8 f7 45 ec 00 02 00 00 75 10 8b 45
> EIP: [<c06e97ef>] text_poke+0x168/0x1a4 SS:ESP 0068:f45d8ed8
> ---[ end trace 12f1ca8c7f7964a0 ]---
> Kernel panic - not syncing: Fatal exception
> Pid: 5411, comm: insmod Tainted: G      D    2.6.29-tip #8
> Call Trace:
>  [<c06e6081>] ? printk+0xf/0x16
>  [<c06e5fc8>] panic+0x39/0xe3
>  [<c06e9526>] oops_end+0x96/0xa5
>  [<c040a486>] die+0x54/0x5a
>  [<c06e8e43>] do_trap+0x89/0xa2
>  [<c0408bbe>] ? do_invalid_op+0x0/0x7b
>  [<c0408c2f>] do_invalid_op+0x71/0x7b
>  [<c06e97ef>] ? text_poke+0x168/0x1a4
>  [<c045567d>] ? mark_lock+0x1e/0x1e0
>  [<c042672c>] ? set_pte_vaddr+0xac/0xcf
>  [<c054d6fc>] ? trace_hardirqs_off_thunk+0xc/0x10
>  [<c06e8bfa>] error_code+0x72/0x78
>  [<c0408bbe>] ? do_invalid_op+0x0/0x7b
>  [<c06e97ef>] ? text_poke+0x168/0x1a4
>  [<f8464000>] ? dummy_function+0x0/0xb [probe_bench]
>  [<c06ea30d>] arch_arm_kprobe+0x1a/0x1c
>  [<c06eb4bb>] register_kprobe+0x3b8/0x40a
>  [<f8464110>] install_probe+0x31/0x13d [probe_bench]
>  [<c040304f>] do_one_initcall+0x4a/0x11a
>  [<f84640df>] ? install_probe+0x0/0x13d [probe_bench]
>  [<c044b8fe>] ? up_read+0x16/0x2c
>  [<c044c14e>] ? __blocking_notifier_call_chain+0x40/0x4c
>  [<c045e5e4>] sys_init_module+0x89/0x18c
>  [<c0407b44>] sysenter_do_call+0x12/0x38
> Rebooting in 5 seconds..
> 
> -- 
> Masami Hiramatsu
> 
> Software Engineer
> Hitachi Computer Products (America) Inc.
> Software Solutions Division
> 
> e-mail: mhiramat@redhat.com
> 
> 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
