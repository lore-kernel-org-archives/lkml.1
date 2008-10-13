Return-Path: <linux-kernel-owner+w=401wt.eu-S1756238AbYJMOEr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756238AbYJMOEr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 10:04:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754662AbYJMOEe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 10:04:34 -0400
Received: from mail.telesweet.net ([194.110.252.6]:27787 "EHLO
	mail.telesweet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754625AbYJMOEd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 10:04:33 -0400
X-Greylist: delayed 600 seconds by postgrey-1.27 at vger.kernel.org; Mon, 13 Oct 2008 10:04:32 EDT
X-Spam-Flag: NO
X-Spam-Score: -1.621
Message-ID: <48F35315.3020705@samoylyk.sumy.ua>
Date: Mon, 13 Oct 2008 16:54:29 +0300
From: Oleksandr Samoylyk <oleksandr@samoylyk.sumy.ua>
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: dst cache overflow
Content-Type: text/plain; charset=KOI8-U; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear community,

I've a problem of unexpected loosing of network connection on a server 
running GNU/Linux.

It's a 8-core / 8 GB RAM PPTP "aggregator" with about 2500 sessions and 
200 Mb/s or 30 kpps of Internet traffic.

There are two GigE Intel NICs (Intel(R) PRO/1000 Network Driver - 
version 7.3.20-k2-NAPI).

I've attached their IRQs to different CPUs with smp_affinity.

TSO is off.

Kernel version: linux-2.6.24.3 (server image from ubuntu hardy).

I'm booting with:
noapic acpi=off panic=5 rhash_entries=1048575

I got the following in logs:

Oct  7 22:26:50 linux kernel: [    0.000000] CPU 2:
Oct  7 22:26:50 linux kernel: [    0.000000] Modules linked in: oprofile 
af_packet xt_tcpmss act_police cls_u32 sch_sfq sch_ingress sch_htb 
xt_multiport xt_TCPMSS xt_state
  xt_limit xt_tcpudp iptable_mangle iptable_nat nf_nat nf_conntrack_ipv4 
nf_conntrack iptable_filter ip_tables x_tables pptp pppox ppp_generic 
slhc parport_pc lp parport loop i
TCO_wdt iTCO_vendor_support pcspkr i5000_edac shpchp edac_core 
pci_hotplug evdev ext3 jbd mbcache sg sr_mod cdrom sd_mod ata_piix 
pata_acpi aic94xx libsas scsi_transport_sas a
ta_generic e1000 libata scsi_mod fbcon tileblit font bitblit softcursor fuse
Oct  7 22:26:50 linux kernel: [    0.000000] Pid: 29, comm: events/2 Not 
tainted 2.6.24-19-server #1
Oct  7 22:26:50 linux kernel: [    0.000000] RIP: 
0010:[libsas:_spin_lock_irqsave+0x15/0x30] 
[libsas:_spin_lock_irqsave+0x15/0x30] _spin_lock_irqsave+0x15/0x30
Oct  7 22:26:50 linux kernel: [    0.000000] RSP: 0018:ffff81022568de18 
  EFLAGS: 00000282
Oct  7 22:26:50 linux kernel: [    0.000000] RAX: 0000000000000282 RBX: 
ffff810164d62400 RCX: 0000000000000000
Oct  7 22:26:50 linux kernel: [    0.000000] RDX: 00000000000e4e67 RSI: 
00000000124839fe RDI: ffff810164d626b4
Oct  7 22:26:50 linux kernel: [    0.000000] RBP: ffffffff802345b3 R08: 
0000000000000000 R09: 0000000000000000
Oct  7 22:26:50 linux kernel: [    0.000000] R10: 0000000000000000 R11: 
ffff8101f04d5d00 R12: ffff81022568ddc0
Oct  7 22:26:50 linux kernel: [    0.000000] R13: 0000000000000003 R14: 
0000000000000286 R15: 0000000000000001
Oct  7 22:26:50 linux kernel: [    0.000000] FS: 0000000000000000(0000) 
GS:ffff810228001b80(0000) knlGS:0000000000000000
Oct  7 22:26:50 linux kernel: [    0.000000] CS:  0010 DS: 0018 ES: 0018 
CR0: 000000008005003b
Oct  7 22:26:50 linux kernel: [    0.000000] CR2: 00007f54a9cd2000 CR3: 
0000000000201000 CR4: 00000000000006e0
Oct  7 22:26:50 linux kernel: [    0.000000] DR0: 0000000000000000 DR1: 
0000000000000000 DR2: 0000000000000000
Oct  7 22:26:50 linux kernel: [    0.000000] DR3: 0000000000000000 DR6: 
00000000ffff0ff0 DR7: 0000000000000400
Oct  7 22:26:50 linux kernel: [    0.000000]
Oct  7 22:26:50 linux kernel: [    0.000000] Call Trace:
Oct  7 22:26:50 linux kernel: [    0.000000] 
[pptp:skb_dequeue+0x21/0x3d0] skb_dequeue+0x21/0x80
Oct  7 22:26:50 linux kernel: [    0.000000] 
[pptp:do_buf_work+0x38/0x150] :pptp:do_buf_work+0x38/0x150
Oct  7 22:26:50 linux kernel: [    0.000000] [pptp:_buf_work+0x0/0x20] 
:pptp:_buf_work+0x0/0x20
Oct  7 22:26:50 linux kernel: [    0.000000] [run_workqueue+0xcc/0x170] 
run_workqueue+0xcc/0x170
Oct  7 22:26:50 linux kernel: [    0.000000] [worker_thread+0x0/0x110] 
worker_thread+0x0/0x110
Oct  7 22:26:50 linux kernel: [    0.000000] [worker_thread+0x0/0x110] 
worker_thread+0x0/0x110
Oct  7 22:26:50 linux kernel: [    0.000000] [worker_thread+0xa3/0x110] 
worker_thread+0xa3/0x110
Oct  7 22:26:50 linux kernel: [    0.000000]  [<ffffffff80254260>] 
autoremove_wake_function+0x0/0x30
Oct  7 22:26:50 linux kernel: [    0.000000] [worker_thread+0x0/0x110] 
worker_thread+0x0/0x110
Oct  7 22:26:50 linux kernel: [    0.000000] [worker_thread+0x0/0x110] 
worker_thread+0x0/0x110
Oct  7 22:26:50 linux kernel: [    0.000000]  [kthread+0x4b/0x80] 
kthread+0x4b/0x80
Oct  7 22:26:50 linux kernel: [    0.000000]  [child_rip+0xa/0x12] 
child_rip+0xa/0x12
Oct  7 22:26:50 linux kernel: [    0.000000]  [kthread+0x0/0x80] 
kthread+0x0/0x80
Oct  7 22:26:50 linux kernel: [    0.000000]  [child_rip+0x0/0x12] 
child_rip+0x0/0x12
Oct  7 22:26:50 linux kernel: [    0.000000]
Oct  7 22:26:51 linux kernel: [    0.000000] NETDEV WATCHDOG: eth0: 
transmit timed out
Oct  7 22:26:53 linux kernel: [    0.000000] printk: 19 messages suppressed.
Oct  7 22:26:53 linux kernel: [    0.000000] dst cache overflow
Oct  7 22:26:56 linux kernel: [    0.000000] NETDEV WATCHDOG: eth0: 
transmit timed out
Oct  7 22:26:58 linux kernel: [    0.000000] printk: 19 messages suppressed.
Oct  7 22:26:58 linux kernel: [    0.000000] dst cache overflow
Oct  7 22:27:01 linux kernel: [    0.000000] NETDEV WATCHDOG: eth0: 
transmit timed out
Oct  7 22:27:02 linux kernel: [    0.000000] CPU 2:

The server lost network connectivity until reboot.

I guess it's due to "dst cache overflow".

Some of custom sysctl variables:
net.core.rmem_max = 16777216
net.core.wmem_max = 16777216
net.ipv4.tcp_rmem = 4096 87380 16777216
net.ipv4.tcp_wmem = 4096 65536 16777216
net.ipv4.tcp_no_metrics_save = 1
net.ipv4.tcp_moderate_rcvbuf = 1
net.core.netdev_max_backlog = 4096
net.ipv4.conf.default.arp_filter = 1
net.ipv4.ip_default_ttl = 255
net.ipv4.tcp_max_syn_backlog = 4096

net.ipv4.tcp_timestamps = 0
net.ipv4.tcp_sack = 0

net.nf_conntrack_max = 1743087
net.ipv4.netfilter.ip_conntrack_max = 1743087
net.ipv4.tcp_max_orphans = 131072

net.ipv4.netfilter.ip_conntrack_generic_timeout = 300
net.ipv4.netfilter.ip_conntrack_tcp_timeout_established = 432000
net.ipv4.netfilter.ip_conntrack_icmp_timeout = 10
net.ipv4.netfilter.ip_conntrack_tcp_timeout_close = 5
net.ipv4.netfilter.ip_conntrack_tcp_timeout_syn_recv = 30
net.ipv4.netfilter.ip_conntrack_tcp_timeout_time_wait = 30
net.ipv4.netfilter.ip_conntrack_tcp_timeout_fin_wait = 20
net.ipv4.netfilter.ip_conntrack_tcp_timeout_close_wait = 20
net.ipv4.netfilter.ip_conntrack_tcp_timeout_last_ack = 30

net.ipv4.neigh.default.gc_thresh1 = 4096
net.ipv4.neigh.default.gc_thresh2 = 16384
net.ipv4.neigh.default.gc_thresh3 = 32768

net.ipv4.route.max_size = 1048576
net.ipv4.route.gc_thresh = 131072
net.ipv4.route.gc_elasticity = 4
net.ipv4.route.gc_interval = 1
net.ipv4.route.secret_interval = 3600

fs.file-max = 2097152

kernel.pid_max = 4194303

net.core.somaxconn = 640000

vm.min_free_kbytes = 65536

kernel.panic = 5

vm.swappiness = 0

What can I do to prevent such situations?

Any advice will be appreciate. :)

Thanks!

-- 
  Oleksandr Samoylyk
  OVS-RIPE
