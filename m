Return-Path: <linux-kernel-owner+w=401wt.eu-S1757000AbZIKVpQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757000AbZIKVpQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 17:45:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756988AbZIKVpO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 17:45:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62886 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756985AbZIKVpK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 17:45:10 -0400
Message-ID: <4AAAC5A8.208@redhat.com>
Date: Fri, 11 Sep 2009 17:48:24 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       lkml <linux-kernel@vger.kernel.org>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Andi Kleen <ak@linux.intel.com>, Christoph Hellwig <hch@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Jason Baron <jbaron@redhat.com>, Jim Keniston <jkenisto@us.ibm.com>,
       "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       Tom Zanussi <tzanussi@gmail.com>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>
Subject: Re: [PATCH tracing/kprobes 0/7] tracing/kprobes: kprobe-based	event
 tracer update and perf support
References: <20090910235258.22412.29317.stgit@dhcp-100-2-132.bos.redhat.com> <20090911153609.GA6069@nowhere>
In-Reply-To: <20090911153609.GA6069@nowhere>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frederic Weisbecker wrote:
>
> I've tested the above example and it works very well,
> so I've applied this set, and the previous pending patches
> in:
>
> git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git \
> 	tracing/kprobes

I had a bug on that tree when I did Step.1

 > (Step.1) Define new events under new group
 >
 > $ echo p:mygroup/myprobe do_sys_open dfd=a0 filename=a1 flags=a2 mode=a3 \
 >  > /debug/tracing/kprobes_events
 > $ echo r:mygroup/myretprobe do_sys_open rv >> /debug/tracing/kprobes_events
 > $ cat /debug/tracing/kprobes_events
 > p:myprobe do_sys_open+0 dfd=a0 filename=a1 flags=a2 mode=a3
 > r:myretprobe do_sys_open+0 rv=rv

It seems that you forget to pull PATCH 7/7 of my previous series.
And also I've found my probe registration order is buggy.
I'll fix that.

Thank you,

----
Could not create debugfs 'mygroup/myprobe' directory
Failed to register kprobe event: mygroup/myprobe
Faild to register probe event(-1)
BUG: unable to handle kernel NULL pointer dereference at (null)
IP: [<c0537085>] list_del+0x9/0x60
*pdpt = 000000001f1ed001 *pde = 000000001f1da067 *pte = 0000000000000000
Oops: 0000 [#1] SMP
last sysfs file: /sys/devices/virtual/tty/tty9/uevent
Modules linked in: sunrpc uinput virtio_balloon virtio_net i2c_piix4 pcspkr i2c_
core virtio_blk virtio_pci virtio_ring virtio [last unloaded: scsi_wait_scan]

Pid: 1372, comm: tee Not tainted (2.6.31-rc9 #49)
EIP: 0060:[<c0537085>] EFLAGS: 00210246 CPU: 0
EIP is at list_del+0x9/0x60
EAX: 00000000 EBX: d8d2166c ECX: ccd2165c EDX: 00000000
ESI: d8d21600 EDI: dedecc40 EBP: d8dc9eac ESP: d8dc9ea8
  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
Process tee (pid: 1372, ti=d8dc8000 task=d8da57f0 task.ti=d8dc8000)
Stack:
  d8d2166c d8dc9ebc c047f1db d8d2166c d8d21600 d8dc9ec8 c047f27e d8d21600
<0> d8dc9ed4 c04823bc d8d21600 d8dc9f4c c048302b 0000000c 00000000 00000002
<0> dedecba0 00000001 decbabe8 c044a1b3 d993e114 d993e000 00000001 d993e110
Call Trace:
  [<c047f1db>] ? __trace_remove_event_call+0x29/0xb5
  [<c047f27e>] ? trace_remove_event_call+0x17/0x24
  [<c04823bc>] ? unregister_trace_probe+0xe/0x1f
  [<c048302b>] ? command_trace_probe+0x320/0x466
  [<c044a1b3>] ? remove_wait_queue+0x22/0x27
  [<c042a9c0>] ? __wake_up+0x32/0x3b
  [<c0483245>] ? probes_write+0xd4/0x10b
  [<c0483171>] ? probes_write+0x0/0x10b
  [<c04b26f9>] ? vfs_write+0x80/0xdf
  [<c04b27ec>] ? sys_write+0x3b/0x5d
  [<c0670c91>] ? syscall_call+0x7/0xb
Code: 5d c3 55 89 e5 56 53 89 c3 89 d0 e8 4a ff ff ff 89 c6 89 d8 e8 41 ff ff ff 5b 01 f0 5e 5d c3 90 90 90 55 89 e5 53 89 c3 8b 40 04 <8b> 00 39 d8 74 16 50 53 68 9f fa 75 
c0 6a 30 68 d9 fa 75 c0 e8
EIP: [<c0537085>] list_del+0x9/0x60 SS:ESP 0068:d8dc9ea8
CR2: 0000000000000000
---[ end trace 2adc5d6dc10dde5a ]---
Kernel panic - not syncing: Fatal exception
Pid: 1372, comm: tee Tainted: G      D    2.6.31-rc9 #49
Call Trace:
  [<c066ee91>] ? printk+0xf/0x16
  [<c066ede0>] panic+0x39/0xdb
  [<c0671bcd>] oops_end+0x91/0xa0
  [<c04222e1>] no_context+0x13c/0x146
  [<c0422405>] __bad_area_nosemaphore+0x11a/0x122
  [<c043d4a1>] ? irq_exit+0x34/0x57
  [<c041a84a>] ? smp_apic_timer_interrupt+0x68/0x76
  [<c06710aa>] ? apic_timer_interrupt+0x2a/0x30
  [<c0420dd4>] ? kvm_mmu_write+0x5a/0x62
  [<c0422450>] __bad_area+0x33/0x39
  [<c0422463>] bad_area+0xd/0x10
  [<c0672e8a>] do_page_fault+0x1a3/0x2a5
  [<c0672ce7>] ? do_page_fault+0x0/0x2a5
  [<c06712de>] error_code+0x66/0x6c
  [<c0672ce7>] ? do_page_fault+0x0/0x2a5
  [<c0537085>] ? list_del+0x9/0x60
  [<c047f1db>] __trace_remove_event_call+0x29/0xb5
  [<c047f27e>] trace_remove_event_call+0x17/0x24
  [<c04823bc>] unregister_trace_probe+0xe/0x1f
  [<c048302b>] command_trace_probe+0x320/0x466
  [<c044a1b3>] ? remove_wait_queue+0x22/0x27
  [<c042a9c0>] ? __wake_up+0x32/0x3b
  [<c0483245>] probes_write+0xd4/0x10b
  [<c0483171>] ? probes_write+0x0/0x10b
  [<c04b26f9>] vfs_write+0x80/0xdf
  [<c04b27ec>] sys_write+0x3b/0x5d
  [<c0670c91>] syscall_call+0x7/0xb



-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

