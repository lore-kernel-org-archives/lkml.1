Return-Path: <linux-kernel-owner+w=401wt.eu-S1751964AbZH0JLc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751964AbZH0JLc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 05:11:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751898AbZH0JLb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 05:11:31 -0400
Received: from mga11.intel.com ([192.55.52.93]:60817 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751498AbZH0JLa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 05:11:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,285,1249282800"; 
   d="scan'208";a="721276719"
Subject: Re: [Bug #14016] mm/ipw2200 regression
From: Zhu Yi <yi.zhu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mel Gorman <mel@csn.ul.ie>, Johannes Weiner <hannes@cmpxchg.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Mel Gorman <mel@skynet.ie>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       James Ketrenos <jketreno@linux.intel.com>,
       "Chatre, Reinette" <reinette.chatre@intel.com>,
       "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
       "ipw2100-devel@lists.sourceforge.net" 
	<ipw2100-devel@lists.sourceforge.net>
In-Reply-To: <20090826074409.606b5124.akpm@linux-foundation.org>
References: <riPp5fx5ECC.A.2IG.qsGlKB@chimera>
	 <_yaHeGjHEzG.A.FIH.7sGlKB@chimera>
	 <84144f020908252309u5cff8afdh2214577ca4db9b5d@mail.gmail.com>
	 <20090826082741.GA25955@cmpxchg.org>	<20090826093747.GA10955@csn.ul.ie>
	 <20090826074409.606b5124.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Thu, 27 Aug 2009 17:11:29 +0800
Message-Id: <1251364289.3704.176.camel@debian>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-08-26 at 22:44 +0800, Andrew Morton wrote:
> 
> It is perhaps pretty simple to make the second (GFP_ATOMIC) allocation
> go away.  The code is already conveniently structured to do this:
> 
>         do {
>                 chunk = (struct fw_chunk *)(data + offset);
>                 offset += sizeof(struct fw_chunk);
>                 /* build DMA packet and queue up for sending */
>                 /* dma to chunk->address, the chunk->length bytes from
> data +
>                  * offeset*/
>                 /* Dma loading */
>                 rc = ipw_fw_dma_add_buffer(priv, shared_phys + offset,
> 
> le32_to_cpu(chunk->address),
> 
> le32_to_cpu(chunk->length));
>                 if (rc) {
>                         IPW_DEBUG_INFO("dmaAddBuffer Failed\n");
>                         goto out;
>                 }
> 
>                 offset += le32_to_cpu(chunk->length);
>         } while (offset < len);
> 
> what is the typical/expected value of chunk->length here?  If it's
> significantly less than 4096*(2^6), could we convert this function to
> use a separate DMAable allocation per fw_chunk?

Unfortunately, the largest chunk size for the latest 3.1 firmware is
0x20040, which also requires order 6 page allocation. I'll try to use
the firmware DMA command block (64 slots) to handle the image (each for
4k, totally 256k).

Thanks,
-yi

