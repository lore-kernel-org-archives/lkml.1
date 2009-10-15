Return-Path: <linux-kernel-owner+w=401wt.eu-S1762253AbZJOAh6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762253AbZJOAh6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 20:37:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758513AbZJOAh5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 20:37:57 -0400
Received: from gw1.cosmosbay.com ([212.99.114.194]:60504 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754660AbZJOAh4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 20:37:56 -0400
Message-ID: <4AD66E9B.2020803@gmail.com>
Date: Thu, 15 Oct 2009 02:36:43 +0200
From: Eric Dumazet <eric.dumazet@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Massimo Cetra <mcetra@navynet.it>
CC: Massimo Cetra <ctrixk@navynet.it>, David Miller <davem@davemloft.net>,
       rjw@sisk.pl, linux-kernel@vger.kernel.org,
       kernel-testers@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH] virtio_net: use dev_kfree_skb_any() in free_old_xmit_skbs()
References: <zJ_pXHNwoHC.A.akB.Aal0KB@chimera>	<r-4Wjt4coy.A.CwC.Wal0KB@chimera> <20091012.034224.64980795.davem@davemloft.net> <4AD44435.3050703@navynet.it> <4AD45447.7030705@gmail.com> <4AD455E4.2070105@navynet.it> <4AD62626.6010709@navynet.it>
In-Reply-To: <4AD62626.6010709@navynet.it>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Thu, 15 Oct 2009 02:36:45 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Massimo Cetra a écrit :
> Eric,
> thanks for the patch.
> The problem didn't arise again and i haven't seen any warning like that
> on both servers where that problem was happening more frequently.
> 
> I would say that it's fixed and if it's not, i'll let you know as soon
> as it happens again.
> 

Thanks Massimo, I think patch is reasonably safe and should be taken as is :


[PATCH] virtio_net: use dev_kfree_skb_any() in free_old_xmit_skbs()

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
---

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 8d00976..54bf091 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -454,7 +454,7 @@ static unsigned int free_old_xmit_skbs(struct virtnet_info *vi)
 		vi->dev->stats.tx_bytes += skb->len;
 		vi->dev->stats.tx_packets++;
 		tot_sgs += skb_vnet_hdr(skb)->num_sg;
-		kfree_skb(skb);
+		dev_kfree_skb_any(skb);
 	}
 	return tot_sgs;
 }

