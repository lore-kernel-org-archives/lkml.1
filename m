Return-Path: <linux-kernel-owner+w=401wt.eu-S1753455AbYIZSqb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753455AbYIZSqb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 14:46:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752103AbYIZSqX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 14:46:23 -0400
Received: from wf-out-1314.google.com ([209.85.200.169]:27969 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751983AbYIZSqV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 14:46:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type;
        b=M/tvASQEe9t9C5EHImVlVlcsQi+s+L2FO6APnOOconBUTpqy3l6WuV3i0/ZDRHsufH
         T3qiEjnBwSY3yPn+giBAOaYanSzuJBpr+V6Kt16thbng/0ZyGAsqTDmVkWvJi7iZx5hD
         pAM3AVIIwRV/9R/6MGvco8QHtr0Yd1FHpaB6A=
Message-ID: <19f34abd0809261146j72a68765i964466336a3a34dc@mail.gmail.com>
Date: Fri, 26 Sep 2008 20:46:20 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Swap on loop device on tmpfs locks up machine
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_10198_29082457.1222454780632"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_10198_29082457.1222454780632
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi,

It turns out that swap over loop device on tmpfs will lock up the
machine. That is, all programs become blocked, but I can still do
things like switch VT consoles.

To reproduce (as root):

    mount -t tmpfs tmpfs /mnt
    dd if=/dev/zero of=/mnt/disk
    swapoff -a
    losetup -f /mnt/disk
    mkswap /dev/loop0 # replace loop0 with actual loop device
    swapon /dev/loop0
    <memory hog, like continuous malloc()>

I'm not sure it's really a very good idea to do this in the first
place, but should something give a warning or prevent a user from
doing it?

There is no output on serial console, I have most debugging options
turned on. SysRq-l (backtrace for active CPUs) shows nothing much
interesting:

Pid: 0, comm: swapper Not tainted (2.6.27-rc7-00106-g6ef190c #1)
EIP: 0060:[<c011f295>] EFLAGS: 00000202 CPU: 0
EIP is at native_safe_halt+0x5/0x10

And SysRq-w (task dump for blocked tasks) shows that almost all
processes are blocking in schedule_timeout, for example:

bash          D f6eb5cf0  6184  3688   3687
       f6eb5d38 00200046 00000000 f6eb5cf0 c0159b4f 00000000 f6a7f2c0 c0159d7b
       c2036d80 f6933fc0 67525eae 000000f4 f6a7f2c0 f6a7f534 c2036d80 f6eb4000
       c0595da3 c0955b80 000210af 00000000 c013f9eb 000124b0 00000000 00200296
Call Trace:
 [<c0159b4f>] ? mark_held_locks+0x6f/0x90
 [<c0159d7b>] ? trace_hardirqs_on+0xb/0x10
 [<c0595da3>] ? _spin_unlock_irqrestore+0x43/0x70
 [<c013f9eb>] ? __mod_timer+0x9b/0xe0
 [<c05933c8>] schedule_timeout+0x48/0xc0
 [<c0159d7b>] ? trace_hardirqs_on+0xb/0x10
 [<c013f480>] ? process_timeout+0x0/0x10
 [<c05933c3>] ? schedule_timeout+0x43/0xc0
 [<c05932ee>] io_schedule_timeout+0x1e/0x30
 [<c0187385>] congestion_wait+0x55/0x70
 [<c0149900>] ? autoremove_wake_function+0x0/0x50
 [<c0181969>] throttle_vm_writeout+0x69/0x80
 [<c0184fa5>] shrink_zone+0x75/0x130
 [<c010a325>] ? native_sched_clock+0xb5/0x110
 [<c01853c7>] do_try_to_free_pages+0x107/0x3c0
 [<c018576d>] try_to_free_pages+0x6d/0x80
 [<c0183ea0>] ? isolate_pages_global+0x0/0x60
 [<c017fef5>] __alloc_pages_internal+0x1a5/0x440
 [<c018911d>] do_wp_page+0xad/0x550
 [<c018a8e9>] handle_mm_fault+0x409/0x7b0
 [<c014da1d>] ? down_read_trylock+0x5d/0x70
 [<c0120808>] do_page_fault+0x298/0x700
 [<c028cee8>] ? copy_to_user+0x48/0x60
 [<c028c7e4>] ? trace_hardirqs_on_thunk+0xc/0x10
 [<c0120570>] ? do_page_fault+0x0/0x700
 [<c059615a>] error_code+0x72/0x78

The only process that isn't hung in schedule_timeout() is this:

loop0         D f6727dec  7128  3731      2
       f6727e04 00000046 00000002 f6727dec f6727df4 00000000 00000001 00000303
       c2161d80 f7856600 f6f6f2c0 c0700e0c f6f6f2c0 f6f6f534 c2161d80 f6726000
       00001b23 ffffffff f7425180 f6727df0 00000000 00000000 00000000 0000007f
Call Trace:
 [<c059331e>] io_schedule+0x1e/0x30
 [<c0179ed7>] sync_page+0x37/0x50
 [<c05935b5>] __wait_on_bit+0x45/0x70
 [<c0179ea0>] ? sync_page+0x0/0x50
 [<c017a125>] wait_on_page_bit+0x55/0x60
 [<c0149950>] ? wake_bit_function+0x0/0x60
 [<c019a788>] shmem_getpage+0x588/0x770
 [<c0159d7b>] ? trace_hardirqs_on+0xb/0x10
 [<c019a9aa>] shmem_write_begin+0x3a/0x50
 [<c017a361>] pagecache_write_begin+0x51/0x130
 [<c03135ec>] do_lo_send_aops+0xac/0x1b0
 [<c0159ce4>] ? trace_hardirqs_on_caller+0xd4/0x160
 [<c0313371>] loop_thread+0x301/0x410
 [<c0313540>] ? do_lo_send_aops+0x0/0x1b0
 [<c0149900>] ? autoremove_wake_function+0x0/0x50
 [<c0313070>] ? loop_thread+0x0/0x410
 [<c0149612>] kthread+0x42/0x70
 [<c01495d0>] ? kthread+0x0/0x70
 [<c0104e93>] kernel_thread_helper+0x7/0x14

The memory hog is also attached for reference.


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036

------=_Part_10198_29082457.1222454780632
Content-Type: text/x-csrc; name=swap.c
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fll5nm2q0
Content-Disposition: attachment; filename=swap.c

I2luY2x1ZGUgPHN0ZGxpYi5oPgoKaW50IG1haW4odm9pZCkKewoJd2hpbGUgKDEpIHsKCQljaGFy
ICp4ID0gbWFsbG9jKDQwOTUpOwoJCXhbMF0gPSAwOwoJfQoKCXJldHVybiAwOwp9Cg==
------=_Part_10198_29082457.1222454780632--
