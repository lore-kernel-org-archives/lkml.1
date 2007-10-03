Return-Path: <linux-kernel-owner+w=401wt.eu-S1755355AbXJCPmR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755355AbXJCPmR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 11:42:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754583AbXJCPl7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 11:41:59 -0400
Received: from mk-filter-4-a-1.mail.uk.tiscali.com ([212.74.100.55]:4602 "EHLO
	mk-filter-4-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754594AbXJCPl6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 11:41:58 -0400
X-Trace: 612967384-mk-filter-4.mail.uk.tiscali.com-B2C-$THROTTLED-DYNAMIC-CUSTOMER-DYNAMIC-IP
X-SBRS: None
X-RemoteIP: 81.1.76.66
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ah4FAGNVA0dRAUxC/2dsb2JhbACBWQ
Message-ID: <63320.217.150.108.178.1191426097.squirrel@newgolddream.dyndns.info>
In-Reply-To: <20071003061805.GA8851@linux-sh.org>
References: <1191359367.17654.24.camel@localhost.localdomain>
    <20071003061805.GA8851@linux-sh.org>
Date: Wed, 3 Oct 2007 16:41:37 +0100 (BST)
Subject: Re: [PATCH] Fix SH DMAC code to handle PVR2 cascade
From: "Adrian McMenamin" <adrian@newgolddream.dyndns.info>
To: "Paul Mundt" <lethal@linux-sh.org>,
       "linux-sh" <linuxsh-dev@lists.sourceforge.net>,
       "LKML" <linux-kernel@vger.kernel.org>
User-Agent: SquirrelMail/1.4.9a
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, October 3, 2007 7:18 am, Paul Mundt wrote:
> On Tue, Oct 02, 2007 at 10:09:27PM +0100, Adrian McMenamin wrote:
>> Fix SH DMAC code to correctly handle PVR2 cascade DMA.
>>
>> This updates http://lkml.org/lkml/2007/10/2/276
>>
>> (I decided it was better to have the true size of the transfer put in
>> via the API and refactor this here. And calc_xmit_shift(chan) should
>> return 5 but only returns 3 so I've not used it here)
>>
> It would be helpful to know why calc_xmit_shift() is broken here rather
> than just coding around it, as this will have implications for the other
> DMA channels on SH7091/SH7750.


>From include/asm-sh/cpu-sh4/dma.h

53 /*
54  * The DMA count is defined as the number of bytes to transfer.
55  */
56 static unsigned int ts_shift[] __maybe_unused = {
57         [XMIT_SZ_64BIT]         = 3,
58         [XMIT_SZ_8BIT]          = 0,
59         [XMIT_SZ_16BIT]         = 1,
60         [XMIT_SZ_32BIT]         = 2,
61         [XMIT_SZ_256BIT]        = 5,
62 };
63 #endif

ie ts_shift returns the number of bytes per transfer, but is then used as
a bit shift:

45 /*
46  * We determine the correct shift size based off of the CHCR transmit size
47  * for the given channel. Since we know that it will take:
48  *
49  *      info->count >> ts_shift[transmit_size]
50  *
51  * iterations to complete the transfer.
52  */
53 static inline unsigned int calc_xmit_shift(struct dma_channel *chan)
54 {
55         u32 chcr = ctrl_inl(CHCR[chan->chan]);
56
57         return ts_shift[(chcr & CHCR_TS_MASK)>>CHCR_TS_SHIFT];
58 }


(From arch/sh/drivers/dma/dma-sh.c)

I'm not anywhere where I can fix this at the moment, but i am sure it
could be patched quite trivally.




