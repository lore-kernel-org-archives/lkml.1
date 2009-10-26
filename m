Return-Path: <linux-kernel-owner+w=401wt.eu-S1754885AbZJZTvK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754885AbZJZTvK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 15:51:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753910AbZJZTvK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 15:51:10 -0400
Received: from gw1.cosmosbay.com ([212.99.114.194]:51075 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752217AbZJZTvI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 15:51:08 -0400
Message-ID: <4AE5FD84.8070906@gmail.com>
Date: Mon, 26 Oct 2009 20:50:28 +0100
From: Eric Dumazet <eric.dumazet@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Massimo Cetra <mcetra@navynet.it>
Subject: Re: [Bug #14378] Problems with net/core/skbuff.c
References: <Sj-rRjx6TwF.A.djE.vqe5KB@chimera> <6dRYo8ss7vL.A.B9G.nre5KB@chimera>
In-Reply-To: <6dRYo8ss7vL.A.B9G.nre5KB@chimera>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Mon, 26 Oct 2009 20:50:30 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki a écrit :
> This message has been generated automatically as a part of a report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.31.  Please verify if it still should be listed and let me know
> (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14378
> Subject		: Problems with net/core/skbuff.c
> Submitter	: Massimo Cetra <mcetra@navynet.it>
> Date		: 2009-10-08 14:51 (19 days old)
> References	: http://marc.info/?l=linux-kernel&m=125501488220358&w=4
> 
> 

This was corrected by commit ed79bab847d8e5a2986d8ff43c49c6fb8ee3265f

virtio_net: use dev_kfree_skb_any() in free_old_xmit_skbs()

Because netpoll can call netdevice start_xmit() method with
irqs disabled, drivers should not call kfree_skb() from
their start_xmit(), but use dev_kfree_skb_any() instead.

Oct  8 11:16:52 172.30.1.31 [113074.791813] ------------[ cut here ]------------
Oct  8 11:16:52 172.30.1.31 [113074.791813] WARNING: at net/core/skbuff.c:398 \
                skb_release_head_state+0x64/0xc8()
Oct  8 11:16:52 172.30.1.31 [113074.791813] Hardware name:
Oct  8 11:16:52 172.30.1.31 [113074.791813] Modules linked in: netconsole ocfs2 jbd2 quota_tree \
ocfs2_dlmfs ocfs2_stack_o2cb ocfs2_dlm ocfs2_nodemanager ocfs2_stackglue configfs crc32c drbd cn loop \
serio_raw psmouse snd_pcm snd_timer snd soundcore snd_page_alloc virtio_net pcspkr parport_pc parport \
i2c_piix4 i2c_core button processor evdev ext3 jbd mbcache dm_mirror dm_region_hash dm_log dm_snapshot \
dm_mod ide_cd_mod cdrom ata_generic ata_piix virtio_blk libata scsi_mod piix ide_pci_generic ide_core \
                virtio_pci virtio_ring virtio floppy thermal fan thermal_sys [last unloaded: netconsole]
Oct  8 11:16:52 172.30.1.31 [113074.791813] Pid: 11132, comm: php5-cgi Tainted: G        W  \
                2.6.31.2-vserver #1
Oct  8 11:16:52 172.30.1.31 [113074.791813] Call Trace:
Oct  8 11:16:52 172.30.1.31 [113074.791813] <IRQ>  [<ffffffff81253cd5>] ? \
                skb_release_head_state+0x64/0xc8
Oct  8 11:16:52 172.30.1.31 [113074.791813] [<ffffffff81253cd5>] ? skb_release_head_state+0x64/0xc8
Oct  8 11:16:52 172.30.1.31 [113074.791813] [<ffffffff81049ae1>] ? warn_slowpath_common+0x77/0xa3
Oct  8 11:16:52 172.30.1.31 [113074.791813] [<ffffffff81253cd5>] ? skb_release_head_state+0x64/0xc8
Oct  8 11:16:52 172.30.1.31 [113074.791813] [<ffffffff81253a1a>] ? __kfree_skb+0x9/0x7d
Oct  8 11:16:52 172.30.1.31 [113074.791813] [<ffffffffa01cb139>] ? free_old_xmit_skbs+0x51/0x6e \
                [virtio_net]
Oct  8 11:16:52 172.30.1.31 [113074.791813] [<ffffffffa01cbc85>] ? start_xmit+0x26/0xf2 [virtio_net]
Oct  8 11:16:52 172.30.1.31 [113074.791813] [<ffffffff8126934f>] ? netpoll_send_skb+0xd2/0x205
Oct  8 11:16:52 172.30.1.31 [113074.791813] [<ffffffffa0429216>] ? write_msg+0x90/0xeb [netconsole]
Oct  8 11:16:52 172.30.1.31 [113074.791813] [<ffffffff81049f06>] ? __call_console_drivers+0x5e/0x6f
Oct  8 11:16:52 172.30.1.31 [113074.791813] [<ffffffff8102b49d>] ? kvm_clock_read+0x4d/0x52
Oct  8 11:16:52 172.30.1.31 [113074.791813] [<ffffffff8104a082>] ? release_console_sem+0x115/0x1ba
Oct  8 11:16:52 172.30.1.31 [113074.791813] [<ffffffff8104a632>] ? vprintk+0x2f2/0x34b
Oct  8 11:16:52 172.30.1.31 [113074.791813] [<ffffffff8106b142>] ? vx_update_load+0x18/0x13e
Oct  8 11:16:52 172.30.1.31 [113074.791813] [<ffffffff81308309>] ? printk+0x4e/0x5d
Oct  8 11:16:52 172.30.1.31 [113074.791813] [<ffffffff8102b49d>] ? kvm_clock_read+0x4d/0x52
Oct  8 11:16:52 172.30.1.31 [113074.791813] [<ffffffff81070b62>] ? getnstimeofday+0x55/0xaf
Oct  8 11:16:52 172.30.1.31 [113074.791813] [<ffffffff81062683>] ? ktime_get_ts+0x21/0x49
Oct  8 11:16:52 172.30.1.31 [113074.791813] [<ffffffff810626b7>] ? ktime_get+0xc/0x41
Oct  8 11:16:52 172.30.1.31 [113074.791813] [<ffffffff81062788>] ? hrtimer_interrupt+0x9c/0x146
Oct  8 11:16:52 172.30.1.31 [113074.791813] [<ffffffff81024a4b>] ? smp_apic_timer_interrupt+0x80/0x93
Oct  8 11:16:52 172.30.1.31 [113074.791813] [<ffffffff81011663>] ? apic_timer_interrupt+0x13/0x20
Oct  8 11:16:52 172.30.1.31 [113074.791813] <EOI>  [<ffffffff8130a9eb>] ? _spin_unlock_irq+0xd/0x31

Reported-and-tested-by: Massimo Cetra <mcetra@navynet.it>
Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
Bug-Entry: http://bugzilla.kernel.org/show_bug.cgi?id=14378
Signed-off-by: David S. Miller <davem@davemloft.net>

