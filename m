Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755456Ab0BLXbF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 18:31:05 -0500
Received: from mail-in-09.arcor-online.net ([151.189.21.49]:46604 "EHLO
	mail-in-09.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752670Ab0BLXbA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 18:31:00 -0500
X-DKIM: Sendmail DKIM Filter v2.8.2 mail-in-11.arcor-online.net 19137E3AC9
Message-ID: <4B75E528.7090605@arcor.de>
Date: Sat, 13 Feb 2010 00:32:56 +0100
From: Henry Nestler <henry-20071123@arcor.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.9.2.2pre) Gecko/20100207 Lanikai/3.1b1pre
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: =?ISO-8859-15?Q?=22Fr=E9d=E9ric_L=2E_W=2E_Meunier=22?= 
	<fredlwm@gmail.com>,
       gregkh@suse.de, Simon.Richter@phobos.fachschaften.tu-muenchen.de
Subject: [2.6.33-rc7] tty: page allocation failure (from tty_buffer_request_room)
References: <ed7v4-5Xl-13@gated-at.bofh.it>
In-Reply-To: <ed7v4-5Xl-13@gated-at.bofh.it>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject line changed to more the relevant informations, and CC to tty 
maintainer.

Simon found the same bug on 2.6.31-1-powerpc:
http://www.mail-archive.com/debian-bugs-dist@lists.debian.org/msg715324.html

I can form a patch for kernel 2.6.33-rc7. But I don't know it is right, 
that tty_buffer_request_room calls kmalloc (over tty_buffer_find --> 
tty_buffer_alloc) from inside a spin_lock? Think yes, because 
tty_buffer_find needs the lock.

Henry

> I got the following twice with 2.6.33-rc7. Henry Nestler
> (coLinux maintainer) thinks it may also happen without coLinux,
> so I'm redirecting it.
>
> ---------- Forwarded message ----------
>
> Hello Frédéric,
>
> I think that warning is abundant.
>
> You are doing some output on console, for example write to a device /dev/tty.
> Inside tty_buffer_request_room I found, that kmalloc was called and interrupts
> are disabled. That means, memory can not swap out - if no free page is
> available. tty_buffer_request_room checks for NULL returns. So, it assumes,
> that kmalloc can fail. Unless they have forgotten to set __GFP_NOWARN. - Or it
> is a defective design, and kmalloc should not called inside a spin_lock.
>
> This depends on low system memory system, and I think, it can be have also in
> native kernel. (without colinux patch)
>
> Your warning output should send to kernel list.
>
> For coLinux I will suppress the warning in this way:
> ===
> --- linux-2.6.33-rc7-source/drivers/char/tty_buffer.c
> +++ linux-2.6.33-rc7-source/drivers/char/tty_buffer.c
> @@ -60,7 +60,7 @@
>
>          if (tty->buf.memory_used + size > 65536)
>                  return NULL;
> -       p = kmalloc(sizeof(struct tty_buffer) + 2 * size, GFP_ATOMIC);
> +       p = kmalloc(sizeof(struct tty_buffer) + 2 * size, GFP_ATOMIC | __GFP_NOWARN);
>          if (p == NULL)
>                  return NULL;
>          p->used = 0;
> ===
>
> -- Henry
[... non informative text removed ...]
> At 12.02.2010 05:47, Frédéric L. W. Meunier wrote:
>> Hi Henry. I found the following in my /var/log/kernel. I didn't
>> notice anything at the time, and don't remember what I was
>> doing (if anything).
>>
>> kernel: mconf: page allocation failure. order:1, mode:0x20
>> kernel: Pid: 25277, comm: mconf Not tainted 2.6.33-rc7-co #1
>> kernel: Call Trace:
>> kernel:  [<c1184ed7>] ? printk+0xf/0x18
>> kernel:  [<c1042a8e>] __alloc_pages_nodemask+0x3e8/0x467
>> kernel:  [<c105b251>] cache_alloc_refill+0x269/0x454
>> kernel:  [<c10118c8>] ? try_to_wake_up+0x165/0x181
>> kernel:  [<c105b49f>] __kmalloc+0x63/0x93
>> kernel:  [<c1107163>] tty_buffer_request_room+0xae/0x12c
>> kernel:  [<c11072ee>] tty_insert_flip_string+0x26/0x70
>> kernel:  [<c1107e18>] pty_write+0x28/0x49
>> kernel:  [<c1103be6>] n_tty_write+0x1df/0x2c8
>> kernel:  [<c10118e4>] ? default_wake_function+0x0/0xd
>> kernel:  [<c110189f>] tty_write+0x153/0x1c9
>> kernel:  [<c104e6d4>] ? handle_mm_fault+0x227/0x4cf
>> kernel:  [<c1103a07>] ? n_tty_write+0x0/0x2c8
>> kernel:  [<c105dda9>] vfs_write+0x8a/0x112
>> kernel:  [<c110174c>] ? tty_write+0x0/0x1c9
>> kernel:  [<c105dec8>] sys_write+0x3b/0x60
>> kernel:  [<c1002650>] sysenter_do_call+0x12/0x26
>> kernel: Mem-Info:
>> kernel: Normal per-cpu:
>> kernel: CPU    0: hi:   90, btch:  15 usd:  15
>> kernel: active_anon:4096 inactive_anon:6585 isolated_anon:0
>> kernel:  active_file:22030 inactive_file:21094 isolated_file:0
>> kernel:  unevictable:0 dirty:66 writeback:0 unstable:0
>> kernel:  free:525 slab_reclaimable:4787 slab_unreclaimable:557
>> kernel:  mapped:2518 shmem:286 pagetables:179 bounce:0
>> kernel: Normal free:2100kB min:2036kB low:2544kB high:3052kB active_anon:16384kB inactive_anon:26340kB active_file:88120kB inactive_file:84376kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:260096kB mlocked:0kB dirty:264kB writeback:0kB mapped:10072kB shmem:1144kB slab_reclaimable:19148kB slab_unreclaimable:2228kB kernel_stack:352kB pagetables:716kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:5 all_unreclaimable? no
>> kernel: lowmem_reserve[]: 0 0
>> kernel: Normal: 497*4kB 2*8kB 6*16kB 0*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 2100kB
>> kernel: 43443 total pagecache pages
>> kernel: 26 pages in swap cache
>> kernel: Swap cache stats: add 122, delete 96, find 7/8
>> kernel: Free swap  = 987512kB
>> kernel: Total swap = 987956kB
>> kernel: 65536 pages RAM
>> kernel: 5438 pages reserved
>> kernel: 32537 pages shared
>> kernel: 31318 pages non-shared
>> kernel: mconf: page allocation failure. order:1, mode:0x20

