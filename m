Return-Path: <linux-kernel-owner+w=401wt.eu-S1752734AbYKRBmJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752734AbYKRBmJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 20:42:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751750AbYKRBl4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 20:41:56 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:38783 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750952AbYKRBlz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 20:41:55 -0500
Date: Mon, 17 Nov 2008 20:41:53 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Paul Mackerras <paulus@samba.org>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linuxppc-dev@ozlabs.org, Andrew Morton <akpm@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Large stack usage in fs code (especially for PPC64)
In-Reply-To: <18722.5316.582974.95373@cargo.ozlabs.ibm.com>
Message-ID: <alpine.DEB.1.10.0811172020260.26123@gandalf.stny.rr.com>
References: <alpine.DEB.1.10.0811171508300.8722@gandalf.stny.rr.com> <alpine.DEB.1.10.0811171557370.26123@gandalf.stny.rr.com> <alpine.LFD.2.00.0811171309580.18283@nehalem.linux-foundation.org> <alpine.DEB.1.10.0811171936480.26123@gandalf.stny.rr.com>
 <18722.5316.582974.95373@cargo.ozlabs.ibm.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 18 Nov 2008, Paul Mackerras wrote:
> > 
> > 64 bytes, still much lower than the 160 of PPC64.
> 
> The ppc64 ABI has a minimum stack frame of 112 bytes, due to having an
> area for called functions to store their parameters (64 bytes) plus 6
> slots for saving stuff and for the compiler and linker to use if they
> need to.  That's before any local variables are allocated.
> 
> The ppc32 ABI has a minimum stack frame of 16 bytes, which is much
> nicer, at the expense of a much more complicated va_arg().

Here's a full dump that I got from my 32bit Powerbook:

rostedt@gollum:~$ cat /debug/tracing/stack_trace 
        Depth   Size      Location    (57 entries)
        -----   ----      --------
  0)     3196      48   ftrace_call+0x4/0x48
  1)     3148      48   update_curr+0xa0/0x110
  2)     3100      48   enqueue_task_fair+0x54/0xfc
  3)     3052      32   enqueue_task+0x34/0x54
  4)     3020      16   activate_task+0x40/0x64
  5)     3004      48   try_to_wake_up+0x78/0x164
  6)     2956      16   default_wake_function+0x28/0x40
  7)     2940      48   __wake_up_common+0x54/0xac
  8)     2892      32   __wake_up_sync+0x58/0x94
  9)     2860      16   sock_def_readable+0x58/0xb8
 10)     2844      32   sock_queue_rcv_skb+0x10c/0x128
 11)     2812      32   __udp_queue_rcv_skb+0x2c/0xc4
 12)     2780      32   udp_queue_rcv_skb+0x1d8/0x27c
 13)     2748      96   __udp4_lib_rcv+0x514/0x77c
 14)     2652      16   udp_rcv+0x30/0x48
 15)     2636      32   ip_local_deliver_finish+0xf4/0x1cc
 16)     2604      16   ip_local_deliver+0x94/0xac
 17)     2588      64   ip_rcv_finish+0x2ec/0x31c
 18)     2524      32   ip_rcv+0x23c/0x278
 19)     2492      48   netif_receive_skb+0x48c/0x4c0
 20)     2444      48   process_backlog+0xb0/0x144
 21)     2396      48   net_rx_action+0x8c/0x1bc
 22)     2348      48   __do_softirq+0x84/0x10c
 23)     2300      16   do_softirq+0x50/0x6c
 24)     2284      16   local_bh_enable+0x90/0xc8
 25)     2268      32   dev_queue_xmit+0x564/0x5b0
 26)     2236      48   ip_finish_output+0x2b4/0x2f4
 27)     2188      32   ip_output+0xec/0x104
 28)     2156      16   ip_local_out+0x44/0x5c
 29)     2140      48   ip_push_pending_frames+0x340/0x3ec
 30)     2092      48   udp_push_pending_frames+0x2ac/0x348
 31)     2044     160   udp_sendmsg+0x458/0x5bc
 32)     1884      32   inet_sendmsg+0x70/0x88
 33)     1852     240   sock_sendmsg+0xd0/0xf8
 34)     1612      32   kernel_sendmsg+0x3c/0x58
 35)     1580      96   xs_send_kvec+0xb4/0xcc [sunrpc]
 36)     1484      64   xs_sendpages+0x94/0x1f0 [sunrpc]
 37)     1420      32   xs_udp_send_request+0x44/0x14c [sunrpc]
 38)     1388      32   xprt_transmit+0x100/0x228 [sunrpc]
 39)     1356      32   call_transmit+0x234/0x290 [sunrpc]
 40)     1324      48   __rpc_execute+0xcc/0x2d4 [sunrpc]
 41)     1276      32   rpc_execute+0x48/0x60 [sunrpc]
 42)     1244      32   rpc_run_task+0x74/0x90 [sunrpc]
 43)     1212      64   rpc_call_sync+0x6c/0xa0 [sunrpc]
 44)     1148      80   rpcb_register_call+0xb0/0x110 [sunrpc]
 45)     1068      96   rpcb_register+0xe8/0x100 [sunrpc]
 46)      972      80   svc_register+0x118/0x168 [sunrpc]
 47)      892      64   svc_setup_socket+0xa0/0x354 [sunrpc]
 48)      828     272   svc_create_socket+0x1e0/0x250 [sunrpc]
 49)      556      16   svc_udp_create+0x38/0x50 [sunrpc]
 50)      540      96   svc_create_xprt+0x1c8/0x2fc [sunrpc]
 51)      444      48   lockd_up+0xcc/0x27c [lockd]
 52)      396      96   write_ports+0xf4/0x2cc [nfsd]
 53)      300      32   nfsctl_transaction_write+0x78/0xbc [nfsd]
 54)      268      32   vfs_write+0xc8/0x178
 55)      236      48   sys_write+0x5c/0xa0
 56)      188     188   ret_from_syscall+0x0/0x40

