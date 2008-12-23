Return-Path: <linux-kernel-owner+w=401wt.eu-S1752158AbYLWUDf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752158AbYLWUDf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2008 15:03:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751143AbYLWUD0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Dec 2008 15:03:26 -0500
Received: from host64.cybernetics.com ([98.174.209.230]:4078 "EHLO
	mail.cybernetics.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751114AbYLWUDY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2008 15:03:24 -0500
X-Greylist: delayed 1469 seconds by postgrey-1.27 at vger.kernel.org; Tue, 23 Dec 2008 15:03:24 EST
Message-ID: <49513E33.5050001@cybernetics.com>
Date: Tue, 23 Dec 2008 14:38:27 -0500
From: Tony Battersby <tonyb@cybernetics.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081125)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>, Suresh Siddha <suresh.b.siddha@intel.com>,
       arjan@linux.intel.com, venkatesh.pallipadi@intel.com, jeremy@goop.org
Subject: DEBUG_PAGEALLOC + order-10 alloc/free_pages = lockup
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

An order-10 alloc_pages followed by free_pages with DEBUG_PAGEALLOC
causes a lockup during subsequent memory allocations.  Order-9 and lower
do not trigger the problem.  This problem was introduced in 2.6.25-rc1
and fixed in 2.6.28-rc1.  Even though the bug is now fixed, I am
reporting it because:

1) I am not sure that anyone ever realized that the bug existed.
2) I want to make sure that the bug is really fixed and not just hidden
from view.
3) To see if anyone thinks that the fix should be included in
2.6.27 -stable.

How to reproduce the problem:
Configure a kernel from 2.6.25-rc1 to 2.6.27.10 with DEBUG_PAGEALLOC on
x86 or x86-64.
Compile and insert the kernel module given below.
Transfer some data over the network.

/* begin C file */

#include <linux/kernel.h>
#include <linux/module.h>
#include <linux/slab.h>

int __init bug_init(void)
{
   int page_order = 10;
   struct page *page;

   page = alloc_pages(GFP_NOIO, page_order);
   if (page == NULL)
      {
      printk(KERN_DEBUG "alloc_pages(%d) failed\n", page_order);
      return -ENOMEM;
      }

   printk(KERN_DEBUG "alloc_pages(%d) = %p\n", page_order, page);
   __free_pages(page, page_order);

   return -ENODEV; /* no need to stay loaded */
}

void __exit bug_exit(void)
{
}

module_init(bug_init);
module_exit(bug_exit);

/* end C file */

This bug was introduced in 2.6.25-rc1 by the following commit:

commit a03c2a48e02aacaaea211c94691b729be357e047
Author: Thomas Gleixner <tglx@linutronix.de>
Date:   Sat Feb 9 23:24:09 2008 +0100

    x86: DEBUG_PAGEALLOC: enable after mem_init()
    
    DEBUG_PAGEALLOC must not be enabled before mem_init(). Before this
    point there is nothing to allocate.
   
However, reverting the above commit from 2.6.25-rc1 by itself doesn't
fix the problem, since there were other related changes that came after
this commit.

This bug was fixed in 2.6.28-rc1 by the following commit:

commit 0b8fdcbcd287a1fbe66817491e6149841ae25705
Author: Suresh Siddha <suresh.b.siddha@intel.com>
Date:   Tue Sep 23 14:00:39 2008 -0700

    x86, cpa: dont use large pages for kernel identity mapping with DEBUG_PAGEALLOC
    
    Don't use large pages for kernel identity mapping with DEBUG_PAGEALLOC.
    This will remove the need to split the large page for the
    allocated kernel page in the interrupt context.
    
    This will simplify cpa code(as we don't do the split any more from the
    interrupt context). cpa code simplication in the subsequent patches.

I have verified that applying 0b8fdcbcd287a1fbe66817491e6149841ae25705
to 2.6.27.10 fixes the problem there too.

Here is the initial kernel oops with git head
a03c2a48e02aacaaea211c94691b729be357e047 (i.e. a few dozen commits
before 2.6.25-rc1):

