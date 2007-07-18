Return-Path: <linux-kernel-owner+w=401wt.eu-S1765292AbXGRBmh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765292AbXGRBmh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 21:42:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755485AbXGRBm0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 21:42:26 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:53568 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754653AbXGRBmY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 21:42:24 -0400
Date: Wed, 18 Jul 2007 09:40:27 +0800
From: Joe Jin <joe.jin@oracle.com>
To: Hugh Dickins <hugh@veritas.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Joe Jin <joe.jin@oracle.com>,
       bill.irwin@oracle.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Add nid sanity on alloc_pages_node
Message-ID: <20070718014027.GA23559@joejin-pc.cn.oracle.com>
References: <20070713024507.GA19438@joejin-pc.cn.oracle.com> <20070712221842.f5e47065.akpm@linux-foundation.org> <Pine.LNX.4.64.0707171558470.26771@blonde.wat.veritas.com> <20070717093228.3a3638aa.akpm@linux-foundation.org> <Pine.LNX.4.64.0707171818080.19489@blonde.wat.veritas.com> <20070717115849.9f5e435c.akpm@linux-foundation.org> <Pine.LNX.4.64.0707172044001.5286@blonde.wat.veritas.com> <20070717130118.bc78d31a.akpm@linux-foundation.org> <Pine.LNX.4.64.0707172133400.9010@blonde.wat.veritas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0707172133400.9010@blonde.wat.veritas.com>
User-Agent: Mutt/1.4.2.2i
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAA==
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


With your patch, I have reproduced the panic:

Unable to handle kernel paging request at 000000000000186a RIP: 
 [<ffffffff8105d4e7>] __alloc_pages+0x2f/0x2c3
PGD 72595067 PUD 72594067 PMD 0 
Oops: 0000 [1] SMP 
CPU 0 
Modules linked in: xt_tcpudp iptable_filter ip_tables x_tables cpufreq_ondemand dm_mirror dm_multipath dm_mod video sbs button battery backlight ac snd_intel8x0 snd_ac97_codec ac97_bus snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss snd_mixer_oss snd_pcm sg snd_timer shpchp snd soundcore tg3 i2c_i801 piix i2c_core snd_page_alloc ide_cd cdrom serio_raw ata_piix libata sd_mod scsi_mod ext3 jbd ehci_hcd ohci_hcd uhci_hcd
Pid: 3996, comm: sh Not tainted 2.6.22 #9
RIP: 0010:[<ffffffff8105d4e7>]  [<ffffffff8105d4e7>] __alloc_pages+0x2f/0x2c3
RSP: 0018:ffff810071563e48  EFLAGS: 00010246
RAX: 0000000000000000 RBX: 000000e8d4a51000 RCX: 0000000000000000
RDX: ffff810071563fd8 RSI: 0000000000000009 RDI: 00000000000242d2
RBP: 00000000000242d2 R08: 0000000000000000 R09: 0000000000043a01
R10: ffff810000e88000 R11: ffffffff81072a02 R12: 0000000000001862
R13: ffff810070c74ea0 R14: 0000000000000009 R15: 00002adc51042000
FS:  00002adc4db3ddb0(0000) GS:ffffffff81312000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 000000000000186a CR3: 000000007d963000 CR4: 00000000000006e0
Process sh (pid: 3996, threadinfo ffff810071562000, task ffff810070c74ea0)
Stack:  00000010000242d2 ffff810000e88000 ffff810070e76710 ffffffff812e31e0
 ffffffffffffffff 000000e8d4a51000 ffffffffffffffff ffff810077d11b00
 000000000000000e ffff810071563f50 00002adc51042000 ffffffff81071a67
Call Trace:
 [<ffffffff81071a67>] alloc_fresh_huge_page+0x98/0xe7
 [<ffffffff8107263b>] hugetlb_sysctl_handler+0x14/0xf1
 [<ffffffff810bdad9>] proc_sys_write+0x7c/0xa6
 [<ffffffff8108074b>] vfs_write+0xad/0x156
 [<ffffffff81080ced>] sys_write+0x45/0x6e
 [<ffffffff81009c9c>] tracesys+0xdc/0xe1


Code: 49 83 7c 24 08 00 75 0e 48 c7 44 24 08 00 00 00 00 e9 6a 02 
RIP  [<ffffffff8105d4e7>] __alloc_pages+0x2f/0x2c3
 RSP <ffff810071563e48>
CR2: 000000000000186a

>From your patch, if we dont the lock, the race condition maybe occur at
next_node(). 

On 2007-07-17 21:35, Hugh Dickins wrote:
> On Tue, 17 Jul 2007, Andrew Morton wrote:
> > 
> > Given that we've now gone and added deliberate-but-we-hope-benign 
> > races into this code, an elaborate comment which explains and justifies
> > it all is pretty much obligatory, IMO.
> 
> [PATCH] Remove nid_lock from alloc_fresh_huge_page
> 
> The fix to that race in alloc_fresh_huge_page() which could give an illegal
> node ID did not need nid_lock at all: the fix was to replace static int nid
> by static int prev_nid and do the work on local int nid.  nid_lock did make
> sure that racers strictly roundrobin the nodes, but that's not something we
> need to enforce strictly.  Kill nid_lock.
> 
> Signed-off-by: Hugh Dickins <hugh@veritas.com>
> ---
>  mm/hugetlb.c |   10 +++++++---
>  1 file changed, 7 insertions(+), 3 deletions(-)
> 
> --- 2.6.22-git9/mm/hugetlb.c	2007-07-17 20:29:33.000000000 +0100
> +++ linux/mm/hugetlb.c	2007-07-17 21:29:58.000000000 +0100
> @@ -107,15 +107,19 @@ static int alloc_fresh_huge_page(void)
>  {
>  	static int prev_nid;
>  	struct page *page;
> -	static DEFINE_SPINLOCK(nid_lock);
>  	int nid;
>  
> -	spin_lock(&nid_lock);
> +	/*
> +	 * Copy static prev_nid to local nid, work on that, then copy it
> +	 * back to prev_nid afterwards: otherwise there's a window in which
> +	 * a racer might pass invalid nid MAX_NUMNODES to alloc_pages_node.
> +	 * But we don't need to use a spin_lock here: it really doesn't
> +	 * matter if occasionally a racer chooses the same nid as we do.
> +	 */
>  	nid = next_node(prev_nid, node_online_map);
>  	if (nid == MAX_NUMNODES)
>  		nid = first_node(node_online_map);
>  	prev_nid = nid;
> -	spin_unlock(&nid_lock);
>  
>  	page = alloc_pages_node(nid, htlb_alloc_mask|__GFP_COMP|__GFP_NOWARN,
>  					HUGETLB_PAGE_ORDER);
