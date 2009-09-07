Return-Path: <linux-kernel-owner+w=401wt.eu-S1753630AbZIGS0i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753630AbZIGS0i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Sep 2009 14:26:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752397AbZIGS0i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Sep 2009 14:26:38 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:57416 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752327AbZIGS0g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Sep 2009 14:26:36 -0400
Date: Mon, 7 Sep 2009 20:26:29 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Michael Buesch <mb@bu3sch.de>
Cc: Con Kolivas <kernel@kolivas.org>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Mike Galbraith <efault@gmx.de>,
       Felix Fietkau <nbd@openwrt.org>
Subject: Re: BFS vs. mainline scheduler benchmarks and measurements
Message-ID: <20090907182629.GA3484@elte.hu>
References: <20090906205952.GA6516@elte.hu> <200909071716.57722.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200909071716.57722.mb@bu3sch.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Michael Buesch <mb@bu3sch.de> wrote:

> Here's a very simple test setup on an embedded singlecore bcm47xx 
> machine (WL500GPv2) It uses iperf for performance testing. The 
> iperf server is run on the embedded device. The device is so slow 
> that the iperf test is completely CPU bound. The network 
> connection is a 100MBit on the device connected via patch cable to 
> a 1000MBit machine.
> 
> The kernel is openwrt-2.6.30.5.
> 
> Here are the results:
> 
> 
> 
> Mainline CFS scheduler:
> 
> mb@homer:~$ iperf -c 192.168.1.1
> ------------------------------------------------------------
> Client connecting to 192.168.1.1, TCP port 5001
> TCP window size: 16.0 KByte (default)
> ------------------------------------------------------------
> [  3] local 192.168.1.99 port 35793 connected with 192.168.1.1 port 5001
> [ ID] Interval       Transfer     Bandwidth
> [  3]  0.0-10.0 sec  27.4 MBytes  23.0 Mbits/sec
> mb@homer:~$ iperf -c 192.168.1.1
> ------------------------------------------------------------
> Client connecting to 192.168.1.1, TCP port 5001
> TCP window size: 16.0 KByte (default)
> ------------------------------------------------------------
> [  3] local 192.168.1.99 port 35794 connected with 192.168.1.1 port 5001
> [ ID] Interval       Transfer     Bandwidth
> [  3]  0.0-10.0 sec  27.3 MBytes  22.9 Mbits/sec
> mb@homer:~$ iperf -c 192.168.1.1
> ------------------------------------------------------------
> Client connecting to 192.168.1.1, TCP port 5001
> TCP window size: 16.0 KByte (default)
> ------------------------------------------------------------
> [  3] local 192.168.1.99 port 56147 connected with 192.168.1.1 port 5001
> [ ID] Interval       Transfer     Bandwidth
> [  3]  0.0-10.0 sec  27.3 MBytes  22.9 Mbits/sec
> 
> 
> BFS scheduler:
> 
> mb@homer:~$ iperf -c 192.168.1.1
> ------------------------------------------------------------
> Client connecting to 192.168.1.1, TCP port 5001
> TCP window size: 16.0 KByte (default)
> ------------------------------------------------------------
> [  3] local 192.168.1.99 port 52489 connected with 192.168.1.1 port 5001
> [ ID] Interval       Transfer     Bandwidth
> [  3]  0.0-10.0 sec  38.2 MBytes  32.0 Mbits/sec
> mb@homer:~$ iperf -c 192.168.1.1
> ------------------------------------------------------------
> Client connecting to 192.168.1.1, TCP port 5001
> TCP window size: 16.0 KByte (default)
> ------------------------------------------------------------
> [  3] local 192.168.1.99 port 52490 connected with 192.168.1.1 port 5001
> [ ID] Interval       Transfer     Bandwidth
> [  3]  0.0-10.0 sec  38.1 MBytes  31.9 Mbits/sec
> mb@homer:~$ iperf -c 192.168.1.1
> ------------------------------------------------------------
> Client connecting to 192.168.1.1, TCP port 5001
> TCP window size: 16.0 KByte (default)
> ------------------------------------------------------------
> [  3] local 192.168.1.99 port 52491 connected with 192.168.1.1 port 5001
> [ ID] Interval       Transfer     Bandwidth
> [  3]  0.0-10.0 sec  38.1 MBytes  31.9 Mbits/sec

