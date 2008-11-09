Return-Path: <linux-kernel-owner+w=401wt.eu-S1754909AbYKIKOP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754909AbYKIKOP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2008 05:14:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753691AbYKIKN7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Nov 2008 05:13:59 -0500
Received: from ey-out-2122.google.com ([74.125.78.27]:35903 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753661AbYKIKN5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2008 05:13:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding:sender;
        b=SzkCE0Ts2D3dZ+rvjd99ysFhtUSGKoSLmd3b3VQJD7Ty3gQgVHBztOEdCnLBVKHa5g
         tAkjIpBaeGEM2I7O3We9LSHtvnNSVM/q6lYmCIWlvFQeV3sP2xpZpnnOjT4kJDMAJZfV
         MqSBDuQtMWhizHe7yGzjeMvouFokch88wBotk=
Date: Sun, 9 Nov 2008 12:13:49 +0200
From: Pekka Paalanen <pq@iki.fi>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Pekka Paalanen <pq@iki.fi>, linux-kernel <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, fweisbec@gmail.com
Subject: Tracing framework regression in 2.6.28-rc3
Message-ID: <20081109121349.4b0531be@daedalus.pq.iki.fi>
In-Reply-To: <20081102183534.1bdc6779@daedalus.pq.iki.fi>
References: <20081102183534.1bdc6779@daedalus.pq.iki.fi>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo, Steven,

the kernel NULL pointer dereference bug still exists in -rc3,
please see below.


On Sun, 2 Nov 2008 18:35:34 +0200
Pekka Paalanen <pq@iki.fi> wrote:

> Another issue is the disappeared 'none' pseudo-tracer, which seems
> to be replaced with the 'nop' real tracer. Is using 'nop' now equivalent
> to the previous 'none' tracer?
> I mean, when the 'nop' tracer is current, are all tracing calls no-ops and
> nothing will ever get into the ring buffer?
> I have to update the mmiotrace documentation about disabling tracing.
> 
> Do I understand correctly, that if tracing is enabled, e.g.
> CONFIG_MMIOTRACE is set, the kernel will always allocate the huge
> ring buffers from boot, and they cannot be freed?
> 
> 
> Changing the number of entries via /debug/tracing/trace_entries is broken.
> For instance,
> echo 200 > trace_entries
> hangs forever. Hmm, actually, the shell died on the first try, and on
> the second try it hangs forever. I got this in my dmesg:
> 
> [18264.907176] BUG: unable to handle kernel NULL pointer dereference at 0000000000000008
> [18264.908001] IP: [<ffffffff80259427>] ring_buffer_resize+0x2f/0x275
> [18264.908001] PGD 9eb9067 PUD 9e6a067 PMD 0 
> [18264.908001] Oops: 0000 [#1] PREEMPT 
> [18264.908001] last sysfs file: /sys/class/drm/version
> [18264.908001] Dumping ftrace buffer:
> [18264.908001]    (ftrace buffer empty)
> [18264.908001] CPU 0 
> [18264.908001] Modules linked in: nouveau drm w83627hf hwmon_vid tun snd_seq_midi snd_seq_oss snd_seq_midi_event snd_seq snd_pcm_oss snd_mixer_oss nf_conntrack_ftp nf_conntrack_irc nf_conntrack usbhid i2c_viapro uhci_hcd i2c_core snd_via82xx snd_ac97_codec ac97_bus snd_pcm snd_timer snd_page_alloc snd_mpu401 snd_mpu401_uart k8temp snd_rawmidi snd_seq_device thermal processor snd soundcore analog ohci1394 gameport ieee1394 sg ne2k_pci ehci_hcd skge 8390 thermal_sys button evdev [last unloaded: drm]
> [18264.908001] Pid: 20263, comm: bash Not tainted 2.6.28-rc2 #1
> [18264.908001] RIP: 0010:[<ffffffff80259427>]  [<ffffffff80259427>] ring_buffer_resize+0x2f/0x275
> [18264.908001] RSP: 0018:ffff880006babe28  EFLAGS: 00010296
> [18264.908001] RAX: ffff880006babe48 RBX: 0000000000000004 RCX: ffff88003f80e150
> [18264.908001] RDX: ffff88003f80e130 RSI: 00000000000000c8 RDI: 0000000000000000
> [18264.908001] RBP: ffff880006babe88 R08: ffff88003f80e150 R09: 0000000000000000
> [18264.908001] R10: ffffffff80280abd R11: ffff880006babcf8 R12: ffff880009ea0840
> [18264.908001] R13: 0000000000001000 R14: ffffffff80707020 R15: 0000000000000000
> [18264.908001] FS:  00007fa5e8ec16f0(0000) GS:ffffffff80654180(0000) knlGS:00000000f692fb90
> [18264.908001] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [18264.908001] CR2: 0000000000000008 CR3: 0000000009c1d000 CR4: 00000000000006e0
> [18264.908001] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [18264.908001] DR3: 0000000000000000 DR6: 00000000ffff4ff0 DR7: 0000000000000400
> [18264.908001] Process bash (pid: 20263, threadinfo ffff880006baa000, task ffff88003fa9eed0)
> [18264.908001] Stack:
> [18264.908001]  00008241000001b6 0000000000000000 ffff88003f80e1e8 ffff88000000015e
> [18264.908001]  ffff880006babe48 ffff880006babe48 ffffffff80349fb7 0000000000000004
> [18264.908001]  ffff880009ea0840 ffff880006babe98 ffffffff80707020 0000000000000000
> [18264.908001] Call Trace:
> [18264.908001]  [<ffffffff80349fb7>] ? strict_strtoul+0x40/0x75
> [18264.908001]  [<ffffffff8025a6d9>] tracing_entries_write+0xcd/0x160
> [18264.908001]  [<ffffffff80280c54>] ? cpu_cache_get+0x11/0x1b
> [18264.908001]  [<ffffffff8032b809>] ? security_file_permission+0x11/0x13
> [18264.908001]  [<ffffffff80284be9>] vfs_write+0xa7/0xe1
> [18264.908001]  [<ffffffff80284cdd>] sys_write+0x47/0x6c
> [18264.908001]  [<ffffffff8020b4bb>] system_call_fastpath+0x16/0x1b
> [18264.908001] Code: 41 57 48 8d 45 c0 41 56 41 55 4c 8d ae ff 0f 00 00 41 54 49 81 e5 00 f0 ff ff 53 48 83 ec 38 48 89 45 c0 48 89 45 c8 48 89 7d a8 <8b> 5f 08 b8 00 20 00 00 48 c1 e3 0c 49 81 fd ff 1f 00 00 4c 0f 
> [18264.908001] RIP  [<ffffffff80259427>] ring_buffer_resize+0x2f/0x275
> [18264.908001]  RSP <ffff880006babe28>
> [18264.908001] CR2: 0000000000000008
> [18266.573994] ---[ end trace 51e948c87ca56415 ]---
> 
> 
> $ addr2line -e vmlinux ffffffff80259427 
> /home/pq/linux/linux-2.6.28-rc2/kernel/trace/ring_buffer.c:508
> and if I can trust that, it seems in
> 
> int ring_buffer_resize(struct ring_buffer *buffer, unsigned long size)
> {
>         struct ring_buffer_per_cpu *cpu_buffer;
>         unsigned nr_pages, rm_pages, new_pages;
>         struct buffer_page *page, *tmp;
>         unsigned long buffer_size;
>         unsigned long addr;
>         LIST_HEAD(pages);
>         int i, cpu;
> 
>         size = DIV_ROUND_UP(size, BUF_PAGE_SIZE);
>         size *= BUF_PAGE_SIZE;
>         buffer_size = buffer->pages * BUF_PAGE_SIZE;
> 
> buffer is NULL. Line 508 is the last line quoted here.
> 
> 
> Steven, can you reproduce these?
> I'm on x86_64.

With 2.6.28-rc3, the bug is on the exact same line.
Steps to reproduce:
cd /debug/tracing
echo 0 > tracing_enabled
echo 200 > trace_entries

Result:

[  162.011249] BUG: unable to handle kernel NULL pointer dereference at 0000000000000008
[  162.012001] IP: [<ffffffff8025a42b>] ring_buffer_resize+0x2f/0x275
[  162.012001] PGD 3bc5b067 PUD 3bc5c067 PMD 0 
[  162.012001] Oops: 0000 [#1] PREEMPT 
[  162.012001] last sysfs file: /sys/devices/platform/w83627hf.656/fan3_min
[  162.012001] Dumping ftrace buffer:
[  162.012001]    (ftrace buffer empty)
[  162.012001] CPU 0 
[  162.012001] Modules linked in: w83627hf hwmon_vid tun snd_seq_midi snd_seq_oss snd_seq_midi_event snd_seq snd_pcm_oss snd_mixer_oss nf_conntrack_ftp nf_conntrack_irc nf_conntrack usbhid snd_via82xx snd_ac97_codec ac97_bus snd_pcm snd_timer snd_page_alloc snd_mpu401 snd_mpu401_uart snd_rawmidi snd_seq_device snd i2c_viapro i2c_core soundcore uhci_hcd ne2k_pci skge ehci_hcd ohci1394 8390 k8temp analog gameport ieee1394 sg thermal processor button thermal_sys evdev
[  162.012001] Pid: 4260, comm: bash Not tainted 2.6.28-rc3 #1
[  162.012001] RIP: 0010:[<ffffffff8025a42b>]  [<ffffffff8025a42b>] ring_buffer_resize+0x2f/0x275
[  162.012001] RSP: 0018:ffff88003bc6be28  EFLAGS: 00010296
[  162.012001] RAX: ffff88003bc6be48 RBX: 0000000000000004 RCX: ffff88003f80e150
[  162.012001] RDX: ffff88003f80e130 RSI: 00000000000000c8 RDI: 0000000000000000
[  162.012001] RBP: ffff88003bc6be88 R08: ffff88003f80e150 R09: ffff88003f800240
[  162.012001] R10: ffffffff80281611 R11: ffff88003f808f40 R12: ffff88003bce5f00
[  162.012001] R13: 0000000000001000 R14: ffffffff80709060 R15: 0000000000000000
[  162.012001] FS:  00007f3a23bfc6f0(0000) GS:ffffffff80656180(0000) knlGS:0000000000000000
[  162.012001] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  162.012001] CR2: 0000000000000008 CR3: 000000003bc2f000 CR4: 00000000000006e0
[  162.012001] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  162.012001] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  162.012001] Process bash (pid: 4260, threadinfo ffff88003bc6a000, task ffff88003bc34350)
[  162.012001] Stack:
[  162.012001]  00008241000001b6 0000000000000000 ffff88003f80e1e8 ffff88000000015e
[  162.012001]  ffff88003bc6be48 ffff88003bc6be48 ffffffff8034ab77 0000000000000004
[  162.012001]  ffff88003bce5f00 ffff88003bc6be98 ffffffff80709060 0000000000000000
[  162.012001] Call Trace:
[  162.012001]  [<ffffffff8034ab77>] ? strict_strtoul+0x40/0x75
[  162.012001]  [<ffffffff8025b6dd>] tracing_entries_write+0xcd/0x160
[  162.012001]  [<ffffffff802817a8>] ? cpu_cache_get+0x11/0x1b
[  162.012001]  [<ffffffff8032c33d>] ? security_file_permission+0x11/0x13
[  162.012001]  [<ffffffff8028573d>] vfs_write+0xa7/0xe1
[  162.012001]  [<ffffffff80285831>] sys_write+0x47/0x6c
[  162.012001]  [<ffffffff8020b56b>] system_call_fastpath+0x16/0x1b
[  162.012001] Code: 41 57 48 8d 45 c0 41 56 41 55 4c 8d ae ff 0f 00 00 41 54 49 81 e5 00 f0 ff ff 53 48 83 ec 38 48 89 45 c0 48 89 45 c8 48 89 7d a8 <8b> 5f 08 b8 00 20 00 00 48 c1 e3 0c 49 81 fd ff 1f 00 00 4c 0f 
[  162.012001] RIP  [<ffffffff8025a42b>] ring_buffer_resize+0x2f/0x275
[  162.012001]  RSP <ffff88003bc6be28>
[  162.012001] CR2: 0000000000000008
[  163.686343] ---[ end trace ae90bab6246f995d ]---


-- 
Pekka Paalanen
http://www.iki.fi/pq/
