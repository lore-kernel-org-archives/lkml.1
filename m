Return-Path: <linux-kernel-owner+w=401wt.eu-S1756606AbYGASjp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756606AbYGASjp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 14:39:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752758AbYGASjg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 14:39:36 -0400
Received: from dauphin.brewtab.com ([208.86.224.67]:60423 "EHLO
	mail.brewtab.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752623AbYGASje (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 14:39:34 -0400
X-Greylist: delayed 706 seconds by postgrey-1.27 at vger.kernel.org; Tue, 01 Jul 2008 14:39:34 EDT
Message-ID: <486A771D.3060708@brewtab.com>
Date: Tue, 01 Jul 2008 14:27:41 -0400
From: Christopher Thunes <c2thunes@brewtab.com>
User-Agent: Mozilla-Thunderbird 2.0.0.14 (X11/20080509)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: BUG on call to pskb_expand_head in skbuff.c 
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,
   We're running Xen and have been hitting this kernel bug for the past 
couple weeks which has been causing complete system crashes. Here is the 
initial traceback.

Kernel BUG at ...ib/xen-3.2.1/linux-2.6.18-xen.hg/net/core/skbuff.c:695
invalid opcode: 0000 [1] SMP
CPU 3
Modules linked in: xt_mac tun arptable_filter arp_tables xt_physdev
iptable_filter ip_tables x_tables bridge ipv6 button ac battery nfs
lockd nfs_acl sunrpc sg sr_mod parport_pc parport floppy serio_raw
pcspkr i2c_i801 i2c_core joydev ext3 jbd dm_mirror dm_snapshot dm_mod
sd_mod ide_cd cdrom usbhid usb_storage aacraid ehci_hcd e1000 piix
scsi_mod uhci_hcd usbcore thermal processor fan
Pid: 9699, comm: qemu-dm Tainted: GF     2.6.18.8-xen #1
RIP: e030:[<ffffffff803948e5>]  [<ffffffff803948e5>]
pskb_expand_head+0x2a/0x138RSP: e02b:ffff880007d0fc08  EFLAGS:
00010202
RAX: 0000000000000001 RBX: ffff880019b6c0c0 RCX: ffff880078365000
RDX: 0000000000000134 RSI: 0000000000000020 RDI: ffff880078365100
RBP: ffff88007f10e000 R08: ffff880078365012 R09: 0000000000000194
R10: ffff88007f10e000 R11: ffffffff8039b349 R12: 0000000000000000
R13: ffff8800789f7e04 R14: 0000000000000002 R15: 0000000000000178
FS:  00002ba5be9835f0(0000) GS:ffffffff804d7180(0000) knlGS:0000000000000000
CS:  e033 DS: 0000 ES: 0000
Process qemu-dm (pid: 9699, threadinfo ffff880048626000, task 
ffff880001239080)
Stack:  ffff8800789f7dc0 ffff880019b6c0c0 ffff88007f10e000 ffff880019b6c0c0
  ffff8800789f7e04 ffffffff80394a4b 0000000000000178 ffff880019b6c0c0
  ffff88007f10e000 ffff880019b6c0c0 ffff8800789f7e04 0000000000000002
Call Trace:
  <IRQ> [<ffffffff80394a4b>] __pskb_pull_tail+0x58/0x26e
  [<ffffffff8039b4a3>] dev_queue_xmit+0x15a/0x313
  [<ffffffff8039e9e2>] neigh_update+0x304/0x3d9
  [<ffffffff803a7ccd>] eth_header_cache_update+0x0/0x12
  [<ffffffff803d6cc8>] arp_process+0x579/0x5c2
  [<ffffffff803d674f>] arp_process+0x0/0x5c2
  [<ffffffff803b0b22>] nf_hook_slow+0x58/0xc4
  [<ffffffff803d674f>] arp_process+0x0/0x5c2
  [<ffffffff803d6e17>] arp_rcv+0x106/0x129
  [<ffffffff80398d95>] netif_receive_skb+0x0/0x2eb
  [<ffffffff80398ffb>] netif_receive_skb+0x266/0x2eb
  [<ffffffff88247950>] :bridge:br_pass_frame_up+0x67/0x69
  [<ffffffff88247a18>] :bridge:br_handle_frame_finish+0xc6/0xf8
  [<ffffffff88247bd2>] :bridge:br_handle_frame+0x188/0x1a6
  [<ffffffff80398f5f>] netif_receive_skb+0x1ca/0x2eb
  [<ffffffff8039af67>] process_backlog+0xd0/0x182
  [<ffffffff8039b1e2>] net_rx_action+0xe3/0x24a
  [<ffffffff802356ec>] __do_softirq+0x83/0x117
  [<ffffffff8020b1ac>] call_softirq+0x1c/0x28
  <EOI> [<ffffffff8020d01f>] do_softirq+0x6a/0xeb
  [<ffffffff8039936e>] netif_rx_ni+0x19/0x1d
  [<ffffffff882702b8>] :tun:tun_chr_writev+0x1d0/0x204
  [<ffffffff88270306>] :tun:tun_chr_write+0x1a/0x1f
  [<ffffffff802803f7>] vfs_write+0xce/0x174
  [<ffffffff802809b5>] sys_write+0x45/0x6e
  [<ffffffff8020a4fc>] system_call+0x68/0x6d
  [<ffffffff8020a494>] system_call+0x0/0x6d

I've already posted this to xen-devel and Keir Fraser has already told 
me that this is unrelated to any Xen modifications so I thought I'd try 
here. We have seen this same traceback on two identical hardware systems 
with the following configurations

    - Supermicro 6025B-TR Barebones
    - Supermicro X7DBE+ Motherboard
    - Adaptec 3405 RAID Card
    - Integrated Intel Corporation 631xESB/632xESB DPT NIC

The host systems are running Debian 4.0 Etch amd64 with a stock Xen 
kernel pulled from http://xenbits.xensource.com/ and compiled with the 
default configuration. Here is lspci output

00:00.0 Host bridge: Intel Corporation 5000P Chipset Memory Controller 
Hub (rev b1)
00:02.0 PCI bridge: Intel Corporation 5000 Series Chipset PCI Express x8 
Port 2-3 (rev b1)
00:04.0 PCI bridge: Intel Corporation 5000 Series Chipset PCI Express x8 
Port 4-5 (rev b1)
00:06.0 PCI bridge: Intel Corporation 5000 Series Chipset PCI Express x8 
Port 6-7 (rev b1)
00:08.0 System peripheral: Intel Corporation 5000 Series Chipset DMA 
Engine (rev b1)
00:10.0 Host bridge: Intel Corporation 5000 Series Chipset Error 
Reporting Registers (rev b1)
00:10.1 Host bridge: Intel Corporation 5000 Series Chipset Error 
Reporting Registers (rev b1)
00:10.2 Host bridge: Intel Corporation 5000 Series Chipset Error 
Reporting Registers (rev b1)
00:11.0 Host bridge: Intel Corporation 5000 Series Chipset Reserved 
Registers (rev b1)
00:13.0 Host bridge: Intel Corporation 5000 Series Chipset Reserved 
Registers (rev b1)
00:15.0 Host bridge: Intel Corporation 5000 Series Chipset FBD Registers 
(rev b1)
00:16.0 Host bridge: Intel Corporation 5000 Series Chipset FBD Registers 
(rev b1)
00:1c.0 PCI bridge: Intel Corporation 631xESB/632xESB/3100 Chipset PCI 
Express Root Port 1 (rev 09)
00:1d.0 USB Controller: Intel Corporation 631xESB/632xESB/3100 Chipset 
UHCI USB Controller #1 (rev 09)
00:1d.1 USB Controller: Intel Corporation 631xESB/632xESB/3100 Chipset 
UHCI USB Controller #2 (rev 09)
00:1d.2 USB Controller: Intel Corporation 631xESB/632xESB/3100 Chipset 
UHCI USB Controller #3 (rev 09)
00:1d.7 USB Controller: Intel Corporation 631xESB/632xESB/3100 Chipset 
EHCI USB2 Controller (rev 09)
00:1e.0 PCI bridge: Intel Corporation 82801 PCI Bridge (rev d9)
00:1f.0 ISA bridge: Intel Corporation 631xESB/632xESB/3100 Chipset LPC 
Interface Controller (rev 09)
00:1f.1 IDE interface: Intel Corporation 631xESB/632xESB IDE Controller 
(rev 09)
00:1f.3 SMBus: Intel Corporation 631xESB/632xESB/3100 Chipset SMBus 
Controller (rev 09)
01:00.0 PCI bridge: Intel Corporation 6311ESB/6321ESB PCI Express 
Upstream Port (rev 01)
01:00.3 PCI bridge: Intel Corporation 6311ESB/6321ESB PCI Express to 
PCI-X Bridge (rev 01)
02:00.0 PCI bridge: Intel Corporation 6311ESB/6321ESB PCI Express 
Downstream Port E1 (rev 01)
02:02.0 PCI bridge: Intel Corporation 6311ESB/6321ESB PCI Express 
Downstream Port E3 (rev 01)
03:00.0 PCI bridge: Intel Corporation 6700PXH PCI Express-to-PCI Bridge 
A (rev 09)
03:00.2 PCI bridge: Intel Corporation 6700PXH PCI Express-to-PCI Bridge 
B (rev 09)
06:00.0 Ethernet controller: Intel Corporation 631xESB/632xESB DPT LAN 
Controller Copper (rev 01)
06:00.1 Ethernet controller: Intel Corporation 631xESB/632xESB DPT LAN 
Controller Copper (rev 01)
09:00.0 PCI bridge: Intel Corporation 80333 Segment-A PCI Express-to-PCI 
Express Bridge
09:00.2 PCI bridge: Intel Corporation 80333 Segment-B PCI Express-to-PCI 
Express Bridge
0a:0e.0 RAID bus controller: Adaptec AAC-RAID
0d:01.0 VGA compatible controller: ATI Technologies Inc ES1000 (rev 02)


And kernel version

Linux version 2.6.18.8-xen (xxxx) (gcc version 4.1.2 20061115 
(prerelease) (Debian 4.1.1-21)) #1 SMP Wed Apr 30 14:27:56 EDT 2008

The system is crashing at line 695 in core/net/skbuff.c (Xen source tree 
anyway). After getting a couple of these crashes we replaced the code in 
skbuff.c in pskb_expand_head

	if (skb_shared(skb))
		BUG();

to instead read

	if (skb_shared(skb)) {
		printk(KERN_INFO "skb_shared BUG problem detected\n");
		printk(KERN_INFO "  skb->users: %d\n", 	atomic_read(&skb->users));
		printk(KERN_INFO "  skb->dev: %s\n", skb->dev->name);
		printk(KERN_INFO "  skb->fclone: %d\n", skb->fclone);
	}

We also went ahead and cleared out all iptables and arptables rules, 
made sure that iptables and arptables modules wouldn't load again and 
restarted the system. After doing this the bug was triggered within a 
day while under normal load and network activity. In dmesg output we got 
this from the debugging code above

	skb_shared BUG problem detected
	   skb->users: 2
	   skb->dev: br0
	   skb->fclone: 0

My initial suspicion was that it was somehow related to arptables given 
the initial traceback but given that it was reproduced without iptables 
and arptables modules loaded makes me now think otherwise. The network 
setup for this system consists of Xen guests with their interfaces all 
bridged on br0. IP forwarding is enabled and traffic is routed between 
the bridge device and the external network on eth1.

At the moment we have not been able to trigger this bug at will so we 
don't have any way to test this on a newer kernel. If there is any more 
information that you think I may be able to provide I would be happy to 
provide all and any information possible. Here is the thread on 
xen-devel for reference

http://article.gmane.org/gmane.comp.emulators.xen.devel/52881

If anyone has any ideas or suggestions I'd really appreciate insight 
into this issue.

Much Thanks,
Christopher Thunes