And here's my i386 max stack:

[root@mirhel51 ~]# cat /debug/tracing/stack_trace 
        Depth   Size      Location    (47 entries)
        -----   ----      --------
  0)     2216     240   blk_recount_segments+0x39/0x51
  1)     1976      12   bio_phys_segments+0x16/0x1c
  2)     1964      20   blk_rq_bio_prep+0x29/0xae
  3)     1944      16   init_request_from_bio+0xc9/0xcd
  4)     1928      60   __make_request+0x2f6/0x3c1
  5)     1868     136   generic_make_request+0x36a/0x3a0
  6)     1732      56   submit_bio+0xcd/0xd8
  7)     1676      28   submit_bh+0xd1/0xf0
  8)     1648     112   block_read_full_page+0x299/0x2a9
  9)     1536       8   blkdev_readpage+0x14/0x16
 10)     1528      28   read_cache_page_async+0x7e/0x109
 11)     1500      16   read_cache_page+0x11/0x49
 12)     1484      32   read_dev_sector+0x3c/0x72
 13)     1452      48   read_lba+0x4d/0xaa
 14)     1404     168   efi_partition+0x85/0x61b
 15)     1236      84   rescan_partitions+0x14b/0x316
 16)     1152      40   __blkdev_get+0x1b2/0x258
 17)     1112       8   blkdev_get+0xf/0x11
 18)     1104      36   register_disk+0xbc/0x112
 19)     1068      32   add_disk+0x9f/0xf3
 20)     1036      48   sd_probe+0x2d4/0x394
 21)      988      20   driver_probe_device+0xa5/0x120
 22)      968       8   __device_attach+0xd/0xf
 23)      960      28   bus_for_each_drv+0x3e/0x67
 24)      932      24   device_attach+0x56/0x6a
 25)      908      16   bus_attach_device+0x26/0x4d
 26)      892      64   device_add+0x380/0x4aa
 27)      828      28   scsi_sysfs_add_sdev+0xa1/0x1c9
 28)      800     160   scsi_probe_and_add_lun+0x97e/0xa8f
 29)      640      36   __scsi_add_device+0x88/0xae
 30)      604      40   ata_scsi_scan_host+0x8b/0x1cd
 31)      564      28   ata_host_register+0x1da/0x1ea
 32)      536      24   ata_host_activate+0x98/0xb5
 33)      512     188   ahci_init_one+0xa23/0xa4f
 34)      324      20   pci_device_probe+0x3e/0x5e
 35)      304      20   driver_probe_device+0xa5/0x120
 36)      284      20   __driver_attach+0x51/0x70
 37)      264      32   bus_for_each_dev+0x40/0x62
 38)      232      12   driver_attach+0x19/0x1b
 39)      220      28   bus_add_driver+0x9c/0x1ac
 40)      192      28   driver_register+0x76/0xd2
 41)      164      20   __pci_register_driver+0x44/0x70
 42)      144       8   ahci_init+0x14/0x16
 43)      136      92   _stext+0x4f/0x116
 44)       44      16   kernel_init+0xf7/0x145
 45)       28      28   kernel_thread_helper+0x7/0x10

Note, the i386 box had 4KSTACKS defined and the PPC did not have 
IRQSTACKS defined. I'll compile with IRQSTACKS defined and post that 
result.

-- Steve

