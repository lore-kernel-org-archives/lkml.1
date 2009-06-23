Return-Path: <linux-kernel-owner+w=401wt.eu-S1760419AbZFWPSt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760419AbZFWPSt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 11:18:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753381AbZFWPSm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 11:18:42 -0400
Received: from adsl-70-250-156-241.dsl.austtx.swbell.net ([70.250.156.241]:54467
	"EHLO gw.microgate.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752209AbZFWPSm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 11:18:42 -0400
Subject: Re: [PATCH] synclink_gt fix transmit race and timeout
From: Paul Fulghum <paulkf@microgate.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20090622231937.2d32898e.akpm@linux-foundation.org>
References: <1245181451.3727.5.camel@x2.microgate.com>
	 <20090622231937.2d32898e.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Tue, 23 Jun 2009 10:16:01 -0500
Message-Id: <1245770161.3701.42.camel@x2.microgate.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-06-22 at 23:19 -0700, Andrew Morton wrote:
> On Tue, 16 Jun 2009 14:44:11 -0500 Paul Fulghum <paulkf@microgate.com> wrote:
> 
> > Fix race condition when adding transmit data to active DMA buffer ring
> > that can cause transmit stall.

> It's not a terribly good changelog, sorry.
> It fails to describe the race condition?

I attempted to say what was done in the change log and
let the patch describe the details of how it was done.
But I can see that might not be enough.

How's this? :

If after adding transmit data to the transmit DMA ring the
transmit DMA controller has become inactive before reading
the new data and the serial transmitter is still active sending
data already in the transmit FIFO and/or shift register,
then wait for the serial transmitter to become idle before
reactivating the transmit DMA controller.

Otherwise the transmit DMA controller may present the
new data to the serial transmitter in a small timing window
just as the serial transmitter transitions to the idle state.
Hitting this window results in the serial transmitter entering
an inconsistent state where it does not process the new data
and does not signal the transition to the idle state.

>From the driver perspective, this condition appears as an
active transmit DMA controller (correct) with unsent DMA buffers 
(correct) and an active serial transmitter (wrong), even though
no data is actually being sent. When all the DMA buffers are full,
no further data is accepted from a user application calling
write() until a timeout occurs and the transmitter and
DMA controller are reset.

--

If this is good enough, I will resubmit the patch with
the updated change log.

--
Paul Fulghum
Microgate Systems, Ltd

