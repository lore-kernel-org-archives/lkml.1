Return-Path: <linux-kernel-owner+w=401wt.eu-S1756664AbYA0Oyf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756664AbYA0Oyf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2008 09:54:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753559AbYA0OyZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jan 2008 09:54:25 -0500
Received: from fg-out-1718.google.com ([72.14.220.152]:21861 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753296AbYA0OyY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2008 09:54:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=qQpO/MpmqzgepwQSe799jF1V6ONG1tVeGKXkq2qKB+TLcMrKR7SqjtT6TCSYiYBTnR3a4MmAO201bcECekvaf79zMpyB7aqj/E/Pf1T0zjdl8CuAOypfKSwS472gCewfWvgsce8j6PpexPP50e4+BkFEHc6GEO4DnJKcCyqkHrc=
Date: Sun, 27 Jan 2008 15:53:45 +0100
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Matt Mackall <mpm@selenic.com>,
       Satyam Sharma <satyam.sharma@gmail.com>,
       "David S. Miller" <davem@davemloft.net>, Jeff Garzik <jeff@garzik.org>
Subject: "inconsistent lock state" (netconsole/net related)
Message-ID: <20080127145314.GA6223@joi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

My box is locking up on start of X.org so I enabled netconsole
and at every boot I'm getting:

ne2k-pci.c:v1.03 9/22/2003 D. Becker/P. Gortmaker
ACPI: PCI Interrupt 0000:00:0c.0[A] -> GSI 17 (level, low) -> IRQ 17
eth0: Compex RL2000 found at 0xb000, IRQ 17, 00:80:48:de:5e:89.
netconsole: local port 12345
netconsole: local IP 10.0.0.2
netconsole: interface eth0
netconsole: remote port 8888
netconsole: remote IP 10.0.0.1
netconsole: remote ethernet address 00:06:5b:6a:a5:74
netconsole: device eth0 not up yet, forcing it
netconsole: carrier detect appears untrustworthy, waiting 4 seconds
Switched to high resolution mode on CPU 0
console [netcon0] enabled

=================================
[ INFO: inconsistent lock state ]
2.6.24 #83
---------------------------------
inconsistent {in-softirq-W} -> {softirq-on-W} usage.
swapper/1 [HC0[0]:SC0[0]:HE1:SE1] takes:
 (_xmit_ETHER){-+..}, at: [<ffffffff8049b890>] netpoll_send_skb+0x110/0x190
{in-softirq-W} state was registered at:
  [<ffffffffffffffff>] 0xffffffffffffffff
irq event stamp: 527623
hardirqs last  enabled at (527623): [<ffffffff805250a5>] _spin_unlock_irqrestore+0x65/0x80
hardirqs last disabled at (527622): [<ffffffff80524c9d>] _spin_lock_irqsave+0x1d/0x60
softirqs last  enabled at (527618): [<ffffffff8023afb3>] __do_softirq+0xb3/0xd0
softirqs last disabled at (527609): [<ffffffff8020c6cc>] call_softirq+0x1c/0x30

other info that might help us debug this:
1 lock held by swapper/1:
 #0:  (target_list_lock){--..}, at: [<ffffffff80426c20>] write_msg+0x40/0xe0

stack backtrace:
Pid: 1, comm: swapper Not tainted 2.6.24 #83

Call Trace:
 [<ffffffff80257129>] print_usage_bug+0x189/0x190
 [<ffffffff80258001>] mark_lock+0x4d1/0x660
 [<ffffffff80258ff1>] __lock_acquire+0x701/0x10f0
 [<ffffffff805250b5>] _spin_unlock_irqrestore+0x75/0x80
 [<ffffffff8049b890>] netpoll_send_skb+0x110/0x190
 [<ffffffff80259a72>] lock_acquire+0x92/0xc0
 [<ffffffff8049b890>] netpoll_send_skb+0x110/0x190
 [<ffffffff80524de0>] _spin_trylock+0x40/0x80
 [<ffffffff8049b890>] netpoll_send_skb+0x110/0x190
 [<ffffffff8049c79a>] netpoll_send_udp+0x22a/0x2a0
 [<ffffffff80426c82>] write_msg+0xa2/0xe0
 [<ffffffff8023539e>] __call_console_drivers+0x4e/0x70
 [<ffffffff80235414>] _call_console_drivers+0x54/0x90
 [<ffffffff80235757>] release_console_sem+0x117/0x260
 [<ffffffff8023630d>] register_console+0x15d/0x2f0
 [<ffffffff80702045>] init_netconsole+0x205/0x220
 [<ffffffff806e3659>] kernel_init+0xc9/0x2b0
 [<ffffffff8052439d>] trace_hardirqs_on_thunk+0x35/0x3a
 [<ffffffff802583a9>] trace_hardirqs_on+0xd9/0x180
 [<ffffffff8020c358>] child_rip+0xa/0x12
 [<ffffffff8020bf13>] restore_args+0x0/0x30
 [<ffffffff80235699>] release_console_sem+0x59/0x260
 [<ffffffff806e3590>] kernel_init+0x0/0x2b0
 [<ffffffff8020c34e>] child_rip+0x0/0x12

netconsole: network logging started
Driver 'sd' needs updating - please use bus_type methods
Driver 'sr' needs updating - please use bus_type methods
sata_via 0000:00:0f.0: version 2.3
ACPI: PCI Interrupt 0000:00:0f.0[B] -> GSI 20 (level, low) -> IRQ 20
sata_via 0000:00:0f.0: routed to hard irq line 10
scsi0 : sata_via
scsi1 : sata_via
ata1: SATA max UDMA/133 cmd 0xd000 ctl 0xc800 bmdma 0xb800 irq 20
ata2: SATA max UDMA/133 cmd 0xc400 ctl 0xc000 bmdma 0xb808 irq 20
ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata1.00: ATA-6: WDC WD1600JD-00HBB0, 08.02D08, max UDMA/133
ata1.00: 312581808 sectors, multi 16: LBA48
(...)

I'm on latest git (326e96b92306b7af24a3608ec01156cba17a3fc1: printk: revert ktime_get() timestamps).
If you want more informations just ask.

Now I'm going to bisect lockup because netconsole didn't help...

Marcin Slusarz