BUG: unable to handle kernel NULL pointer dereference at 00000005
IP: [<c0122590>] __remove_hrtimer+0x20/0x70
*pde = 00000000 
Oops: 0002 [#1] DEBUG_PAGEALLOC
Modules linked in: e1000 emlog ftdi_sio usbserial [last unloaded: usbserial]
Pid: 446, comm: thttpd Tainted: P         (2.6.24-09506-g166124f-dirty #3)
EIP: 0060:[<c0122590>] EFLAGS: 00010002 CPU: 0
EIP is at __remove_hrtimer+0x20/0x70
EAX: 00000001 EBX: cfb19f54 ECX: 00000002 EDX: 00000001
ESI: cea39000 EDI: 00000002 EBP: c02ba7e8 ESP: cfb3bae8
 DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
Process thttpd (pid: 446, ti=cfb3a000 task=cf910030 task.ti=cfb3a000)
Stack: 00000028 cfb19f54 cea39000 c0122838 00000000 9a74c3a0 00000009 49512994 
       00000001 b6aed695 00000000 cf910030 c02b6460 00000000 c0117835 c01178b0 
       c02b90c0 00000000 c0126ef1 c0126f4f cec00000 00000000 c02b90c0 00000000 
Call Trace:
 [<c0122838>] hrtimer_run_queues+0x158/0x190
 [<c0117835>] run_local_timers+0x5/0x20
 [<c01178b0>] update_process_times+0x20/0x50
 [<c0126ef1>] tick_periodic+0x21/0x70
 [<c0126f4f>] tick_handle_periodic+0xf/0x70
 [<c0104c92>] timer_interrupt+0x12/0x20
 [<c012d415>] handle_IRQ_event+0x25/0x50
 [<c012e7a3>] handle_level_irq+0x43/0xa0
 [<c01049f4>] do_IRQ+0x34/0x70
 [<c0102f57>] common_interrupt+0x23/0x28
 [<c0250000>] unix_sock_destructor+0x70/0xf0
 [<c0207b27>] __alloc_skb+0x97/0x110
 [<c02359c7>] tcp_send_ack+0x27/0xc0
 [<c02344ab>] tcp_rcv_established+0x31b/0x6d0
 [<c0239dc0>] tcp_v4_do_rcv+0xa0/0x190
 [<c023b822>] tcp_v4_rcv+0x4f2/0x5b0
 [<c022167c>] ip_local_deliver+0x5c/0xd0
 [<c022194e>] ip_rcv+0x25e/0x460
 [<c010af6f>] __change_page_attr_set_clr+0x30f/0x3d0
 [<c02216f0>] ip_rcv+0x0/0x460
 [<c020c5fa>] netif_receive_skb+0x18a/0x200
 [<d0862ba7>] e1000_clean_rx_irq+0x157/0x4d0 [e1000]
 [<d0862a50>] e1000_clean_rx_irq+0x0/0x4d0 [e1000]
 [<d0860056>] e1000_clean+0x1d6/0x540 [e1000]
 [<c010c2a6>] __update_rq_clock+0x26/0x110
 [<c010c1e0>] update_curr+0x80/0x110
 [<c010c05a>] sched_slice+0x1a/0x60
 [<c020e690>] net_rx_action+0x60/0xf0
 [<c01145b2>] __do_softirq+0x42/0x90
 [<c0114627>] do_softirq+0x27/0x30
 [<c01049f9>] do_IRQ+0x39/0x70
 [<c0102f57>] common_interrupt+0x23/0x28
 [<c020007b>] pirq_ali_set+0x4b/0x80
 [<c0250000>] unix_sock_destructor+0x70/0xf0
 [<c019ec9a>] __copy_from_user_ll_nozero+0x3a/0x70
 [<c014c3c4>] pipe_iov_copy_from_user+0x34/0x70
 [<c014ca23>] pipe_write+0x123/0x450
 [<c0146ed5>] do_sync_write+0xd5/0x120
 [<c011fd70>] autoremove_wake_function+0x0/0x40
 [<c020e690>] net_rx_action+0x60/0xf0
 [<c0146e00>] do_sync_write+0x0/0x120
 [<c01476ab>] vfs_write+0x8b/0xc0
 [<c0147b81>] sys_write+0x41/0x70
 [<c0102d66>] sysenter_past_esp+0x5f/0x85
BUG: unable to handle kernel NULL pointer dereference at 000001e0
IP: [<c0103365>] dump_trace+0x55/0xf0
*pde = 00000000 
Oops: 0000 [#2] DEBUG_PAGEALLOC
Modules linked in: e1000 emlog ftdi_sio usbserial [last unloaded: usbserial]

With the remaining commits in 2.6.25-rc1 applied, I get a lockup instead
of a null-pointer dereference.  Here is the lockup detected by enabling
the NMI watchdog on 2.6.27.10:

BUG: NMI Watchdog detected LOCKUP on CPU0, ip c03283e0, registers:
Modules linked in: w83781d hwmon_vid i2c_piix4 i2c_core e1000 emlog ftdi_sio usbserial
[last unloaded: usbserial]

Pid: 699, comm: codeload.cgi Not tainted (2.6.27.10 #16)
EIP: 0060:[<c03283e0>] EFLAGS: 00000086 CPU: 0
EIP is at __kprobes_text_start+0x0/0x8
EAX: 0000006b EBX: 0000006b ECX: 00000200 EDX: ca402000
ESI: 00000200 EDI: ca402df0 EBP: cf931960 ESP: cf931940
 DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
Process codeload.cgi (pid: 699, ti=cf930000 task=cfbe3788 task.ti=cf930000)
Stack: 00000003 c0169abf 00000060 00010086 ca402df0 ca402000 ca402000 cf3aab08 
       cf9319cc c016a9cd 00000000 00000020 00000020 cf812428 cf812430 cf812444 
       cf812444 00000020 cf810880 0000000c cf812420 cf81fef0 cf9319cc c016a2e1 
Call Trace:
 [<c0169abf>] ? poison_obj+0x2f/0x50
 [<c016a9cd>] ? cache_alloc_refill+0x46d/0x6c0
 [<c016a2e1>] ? cache_alloc_debugcheck_after+0x71/0x1f0
 [<c0145c8a>] ? trace_hardirqs_on_caller+0x7a/0x140
 [<c016b9b5>] ? __kmalloc_track_caller+0x135/0x150
 [<c02c99e9>] ? __alloc_skb+0x29/0x100
 [<c02fe8ca>] ? tcp_send_ack+0x2a/0xc0
 [<c02c9a09>] ? __alloc_skb+0x49/0x100
 [<c02fe8ca>] ? tcp_send_ack+0x2a/0xc0
 [<c02f5cd0>] ? __tcp_ack_snd_check+0x50/0xa0
 [<c02fb067>] ? tcp_rcv_established+0x5c7/0x990
 [<c03007c3>] ? tcp_v4_do_rcv+0xa3/0x1b0
 [<c0327ce8>] ? _spin_lock_nested+0x38/0x40
 [<c0301a2c>] ? tcp_v4_rcv+0x47c/0x6b0
 [<c02e75e1>] ? ip_local_deliver+0xa1/0x150
 [<c02e7590>] ? ip_local_deliver+0x50/0x150
 [<c02e7a53>] ? ip_rcv+0x2c3/0x5a0
 [<c02d0094>] ? netif_receive_skb+0x74/0x270
 [<c02e7790>] ? ip_rcv+0x0/0x5a0
 [<c02d01e9>] ? netif_receive_skb+0x1c9/0x270
 [<c02d0094>] ? netif_receive_skb+0x74/0x270
 [<d0962a47>] ? e1000_clean_rx_irq+0x167/0x390 [e1000]
 [<d09628e0>] ? e1000_clean_rx_irq+0x0/0x390 [e1000]
 [<d0964da9>] ? e1000_clean+0x239/0x560 [e1000]
 [<c0145d5b>] ? trace_hardirqs_on+0xb/0x10
 [<c02d1331>] ? net_rx_action+0xe1/0x170
 [<c0127bc3>] ? __do_softirq+0x93/0x120
 [<c0127ca7>] ? do_softirq+0x57/0x60
 [<c012821b>] ? irq_exit+0x6b/0x80
 [<c0105e3d>] ? do_IRQ+0x4d/0xa0
 [<c01dd274>] ? trace_hardirqs_off_thunk+0xc/0x18
 [<c0103a34>] ? common_interrupt+0x28/0x30
 [<c01dd8e1>] ? __copy_from_user_ll_nocache_nozero+0x61/0x100
 [<c0152017>] ? iov_iter_copy_from_user_atomic+0x57/0x90
 [<c0153938>] ? generic_file_buffered_write+0x118/0x5d0
 [<c0327c6d>] ? _spin_unlock+0x1d/0x20
 [<c0185126>] ? mnt_drop_write+0x46/0xe0
 [<c0154064>] ? __generic_file_aio_write_nolock+0x274/0x4c0
 [<c0326a02>] ? __mutex_lock_common+0x1f2/0x2f0
 [<c0185126>] ? mnt_drop_write+0x46/0xe0
 [<c0154316>] ? generic_file_aio_write+0x66/0xe0
 [<c016eb3d>] ? do_sync_write+0xcd/0x110
 [<c0135e40>] ? autoremove_wake_function+0x0/0x40
 [<c0325ca3>] ? schedule+0x233/0x700
 [<c016f502>] ? vfs_write+0x92/0x120
 [<c016ea70>] ? do_sync_write+0x0/0x110
 [<c016f64d>] ? sys_write+0x3d/0x70
 [<c0103031>] ? sysenter_do_call+0x12/0x35
 [<c0183496>] ? free_fdtable_rcu+0x76/0x80
 =======================
Code: e0 46 c0 8b 42 14 89 e5 85 c0 78 19 8b 42 14 83 e8 01 85 c0 89 42 14 79 0a b8 00 a0 42 c0 e8 98
2b ec ff 5d c3 0f 0b eb fe 90 90 <68> 20 65 11 c0 8d 76 00 06 1e 50 55 57 56 52 51 53 fc 0f a0 b9 


