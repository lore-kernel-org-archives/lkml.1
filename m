Return-Path: <linux-kernel-owner+w=401wt.eu-S1756948AbYBFSqz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756948AbYBFSqz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 13:46:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753761AbYBFSqr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 13:46:47 -0500
Received: from rn-out-0910.google.com ([64.233.170.186]:29460 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753033AbYBFSqq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 13:46:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=OYpRzQA71WEsojJbDPBWhxpe0O5gbo6VgJafpDnFbZ/vBQD95misc4GUeeglJdGcDrnFMbgJT2PIpVmpQz63zSJ2tYzO0+b8scnIL6dyVKRwC5vBzgoYvTfVtgzlbYp9JaqAg4s7CLrulOpbAsMuUu9BWHYCSLAD+w6lAVFzB5Q=
Message-ID: <e9c3a7c20802061046r2d939947m97883c3fbef6e016@mail.gmail.com>
Date: Wed, 6 Feb 2008 11:46:43 -0700
From: "Dan Williams" <dan.j.williams@intel.com>
To: "Haavard Skinnemoen" <hskinnemoen@atmel.com>
Subject: Re: [RFC v2 0/5] dmaengine: Slave DMA interface and example users
Cc: "David Brownell" <david-b@pacbell.net>, linux-kernel@vger.kernel.org,
       "Shannon Nelson" <shannon.nelson@intel.com>, kernel@avr32linux.org,
       "Francis Moreau" <francis.moro@gmail.com>,
       "Paul Mundt" <lethal@linux-sh.org>,
       "Vladimir A. Barinov" <vbarinov@ru.mvista.com>,
       "Pierre Ossman" <drzeus-list@drzeus.cx>
In-Reply-To: <20080204163200.550481a7@dhcp-252-066.norway.atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1201630213-31900-1-git-send-email-hskinnemoen@atmel.com>
	 <20080129215453.1e3758ab@siona>
	 <200801292256.14553.david-b@pacbell.net>
	 <20080130095641.39eaad13@dhcp-252-066.norway.atmel.com>
	 <e9c3a7c20801300939w7b73f5a6ld73bde8c3fada569@mail.gmail.com>
	 <20080204163200.550481a7@dhcp-252-066.norway.atmel.com>
X-Google-Sender-Auth: e12a521ba5b09c0c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Feb 4, 2008 8:32 AM, Haavard Skinnemoen <hskinnemoen@atmel.com> wrote:
> On Wed, 30 Jan 2008 10:39:47 -0700
> "Dan Williams" <dan.j.williams@intel.com> wrote:
>
> > Agreed, the issue is how to do this without requiring an
> > interrupt+callback sequence for each transaction or requiring the
> > client to carry per transaction unmap-data.  For example NET_DMA never
> > sees a dma_addr_t and assumes that all it needs to care about is the
> > last transaction in a sequence.  Since it is alive for the duration of
> > a transaction, we could put unmap data in dma_async_tx_descriptor
> > along with an unmap function pointer since dma_unmap* routines have an
> > equal number of parameters.  But I just got through making this
> > structure smaller so maybe there is a better way.
>
> I have to say I'm not crazy about the idea of adding more callbacks to
> the descriptor...
>
> The client must somehow know when the transfer is complete -- after
> all, it has to call async_tx_ack() at some point. So additional
> callbacks shouldn't be needed.
>

The 'ack' only signifies that the client is done with this descriptor,
it tells the api "this descriptor can be freed/reused, no dependent
operations will be submitted against it".  This can and does happen
before the operation actually completes.

[..]

> This requires three additional fields in the dma_async_tx_descriptor
> structure, but in many cases the driver needs these fields in its own
> private descriptor wrapper anyway.
>

I agree this should be moved up to the common descriptor.  The unmap
routines are fairly symmetric, so it may not be that bad to also have
an "unmap type" that the cleanup routines could key off of, one of the
options being "do not unmap" for clients that know what they are
doing.

--
Dan
