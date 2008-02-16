Return-Path: <linux-kernel-owner+w=401wt.eu-S1754851AbYBPJWu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754851AbYBPJWu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2008 04:22:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751902AbYBPJWi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Feb 2008 04:22:38 -0500
Received: from bzq-179-150-194.static.bezeqint.net ([212.179.150.194]:42304
	"EHLO il.qumranet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751783AbYBPJWf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2008 04:22:35 -0500
Message-ID: <47B6AB14.5090408@qumranet.com>
Date: Sat, 16 Feb 2008 11:21:24 +0200
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Christoph Lameter <clameter@sgi.com>,
       Andrea Arcangeli <andrea@qumranet.com>, Robin Holt <holt@sgi.com>,
       Izik Eidus <izike@qumranet.com>, kvm-devel@lists.sourceforge.net,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, general@lists.openfabrics.org,
       Steve Wise <swise@opengridcomputing.com>,
       Roland Dreier <rdreier@cisco.com>, Kanoj Sarcar <kanojsarcar@yahoo.com>,
       steiner@sgi.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       daniel.blueman@quadrics.com
Subject: Re: [patch 1/6] mmu_notifier: Core code
References: <20080215064859.384203497@sgi.com>	<20080215064932.371510599@sgi.com>	<20080215193719.262c03a1.akpm@linux-foundation.org>	<47B6A2BE.6080201@qumranet.com> <20080216005653.353a62dc.akpm@linux-foundation.org>
In-Reply-To: <20080216005653.353a62dc.akpm@linux-foundation.org>
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:

  

>> Very.  kvm pins pages that are referenced by the guest;
>>     
>
> hm.  Why does it do that?
>
>   

It was deemed best not to allow the guest to write to a page that has 
been swapped out and assigned to an unrelated host process.

One way to view the kvm shadow page tables is as hardware dma 
descriptors. kvm pins pages for the same reason that drivers pin pages 
that are being dma'ed. It's also the reason why mmu notifiers are useful 
for such a wide range of dma capable hardware.

>> a 64-bit guest 
>> will easily pin its entire memory with the kernel map.
>>     
>
>   
>>  So this is 
>> critical for guest swapping to actually work.
>>     
>
> Curious.  If KVM can release guest pages at the request of this notifier so
> that they can be swapped out, why can't it release them by default, and
> allow swapping to proceed?
>
>   

If kvm releases a page, it must also zap any shadow ptes pointing at the 
page and flush the tlb. If you do that for all of memory you can't 
reference any of it.

Releasing a page has costs, both at the time of the release and when the 
guest eventually refers to the page again.

>> Other nice features like page migration are also enabled by this patch.
>>
>>     
>
> We already have page migration.  Do you mean page-migration-when-using-kvm?
>   

Yes, I'm obviously writing from a kvm-centric point of view. This is an 
important feature, as the virtualization future seems to be NUMA hosts 
(2- or 4- way, 4 cores per socket) running moderately sized guests. The 
ability to load-balance guests among the NUMA nodes is important for 
performance.

(btw, I'm also looking forward to memory defragmentation. large pages 
are important for virtualization workloads and mmu notifiers are again 
critical to getting it to work while running kvm).

-- 
Any sufficiently difficult bug is indistinguishable from a feature.

