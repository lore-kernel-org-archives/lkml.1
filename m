Return-Path: <linux-kernel-owner+w=401wt.eu-S1760564AbYA3S2h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760564AbYA3S2h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 13:28:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753771AbYA3S2Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 13:28:24 -0500
Received: from ag-out-0708.google.com ([72.14.246.241]:46204 "EHLO
	ag-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753507AbYA3S2W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 13:28:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=AQUWOlpFM4unh3R/hslOWHpDL7yPUeG5YLeUju0DlDn9VEJYEQkWEQbaBC3/I+d44KrdySx9YPsUxgJHuX20UPzoDt0BMNUE9HajujGqrsvslfcb1AJOotWt2T7HyyZNFSJ/cW/xvr8eD5DpEtRHJ0lmBU9l1U6Rm+adZHCQRJ0=
Message-ID: <e9c3a7c20801301028l12af0f6bv90509ea08c319bc6@mail.gmail.com>
Date: Wed, 30 Jan 2008 11:28:20 -0700
From: "Dan Williams" <dan.j.williams@intel.com>
To: "David Brownell" <david-b@pacbell.net>
Subject: Re: [RFC v2 2/5] dmaengine: Add slave DMA interface
Cc: "Haavard Skinnemoen" <hskinnemoen@atmel.com>, linux-kernel@vger.kernel.org,
       "Shannon Nelson" <shannon.nelson@intel.com>, kernel@avr32linux.org,
       "Francis Moreau" <francis.moro@gmail.com>,
       "Paul Mundt" <lethal@linux-sh.org>,
       "Vladimir A. Barinov" <vbarinov@ru.mvista.com>,
       "Pierre Ossman" <drzeus-list@drzeus.cx>
In-Reply-To: <200801300252.50344.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1201630213-31900-1-git-send-email-hskinnemoen@atmel.com>
	 <200801292330.05874.david-b@pacbell.net>
	 <20080130102706.15c88346@dhcp-252-066.norway.atmel.com>
	 <200801300252.50344.david-b@pacbell.net>
X-Google-Sender-Auth: 98f578349ad292c9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 30, 2008 3:52 AM, David Brownell <david-b@pacbell.net> wrote:
> On Wednesday 30 January 2008, Haavard Skinnemoen wrote:
> > Descriptor-based vs. register-based transfers sounds like something the
> > DMA engine driver is free to decide on its own.
>
> Not entirely.  The current interface has "dma_async_tx_descriptor"
> wired pretty thoroughly into the call structure -- hard to avoid.
> (And where's the "dma_async_rx_descriptor", since that's only TX??
> Asymmetry like that is usually not a healthy sign.)  The engine is
> not free to avoid those descriptors ...
>

For better or worse I picked async_tx to represent "asynchronous
transfers/transforms", not "transmit".  So there is no asymmetry as it
is used for operations in any direction, or multiple directions as is
the case with xor.  It is simply a gathering point for the common
functionality of descriptor-based offload-engines plus some extra
stuff to deal with creating arbitrary dependency chains.

> And consider that many DMA transfers can often be started (after
> cache synch operations) by writing less than half a dozen registers:
> source address, destination address, params, length, enable.  Being
> wildly generous, let's call that a couple dozen instructions, including
> saving "what to do when it's done".  The current framework requires
> several calls just to fill descriptors ... burning lots more than that
> many instructions even before getting around to the Real Work!  (So I
> was getting at low DMA overheads there, more than any particular way
> to talk to the controller.)
>

Well, it has gone from 4 calls to 2 recently for the memcpy case.  The
only reason it is not 1 call is to support switching dependency chains
between channels i.e. performing some copies on one channel followed
by an xor an another.

--
Dan
