Return-Path: <linux-kernel-owner+w=401wt.eu-S1760217AbZFWQ2e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760217AbZFWQ2e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 12:28:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759527AbZFWQ2X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 12:28:23 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49453 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759410AbZFWQ2W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 12:28:22 -0400
Date: Tue, 23 Jun 2009 09:27:39 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Paul Fulghum <paulkf@microgate.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] synclink_gt fix transmit race and timeout
Message-Id: <20090623092739.5a8e9dd5.akpm@linux-foundation.org>
In-Reply-To: <1245770161.3701.42.camel@x2.microgate.com>
References: <1245181451.3727.5.camel@x2.microgate.com>
	<20090622231937.2d32898e.akpm@linux-foundation.org>
	<1245770161.3701.42.camel@x2.microgate.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Jun 2009 10:16:01 -0500 Paul Fulghum <paulkf@microgate.com> wrote:

> On Mon, 2009-06-22 at 23:19 -0700, Andrew Morton wrote:
> > On Tue, 16 Jun 2009 14:44:11 -0500 Paul Fulghum <paulkf@microgate.com> wrote:
> > 
> > > Fix race condition when adding transmit data to active DMA buffer ring
> > > that can cause transmit stall.
> 
> > It's not a terribly good changelog, sorry.
> > It fails to describe the race condition?
> 
> I attempted to say what was done in the change log and
> let the patch describe the details of how it was done.
> But I can see that might not be enough.
> 
> How's this? :
> 
> If after adding transmit data to the transmit DMA ring the
> transmit DMA controller has become inactive before reading
> the new data and the serial transmitter is still active sending
> data already in the transmit FIFO and/or shift register,
> then wait for the serial transmitter to become idle before
> reactivating the transmit DMA controller.
> 
> Otherwise the transmit DMA controller may present the
> new data to the serial transmitter in a small timing window
> just as the serial transmitter transitions to the idle state.
> Hitting this window results in the serial transmitter entering
> an inconsistent state where it does not process the new data
> and does not signal the transition to the idle state.
> 
> >From the driver perspective, this condition appears as an
> active transmit DMA controller (correct) with unsent DMA buffers 
> (correct) and an active serial transmitter (wrong), even though
> no data is actually being sent. When all the DMA buffers are full,
> no further data is accepted from a user application calling
> write() until a timeout occurs and the transmitter and
> DMA controller are reset.
> 

That covers it ;) But I stil lcan't work out whether we shoul backport
this into -stable.

> 
> If this is good enough, I will resubmit the patch with
> the updated change log.

I updated the patch.

I did have a couple of other comments on the patch which seem to have
been missed?

