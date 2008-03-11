Return-Path: <linux-kernel-owner+w=401wt.eu-S1753974AbYCKIPA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753974AbYCKIPA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 04:15:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751920AbYCKIOq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 04:14:46 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:52382 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750992AbYCKIOo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 04:14:44 -0400
Date: Tue, 11 Mar 2008 09:14:10 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <clameter@sgi.com>,
       kernel list <linux-kernel@vger.kernel.org>,
       Andy Whitcroft <apw@shadowen.org>, Mel Gorman <mel@csn.ul.ie>
Subject: Re: [PATCH] mm: make mem_map allocation continuous.
Message-ID: <20080311081410.GA24240@elte.hu>
References: <86802c440803102322i74333718h60de0da329b139c8@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86802c440803102322i74333718h60de0da329b139c8@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Yinghai Lu <yhlu.kernel@gmail.com> wrote:

> [PATCH] mm: make mem_map allocation continuous.
> 
> vmemmap allocation current got
>  [ffffe20000000000-ffffe200001fffff] PMD ->ffff810001400000 on node 0
>  [ffffe20000200000-ffffe200003fffff] PMD ->ffff810001800000 on node 0
>  [ffffe20000400000-ffffe200005fffff] PMD ->ffff810001c00000 on node 0
>  [ffffe20000600000-ffffe200007fffff] PMD ->ffff810002000000 on node 0
>  [ffffe20000800000-ffffe200009fffff] PMD ->ffff810002400000 on node 0
> ...
> 
> there is 2M hole between them.
> 
> the rootcause is that usemap (24 bytes) will be allocated after every 2M
> mem_map. and it will push next vmemmap (2M) to next align (2M).
> 
> solution:
> try to allocate mem_map continously.
> 
> after patch, will get
>  [ffffe20000000000-ffffe200001fffff] PMD ->ffff810001400000 on node 0
>  [ffffe20000200000-ffffe200003fffff] PMD ->ffff810001600000 on node 0
>  [ffffe20000400000-ffffe200005fffff] PMD ->ffff810001800000 on node 0
>  [ffffe20000600000-ffffe200007fffff] PMD ->ffff810001a00000 on node 0
>  [ffffe20000800000-ffffe200009fffff] PMD ->ffff810001c00000 on node 0
> ...
> and usemap will share in page because of they are allocated continuously too.
> sparse_early_usemap_alloc: usemap = ffff810024e00000 size = 24
> sparse_early_usemap_alloc: usemap = ffff810024e00080 size = 24
> sparse_early_usemap_alloc: usemap = ffff810024e00100 size = 24
> sparse_early_usemap_alloc: usemap = ffff810024e00180 size = 24
> ...
> 
> so we make the bootmem allocation more compact and use less memory for usemap.
> 
> Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

very nice fix!

i suspect this patch should go via -mm.

>  	usemap = alloc_bootmem_node(NODE_DATA(nid), usemap_size());
> +	printk(KERN_INFO "sparse_early_usemap_alloc: usemap = %p size = %ld\n", usemap, usemap_size());

this should be in a separate patch.

	Ingo
