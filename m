Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757398Ab0BLRWb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 12:22:31 -0500
Received: from mail-yx0-f196.google.com ([209.85.210.196]:60065 "EHLO
	mail-yx0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756963Ab0BLRW3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 12:22:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:user-agent:x-archive
         :mime-version:content-type;
        b=EBLyCj4uh4FvSpzI7TKdg4RbRapqinhkLoV/U1x2N0UZN//b9OS74uEHuFljJnLdH9
         Bc9FXjcqn8Y9xVGBf737ePkZy7Mq8Xx7qqKjUe2varQVRMkvbtIKAE9ZRF4SVoUaw6wO
         tZRj3T8Y/CFrk0tif6hI59HuNOe4EKa4xLz6U=
Date: Fri, 12 Feb 2010 15:22:20 -0200 (BRST)
From: "=?ISO-8859-15?Q?Fr=E9d=E9ric_L=2E_W=2E_Meunier?=" 
	<fredlwm@gmail.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
cc: Henry <henry-colinux@arcor.de>
Subject: 2.6.33-rc7: mconf: page allocation failure
Message-ID: <alpine.LNX.2.01.1002121514060.28785@dyndns.pervalidus.net>
User-Agent: Alpine 2.01 (LNX 1266 2009-07-14)
X-Archive: encrypt
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-1783809952-1265995346=:28785"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-1783809952-1265995346=:28785
Content-Type: TEXT/PLAIN; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 8BIT

I got the following twice with 2.6.33-rc7. Henry Nestler 
(coLinux maintainer) thinks it may also happen without coLinux, 
so I'm redirecting it.

---------- Forwarded message ----------

Hello Frédéric,

I think that warning is abundant.

You are doing some output on console, for example write to a device /dev/tty. 
Inside tty_buffer_request_room I found, that kmalloc was called and interrupts 
are disabled. That means, memory can not swap out - if no free page is 
available. tty_buffer_request_room checks for NULL returns. So, it assumes, 
that kmalloc can fail. Unless they have forgotten to set __GFP_NOWARN. - Or it 
is a defective design, and kmalloc should not called inside a spin_lock.

This depends on low system memory system, and I think, it can be have also in 
native kernel. (without colinux patch)

Your warning output should send to kernel list.

For coLinux I will suppress the warning in this way:
===
--- linux-2.6.33-rc7-source/drivers/char/tty_buffer.c
+++ linux-2.6.33-rc7-source/drivers/char/tty_buffer.c
@@ -60,7 +60,7 @@

         if (tty->buf.memory_used + size > 65536)
                 return NULL;
-       p = kmalloc(sizeof(struct tty_buffer) + 2 * size, GFP_ATOMIC);
+       p = kmalloc(sizeof(struct tty_buffer) + 2 * size, GFP_ATOMIC | __GFP_NOWARN);
         if (p == NULL)
                 return NULL;
         p->used = 0;
===

Please test the build 20100212 from today.
The upload is in process and needs some minutes.

-- 
Henry

At 12.02.2010 05:47, Frédéric L. W. Meunier wrote:
> Hi Henry. I found the following in my /var/log/kernel. I didn't
> notice anything at the time, and don't remember what I was
> doing (if anything).
> 
> Feb 12 00:50:09 pervalidus kernel: mconf: page allocation failure. order:1, 
> mode:0x20
> Feb 12 00:50:09 pervalidus kernel: Pid: 25277, comm: mconf Not tainted 
> 2.6.33-rc7-co #1
> Feb 12 00:50:09 pervalidus kernel: Call Trace:
> Feb 12 00:50:09 pervalidus kernel:  [<c1184ed7>] ? printk+0xf/0x18
> Feb 12 00:50:09 pervalidus kernel:  [<c1042a8e>] 
> __alloc_pages_nodemask+0x3e8/0x467
> Feb 12 00:50:09 pervalidus kernel:  [<c105b251>] 
> cache_alloc_refill+0x269/0x454
> Feb 12 00:50:09 pervalidus kernel:  [<c10118c8>] ? try_to_wake_up+0x165/0x181
> Feb 12 00:50:09 pervalidus kernel:  [<c105b49f>] __kmalloc+0x63/0x93
> Feb 12 00:50:09 pervalidus kernel:  [<c1107163>] 
> tty_buffer_request_room+0xae/0x12c
> Feb 12 00:50:09 pervalidus kernel:  [<c11072ee>] 
> tty_insert_flip_string+0x26/0x70
> Feb 12 00:50:09 pervalidus kernel:  [<c1107e18>] pty_write+0x28/0x49
> Feb 12 00:50:09 pervalidus kernel:  [<c1103be6>] n_tty_write+0x1df/0x2c8
> Feb 12 00:50:09 pervalidus kernel:  [<c10118e4>] ? 
> default_wake_function+0x0/0xd
> Feb 12 00:50:09 pervalidus kernel:  [<c110189f>] tty_write+0x153/0x1c9
> Feb 12 00:50:09 pervalidus kernel:  [<c104e6d4>] ? 
> handle_mm_fault+0x227/0x4cf
> Feb 12 00:50:09 pervalidus kernel:  [<c1103a07>] ? n_tty_write+0x0/0x2c8
> Feb 12 00:50:09 pervalidus kernel:  [<c105dda9>] vfs_write+0x8a/0x112
> Feb 12 00:50:09 pervalidus kernel:  [<c110174c>] ? tty_write+0x0/0x1c9
> Feb 12 00:50:09 pervalidus kernel:  [<c105dec8>] sys_write+0x3b/0x60
> Feb 12 00:50:09 pervalidus kernel:  [<c1002650>] sysenter_do_call+0x12/0x26
> Feb 12 00:50:09 pervalidus kernel: Mem-Info:
> Feb 12 00:50:09 pervalidus kernel: Normal per-cpu:
> Feb 12 00:50:09 pervalidus kernel: CPU    0: hi:   90, btch:  15 usd:  15
> Feb 12 00:50:09 pervalidus kernel: active_anon:4096 inactive_anon:6585 
> isolated_anon:0
> Feb 12 00:50:09 pervalidus kernel:  active_file:22030 inactive_file:21094 
> isolated_file:0
> Feb 12 00:50:09 pervalidus kernel:  unevictable:0 dirty:66 writeback:0 
> unstable:0
> Feb 12 00:50:09 pervalidus kernel:  free:525 slab_reclaimable:4787 
> slab_unreclaimable:557
> Feb 12 00:50:09 pervalidus kernel:  mapped:2518 shmem:286 pagetables:179 
> bounce:0
> Feb 12 00:50:09 pervalidus kernel: Normal free:2100kB min:2036kB low:2544kB 
> high:3052kB active_anon:16384kB inactive_anon:26340kB active_file:88120kB 
> inactive_file:84376kB unevictable:0kB isolated(anon):0kB isolated(file):0kB 
> present:260096kB mlocked:0kB dirty:264kB writeback:0kB mapped:10072kB 
> shmem:1144kB slab_reclaimable:19148kB slab_unreclaimable:2228kB 
> kernel_stack:352kB pagetables:716kB unstable:0kB bounce:0kB writeback_tmp:0kB 
> pages_scanned:5 all_unreclaimable? no
> Feb 12 00:50:09 pervalidus kernel: lowmem_reserve[]: 0 0
> Feb 12 00:50:09 pervalidus kernel: Normal: 497*4kB 2*8kB 6*16kB 0*32kB 0*64kB 
> 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 2100kB
> Feb 12 00:50:09 pervalidus kernel: 43443 total pagecache pages
> Feb 12 00:50:09 pervalidus kernel: 26 pages in swap cache
> Feb 12 00:50:09 pervalidus kernel: Swap cache stats: add 122, delete 96, find 
> 7/8
> Feb 12 00:50:09 pervalidus kernel: Free swap  = 987512kB
> Feb 12 00:50:09 pervalidus kernel: Total swap = 987956kB
> Feb 12 00:50:09 pervalidus kernel: 65536 pages RAM
> Feb 12 00:50:09 pervalidus kernel: 5438 pages reserved
> Feb 12 00:50:09 pervalidus kernel: 32537 pages shared
> Feb 12 00:50:09 pervalidus kernel: 31318 pages non-shared
--8323328-1783809952-1265995346=:28785--
