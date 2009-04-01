Return-Path: <linux-kernel-owner+w=401wt.eu-S1759290AbZDAJLf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759290AbZDAJLf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 05:11:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750903AbZDAJLZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 05:11:25 -0400
Received: from relay.atmel.no ([80.232.32.139]:56718 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751191AbZDAJLY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 05:11:24 -0400
Date: Wed, 1 Apr 2009 11:11:16 +0200
From: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>
To: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Cc: "Sosnowski, Maciej" <maciej.sosnowski@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [PATCH 2/2] dw_dmac: add cyclic API to DW DMA driver
Message-ID: <20090401111116.7c604530@hcegtvedt>
In-Reply-To: <20090401102830.6a749ad2@hskinnemoen-d830>
References: <1237894506-11622-1-git-send-email-hans-christian.egtvedt@atmel.com>
	<1237894506-11622-2-git-send-email-hans-christian.egtvedt@atmel.com>
	<129600E5E5FB004392DDC3FB599660D790F8C3F0@irsmsx504.ger.corp.intel.com>
	<20090401102830.6a749ad2@hskinnemoen-d830>
Organization: Atmel
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.16.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 1 Apr 2009 10:28:30 +0200
Haavard Skinnemoen <haavard.skinnemoen@atmel.com> wrote:

> Sosnowski, Maciej wrote:
> > > +void dw_dma_cyclic_stop(struct dma_chan *chan)
> > > +{
> > > +	struct dw_dma_chan	*dwc = to_dw_dma_chan(chan);
> > > +	struct dw_dma		*dw =
> > > to_dw_dma(dwc->chan.device); +
> > > +	channel_clear_bit(dw, CH_EN, dwc->mask);
> > > +	while (dma_readl(dw, CH_EN) & dwc->mask)
> > > +		cpu_relax();
> > > +}  
> > 
> > Don't you need locks in dw_dma_cyclic_stop?
> 
> Good question. On one hand, if cyclic_start() can race with
> cyclic_stop(), the client probably has more serious issues to deal
> with. On the other hand, if something ever manages to set the CH_EN
> bit at the wrong moment, the loop may never finish.
> 
> So it's probably safest to wrap it in spin_lock_bh(). You should
> probably add a note that this function can not be called from
> interrupt context too.
> 

The problem then is when calling cyclic_stop from the trigger function
in an ALSA driver.

http://www.kernel.org/pub/linux/kernel/people/tiwai/docs/writing-an-alsa-driver/ch05s06.html#pcm-interface-operators-trigger-callback

This callback is atomic, and with interrupts disabled. So using
spin_lock_bh() is AFAICT not allowed.

I am going to brush up the interface and document that the _stop and
_start interface has to be called with interrupts disabled. Will post a
v2 shortly.

-- 
Best regards,
Hans-Christian Egtvedt
