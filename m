Return-Path: <linux-kernel-owner+w=401wt.eu-S1755343AbYIZJsm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755343AbYIZJsm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 05:48:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753862AbYIZJsc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 05:48:32 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:51265 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753526AbYIZJsb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 05:48:31 -0400
Date: Fri, 26 Sep 2008 11:46:34 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Suresh Siddha <suresh.b.siddha@intel.com>,
       Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       Linas Vepstas <linas@austin.ibm.com>,
       "rajesh.shah@intel.com" <rajesh.shah@intel.com>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Kristen Accardi <kristen.c.accardi@intel.com>,
       Muli Ben-Yehuda <muli@il.ibm.com>
Cc: jbarnes@virtuousgeek.org, tglx@linutronix.de, hpa@zytor.com,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       arjan@linux.intel.com, linux-kernel@vger.kernel.org,
       Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH] x86, pci-hotplug, calgary / rio: fix EBDA ioremap()
Message-ID: <20080926094634.GA13527@elte.hu>
References: <20080926014334.GF15609@linux-os.sc.intel.com> <20080926073902.GA30041@elte.hu> <20080926081226.GA8556@elte.hu> <20080926083542.GA5431@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080926083542.GA5431@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> ibmphpd: IBM Hot Plug PCI Controller Driver version: 0.6
> resource map sanity check conflict: 0x9f800 0xaf5e7 0x9f800 0x9ffff reserved
> ------------[ cut here ]------------
> WARNING: at arch/x86/mm/ioremap.c:175 __ioremap_caller+0x5c/0x226()
> Pid: 1, comm: swapper Not tainted 2.6.27-rc7-tip-00914-g347b10f-dirty #36037
>  [<c013a72d>] warn_on_slowpath+0x41/0x68
>  [<c0156f00>] ? __lock_acquire+0x9ba/0xa7f
>  [<c012158c>] ? do_flush_tlb_all+0x0/0x59
>  [<c015ac31>] ? smp_call_function_mask+0x74/0x17d
>  [<c012158c>] ? do_flush_tlb_all+0x0/0x59
>  [<c013b228>] ? printk+0x1a/0x1c
>  [<c013f302>] ? iomem_map_sanity_check+0x82/0x8c
>  [<c0a773e8>] ? _read_unlock+0x22/0x25
>  [<c013f302>] ? iomem_map_sanity_check+0x82/0x8c
>  [<c0154e17>] ? trace_hardirqs_off+0xb/0xd
>  [<c0127731>] __ioremap_caller+0x5c/0x226
>  [<c0156158>] ? trace_hardirqs_on+0xb/0xd
>  [<c012767d>] ? iounmap+0x9d/0xa5
>  [<c01279dd>] ioremap_nocache+0x15/0x17
>  [<c0403c42>] ? ioremap+0xd/0xf
>  [<c0403c42>] ioremap+0xd/0xf
>  [<c0f1928f>] ibmphp_access_ebda+0x60/0xa0e
>  [<c0f17f64>] ibmphp_init+0xb5/0x360
>  [<c0101057>] do_one_initcall+0x57/0x138
>  [<c0f17eaf>] ? ibmphp_init+0x0/0x360
>  [<c0156158>] ? trace_hardirqs_on+0xb/0xd
>  [<c0148d75>] ? __queue_work+0x2b/0x30
>  [<c0f17eaf>] ? ibmphp_init+0x0/0x360
>  [<c0f015a0>] kernel_init+0x17b/0x1e2
>  [<c0f01425>] ? kernel_init+0x0/0x1e2
>  [<c01178b3>] kernel_thread_helper+0x7/0x10
>  =======================
> ---[ end trace a7919e7f17c0a725 ]---
> initcall ibmphp_init+0x0/0x360 returned -19 after 144 msecs
> calling  zt5550_init+0x0/0x6a @ 1
> 
> mapping the EBDA is rather ... un-nice from that driver, so i guess 
> you check does the right thing in flagging possible crap.

it does:

    addr:  0x9f800
     end:  0xaf5e7
p->start:  0x9f800
  p->end:  0x9ffff

resources are laid out like this:

  0009f800-0009ffff : reserved
  000a0000-000bffff : Video RAM area

so the driver over-maps into the Video RAM...

and drivers/pci/hotplug/ibmphp_ebda.c seems to be under the 
misunderstanding that the EBDA is up to 65000 bytes large:

        io_mem = ioremap (ebda_seg<<4, 65000);

in reality the EBDA is at most 4K on a normal PC. So i think the right 
fix is the patch below - crop the range to 4K.

_Maybe_ we could remap io_mem to 64K window once we detected a RIO 
signature - but looking at the bogus 65000 number above i think it was 
just added in randomly as a "should be enough, doesnt cause problems" 
thing.

	Ingo

---------------------->
>From f14478b953f8c8b84c868ae68d04722165622cf5 Mon Sep 17 00:00:00 2001
From: Ingo Molnar <mingo@elte.hu>
Date: Fri, 26 Sep 2008 11:40:53 +0200
Subject: [PATCH] x86, pci-hotplug, calgary / rio: fix EBDA ioremap()

IO resource and ioremap debugging uncovered this ioremap() done
by drivers/pci/hotplug/ibmphp_ebda.c:

initcall pci_hotplug_init+0x0/0x41 returned 0 after 3 msecs
calling  ibmphp_init+0x0/0x360 @ 1
ibmphpd: IBM Hot Plug PCI Controller Driver version: 0.6
resource map sanity check conflict: 0x9f800 0xaf5e7 0x9f800 0x9ffff reserved
------------[ cut here ]------------
WARNING: at arch/x86/mm/ioremap.c:175 __ioremap_caller+0x5c/0x226()
Pid: 1, comm: swapper Not tainted 2.6.27-rc7-tip-00914-g347b10f-dirty #36038
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

the problem is this code:

        io_mem = ioremap (ebda_seg<<4, 65000);

it assumes that the EBDA is 65000 bytes. But BIOS EBDA pointers are
at most 4K large.

_if_ the Rio code truly extends upon the customary EBDA size it needs
to iounmap() this memory and ioremap() it larger, once it knows it from
the generic descriptors that a Rio system is around.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 drivers/pci/hotplug/ibmphp_ebda.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/pci/hotplug/ibmphp_ebda.c b/drivers/pci/hotplug/ibmphp_ebda.c
index 8467d02..cb73713 100644
--- a/drivers/pci/hotplug/ibmphp_ebda.c
+++ b/drivers/pci/hotplug/ibmphp_ebda.c
@@ -276,7 +276,7 @@ int __init ibmphp_access_ebda (void)
 	iounmap (io_mem);
 	debug ("returned ebda segment: %x\n", ebda_seg);
 	
-	io_mem = ioremap (ebda_seg<<4, 65000);
+	io_mem = ioremap(ebda_seg<<4, 4096);
 	if (!io_mem )
 		return -ENOMEM;
 	next_offset = 0x180;
