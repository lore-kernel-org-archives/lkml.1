Return-Path: <linux-kernel-owner+w=401wt.eu-S1756902AbYDALq4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756902AbYDALq4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 07:46:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756894AbYDALqt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 07:46:49 -0400
Received: from s131.mittwaldmedien.de ([62.216.178.31]:20578 "EHLO
	s131.mittwaldmedien.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756575AbYDALqr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 07:46:47 -0400
X-Greylist: delayed 1968 seconds by postgrey-1.27 at vger.kernel.org; Tue, 01 Apr 2008 07:46:47 EDT
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: linux-kernel@vger.kernel.org
Subject: BUG: spinlock tryout failure (in netconsole?)
Date: Tue, 1 Apr 2008 13:11:03 +0200
User-Agent: KMail/1.9.7
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804011311.03219.hs4233@mail.mn-solutions.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This happend with the wireless-testing tree.

$ git-describe
v2.6.25-rc7-3570-g78f8e64

Netconsole was loaded with

$ modprobe netconsole netconsole="5555@/eth0,5555@192.168.233.66/00:1D:60:14:33:2B"

The routing was in a way that the netconsole packets would have
to go via the ethernet device, not via wlan interface. The ARP
entry for the mac address above also says eth0:

$ arp -n
Address                  HWtype  HWaddress           Flags Mask            Iface
192.168.233.1            ether   00:0C:6E:49:9B:27   C                     eth0
192.168.233.66           ether   00:1D:60:14:33:2B   C                     eth0


Apr  1 11:05:39 laptop kernel: libertas_cs enter (INT): if_cs_interrupt()
Apr  1 11:05:39 laptop kernel: BUG: spinlock trylock failure on UP on CPU#0, syslogd/1277
Apr  1 11:05:39 laptop kernel:  lock: f7c8a1d0, .magic: dead4ead, .owner: syslogd/1277, .owner_cpu: 0
Apr  1 11:05:39 laptop kernel: Pid: 1277, comm: syslogd Not tainted 2.6.25-rc7-wl #25
Apr  1 11:05:39 laptop kernel:  [<c01d2061>] spin_bug+0x76/0xb1
Apr  1 11:05:39 laptop kernel:  [<c01d20d2>] _raw_spin_trylock+0x36/0x3b
Apr  1 11:05:39 laptop kernel:  [<c0312a78>] _spin_trylock+0x17/0x5b
Apr  1 11:05:39 laptop kernel:  [<c02c57e3>] netpoll_send_skb+0x85/0x14c
Apr  1 11:05:39 laptop kernel:  [<c02c641c>] netpoll_send_udp+0x252/0x25a
Apr  1 11:05:39 laptop kernel:  [<f890d0d7>] write_msg+0x67/0x94 [netconsole]
Apr  1 11:05:39 laptop kernel:  [<f890d070>] ? write_msg+0x0/0x94 [netconsole]
Apr  1 11:05:39 laptop kernel:  [<c0118676>] __call_console_drivers+0x3b/0x48
Apr  1 11:05:39 laptop kernel:  [<c01186da>] _call_console_drivers+0x57/0x5b
Apr  1 11:05:39 laptop kernel:  [<c0118a53>] release_console_sem+0x11b/0x1b7
Apr  1 11:05:39 laptop kernel:  [<c0118f3a>] vprintk+0x263/0x29a
Apr  1 11:05:39 laptop kernel:  [<c0118f86>] printk+0x15/0x17
Apr  1 11:05:39 laptop kernel:  [<f88f8d5e>] if_cs_interrupt+0x63/0x4f9 [libertas_cs]
Apr  1 11:05:39 laptop kernel:  [<c0139dc0>] handle_IRQ_event+0x1a/0x46
Apr  1 11:05:39 laptop kernel:  [<c013b011>] handle_level_irq+0x6f/0xba
Apr  1 11:05:39 laptop kernel:  [<c0105a96>] do_IRQ+0x53/0x6d
Apr  1 11:05:39 laptop kernel:  [<c0104316>] common_interrupt+0x2e/0x34
Apr  1 11:05:39 laptop kernel:  [<c0130000>] ? get_usage_chars+0x78/0x7d
Apr  1 11:05:39 laptop kernel:  [<c0312c49>] ? _spin_unlock_irqrestore+0x38/0x51
Apr  1 11:05:39 laptop kernel:  [<c023a43e>] rtl8139_start_xmit+0xe9/0x10f
Apr  1 11:05:39 laptop kernel:  [<c02ba9a3>] dev_hard_start_xmit+0x16f/0x1dc
Apr  1 11:05:39 laptop kernel:  [<c02c7612>] __qdisc_run+0x7a/0x14e
Apr  1 11:05:39 laptop kernel:  [<c02bcd84>] dev_queue_xmit+0x119/0x23d
Apr  1 11:05:39 laptop kernel:  [<c02d1fb8>] ip_finish_output+0x1d1/0x20c
Apr  1 11:05:39 laptop kernel:  [<c02d29bd>] ip_output+0x56/0x5a
Apr  1 11:05:39 laptop kernel:  [<c02d0bc4>] ip_local_out+0x18/0x1b
Apr  1 11:05:39 laptop kernel:  [<c02d0e20>] ip_push_pending_frames+0x259/0x2c9
Apr  1 11:05:39 laptop kernel:  [<c02e8184>] udp_push_pending_frames+0x2b2/0x345
Apr  1 11:05:39 laptop kernel:  [<c02e9071>] udp_sendmsg+0x416/0x51a
Apr  1 11:05:39 laptop kernel:  [<c02edd6a>] inet_sendmsg+0x3b/0x48
Apr  1 11:05:39 laptop kernel:  [<c02b163f>] sock_sendmsg+0xc9/0xe0
Apr  1 11:05:39 laptop kernel:  [<c0127775>] ? autoremove_wake_function+0x0/0x33
Apr  1 11:05:39 laptop kernel:  [<c01cf5c2>] ? copy_from_user+0x3b/0x5e
Apr  1 11:05:39 laptop kernel:  [<c02b18a4>] sys_sendto+0xa4/0xc3
Apr  1 11:05:39 laptop kernel:  [<c017e8fb>] ? dnotify_parent+0x57/0x5c
Apr  1 11:05:39 laptop kernel:  [<c01563a6>] ? do_readv_writev+0x132/0x140
Apr  1 11:05:39 laptop kernel:  [<c02b2409>] sys_socketcall+0xde/0x166
Apr  1 11:05:39 laptop kernel:  [<c010387e>] sysenter_past_esp+0x5f/0xa5
Apr  1 11:05:39 laptop kernel:  =======================
Apr  1 11:05:39 laptop kernel: libertas_cs cs (INT): int_cause 0x0002
