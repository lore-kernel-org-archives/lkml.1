Return-Path: <linux-kernel-owner+w=401wt.eu-S1754294AbYIZIgS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754294AbYIZIgS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 04:36:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752503AbYIZIgE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 04:36:04 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:55864 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752763AbYIZIgB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 04:36:01 -0400
Date: Fri, 26 Sep 2008 10:35:42 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: jbarnes@virtuousgeek.org, tglx@linutronix.de, hpa@zytor.com,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       arjan@linux.intel.com, linux-kernel@vger.kernel.org,
       Yinghai Lu <yhlu.kernel@gmail.com>
Subject: Re: [patch] ioremap sanity check to catch mapping requests
	exceeding the BAR sizes
Message-ID: <20080926083542.GA5431@elte.hu>
References: <20080926014334.GF15609@linux-os.sc.intel.com> <20080926073902.GA30041@elte.hu> <20080926081226.GA8556@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080926081226.GA8556@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Subject: [PATCH] IO resources, x86: ioremap sanity check to catch mapping requests exceeding

i started testing it in -tip, and it triggered on a quirky PCI hotplug 
driver:

calling  ibmphp_init+0x0/0x360 @ 1
ibmphpd: IBM Hot Plug PCI Controller Driver version: 0.6
resource map sanity check conflict: 0x9f800 0xaf5e7 0x9f800 0x9ffff reserved
------------[ cut here ]------------
WARNING: at arch/x86/mm/ioremap.c:175 __ioremap_caller+0x5c/0x226()
Pid: 1, comm: swapper Not tainted 2.6.27-rc7-tip-00914-g347b10f-dirty #36037
 [<c013a72d>] warn_on_slowpath+0x41/0x68
 [<c0156f00>] ? __lock_acquire+0x9ba/0xa7f
 [<c012158c>] ? do_flush_tlb_all+0x0/0x59
 [<c015ac31>] ? smp_call_function_mask+0x74/0x17d
 [<c012158c>] ? do_flush_tlb_all+0x0/0x59
 [<c013b228>] ? printk+0x1a/0x1c
 [<c013f302>] ? iomem_map_sanity_check+0x82/0x8c
 [<c0a773e8>] ? _read_unlock+0x22/0x25
 [<c013f302>] ? iomem_map_sanity_check+0x82/0x8c
 [<c0154e17>] ? trace_hardirqs_off+0xb/0xd
 [<c0127731>] __ioremap_caller+0x5c/0x226
 [<c0156158>] ? trace_hardirqs_on+0xb/0xd
 [<c012767d>] ? iounmap+0x9d/0xa5
 [<c01279dd>] ioremap_nocache+0x15/0x17
 [<c0403c42>] ? ioremap+0xd/0xf
 [<c0403c42>] ioremap+0xd/0xf
 [<c0f1928f>] ibmphp_access_ebda+0x60/0xa0e
 [<c0f17f64>] ibmphp_init+0xb5/0x360
 [<c0101057>] do_one_initcall+0x57/0x138
 [<c0f17eaf>] ? ibmphp_init+0x0/0x360
 [<c0156158>] ? trace_hardirqs_on+0xb/0xd
 [<c0148d75>] ? __queue_work+0x2b/0x30
 [<c0f17eaf>] ? ibmphp_init+0x0/0x360
 [<c0f015a0>] kernel_init+0x17b/0x1e2
 [<c0f01425>] ? kernel_init+0x0/0x1e2
 [<c01178b3>] kernel_thread_helper+0x7/0x10
 =======================
---[ end trace a7919e7f17c0a725 ]---
initcall ibmphp_init+0x0/0x360 returned -19 after 144 msecs
calling  zt5550_init+0x0/0x6a @ 1

mapping the EBDA is rather ... un-nice from that driver, so i guess you 
check does the right thing in flagging possible crap.

	Ingo