That's interesting. I tried to reproduce it on x86, but the profile 
does not show any scheduler overhead at all on the server:

$ perf report

#
# Samples: 8369
#
# Overhead  Symbol
# ........  ......
#
     9.20%  [k] copy_user_generic_string
     3.80%  [k] e1000_clean
     3.58%  [k] ipt_do_table
     2.72%  [k] mwait_idle
     2.68%  [k] nf_iterate
     2.28%  [k] e1000_intr
     2.15%  [k] tcp_packet
     2.10%  [k] __hash_conntrack
     1.59%  [k] read_tsc
     1.52%  [k] _local_bh_enable_ip
     1.34%  [k] eth_type_trans
     1.29%  [k] __alloc_skb
     1.19%  [k] tcp_recvmsg
     1.19%  [k] ip_rcv
     1.17%  [k] e1000_clean_rx_irq
     1.12%  [k] apic_timer_interrupt
     0.99%  [k] vsnprintf
     0.96%  [k] nf_conntrack_in
     0.96%  [k] kmem_cache_free
     0.93%  [k] __kmalloc_track_caller


Could you profile it please? Also, what's the context-switch rate?

Below is the call-graph profile as well - all the overhead is in 
networking and SLAB.

	Ingo

 $ perf report --call-graph fractal,5

