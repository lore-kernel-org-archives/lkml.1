Return-Path: <linux-kernel-owner+w=401wt.eu-S1763748AbYA3Rj4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763748AbYA3Rj4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 12:39:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753531AbYA3Rjt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 12:39:49 -0500
Received: from rn-out-0910.google.com ([64.233.170.185]:47638 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752480AbYA3Rjs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 12:39:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=rrjxfz1g+eagofwvfMkSkU0L2hnYHX6Ntb6ohK46UXcJDVlZk47jjqKdYKIzvbka1SCbJ46Y4PR/DiZ/tyZ2Xro2X6RxzDw0AjBICHobtYh/LwiQWKEywpMGsZ3ZaeBLxJFcwnaiZ+C6UNOc0wJuD0OJUt7/TxY7kLivH/aJ3T0=
Message-ID: <e9c3a7c20801300939w7b73f5a6ld73bde8c3fada569@mail.gmail.com>
Date: Wed, 30 Jan 2008 10:39:47 -0700
From: "Dan Williams" <dan.j.williams@intel.com>
To: "Haavard Skinnemoen" <hskinnemoen@atmel.com>
Subject: Re: [RFC v2 0/5] dmaengine: Slave DMA interface and example users
Cc: "David Brownell" <david-b@pacbell.net>, linux-kernel@vger.kernel.org,
       "Shannon Nelson" <shannon.nelson@intel.com>, kernel@avr32linux.org,
       "Francis Moreau" <francis.moro@gmail.com>,
       "Paul Mundt" <lethal@linux-sh.org>,
       "Vladimir A. Barinov" <vbarinov@ru.mvista.com>,
       "Pierre Ossman" <drzeus-list@drzeus.cx>
In-Reply-To: <20080130095641.39eaad13@dhcp-252-066.norway.atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1201630213-31900-1-git-send-email-hskinnemoen@atmel.com>
	 <20080129215453.1e3758ab@siona>
	 <200801292256.14553.david-b@pacbell.net>
	 <20080130095641.39eaad13@dhcp-252-066.norway.atmel.com>
X-Google-Sender-Auth: 0c56858c08168685
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 30, 2008 1:56 AM, Haavard Skinnemoen <hskinnemoen@atmel.com> wrote:
> On Tue, 29 Jan 2008 22:56:14 -0800
> David Brownell <david-b@pacbell.net> wrote:
>
> > On Tuesday 29 January 2008, Haavard Skinnemoen wrote:
> > >
> > > Btw, there's one issue I forgot to mention: I believe the DMA Engine
> > > framework is currently misusing the DMA mapping API, and this patchset
> > > makes things worse.
> > >
> > > Currently, the async_tx bits of the API do the required calls to
> > > dma_map_single() and/or dma_map_page(), but they rely on the driver to
> > > do the unmapping. This is problematic ...
> > >
> > > How do we solve this?
> >
> > How about:  for peripheral DMA, don't let the engine see anything
> > except dma_addr_t values.
>
> I don't think it does, but the dma_addr_t value is enough to call
> dma_unmap_single() and dma_unmap_page().

Right, dma_addr_t values are all the driver sees in the current scheme.

>
> > The engine needs to be able to dma_alloc_coherent() memory too,
> > which is pre-mapped.
>
> Right, which is another argument for not doing any unmapping in the DMA
> engine driver. We really need to push this responsibility to the client.
>

Agreed, the issue is how to do this without requiring an
interrupt+callback sequence for each transaction or requiring the
client to carry per transaction unmap-data.  For example NET_DMA never
sees a dma_addr_t and assumes that all it needs to care about is the
last transaction in a sequence.  Since it is alive for the duration of
a transaction, we could put unmap data in dma_async_tx_descriptor
along with an unmap function pointer since dma_unmap* routines have an
equal number of parameters.  But I just got through making this
structure smaller so maybe there is a better way.

--
Dan
