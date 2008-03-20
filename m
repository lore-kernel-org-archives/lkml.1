Return-Path: <linux-kernel-owner+w=401wt.eu-S1758341AbYCTRqq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758341AbYCTRqq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2008 13:46:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755973AbYCTRqd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Mar 2008 13:46:33 -0400
Received: from mga03.intel.com ([143.182.124.21]:23571 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755106AbYCTRqc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2008 13:46:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,532,1199692800"; 
   d="scan'208";a="220987019"
X-MIMEOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: RE: [2.6.25-rc5-mm1][regression] ia64: hackbench doesn't finish>12hour
Date: Thu, 20 Mar 2008 10:23:10 -0700
Message-ID: <1FE6DD409037234FAB833C420AA843ECDDA39A@orsmsx424.amr.corp.intel.com>
In-reply-to: <1206029802.8514.406.camel@twins>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [2.6.25-rc5-mm1][regression] ia64: hackbench doesn't finish>12hour
Thread-Index: AciKpel91f4htOsvSY+IGoZdYkMjQgAB1ueQ
References: <20080318084314.FF0F.KOSAKI.MOTOHIRO@jp.fujitsu.com> <DDF46CB71CB9D647A983FECACF09A886A33019@orsmsx424.amr.corp.intel.com> <20080318094527.FF12.KOSAKI.MOTOHIRO@jp.fujitsu.com> <DDF46CB71CB9D647A983FECACF09A886A8A6B5@orsmsx424.amr.corp.intel.com> <1205969039.6437.44.camel@lappy> <1FE6DD409037234FAB833C420AA843ECDDA233@orsmsx424.amr.corp.intel.com> <1206029802.8514.406.camel@twins>
From: "Luck, Tony" <tony.luck@intel.com>
To: "Peter Zijlstra" <a.p.zijlstra@chello.nl>
Cc: "Yu, Fenghua" <fenghua.yu@intel.com>,
       "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>,
       "LKML" <linux-kernel@vger.kernel.org>, <linux-ia64@vger.kernel.org>,
       "Hidetoshi Seto" <seto.hidetoshi@jp.fujitsu.com>,
       "Andrew Morton" <akpm@linux-foundation.org>
X-OriginalArrivalTime: 20 Mar 2008 17:23:17.0333 (UTC) FILETIME=[16040050:01C88AAF]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Yeah, semaphores can't be used from hardirq contexts for much the same
> reasons. But its all ia64 code, right? So I'm not directly seeing how
> other archs are affected here.

The root of the problem is a call chain like this:

 [<a00000010005c200>] ia64_global_tlb_purge+0x540/0xa40
                                sp=e0000001c28afca0 bsp=e0000001c28a0ea0
 [<a00000010005c8a0>] flush_tlb_range+0x1a0/0x240
                                sp=e0000001c28afca0 bsp=e0000001c28a0e70
 [<a000000100105a90>] page_referenced_one+0x170/0x260
                                sp=e0000001c28afca0 bsp=e0000001c28a0e20
 [<a000000100105f20>] page_referenced+0x180/0x320
                                sp=e0000001c28afcb0 bsp=e0000001c28a0dd0
 [<a0000001000ec640>] shrink_active_list+0x520/0xbc0
                                sp=e0000001c28afcc0 bsp=e0000001c28a0d48
 [<a0000001000ece30>] shrink_zone+0x150/0x200
                                sp=e0000001c28afd80 bsp=e0000001c28a0d00
 [<a0000001000edaf0>] kswapd+0x690/0x940
                                sp=e0000001c28afd80 bsp=e0000001c28a0c40
 [<a0000001000a6860>] kthread+0xa0/0x120
                                sp=e0000001c28afe30 bsp=e0000001c28a0c10
 [<a000000100013b70>] kernel_thread_helper+0x30/0x60
                                sp=e0000001c28afe30 bsp=e0000001c28a0be0
 [<a0000001000089c0>] start_kernel_thread+0x20/0x40
                                sp=e0000001c28afe30 bsp=e0000001c28a0be0

Some place in the upper (arch independent) parts of this trace the
code acquires an anon_vma_lock and holds it while calling into arch
specific code (there is presumably some inlining going on here because
the source doesn't have an obvious call from page_referenced_one() to
flush_tlb_range()).

My concern for other architectures (especially ones that require IPI to
complete the TLB shootdown) is that holding anon_vma_lock while doing
the shootdown leaves them open for some deadlock scenarios in this
code path.  But perhaps I completley misunderstand how IPI shootdown
happens (very possible).

-Tony