#
# Samples: 8947
#
# Overhead         Command                  Shared Object  Symbol
# ........  ..............  .............................  ......
#
     9.06%           iperf  [kernel]                       [k] copy_user_generic_string
                |          
                |--98.89%-- skb_copy_datagram_iovec
                |          |          
                |          |--77.18%-- tcp_recvmsg
                |          |          sock_common_recvmsg
                |          |          __sock_recvmsg
                |          |          sock_recvmsg
                |          |          sys_recvfrom
                |          |          system_call_fastpath
                |          |          __recv
                |          |          
                |           --22.82%-- tcp_rcv_established
                |                     tcp_v4_do_rcv
                |                     tcp_prequeue_process
                |                     tcp_recvmsg
                |                     sock_common_recvmsg
                |                     __sock_recvmsg
                |                     sock_recvmsg
                |                     sys_recvfrom
                |                     system_call_fastpath
                |                     __recv
                |          
                 --1.11%-- system_call_fastpath
                           __GI___libc_nanosleep

     3.62%          [init]  [kernel]                       [k] e1000_clean
     2.96%          [init]  [kernel]                       [k] ipt_do_table
     2.79%          [init]  [kernel]                       [k] mwait_idle
     2.22%          [init]  [kernel]                       [k] e1000_intr
     1.93%          [init]  [kernel]                       [k] nf_iterate
     1.65%          [init]  [kernel]                       [k] __hash_conntrack
     1.52%          [init]  [kernel]                       [k] tcp_packet
     1.29%          [init]  [kernel]                       [k] ip_rcv
     1.18%          [init]  [kernel]                       [k] __alloc_skb
     1.15%           iperf  [kernel]                       [k] tcp_recvmsg

     1.04%          [init]  [kernel]                       [k] _local_bh_enable_ip
     1.02%          [init]  [kernel]                       [k] apic_timer_interrupt
     1.02%          [init]  [kernel]                       [k] eth_type_trans
     1.01%          [init]  [kernel]                       [k] tcp_v4_rcv
     0.96%           iperf  [kernel]                       [k] kfree
                |          
                |--95.35%-- skb_release_data
                |          __kfree_skb
                |          |          
                |          |--79.27%-- tcp_recvmsg
                |          |          sock_common_recvmsg
                |          |          __sock_recvmsg
                |          |          sock_recvmsg
                |          |          sys_recvfrom
                |          |          system_call_fastpath
                |          |          __recv
                |          |          
                |           --20.73%-- tcp_rcv_established
                |                     tcp_v4_do_rcv
                |                     tcp_prequeue_process
                |                     tcp_recvmsg
                |                     sock_common_recvmsg
                |                     __sock_recvmsg
                |                     sock_recvmsg
                |                     sys_recvfrom
                |                     system_call_fastpath
                |                     __recv
                |          
                 --4.65%-- __kfree_skb
                           |          
                           |--75.00%-- tcp_rcv_established
                           |          tcp_v4_do_rcv
                           |          tcp_prequeue_process
                           |          tcp_recvmsg
                           |          sock_common_recvmsg
                           |          __sock_recvmsg
                           |          sock_recvmsg
                           |          sys_recvfrom
                           |          system_call_fastpath
                           |          __recv
                           |          
                            --25.00%-- tcp_recvmsg
                                      sock_common_recvmsg
                                      __sock_recvmsg
                                      sock_recvmsg
                                      sys_recvfrom
                                      system_call_fastpath
                                      __recv

     0.96%          [init]  [kernel]                       [k] read_tsc
     0.92%           iperf  [kernel]                       [k] tcp_v4_do_rcv
                |          
                |--95.12%-- tcp_prequeue_process
                |          tcp_recvmsg
                |          sock_common_recvmsg
                |          __sock_recvmsg
                |          sock_recvmsg
                |          sys_recvfrom
                |          system_call_fastpath
                |          __recv
                |          
                 --4.88%-- tcp_recvmsg
                           sock_common_recvmsg
                           __sock_recvmsg
                           sock_recvmsg
                           sys_recvfrom
                           system_call_fastpath
                           __recv

     0.92%          [init]  [kernel]                       [k] e1000_clean_rx_irq
     0.86%           iperf  [kernel]                       [k] tcp_rcv_established
                |          
                |--96.10%-- tcp_v4_do_rcv
                |          tcp_prequeue_process
                |          tcp_recvmsg
                |          sock_common_recvmsg
                |          __sock_recvmsg
                |          sock_recvmsg
                |          sys_recvfrom
                |          system_call_fastpath
                |          __recv
                |          
                 --3.90%-- tcp_prequeue_process
                           tcp_recvmsg
                           sock_common_recvmsg
                           __sock_recvmsg
                           sock_recvmsg
                           sys_recvfrom
                           system_call_fastpath
                           __recv

     0.84%           iperf  [kernel]                       [k] kmem_cache_free
                |          
                |--93.33%-- __kfree_skb
                |          |          
                |          |--71.43%-- tcp_recvmsg
                |          |          sock_common_recvmsg
                |          |          __sock_recvmsg
                |          |          sock_recvmsg
                |          |          sys_recvfrom
                |          |          system_call_fastpath
                |          |          __recv
                |          |          
                |           --28.57%-- tcp_rcv_established
                |                     tcp_v4_do_rcv
                |                     tcp_prequeue_process
                |                     tcp_recvmsg
                |                     sock_common_recvmsg
                |                     __sock_recvmsg
                |                     sock_recvmsg
                |                     sys_recvfrom
                |                     system_call_fastpath
                |                     __recv
                |          
                |--4.00%-- tcp_recvmsg
                |          sock_common_recvmsg
                |          __sock_recvmsg
                |          sock_recvmsg
                |          sys_recvfrom
                |          system_call_fastpath
                |          __recv
                |          
                 --2.67%-- tcp_rcv_established
                           tcp_v4_do_rcv
                           tcp_prequeue_process
                           tcp_recvmsg
                           sock_common_recvmsg
                           __sock_recvmsg
                           sock_recvmsg
                           sys_recvfrom
                           system_call_fastpath
                           __recv

     0.80%          [init]  [kernel]                       [k] netif_receive_skb
     0.79%           iperf  [kernel]                       [k] tcp_event_data_recv
                |          
                |--83.10%-- tcp_rcv_established
                |          tcp_v4_do_rcv
                |          tcp_prequeue_process
                |          tcp_recvmsg
                |          sock_common_recvmsg
                |          __sock_recvmsg
                |          sock_recvmsg
                |          sys_recvfrom
                |          system_call_fastpath
                |          __recv
                |          
                |--12.68%-- tcp_v4_do_rcv
                |          tcp_prequeue_process
                |          tcp_recvmsg
                |          sock_common_recvmsg
                |          __sock_recvmsg
                |          sock_recvmsg
                |          sys_recvfrom
                |          system_call_fastpath
                |          __recv
                |          
                 --4.23%-- tcp_data_queue
                           tcp_rcv_established
                           tcp_v4_do_rcv
                           tcp_prequeue_process
                           tcp_recvmsg
                           sock_common_recvmsg
                           __sock_recvmsg
                           sock_recvmsg
                           sys_recvfrom
                           system_call_fastpath
                           __recv

     0.67%            perf  [kernel]                       [k] format_decode
                |          
                |--91.67%-- vsnprintf
                |          seq_printf
                |          |          
                |          |--67.27%-- show_map_vma
                |          |          show_map
                |          |          seq_read
                |          |          vfs_read
                |          |          sys_read
                |          |          system_call_fastpath
                |          |          __GI_read
                |          |          
                |          |--23.64%-- render_sigset_t
                |          |          proc_pid_status
                |          |          proc_single_show
                |          |          seq_read
                |          |          vfs_read
                |          |          sys_read
                |          |          system_call_fastpath
                |          |          __GI_read
                |          |          
                |          |--7.27%-- proc_pid_status
                |          |          proc_single_show
                |          |          seq_read
                |          |          vfs_read
                |          |          sys_read
                |          |          system_call_fastpath
                |          |          __GI_read
                |          |          
                |           --1.82%-- cpuset_task_status_allowed
                |                     proc_pid_status
                |                     proc_single_show
                |                     seq_read
                |                     vfs_read
                |                     sys_read
                |                     system_call_fastpath
                |                     __GI_read
                |          
                 --8.33%-- seq_printf
                           |          
                           |--60.00%-- proc_pid_status
                           |          proc_single_show
                           |          seq_read
                           |          vfs_read
                           |          sys_read
                           |          system_call_fastpath
                           |          __GI_read
                           |          
                            --40.00%-- show_map_vma
                                      show_map
                                      seq_read
                                      vfs_read
                                      sys_read
                                      system_call_fastpath
                                      __GI_read

     0.65%          [init]  [kernel]                       [k] __kmalloc_track_caller
     0.63%          [init]  [kernel]                       [k] nf_conntrack_in
     0.63%          [init]  [kernel]                       [k] ip_route_input
     0.58%            perf  [kernel]                       [k] vsnprintf
                |          
                |--98.08%-- seq_printf
                |          |          
                |          |--60.78%-- show_map_vma
                |          |          show_map
                |          |          seq_read
                |          |          vfs_read
                |          |          sys_read
                |          |          system_call_fastpath
                |          |          __GI_read
                |          |          
                |          |--19.61%-- render_sigset_t
                |          |          proc_pid_status
                |          |          proc_single_show
                |          |          seq_read
                |          |          vfs_read
                |          |          sys_read
                |          |          system_call_fastpath
                |          |          __GI_read
                |          |          
                |          |--9.80%-- proc_pid_status
                |          |          proc_single_show
                |          |          seq_read
                |          |          vfs_read
                |          |          sys_read
                |          |          system_call_fastpath
                |          |          __GI_read
                |          |          
                |          |--3.92%-- task_mem
                |          |          proc_pid_status
                |          |          proc_single_show
                |          |          seq_read
                |          |          vfs_read
                |          |          sys_read
                |          |          system_call_fastpath
                |          |          __GI_read
                |          |          
                |          |--3.92%-- cpuset_task_status_allowed
                |          |          proc_pid_status
                |          |          proc_single_show
                |          |          seq_read
                |          |          vfs_read
                |          |          sys_read
                |          |          system_call_fastpath
                |          |          __GI_read
                |          |          
                |           --1.96%-- render_cap_t
                |                     proc_pid_status
                |                     proc_single_show
                |                     seq_read
                |                     vfs_read
                |                     sys_read
                |                     system_call_fastpath
                |                     __GI_read
                |          
                 --1.92%-- snprintf
                           proc_task_readdir
                           vfs_readdir
                           sys_getdents
                           system_call_fastpath
                           __getdents64
                           0x69706565000a3430

     0.57%          [init]  [kernel]                       [k] ktime_get
     0.57%          [init]  [kernel]                       [k] nf_nat_fn
     0.56%           iperf  [kernel]                       [k] tcp_packet
                |          
                |--68.00%-- __tcp_ack_snd_check
                |          tcp_rcv_established
                |          tcp_v4_do_rcv
                |          tcp_prequeue_process
                |          tcp_recvmsg
                |          sock_common_recvmsg
                |          __sock_recvmsg
                |          sock_recvmsg
                |          sys_recvfrom
                |          system_call_fastpath
                |          __recv
                |          
                 --32.00%-- tcp_cleanup_rbuf
                           tcp_recvmsg
                           sock_common_recvmsg
                           __sock_recvmsg
                           sock_recvmsg
                           sys_recvfrom
                           system_call_fastpath
                           __recv

     0.56%           iperf  /usr/bin/iperf                 [.] 0x000000000059f8
                |          
                |--8.00%-- 0x4059f8
                |          
                |--8.00%-- 0x405a16
                |          
                |--8.00%-- 0x4059fd
                |          
                |--4.00%-- 0x409d22
                |          
                |--4.00%-- 0x405871
                |          
                |--4.00%-- 0x406ee1
                |          
                |--4.00%-- 0x405726
                |          
                |--4.00%-- 0x4058db
                |          
                |--4.00%-- 0x406ee8
                |          
                |--2.00%-- 0x405b60
                |          
                |--2.00%-- 0x4058fd
                |          
                |--2.00%-- 0x4058d5
                |          
                |--2.00%-- 0x405490
                |          
                |--2.00%-- 0x4058bb
                |          
                |--2.00%-- 0x405b93
                |          
                |--2.00%-- 0x405b8e
                |          
                |--2.00%-- 0x405903
                |          
                |--2.00%-- 0x405ba8
                |          
                |--2.00%-- 0x406eae
                |          
                |--2.00%-- 0x405545
                |          
                |--2.00%-- 0x405870
                |          
                |--2.00%-- 0x405b67
                |          
                |--2.00%-- 0x4058ce
                |          
                |--2.00%-- 0x40570e
                |          
                |--2.00%-- 0x406ee4
                |          
                |--2.00%-- 0x405a02
                |          
                |--2.00%-- 0x406eec
                |          
                |--2.00%-- 0x405b82
                |          
                |--2.00%-- 0x40556a
                |          
                |--2.00%-- 0x405755
                |          
                |--2.00%-- 0x405a0a
                |          
                |--2.00%-- 0x405498
                |          
                |--2.00%-- 0x409d20
                |          
                |--2.00%-- 0x405b21
                |          
                 --2.00%-- 0x405a2c

     0.56%          [init]  [kernel]                       [k] kmem_cache_alloc
     0.56%          [init]  [kernel]                       [k] __inet_lookup_established
     0.55%            perf  [kernel]                       [k] number
                |          
                |--95.92%-- vsnprintf
                |          |          
                |          |--97.87%-- seq_printf
                |          |          |          
                |          |          |--56.52%-- show_map_vma
                |          |          |          show_map
                |          |          |          seq_read
                |          |          |          vfs_read
                |          |          |          sys_read
                |          |          |          system_call_fastpath
                |          |          |          __GI_read
                |          |          |          
                |          |          |--28.26%-- render_sigset_t
                |          |          |          proc_pid_status
                |          |          |          proc_single_show
                |          |          |          seq_read
                |          |          |          vfs_read
                |          |          |          sys_read
                |          |          |          system_call_fastpath
                |          |          |          __GI_read
                |          |          |          
                |          |          |--6.52%-- proc_pid_status
                |          |          |          proc_single_show
                |          |          |          seq_read
                |          |          |          vfs_read
                |          |          |          sys_read
                |          |          |          system_call_fastpath
                |          |          |          __GI_read
                |          |          |          
                |          |          |--4.35%-- render_cap_t
                |          |          |          proc_pid_status
                |          |          |          proc_single_show
                |          |          |          seq_read
                |          |          |          vfs_read
                |          |          |          sys_read
                |          |          |          system_call_fastpath
                |          |          |          __GI_read
                |          |          |          
                |          |           --4.35%-- task_mem
                |          |                     proc_pid_status
                |          |                     proc_single_show
                |          |                     seq_read
                |          |                     vfs_read
                |          |                     sys_read
                |          |                     system_call_fastpath
                |          |                     __GI_read
                |          |          
                |           --2.13%-- scnprintf
                |                     bitmap_scnlistprintf
                |                     seq_bitmap_list
                |                     cpuset_task_status_allowed
                |                     proc_pid_status
                |                     proc_single_show
                |                     seq_read
                |                     vfs_read
                |                     sys_read
                |                     system_call_fastpath
                |                     __GI_read
                |          
                 --4.08%-- seq_printf
                           |          
                           |--50.00%-- show_map_vma
                           |          show_map
                           |          seq_read
                           |          vfs_read
                           |          sys_read
                           |          system_call_fastpath
                           |          __GI_read
                           |          
                            --50.00%-- render_sigset_t
                                      proc_pid_status
                                      proc_single_show
                                      seq_read
                                      vfs_read
                                      sys_read
                                      system_call_fastpath
                                      __GI_read

     0.55%          [init]  [kernel]                       [k] native_sched_clock
     0.50%           iperf  [kernel]                       [k] e1000_xmit_frame
                |          
                |--71.11%-- __tcp_ack_snd_check
                |          tcp_rcv_established
                |          tcp_v4_do_rcv
                |          tcp_prequeue_process
                |          tcp_recvmsg
                |          sock_common_recvmsg
                |          __sock_recvmsg
                |          sock_recvmsg
                |          sys_recvfrom
                |          system_call_fastpath
                |          __recv
                |          
                 --28.89%-- tcp_cleanup_rbuf
                           tcp_recvmsg
                           sock_common_recvmsg
                           __sock_recvmsg
                           sock_recvmsg
                           sys_recvfrom
                           system_call_fastpath
                           __recv

     0.50%           iperf  [kernel]                       [k] ipt_do_table
                |          
                |--37.78%-- ipt_local_hook
                |          nf_iterate
                |          nf_hook_slow
                |          __ip_local_out
                |          ip_local_out
                |          ip_queue_xmit
                |          tcp_transmit_skb
                |          tcp_send_ack
                |          |          
                |          |--58.82%-- __tcp_ack_snd_check
                |          |          tcp_rcv_established
                |          |          tcp_v4_do_rcv
                |          |          tcp_prequeue_process
                |          |          tcp_recvmsg
                |          |          sock_common_recvmsg
                |          |          __sock_recvmsg
                |          |          sock_recvmsg
                |          |          sys_recvfrom
                |          |          system_call_fastpath
                |          |          __recv
                |          |          
                |           --41.18%-- tcp_cleanup_rbuf
                |                     tcp_recvmsg
                |                     sock_common_recvmsg
                |                     __sock_recvmsg
                |                     sock_recvmsg
                |                     sys_recvfrom
                |                     system_call_fastpath
                |                     __recv
                |          
                |--31.11%-- ipt_post_routing_hook
                |          nf_iterate
                |          nf_hook_slow
                |          ip_output
                |          ip_local_out
                |          ip_queue_xmit
                |          tcp_transmit_skb
                |          tcp_send_ack
                |          |          
                |          |--64.29%-- __tcp_ack_snd_check
                |          |          tcp_rcv_established
                |          |          tcp_v4_do_rcv
                |          |          tcp_prequeue_process
                |          |          tcp_recvmsg
                |          |          sock_common_recvmsg
                |          |          __sock_recvmsg
                |          |          sock_recvmsg
                |          |          sys_recvfrom
                |          |          system_call_fastpath
                |          |          __recv
                |          |          
                |           --35.71%-- tcp_cleanup_rbuf
                |                     tcp_recvmsg
                |                     sock_common_recvmsg
                |                     __sock_recvmsg
                |                     sock_recvmsg
                |                     sys_recvfrom
                |                     system_call_fastpath
                |                     __recv
                |          
                |--20.00%-- ipt_local_out_hook
                |          nf_iterate
                |          nf_hook_slow
                |          __ip_local_out
                |          ip_local_out
                |          ip_queue_xmit
                |          tcp_transmit_skb
                |          tcp_send_ack
                |          |          
                |          |--88.89%-- __tcp_ack_snd_check
                |          |          tcp_rcv_established
                |          |          tcp_v4_do_rcv
                |          |          tcp_prequeue_process
                |          |          tcp_recvmsg
                |          |          sock_common_recvmsg
                |          |          __sock_recvmsg
                |          |          sock_recvmsg
                |          |          sys_recvfrom
                |          |          system_call_fastpath
                |          |          __recv
                |          |          
                |           --11.11%-- tcp_cleanup_rbuf
                |                     tcp_recvmsg
                |                     sock_common_recvmsg
                |                     __sock_recvmsg
                |                     sock_recvmsg
                |                     sys_recvfrom
                |                     system_call_fastpath
                |                     __recv
                |          
                |--6.67%-- nf_iterate
                |          nf_hook_slow
                |          |          
                |          |--66.67%-- ip_output
                |          |          ip_local_out
                |          |          ip_queue_xmit
                |          |          tcp_transmit_skb
                |          |          tcp_send_ack
                |          |          tcp_cleanup_rbuf
                |          |          tcp_recvmsg
                |          |          sock_common_recvmsg
                |          |          __sock_recvmsg
                |          |          sock_recvmsg
                |          |          sys_recvfrom
                |          |          system_call_fastpath
                |          |          __recv
                |          |          
                |           --33.33%-- __ip_local_out
                |                     ip_local_out
                |                     ip_queue_xmit
                |                     tcp_transmit_skb
                |                     tcp_send_ack
                |                     __tcp_ack_snd_check
                |                     tcp_rcv_established
                |                     tcp_v4_do_rcv
                |                     tcp_prequeue_process
                |                     tcp_recvmsg
                |                     sock_common_recvmsg
                |                     __sock_recvmsg
                |                     sock_recvmsg
                |                     sys_recvfrom
                |                     system_call_fastpath
                |                     __recv
                |          
                |--2.22%-- ipt_local_in_hook
                |          nf_iterate
                |          nf_hook_slow
                |          ip_local_deliver
                |          ip_rcv_finish
                |          ip_rcv
                |          netif_receive_skb
                |          napi_skb_finish
                |          napi_gro_receive
                |          e1000_receive_skb
                |          e1000_clean_rx_irq
                |          e1000_clean
                |          net_rx_action
                |          __do_softirq
                |          call_softirq
                |          do_softirq
                |          irq_exit
                |          do_IRQ
                |          ret_from_intr
                |          vgettimeofday
                |          
                 --2.22%-- ipt_pre_routing_hook
                           nf_iterate
                           nf_hook_slow
                           ip_rcv
                           netif_receive_skb
                           napi_skb_finish
                           napi_gro_receive
                           e1000_receive_skb
                           e1000_clean_rx_irq
                           e1000_clean
                           net_rx_action
                           __do_softirq
                           call_softirq
                           do_softirq
                           irq_exit
                           do_IRQ
                           ret_from_intr
                           __GI___libc_nanosleep

     0.50%           iperf  [kernel]                       [k] schedule
                |          
                |--57.78%-- do_nanosleep
                |          hrtimer_nanosleep
                |          sys_nanosleep
                |          system_call_fastpath
                |          __GI___libc_nanosleep
                |          
                |--33.33%-- schedule_timeout
                |          sk_wait_data
                |          tcp_recvmsg
                |          sock_common_recvmsg
                |          __sock_recvmsg
                |          sock_recvmsg
                |          sys_recvfrom
                |          system_call_fastpath
                |          __recv
                |          
                |--6.67%-- hrtimer_nanosleep
                |          sys_nanosleep
                |          system_call_fastpath
                |          __GI___libc_nanosleep
                |          
                 --2.22%-- sk_wait_data
                           tcp_recvmsg
                           sock_common_recvmsg
                           __sock_recvmsg
                           sock_recvmsg
                           sys_recvfrom
                           system_call_fastpath
                           __recv

     0.49%           iperf  [kernel]                       [k] tcp_transmit_skb
                |          
                |--97.73%-- tcp_send_ack
                |          |          
                |          |--83.72%-- __tcp_ack_snd_check
                |          |          tcp_rcv_established
                |          |          tcp_v4_do_rcv
                |          |          |          
                |          |          |--97.22%-- tcp_prequeue_process
                |          |          |          tcp_recvmsg
                |          |          |          sock_common_recvmsg
                |          |          |          __sock_recvmsg
                |          |          |          sock_recvmsg
                |          |          |          sys_recvfrom
                |          |          |          system_call_fastpath
                |          |          |          __recv
                |          |          |          
                |          |           --2.78%-- release_sock
                |          |                     tcp_recvmsg
                |          |                     sock_common_recvmsg
                |          |                     __sock_recvmsg
                |          |                     sock_recvmsg
                |          |                     sys_recvfrom
                |          |                     system_call_fastpath
                |          |                     __recv
                |          |          
                |           --16.28%-- tcp_cleanup_rbuf
                |                     tcp_recvmsg
                |                     sock_common_recvmsg
                |                     __sock_recvmsg
                |                     sock_recvmsg
                |                     sys_recvfrom
                |                     system_call_fastpath
                |                     __recv
                |          
                 --2.27%-- __tcp_ack_snd_check
                           tcp_rcv_established
                           tcp_v4_do_rcv
                           tcp_prequeue_process
                           tcp_recvmsg
                           sock_common_recvmsg
                           __sock_recvmsg
                           sock_recvmsg
                           sys_recvfrom
                           system_call_fastpath
                           __recv

     0.49%          [init]  [kernel]                       [k] nf_hook_slow
     0.48%           iperf  [kernel]                       [k] virt_to_head_page
                |          
                |--53.49%-- kfree
                |          skb_release_data
                |          __kfree_skb
                |          |          
                |          |--65.22%-- tcp_recvmsg
                |          |          sock_common_recvmsg
                |          |          __sock_recvmsg
                |          |          sock_recvmsg
                |          |          sys_recvfrom
                |          |          system_call_fastpath
                |          |          __recv
                |          |          
                |           --34.78%-- tcp_rcv_established
                |                     tcp_v4_do_rcv
                |                     tcp_prequeue_process
                |                     tcp_recvmsg
                |                     sock_common_recvmsg
                |                     __sock_recvmsg
                |                     sock_recvmsg
                |                     sys_recvfrom
                |                     system_call_fastpath
                |                     __recv
                |          
                |--18.60%-- skb_release_data
                |          __kfree_skb
                |          |          
                |          |--62.50%-- tcp_rcv_established
                |          |          tcp_v4_do_rcv
                |          |          tcp_prequeue_process
                |          |          tcp_recvmsg
                |          |          sock_common_recvmsg
                |          |          __sock_recvmsg
                |          |          sock_recvmsg
                |          |          sys_recvfrom
                |          |          system_call_fastpath
                |          |          __recv
                |          |          
                |           --37.50%-- tcp_recvmsg
                |                     sock_common_recvmsg
                |                     __sock_recvmsg
                |                     sock_recvmsg
                |                     sys_recvfrom
                |                     system_call_fastpath
                |                     __recv
                |          
                |--18.60%-- kmem_cache_free
                |          __kfree_skb
                |          |          
                |          |--62.50%-- tcp_rcv_established
                |          |          tcp_v4_do_rcv
                |          |          tcp_prequeue_process
                |          |          tcp_recvmsg
                |          |          sock_common_recvmsg
                |          |          __sock_recvmsg
                |          |          sock_recvmsg
                |          |          sys_recvfrom
                |          |          system_call_fastpath
                |          |          __recv
                |          |          
                |           --37.50%-- tcp_recvmsg
                |                     sock_common_recvmsg
                |                     __sock_recvmsg
                |                     sock_recvmsg
                |                     sys_recvfrom
                |                     system_call_fastpath
                |                     __recv
                |          
                 --9.30%-- __kfree_skb
                           |          
                           |--75.00%-- tcp_rcv_established
                           |          tcp_v4_do_rcv
                           |          tcp_prequeue_process
                           |          tcp_recvmsg
                           |          sock_common_recvmsg
                           |          __sock_recvmsg
                           |          sock_recvmsg
                           |          sys_recvfrom
                           |          system_call_fastpath
                           |          __recv
                           |          
                            --25.00%-- tcp_recvmsg
                                      sock_common_recvmsg
                                      __sock_recvmsg
                                      sock_recvmsg
                                      sys_recvfrom
                                      system_call_fastpath
                                      __recv
 ...
