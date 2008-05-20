Return-Path: <linux-kernel-owner+w=401wt.eu-S1763823AbYETKFt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763823AbYETKFt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 06:05:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765916AbYETKBy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 06:01:54 -0400
Received: from orion.ambsoft.pl ([212.109.144.130]:40188 "EHLO
	orion.ambsoft.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765900AbYETKBu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 06:01:50 -0400
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: 2.6.26-rc2-mm1: possible circular locking dependency detected
Date: Tue, 20 May 2008 12:01:34 +0200
User-Agent: KMail/1.9.7
Cc: linux-kernel@vger.kernel.org
References: <20080514010129.4f672378.akpm@linux-foundation.org>
In-Reply-To: <20080514010129.4f672378.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805201201.34688.m.kozlowski@tuxland.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

	This lockdep warning is seen when I remove pcmcia wifi card
from the slot. Doesn't happen every time. It's x86_32.

=======================================================
[ INFO: possible circular locking dependency detected ]
2.6.26-rc2-mm1 #2
-------------------------------------------------------
pccardd/1037 is trying to acquire lock:
 (rtnl_mutex){--..}, at: [<c02870f1>] rtnl_lock+0x14/0x16

but task is already holding lock:
 (&socket->skt_mutex){--..}, at: [<c02608ba>] pccardd+0x161/0x28c

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #2 (&socket->skt_mutex){--..}:
       [<c013fff0>] __lock_acquire+0xf3b/0x103b
       [<c0140169>] lock_acquire+0x79/0x92
       [<c02cfcd5>] mutex_lock_nested+0x90/0x290
       [<c02600a6>] pccard_register_pcmcia+0x22/0x78
       [<ded5af02>] pcmcia_bus_add_socket+0x9f/0xe0 [pcmcia]
       [<c0251c02>] class_interface_register+0x83/0xb2
       [<ded6003a>] 0xded6003a
       [<c0146115>] sys_init_module+0x11e/0x18e4
       [<c0103001>] sysenter_past_esp+0x6a/0xa5
       [<ffffffff>] 0xffffffff

-> #1 (&cls->mutex){--..}:
       [<c013fff0>] __lock_acquire+0xf3b/0x103b
       [<c0140169>] lock_acquire+0x79/0x92
       [<c02cfcd5>] mutex_lock_nested+0x90/0x290
       [<c024f4a0>] device_add+0x42f/0x557
       [<c02895a1>] netdev_register_kobject+0x76/0x7b
       [<c027e3f6>] register_netdevice+0x22e/0x39a
       [<c027e599>] register_netdev+0x37/0x44
       [<c03ce7fb>] loopback_net_init+0x38/0x7d
       [<c027bb59>] register_pernet_operations+0x18/0x1a
       [<c027bbd3>] register_pernet_device+0x24/0x51
       [<c03ce7c1>] loopback_init+0x12/0x14
       [<c03b9721>] kernel_init+0x80/0x227
       [<c0103c13>] kernel_thread_helper+0x7/0x10
       [<ffffffff>] 0xffffffff

-> #0 (rtnl_mutex){--..}:
       [<c013fb8e>] __lock_acquire+0xad9/0x103b
       [<c0140169>] lock_acquire+0x79/0x92
       [<c02cfcd5>] mutex_lock_nested+0x90/0x290
       [<c02870f1>] rtnl_lock+0x14/0x16
       [<c027e04d>] unregister_netdev+0x10/0x1f
       [<ded9d11f>] orinoco_cs_detach+0x20/0x32 [orinoco_cs]
       [<ded5775a>] pcmcia_device_remove+0x3c/0xcf [pcmcia]
       [<c0250efe>] __device_release_driver+0x5e/0x84
       [<c0250fe2>] device_release_driver+0x20/0x2b
       [<c0250434>] bus_remove_device+0x73/0x8b
       [<c024ef95>] device_del+0xdb/0x14b
       [<c024f015>] device_unregister+0x10/0x1a
       [<ded5768e>] pcmcia_card_remove+0x76/0x8c [pcmcia]
       [<ded5825d>] ds_event+0x59/0x9e [pcmcia]
       [<c025ffa6>] send_event+0x7c/0xa8
       [<c02601da>] socket_remove_drivers+0x17/0x19
       [<c02601ef>] socket_shutdown+0x13/0xcc
       [<c02602d3>] socket_remove+0x2b/0x31
       [<c026098f>] pccardd+0x236/0x28c
       [<c01318bb>] kthread+0x3b/0x5d
       [<c0103c13>] kernel_thread_helper+0x7/0x10
       [<ffffffff>] 0xffffffff

other info that might help us debug this:

1 lock held by pccardd/1037:
 #0:  (&socket->skt_mutex){--..}, at: [<c02608ba>] pccardd+0x161/0x28c

stack backtrace:
Pid: 1037, comm: pccardd Not tainted 2.6.26-rc2-mm1 #2
 [<c013d8d6>] print_circular_bug_tail+0x68/0x71
 [<c013cfd5>] ? print_circular_bug_entry+0x43/0x4b
 [<c013fb8e>] __lock_acquire+0xad9/0x103b
 [<c013f42f>] ? __lock_acquire+0x37a/0x103b
 [<c013f42f>] ? __lock_acquire+0x37a/0x103b
 [<c0108587>] ? native_sched_clock+0x66/0xaf
 [<c0140169>] lock_acquire+0x79/0x92
 [<c02870f1>] ? rtnl_lock+0x14/0x16
 [<c02cfcd5>] mutex_lock_nested+0x90/0x290
 [<c02870f1>] ? rtnl_lock+0x14/0x16
 [<c02870f1>] ? rtnl_lock+0x14/0x16
 [<c02870f1>] rtnl_lock+0x14/0x16
 [<c027e04d>] unregister_netdev+0x10/0x1f
 [<ded9d11f>] orinoco_cs_detach+0x20/0x32 [orinoco_cs]
 [<ded5775a>] pcmcia_device_remove+0x3c/0xcf [pcmcia]
 [<c0250efe>] __device_release_driver+0x5e/0x84
 [<c0250fe2>] device_release_driver+0x20/0x2b
 [<c0250434>] bus_remove_device+0x73/0x8b
 [<c024ef95>] device_del+0xdb/0x14b
 [<c024f015>] device_unregister+0x10/0x1a
 [<ded5768e>] pcmcia_card_remove+0x76/0x8c [pcmcia]
 [<ded5825d>] ds_event+0x59/0x9e [pcmcia]
 [<c02601da>] ? socket_remove_drivers+0x17/0x19
 [<c025ffa6>] send_event+0x7c/0xa8
 [<c02601da>] socket_remove_drivers+0x17/0x19
 [<c02601ef>] socket_shutdown+0x13/0xcc
 [<c0120d15>] ? printk+0x20/0x22
 [<c02602d3>] socket_remove+0x2b/0x31
 [<c026098f>] pccardd+0x236/0x28c
 [<c02cf0e8>] ? schedule+0x2c4/0x46f
 [<c011b3eb>] ? sub_preempt_count+0x76/0xbd
 [<c011b15f>] ? default_wake_function+0x0/0x12
 [<c0260759>] ? pccardd+0x0/0x28c
 [<c01318bb>] kthread+0x3b/0x5d
 [<c0131880>] ? kthread+0x0/0x5d
 [<c0103c13>] kernel_thread_helper+0x7/0x10
 =======================
