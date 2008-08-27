Return-Path: <linux-kernel-owner+w=401wt.eu-S1753435AbYH0HiV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753435AbYH0HiV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 03:38:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752428AbYH0HiM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 03:38:12 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:56406 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752234AbYH0HiL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 03:38:11 -0400
Date: Wed, 27 Aug 2008 09:37:52 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Pavel Machek <pavel@suse.cz>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: RFC [PATCH] x86/pci: reserve extra page to avoid error caused
	by P2P pref DMA reads
Message-ID: <20080827073752.GD12191@elte.hu>
References: <1219822159-17245-1-git-send-email-yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1219822159-17245-1-git-send-email-yhlu.kernel@gmail.com>
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


* Yinghai Lu <yhlu.kernel@gmail.com> wrote:

> Diag guys, found one system when loading is high, will have gart wark 
> error. root cause is P2P bridge try to prefetch for several intel 
> e1000 under it. and that skb is near GART iommu area.
> 
> try to reserve page in the boundary at first. last page near TOM2, and 
> last page near MMIO also gart first and last page.
> 
> need one better way for all arch support PCI and memory with a lot of 
> holes etc.

>  void __init dma32_reserve_bootmem(void)
>  {
>  	unsigned long size, align;
> +
> +	/*
> +	 * try to reserve last page to workaround P2P bridge pref DMA reads
> +	 * normally don't need to reserve the page near mmio,
> +	 * because always has acpi etc sit there.
> +	 * but some system has that acpi in the middle of ram below 4g
> +	 * so just reserve it.
> +	 */

Nice! Could this be the root cause of those skb corruptions and e1000 
crashes you've been reporting? So the _usual_ setup accidentally 
protects us from these prefetch induced failures.

I think your patch is fine for the iommu bits, but the 
reserve_last_page() thing should be done in a cleaner way. Cannot we 
just reserve it all at the e820 stage, before passing that RAM to the 
bootmem allocator?

Also, what is the guarantee that 4K of a space is enough to stop all 
prefetching across that boundary?

	Ingo
