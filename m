Return-Path: <linux-kernel-owner+w=401wt.eu-S1754750AbYL1Jie@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754750AbYL1Jie (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Dec 2008 04:38:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752795AbYL1Ji0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Dec 2008 04:38:26 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:52327 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752633AbYL1JiZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Dec 2008 04:38:25 -0500
Date: Sun, 28 Dec 2008 10:37:51 +0100
From: Ingo Molnar <mingo@elte.hu>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: jeremy@goop.org, tony.luck@intel.com, linux-kernel@vger.kernel.org,
       xen-devel@lists.xensource.com, x86@kernel.org, ian.campbell@citrix.com,
       beckyb@kernel.crashing.org, Joerg Roedel <joerg.roedel@amd.com>
Subject: Re: [PATCH 0 of 9] swiotlb: use phys_addr_t for pages
Message-ID: <20081228093751.GC9022@elte.hu>
References: <20081228014432L.fujita.tomonori@lab.ntt.co.jp> <20081227165622.GA19796@elte.hu> <20081228020312K.fujita.tomonori@lab.ntt.co.jp> <20081228142900W.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081228142900W.fujita.tomonori@lab.ntt.co.jp>
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


* FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:

> If we really want to clean up the dma mapping operations, we should 
> define struct dma_mapping_ops in a generic place (such as 
> include/linux/dma-mapping.h) instead each architecture define the own 
> struct dma_mapping_ops. These dma_mapping_ops structures are very 
> similar but a bit different. That's the root cause of the dma mapping 
> operation ugliness.
>
> If we do, X86 and IA64 can share swiotlb and intel VTD code cleanly, 
> X86, IA64, and POWERPC can share swiotlb cleanly too. For example, we 
> can define swiotlb_dma_ops in lib/swiotlb.c and then everyone can share 
> it. Currently, X86 and IA64 define the own swiotlb_dma_ops (and X86 
> needs swiotlb_map_single_phys hack). It doesn't make sense.

Sure.

Note that we went through this process (of unifying dma_mapping_ops) 
recently on x86 recently - 32-bit and 64-bit x86 had such differences.

Note that the main complication wasnt even the small variations in 
signatures, but the different _semantics_: one dma_mapping_ops 
implementation passed in kernel-virtual addresses, the other physical 
addresses. Unifying that was invasive and non-trivial, and it can break 
stuff not at the build level but at the runtime level. We can expect 
similar complications when done over 20 architectures as well.

But yes, it's all desired. Obviously extending swiotlb to highmem and 
using it on xen and powerpc is an essential first step in the direction of 
generalizing all this code.

	Ingo
