Return-Path: <linux-kernel-owner+w=401wt.eu-S1760932AbZEGOWq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760932AbZEGOWq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 10:22:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754292AbZEGOWh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 10:22:37 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:47113 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753623AbZEGOWg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 10:22:36 -0400
Date: Thu, 7 May 2009 16:21:21 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Yinghai Lu <yinghai@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: fix nodes_cover_memory
Message-ID: <20090507142121.GL481@elte.hu>
References: <4A01C08F.8020607@kernel.org> <20090507134723.GA32409@csn.ul.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090507134723.GA32409@csn.ul.ie>
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


* Mel Gorman <mel@csn.ul.ie> wrote:

> On Wed, May 06, 2009 at 09:53:35AM -0700, Yinghai Lu wrote:
> > 
> > found one system that missed one entry for one node in SRAT, and that SRAT is not
> > rejected by nodes_cover_memory()
> > 
> > it turns out that we can not use absent_page_in_range to calaulate
> > e820ram, bacause that will use early_node_map and that is AND result of
> > e820 and SRAT.
> > 
> 
> Correct, good spot.
> 
> > revert back to use e820_hole_size instead.
> > 
> 
> I think the patch fixing this part of the problem is good, but the changelog
> could be better. It took me a while to figure out what the problem was and
> why this patch addressed it.
> 
> How about something like the following?
> 
> ====
> Sanity check the e820 against the SRAT table using only information from the e820 map
> 
> node_cover_memory() sanity checks the SRAT table by ensuring that all
> PXMs cover the memory reported in the e820. However, when calculating
> the size of the holes in the e820, it uses the early_node_map[] which
> contains information taken from both SRAT and e820. If the SRAT is
> missing an entry, then it is not detected that the SRAT table is
> incorrect and missing entries.
> 
> This patch uses the e820 map to calculate the holes instead of
> early_node_map[].
> ====
> 
> As an aside, it strikes me as odd that we discard an entire SRAT because it
> is missing an entry in the e820. The impact may only be that the affinity
> for a range of memory is incorrect, but it does not necessarily mean that the
> entire table is incorrect. The intention of the code appears to be "if there is
> any error in the SRAT, it's best ignored" though so maybe it's best left alone.
> 
> > also change that difference checking to 1M instead of 4G,
> > because e820ram, and pxmram are in pages.
> > 
> 
> While I agree with you, this should be a separate patch with its own
> changelog. Something like
> 
> ===
> Allow 1MB of slack between the e820 map and SRAT, not 4GB
> 
> It is expected that there be slight differences between the e820 map and
> the SRAT table and the intention was that 1MB of slack be allowed. The
> calculation comparing e820ram and pxmram assumes the units are bytes,
> when they are in fact pages. This means 4GB of slack is being allowed,
> not 1MB. This patch makes the correct comparison
> ===
> 
> (1<<(20 - PAGE_SHIFT)) is a bit unreadable. At the very least, change the
> comment above from "Allow a bit of slack" to "Allow 1MB of slack" so the
> next reader knows what the intention of (1<<(20 - PAGE_SHIFT)) is.
> 
> Thanks

thanks Mel!

Yinghai, mind resending the patch as two patches, with Mel's 
changelogs in place and with Mel's Acked-by as well?

Thanks,

	Ingo
