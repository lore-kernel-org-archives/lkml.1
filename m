Return-Path: <linux-kernel-owner+w=401wt.eu-S1755173AbXEFTbX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755173AbXEFTbX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2007 15:31:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755174AbXEFTbX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 May 2007 15:31:23 -0400
Received: from nwd2mail10.analog.com ([137.71.25.55]:24803 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755173AbXEFTbW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2007 15:31:22 -0400
X-IronPort-AV: i="4.14,500,1170651600"; 
   d="scan'208"; a="37644668:sNHT24215366"
From: Robin Getz <rgetz@blackfin.uclinux.org>
Organization: Blackfin uClinux org
To: "Robert Schwebel" <r.schwebel@pengutronix.de>
Subject: Re: Correct location for ADC/DAC drivers
Date: Sun, 6 May 2007 15:33:36 -0400
User-Agent: KMail/1.9.5
Cc: "Bodo Eggert" <7eggert@gmx.de>, "Stefan Roese" <ml@stefan-roese.de>,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       "Marc Kleine-Budde" <mkl@pengutronix.de>
References: <8fZXU-3EI-11@gated-at.bofh.it> <E1Hkfia-0000cJ-18@be1.lrz> <20070506160104.GV22585@pengutronix.de>
In-Reply-To: <20070506160104.GV22585@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705061533.36705.rgetz@blackfin.uclinux.org>
X-OriginalArrivalTime: 06 May 2007 19:31:19.0480 (UTC) FILETIME=[1F285B80:01C79015]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 6 May 2007 12:01, Robert Schwebel pondered:
> On Sun, May 06, 2007 at 02:19:59PM +0200, Bodo Eggert wrote:
> > Since you ask for random thoughts:
> >
> > IO of data streams from or to a DAC/ADC is essentially what soundcards
> > do. I'm wondering if these cards are similar enough to use alsa, and if
> > using that interface would ease or hinder programming the driver.
>
> I had a short look at ALSA and it looks like it is a little bit too
> focussed towards "normal" audio. For example, if follows an asynchronous
> model in the sense that an application can read/write to a buffer at any
> time, taken that the ringbuffer doesn't overflow. That's not enough for
> example for control applications; you need the option for real
> synchronous operation there.

Yes - there are too many applications which require tight/sync connection with 
the data - control loops, software radios, machine control, etc - all have 
much different needs than audio, hwmon, or touchscreen.

> IMHO we need an API which offers
>
> - kernel ring buffers (to make it sure no data gets lost)
> - generic data types (streaming plain ADC values is just the simplest
>   case; we also have for example streaming FPGA data containing
>   preprocessed data sets)
> - optional timestamping for each sample
> - zero-copy from hardware into userspace memory, with DMA support

I am assuming that the driver takes care of all DMA/coherency issues that 
might pop up? (and handles all interrupts)?

> - application notification every N samples (N >= 1)
>
> v4l2 may also be worth a look; but in the end I suppose they are all
> specialized sub-cases of what we'd need for fast DAQ.

I would guess that something like v4l might be the best bet - the driver 
provides a few mmapped buffers that you can read/write into, and some 
mechanism to sync in/out of the buffers.

I was actually looking at UIO, but thought that since we really desire the 
kernel ring buffers, that a think model might be better.?

http://www.kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/gregkh-01-driver/uio-documentation.patch

-Robin
