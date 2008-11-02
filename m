Return-Path: <linux-kernel-owner+w=401wt.eu-S1754119AbYKBQf5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754119AbYKBQf5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Nov 2008 11:35:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753725AbYKBQft
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Nov 2008 11:35:49 -0500
Received: from nf-out-0910.google.com ([64.233.182.191]:17680 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753707AbYKBQfr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Nov 2008 11:35:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:x-mailer:mime-version
         :content-type:content-transfer-encoding:sender;
        b=KN+VD2gacC0KeeMszoqnfNjgo9pGvva/svx/CqysIqEmLxXZRz8hOMR7mp+wWyydTq
         tKgNSABEkY1QpWgaeokDvcPvgwjP3Upw8N/eqVOLtNppJYEEESmZvCAMA7qM2qii3woI
         ovaJm2RLDiYmJ1M9kLPE+R3TbcCBDUTURKEkA=
Date: Sun, 2 Nov 2008 18:35:34 +0200
From: Pekka Paalanen <pq@iki.fi>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       fweisbec@gmail.com
Subject: Tracing framework regressions in 2.6.28-rc2
Message-ID: <20081102183534.1bdc6779@daedalus.pq.iki.fi>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I finally had the time to check how mmiotrace works in 2.6.28-rc2.
On the first try I didn't find any mmiotrace problems, I traced the
Nouveau DRM driver just fine, but the file /debug/tracing/current_tracer
has started to misbehave.

I think it is due to this patch:

commit c2931e05ec5965597cbfb79ad332d4a29aeceb23
Author: Frederic Weisbecker <fweisbec@gmail.com>
Date:   Sat Oct 4 22:04:44 2008 +0200

    ftrace: return an error when setting a nonexistent tracer
    
    When one try to set a nonexistent tracer, no error is returned
    as if the name of the tracer was correct.
    We should return -EINVAL.
    
    Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
    Acked-by: Steven Rostedt <srostedt@redhat.com>
    Signed-off-by: Ingo Molnar <mingo@elte.hu>

Now, whatever I echo to current_tracer, I get EINVAL.
What's more confusing, if I do
echo mmiotrace > /debug/tracing/current_tracer
then I see the EINVAL error *and* mmiotrace is activated!

The problem is with newlines, with 'echo -n' it works as it should.

I'm starting to think the patch itself is fine, but it exposes an
assumption in the write fop: a single write call contains all the
data. I suspect there are actually two write calls in case of 'echo':
one with 'mmiotrace' and one with '\n'. I don't see how else I could
get the behaviour I get.


Another issue is the disappeared 'none' pseudo-tracer, which seems
to be replaced with the 'nop' real tracer. Is using 'nop' now equivalent
to the previous 'none' tracer?
I mean, when the 'nop' tracer is current, are all tracing calls no-ops and
nothing will ever get into the ring buffer?
I have to update the mmiotrace documentation about disabling tracing.

Do I understand correctly, that if tracing is enabled, e.g.
CONFIG_MMIOTRACE is set, the kernel will always allocate the huge
ring buffers from boot, and they cannot be freed?


Changing the number of entries via /debug/tracing/trace_entries is broken.
For instance,
echo 200 > trace_entries
hangs forever. Hmm, actually, the shell died on the first try, and on
the second try it hangs forever. I got this in my dmesg:

[18264.907176] BUG: unable to handle kernel NULL pointer dereference at 0000000000000008
[18264.908001] IP: [<ffffffff80259427>] ring_buffer_resize+0x2f/0x275
[18264.908001] PGD 9eb9067 PUD 9e6a067 PMD 0 
[18264.908001] Oops: 0000 [#1] PREEMPT 
[18264.908001] last sysfs file: /sys/class/drm/version
[18264.908001] Dumping ftrace buffer:
[18264.908001]    (ftrace buffer empty)
[18264.908001] CPU 0 
[18264.908001] Modules linked in: nouveau drm w83627hf hwmon_vid tun snd_seq_midi snd_seq_oss snd_seq_midi_event snd_seq snd_pcm_oss snd_mixer_oss nf_conntrack_ftp nf_conntrack_irc nf_conntrack usbhid i2c_viapro uhci_hcd i2c_core snd_via82xx snd_ac97_codec ac97_bus snd_pcm snd_timer snd_page_alloc snd_mpu401 snd_mpu401_uart k8temp snd_rawmidi snd_seq_device thermal processor snd soundcore analog ohci1394 gameport ieee1394 sg ne2k_pci ehci_hcd skge 8390 thermal_sys button evdev [last unloaded: drm]
[18264.908001] Pid: 20263, comm: bash Not tainted 2.6.28-rc2 #1
[18264.908001] RIP: 0010:[<ffffffff80259427>]  [<ffffffff80259427>] ring_buffer_resize+0x2f/0x275
[18264.908001] RSP: 0018:ffff880006babe28  EFLAGS: 00010296
[18264.908001] RAX: ffff880006babe48 RBX: 0000000000000004 RCX: ffff88003f80e150
[18264.908001] RDX: ffff88003f80e130 RSI: 00000000000000c8 RDI: 0000000000000000
[18264.908001] RBP: ffff880006babe88 R08: ffff88003f80e150 R09: 0000000000000000
[18264.908001] R10: ffffffff80280abd R11: ffff880006babcf8 R12: ffff880009ea0840
[18264.908001] R13: 0000000000001000 R14: ffffffff80707020 R15: 0000000000000000
[18264.908001] FS:  00007fa5e8ec16f0(0000) GS:ffffffff80654180(0000) knlGS:00000000f692fb90
[18264.908001] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[18264.908001] CR2: 0000000000000008 CR3: 0000000009c1d000 CR4: 00000000000006e0
[18264.908001] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[18264.908001] DR3: 0000000000000000 DR6: 00000000ffff4ff0 DR7: 0000000000000400
[18264.908001] Process bash (pid: 20263, threadinfo ffff880006baa000, task ffff88003fa9eed0)
[18264.908001] Stack:
[18264.908001]  00008241000001b6 0000000000000000 ffff88003f80e1e8 ffff88000000015e
[18264.908001]  ffff880006babe48 ffff880006babe48 ffffffff80349fb7 0000000000000004
[18264.908001]  ffff880009ea0840 ffff880006babe98 ffffffff80707020 0000000000000000
[18264.908001] Call Trace:
[18264.908001]  [<ffffffff80349fb7>] ? strict_strtoul+0x40/0x75
[18264.908001]  [<ffffffff8025a6d9>] tracing_entries_write+0xcd/0x160
[18264.908001]  [<ffffffff80280c54>] ? cpu_cache_get+0x11/0x1b
[18264.908001]  [<ffffffff8032b809>] ? security_file_permission+0x11/0x13
[18264.908001]  [<ffffffff80284be9>] vfs_write+0xa7/0xe1
[18264.908001]  [<ffffffff80284cdd>] sys_write+0x47/0x6c
[18264.908001]  [<ffffffff8020b4bb>] system_call_fastpath+0x16/0x1b
[18264.908001] Code: 41 57 48 8d 45 c0 41 56 41 55 4c 8d ae ff 0f 00 00 41 54 49 81 e5 00 f0 ff ff 53 48 83 ec 38 48 89 45 c0 48 89 45 c8 48 89 7d a8 <8b> 5f 08 b8 00 20 00 00 48 c1 e3 0c 49 81 fd ff 1f 00 00 4c 0f 
[18264.908001] RIP  [<ffffffff80259427>] ring_buffer_resize+0x2f/0x275
[18264.908001]  RSP <ffff880006babe28>
[18264.908001] CR2: 0000000000000008
[18266.573994] ---[ end trace 51e948c87ca56415 ]---


$ addr2line -e vmlinux ffffffff80259427 
/home/pq/linux/linux-2.6.28-rc2/kernel/trace/ring_buffer.c:508
and if I can trust that, it seems in

int ring_buffer_resize(struct ring_buffer *buffer, unsigned long size)
{
        struct ring_buffer_per_cpu *cpu_buffer;
        unsigned nr_pages, rm_pages, new_pages;
        struct buffer_page *page, *tmp;
        unsigned long buffer_size;
        unsigned long addr;
        LIST_HEAD(pages);
        int i, cpu;

        size = DIV_ROUND_UP(size, BUF_PAGE_SIZE);
        size *= BUF_PAGE_SIZE;
        buffer_size = buffer->pages * BUF_PAGE_SIZE;

buffer is NULL. Line 508 is the last line quoted here.


Steven, can you reproduce these?
I'm on x86_64.

-- 
Pekka Paalanen
http://www.iki.fi/pq/
