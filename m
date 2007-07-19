Return-Path: <linux-kernel-owner+w=401wt.eu-S938976AbXGSPSA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938976AbXGSPSA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 11:18:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753276AbXGSPRu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 11:17:50 -0400
Received: from sj-iport-3-in.cisco.com ([171.71.176.72]:44612 "EHLO
	sj-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756579AbXGSPRt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 11:17:49 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ao8CAEsdn0arR7O6/2dsb2JhbAA
X-IronPort-AV: i="4.16,557,1175497200"; 
   d="scan'208"; a="504948972:sNHT64161574"
To: "Pekka Enberg" <penberg@cs.helsinki.fi>
Cc: "Andi Kleen" <ak@suse.de>, "Christoph Lameter" <clameter@sgi.com>,
       torvalds@osdl.org, linux-kernel@vger.kernel.org,
       "Michael S. Tsirkin" <mst@dev.mellanox.co.il>
Subject: Re: kmalloc zero size changes break i386
X-Message-Flag: Warning: May contain useful information
References: <200707191201.35777.ak@suse.de>
	<84144f020707190708p1c4d63cnbb0397a602c3527d@mail.gmail.com>
From: Roland Dreier <rdreier@cisco.com>
Date: Thu, 19 Jul 2007 08:17:43 -0700
In-Reply-To: <84144f020707190708p1c4d63cnbb0397a602c3527d@mail.gmail.com> (Pekka Enberg's message of "Thu, 19 Jul 2007 17:08:34 +0300")
Message-ID: <adamyxsfmnc.fsf@cisco.com>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.4.20 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 19 Jul 2007 15:17:44.0237 (UTC) FILETIME=[F4BC05D0:01C7CA17]
Authentication-Results: sj-dkim-2; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim2002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I think the oops below is related -- Michael reports that avoiding
kmalloc(0) in the mlx4_ib driver makes it go away.

From: "Michael S. Tsirkin" <mst@dev.mellanox.co.il>
Subject: oops on mlx4 modprobe
To: general@lists.openfabrics.org, Roland Dreier <rolandd@cisco.com>
Date: Thu, 19 Jul 2007 11:47:51 +0300
Reply-To: "Michael S. Tsirkin" <mst@dev.mellanox.co.il>

I got the following when loading mlx4_ib on git
589f1e81bde732dd0b1bc5d01b6bddd4bcb4527b


[ 1350.668590] Unable to handle kernel NULL pointer dereference at 0000000000000028 RIP:
[ 1350.674068]  [<ffffffff8027b373>] __kmalloc+0x51/0xaf
[ 1350.682159] PGD 0
[ 1350.684378] Oops: 0000 [1] SMP
[ 1350.687735] CPU 3
[ 1350.689950] Modules linked in: ib_ipoib ib_cm ib_sa ib_uverbs ib_umad mlx4_ib mlx4_core ib_mthca ib_mad ib_core piix ata_piix
[ 1350.701777] Pid: 5391, comm: ipoib Not tainted 2.6.22-x86_64-git #119
[ 1350.708400] RIP: 0010:[<ffffffff8027b373>]  [<ffffffff8027b373>] __kmalloc+0x51/0xaf
[ 1350.716536] RSP: 0018:ffff81007c655ba0  EFLAGS: 00010046
[ 1350.722034] RAX: 0000000000000003 RBX: 0000000000000246 RCX: 0000000000000040
[ 1350.729352] RDX: ffff81007ed15000 RSI: 00000000000000d0 RDI: 0000000000000000
[ 1350.736669] RBP: ffff81007c655bc0 R08: 00000000fffffff0 R09: ffff810075779d80
[ 1350.743985] R10: 0000000000000001 R11: 0000000005b8d800 R12: 00000000000000d0
[ 1350.751302] R13: 0000000000000010 R14: ffff81007ed7cc78 R15: ffff81007dbad800
[ 1350.758620] FS:  0000000000000000(0000) GS:ffff81007ff2b340(0000) knlGS:0000000000000000
[ 1350.767089] CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
[ 1350.773021] CR2: 0000000000000028 CR3: 0000000075ca6000 CR4: 00000000000006e0
[ 1350.780338] Process ipoib (pid: 5391, threadinfo ffff81007c654000, task ffff81007c5d8040)
[ 1350.788895] Stack:  ffff81007ed7cc00 0000000000000000 ffff81007ed7cc00 ffff81007ed7cd20
[ 1350.797331]  ffff81007c655c40 ffffffff88063cb6 ffff81006ae20b80 000000006ae20c30
[ 1350.805151]  ffff81007c655df0 ffff81007e3ba380 00000000000000d0 ffff81007ffa7c80
[ 1350.812587] Call Trace:
[ 1350.815619]  [<ffffffff88063cb6>] :mlx4_ib:create_qp_common+0x558/0x736
[ 1350.822421]  [<ffffffff88064c2e>] :mlx4_ib:mlx4_ib_create_qp+0x62/0x11f
[ 1350.829223]  [<ffffffff880999d2>] :ib_ipoib:ipoib_cm_tx_completion+0x0/0x2bb
[ 1350.836461]  [<ffffffff8800eca9>] :ib_core:ib_create_qp+0x18/0x94
[ 1350.842743]  [<ffffffff8809a281>] :ib_ipoib:ipoib_cm_tx_start+0x216/0x651
[ 1350.849714]  [<ffffffff80244382>] queue_work+0x3f/0x4a
[ 1350.855043]  [<ffffffff88080e63>] :ib_sa:ib_sa_join_multicast+0x292/0x2df
[ 1350.862030]  [<ffffffff8809a06b>] :ib_ipoib:ipoib_cm_tx_start+0x0/0x651
[ 1350.868829]  [<ffffffff80243cd4>] run_workqueue+0x85/0x10f
[ 1350.874501]  [<ffffffff80244695>] worker_thread+0x0/0xe7
[ 1350.880000]  [<ffffffff80244771>] worker_thread+0xdc/0xe7
[ 1350.885585]  [<ffffffff80247747>] autoremove_wake_function+0x0/0x38
[ 1350.892036]  [<ffffffff80247622>] kthread+0x49/0x77
[ 1350.897102]  [<ffffffff8020caa8>] child_rip+0xa/0x12
[ 1350.902254]  [<ffffffff802475d9>] kthread+0x0/0x77
[ 1350.907231]  [<ffffffff8020ca9e>] child_rip+0x0/0x12
[ 1350.912384]
[ 1350.914068]
[ 1350.914068] Code: 49 8b 54 c5 00 83 3a 00 74 16 8b 02 c7 42 0c 01 00 00 00 ff
[ 1350.923599] RIP  [<ffffffff8027b373>] __kmalloc+0x51/0xaf
[ 1350.929195]  RSP <ffff81007c655ba0>
[ 1350.932873] CR2: 0000000000000028
