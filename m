Return-Path: <linux-kernel-owner+w=401wt.eu-S933971AbYBMX43@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933971AbYBMX43 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 18:56:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765588AbYBMX4C
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 18:56:02 -0500
Received: from ti-out-0910.google.com ([209.85.142.187]:30335 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760870AbYBMXz7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 18:55:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=PiObPj9wyz0Oo/JaIxmOvuNKxq5Jlfj00ezu3h8SLRkiZpgkadjeAa0HTiefigIC0KNNkAab2TnB8ukPxE7M75LXh6TA8ReqjPiXBLCOISJUpAe+4S6YNfCwnFahdZqnKkKuJxRfFTAmLhXK6kP744D+dHHqlaFmDurrAOrYh64=
Message-ID: <e9c3a7c20802131555y5217f300pc94f82f192ffb60a@mail.gmail.com>
Date: Wed, 13 Feb 2008 16:55:54 -0700
From: "Dan Williams" <dan.j.williams@intel.com>
To: "Haavard Skinnemoen" <hskinnemoen@atmel.com>
Subject: Re: [RFC v2 5/5] Atmel MCI: Driver for Atmel on-chip MMC controllers
Cc: linux-kernel@vger.kernel.org, "Shannon Nelson" <shannon.nelson@intel.com>,
       "David Brownell" <david-b@pacbell.net>, kernel@avr32linux.org,
       "Francis Moreau" <francis.moro@gmail.com>,
       "Paul Mundt" <lethal@linux-sh.org>,
       "Vladimir A. Barinov" <vbarinov@ru.mvista.com>,
       "Pierre Ossman" <drzeus-list@drzeus.cx>
In-Reply-To: <20080213220646.081583d6@siona>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1201630213-31900-1-git-send-email-hskinnemoen@atmel.com>
	 <1201630213-31900-2-git-send-email-hskinnemoen@atmel.com>
	 <1201630213-31900-3-git-send-email-hskinnemoen@atmel.com>
	 <1201630213-31900-4-git-send-email-hskinnemoen@atmel.com>
	 <1201630213-31900-5-git-send-email-hskinnemoen@atmel.com>
	 <1201630213-31900-6-git-send-email-hskinnemoen@atmel.com>
	 <e9c3a7c20802131111l86bf853y9173e23526aeb84c@mail.gmail.com>
	 <20080213220646.081583d6@siona>
X-Google-Sender-Auth: 36a342eb906083de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Feb 13, 2008 2:06 PM, Haavard Skinnemoen <hskinnemoen@atmel.com> wrote:
> On Wed, 13 Feb 2008 12:11:58 -0700
> "Dan Williams" <dan.j.williams@intel.com> wrote:
>
> > > +               desc = chan->device->device_prep_slave(chan,
> > > +                               sg_dma_address(sg), direction,
> > > +                               DMA_SLAVE_WIDTH_32BIT,
> > > +                               sg_dma_len(sg), dma_flags);
> > > +               desc->txd.callback = NULL;
> > > +               list_add_tail(&desc->client_node,
> > > +                               &host->dma.data_descs);
> > > +       }
> >
> > Need to handle device_prep_slave returning NULL?
>
> You're right, we definitely need to handle that. Which probably means
> we need to prepare an interrupt descriptor first that we can throw in
> when we're unable to obtain more descriptors, and submit the rest from
> the callback.
>
> Except we're not allowed to submit anything from the callback. Ouch.
>
> How can we solve that? Set up a work queue and submit it from there?
> Trigger a different tasklet?
>
> In any case, I guess I need to implement support for interrupt
> descriptors in the dw_dmac driver.
>

Well, the other two possibilities are:

1/ Spin/sleep until a descriptor shows up
2/ Fall back to PIO for a few transfers

Descriptor availability is improved if the code interleaves allocation
and submission.  Currently it looks like we wait until all descriptors
for the scatterlist are allocated before we start submitting.
