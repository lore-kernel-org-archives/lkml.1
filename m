Return-Path: <linux-kernel-owner+w=401wt.eu-S1755433AbZDVS7F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755433AbZDVS7F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 14:59:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753023AbZDVS6x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 14:58:53 -0400
Received: from smtp.opengridcomputing.com ([209.198.142.2]:35071 "EHLO
	smtp.opengridcomputing.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752194AbZDVS6x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 14:58:53 -0400
Message-ID: <49EF6929.9020600@opengridcomputing.com>
Date: Wed, 22 Apr 2009 13:59:53 -0500
From: Steve Wise <swise@opengridcomputing.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: balbir@linux.vnet.ibm.com, Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Wolfram Strepp <wstrepp@gmx.de>
Subject: Re: [BUG] rbtree bug with mmotm 2009-04-14-17-24
References: <20090421184223.GP19637@balbir.in.ibm.com> <49EE42CC.7070002@opengridcomputing.com> <20090422131703.GO4593@kernel.dk> <49EF2882.1020306@opengridcomputing.com> <49EF293F.4030504@opengridcomputing.com> <49EF2C32.4030409@opengridcomputing.com> <20090422163032.GV4593@kernel.dk> <20090422163705.GW4593@kernel.dk> <49EF5F31.30408@opengridcomputing.com> <20090422183406.GA4593@kernel.dk>
In-Reply-To: <20090422183406.GA4593@kernel.dk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Odd... Can you try this variant?
>
> diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
> index 7e13f04..3a97c18 100644
> --- a/block/cfq-iosched.c
> +++ b/block/cfq-iosched.c
> @@ -154,6 +154,7 @@ struct cfq_queue {
>  	unsigned long rb_key;
>  	/* prio tree member */
>  	struct rb_node p_node;
> +	struct rb_root *p_root;
>  	/* sorted list of pending requests */
>  	struct rb_root sort_list;
>  	/* if fifo isn't expired, next request to serve */
> @@ -594,22 +595,25 @@ cfq_prio_tree_lookup(struct cfq_data *cfqd, int ioprio, sector_t sector,
>  
>  static void cfq_prio_tree_add(struct cfq_data *cfqd, struct cfq_queue *cfqq)
>  {
> -	struct rb_root *root = &cfqd->prio_trees[cfqq->ioprio];
> +	struct rb_root *root = &cfqd->prio_trees[cfqq->org_ioprio];
>  	struct rb_node **p, *parent;
>  	struct cfq_queue *__cfqq;
>  
> -	if (!RB_EMPTY_NODE(&cfqq->p_node))
> -		rb_erase_init(&cfqq->p_node, root);
> +	if (cfqq->p_root) {
> +		rb_erase_init(&cfqq->p_node, cfqq->p_root);
> +		cfqq->p_root = NULL;
> +	}
>  
>  	if (cfq_class_idle(cfqq))
>  		return;
>  	if (!cfqq->next_rq)
>  		return;
>  
> -	__cfqq = cfq_prio_tree_lookup(cfqd, cfqq->ioprio, cfqq->next_rq->sector,
> -					 &parent, &p);
> +	__cfqq = cfq_prio_tree_lookup(cfqd, cfqq->org_ioprio,
> +					cfqq->next_rq->sector, &parent, &p);
>  	BUG_ON(__cfqq);
>  
> +	cfqq->p_root = root;
>  	rb_link_node(&cfqq->p_node, parent, p);
>  	rb_insert_color(&cfqq->p_node, root);
>  }
> @@ -656,8 +660,10 @@ static void cfq_del_cfqq_rr(struct cfq_data *cfqd, struct cfq_queue *cfqq)
>  
>  	if (!RB_EMPTY_NODE(&cfqq->rb_node))
>  		cfq_rb_erase(&cfqq->rb_node, &cfqd->service_tree);
> -	if (!RB_EMPTY_NODE(&cfqq->p_node))
> -		rb_erase_init(&cfqq->p_node, &cfqd->prio_trees[cfqq->ioprio]);
> +	if (cfqq->p_root) {
> +		rb_erase_init(&cfqq->p_node, cfqq->p_root);
> +		cfqq->p_root = NULL;
> +	}
>  
>  	BUG_ON(!cfqd->busy_queues);
>  	cfqd->busy_queues--;
> @@ -976,7 +982,7 @@ static struct cfq_queue *cfqq_close(struct cfq_data *cfqd,
>  	 * First, if we find a request starting at the end of the last
>  	 * request, choose it.
>  	 */
> -	__cfqq = cfq_prio_tree_lookup(cfqd, cur_cfqq->ioprio,
> +	__cfqq = cfq_prio_tree_lookup(cfqd, cur_cfqq->org_ioprio,
>  				      sector, &parent, NULL);
>  	if (__cfqq)
>  		return __cfqq;
>
>   

Still crashes with this variant:

Starting udev: BUG: unable to handle kernel NULL pointer dereference at 
0000000000000010
IP: [<ffffffff8034ee7b>] rb_erase+0x1ee/0x2a7
PGD 12e539067 PUD 12d506067 PMD 0
Oops: 0000 [#1] SMP
last sysfs file: /sys/block/sda/sda8/dev
CPU 0
Modules linked in: snd_hda_codec_intelhdmi snd_hda_codec_realtek 
snd_hda_intel snd_hda_codec snd_seq_dummy snd_seq_oss snd_seq_midi_event 
snd_seq snd_seq_device snd_pcm_oss snd_mixer_oss snd_pcm sg cxgb3 
rtc_cmos snd_timer snd soundcore shpchp r8169 mii snd_page_alloc floppy 
rtc_core sr_mod i2c_i801 rtc_lib cdrom serio_raw button i2c_core pcspkr 
dm_snapshot dm_zero dm_mirror dm_region_hash dm_log dm_mod ata_piix 
libata sd_mod scsi_mod ext3 jbd uhci_hcd ohci_hcd ehci_hcd
Pid: 2379, comm: vol_id Not tainted 2.6.30-rc2-jens2 #12 P5E-VM HDMI
RIP: 0010:[<ffffffff8034ee7b>]  [<ffffffff8034ee7b>] rb_erase+0x1ee/0x2a7
RSP: 0018:ffff88012b9777f8  EFLAGS: 00010082
RAX: 0000000000000000 RBX: ffff88012acedde0 RCX: ffff88012cd8d7f8
RDX: 0000000000000000 RSI: ffff88012fb8aa30 RDI: 0000000000000000
RBP: ffff88012b977808 R08: 0000000000000000 R09: ffff88012d4f2b28
R10: ffff88012fb8b740 R11: ffff88012f054680 R12: ffff88012fb8aa30
R13: ffff88012fb8aa00 R14: ffff88012acedf00 R15: 0000000000000000
FS:  00000000006e3880(0063) GS:ffff88002804b000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000010 CR3: 000000012c512000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process vol_id (pid: 2379, threadinfo ffff88012b976000, task 
ffff88012dd2ce20)
Stack:
 ffff88012acedf30 ffff88012d4f2b28 ffff88012b977828 ffffffff8034690d
 ffff88012b977828 ffff88012acedf00 ffff88012b977868 ffffffff8034787d
 ffff88012fb8aa00 ffff88012acedf00 ffff88012d4f2b28 ffff88012fb8aa00
Call Trace:
 [<ffffffff8034690d>] rb_erase_init+0x11/0x21
 [<ffffffff8034787d>] cfq_remove_request+0x174/0x1de
 [<ffffffff80347933>] cfq_dispatch_insert+0x4c/0x70
 [<ffffffff803485c4>] cfq_dispatch_requests+0x301/0x417
 [<ffffffff8033b344>] elv_next_request+0x193/0x1a8
 [<ffffffff8034c199>] ? kobject_get+0x1a/0x22
 [<ffffffffa005fe52>] scsi_request_fn+0x7a/0x496 [scsi_mod]
 [<ffffffff8033d720>] blk_start_queueing+0x1a/0x23
 [<ffffffff80347cca>] cfq_insert_request+0x244/0x38c
 [<ffffffff8033b46a>] elv_insert+0x111/0x1bd
 [<ffffffff8033b5ac>] __elv_add_request+0x96/0x9e
 [<ffffffff8033e306>] __make_request+0x3c2/0x400
 [<ffffffff8033ca9b>] generic_make_request+0x27f/0x319
 [<ffffffff802cd91e>] ? bio_init+0x18/0x32
 [<ffffffff8033df3b>] submit_bio+0xb4/0xbd
 [<ffffffff802c9970>] submit_bh+0xe5/0x109
 [<ffffffff802cc659>] block_read_full_page+0x261/0x27f
 [<ffffffff802cfd5e>] ? blkdev_get_block+0x0/0x4e
 [<ffffffff802cefc3>] blkdev_readpage+0x13/0x15
 [<ffffffff80285329>] __do_page_cache_readahead+0x134/0x16c
 [<ffffffff8028552d>] ondemand_readahead+0x143/0x155
 [<ffffffff802855d7>] page_cache_sync_readahead+0x17/0x19
 [<ffffffff8027ecac>] generic_file_aio_read+0x245/0x594
 [<ffffffff802abff4>] do_sync_read+0xe2/0x126
 [<ffffffff8028f553>] ? __do_fault+0x362/0x3ac
 [<ffffffff8024c30c>] ? autoremove_wake_function+0x0/0x38
 [<ffffffff8029104c>] ? handle_mm_fault+0x1d9/0x6d1
 [<ffffffff8031a144>] ? security_file_permission+0x11/0x13
 [<ffffffff802ac748>] vfs_read+0xab/0x134
 [<ffffffff802acae9>] sys_read+0x47/0x70
 [<ffffffff8020ba2b>] system_call_fastpath+0x16/0x1b
Code: e8 d3 fb ff ff e9 86 00 00 00 48 8b 07 a8 01 75 1a 48 83 c8 01 4c 
89 e6 48 89 07 48 83 23 fe 48 89 df e8 11 fc ff ff 48 8b 7b 10 <48> 8b 
57 10 48 85 d2 74 05 f6 02 01 74 2c 48 8b 47 08 48 85 c0
RIP  [<ffffffff8034ee7b>] rb_erase+0x1ee/0x2a7
 RSP <ffff88012b9777f8>
CR2: 0000000000000010
---[ end trace e20a9dac927dc3b0 ]---

