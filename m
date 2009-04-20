Return-Path: <linux-kernel-owner+w=401wt.eu-S1757669AbZDTV7y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757669AbZDTV7y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 17:59:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756308AbZDTV7p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 17:59:45 -0400
Received: from mga01.intel.com ([192.55.52.88]:47445 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756118AbZDTV7o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 17:59:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,219,1239001200"; 
   d="scan'208";a="449656482"
Message-ID: <49ECF040.2000508@intel.com>
Date: Mon, 20 Apr 2009 14:59:28 -0700
From: Dan Williams <dan.j.williams@intel.com>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
CC: "linux-mips@linux-mips.org" <linux-mips@linux-mips.org>,
       "ralf@linux-mips.org" <ralf@linux-mips.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] DMA: TXx9 Soc DMA Controller driver (v2)
References: <1239033288-3086-1-git-send-email-anemo@mba.ocn.ne.jp>	<e9c3a7c20904181305l5a7ea5dcy881b7faec8e447bf@mail.gmail.com> <20090420.033446.65190767.anemo@mba.ocn.ne.jp>
In-Reply-To: <20090420.033446.65190767.anemo@mba.ocn.ne.jp>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Atsushi Nemoto wrote:
> On Sat, 18 Apr 2009 13:05:15 -0700, Dan Williams <dan.j.williams@intel.com> wrote:
>> Not quite "ackable" yet...
> 
> Thank you for review!
> 
>>> +#ifdef CONFIG_MACH_TX49XX
>>> +#define TXX9_DMA_MAY_HAVE_64BIT_REGS
>>> +#define TXX9_DMA_HAVE_CCR_LE
>>> +#define TXX9_DMA_HAVE_SMPCHN
>>> +#define TXX9_DMA_HAVE_IRQ_PER_CHAN
>>> +#endif
>>> +
>>> +#ifdef TXX9_DMA_HAVE_SMPCHN
>>> +#define TXX9_DMA_USE_SIMPLE_CHAIN
>>> +#endif
>>> +
>> There seems to be a lot of ifdef magic in the code based on these
>> defines.  Can we move this magic and some of the pure definitions to
>> drivers/dma/txx9dmac.h?  (See the "#ifdefs are ugly" section of
>> Documentation/SubmittingPatches)
> 
> OK, I will try to clean them up.  But since I don't want to export
> internal implementation details, some of the magics will be left in
> txx9dmac.c, perhaps.

You only need to hide txx9dmac magic if the header was in 
include/linux/, but since it will be in drivers/dma/ you can assume it 
is private.
                }
>> Is there a reason to keep f'irst' off of the tx_list?  It seems like
>> you could simplify this logic and get rid of the scary looking
>> list_splice followed by list_add in txx9dmac_desc_put.  It also seems
>> odd that the descriptors on tx_list are not reachable from the
>> dc->queue list after a submit... but maybe I am missing a subtle
>> detail?
> 
> Well, I'm not sure what do you mean...
> 
> The completion callback handler of the first descriptor should be
> called _after_ the completion of the _last_ child of the descriptor.
> Also I use desc_node for both dc->queue, dc->active_list and
> txd.tx_list.  So if I putted all children to dc->queue or
> dc->active_list, txx9dmac_descriptor_complete() (or its caller) will
> be more complex.
> 
> Or do you mean adding another list_head to maintain txd.tx_list?  Or
> something another at all?

The piece I was missing was that it would make 
txx9dmac_descriptor_complete() more complex.  So, I am fine with the 
leaving the current implementation.

Regards,
Dan
