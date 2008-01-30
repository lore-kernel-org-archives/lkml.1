Return-Path: <linux-kernel-owner+w=401wt.eu-S1759637AbYA3LFu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759637AbYA3LFu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 06:05:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751454AbYA3LFm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 06:05:42 -0500
Received: from py-out-1112.google.com ([64.233.166.178]:63715 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751345AbYA3LFl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 06:05:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=PcZL7OK8f2HvXdmCOZQTjtlq1so8mCVRir6gl27V36teVjVDCPA9Id3OftKVhaArvqmerRoX5s5RJkFLDKQxsiI6lLR8eNeohFlUDxjiulmxRkBdyOaJUIpSPLEif25CTgrlq5L2zXzvMM3nmJBmC8hI8odAeckzqtiTNrQKrAA=
Message-ID: <3efb10970801300305g693a8371u36011426d3a13b3e@mail.gmail.com>
Date: Wed, 30 Jan 2008 12:05:40 +0100
From: "Remy Bohmer" <linux@bohmer.net>
To: "Haavard Skinnemoen" <hskinnemoen@atmel.com>
Subject: Re: [PATCH -mm v4 6/9] atmel_serial: Split the interrupt handler
Cc: michael <trimarchi@gandalf.sssup.it>, fabio@gandalf.sssup.it,
       "Andrew Victor" <linux@maxim.org.za>,
       "Chip Coldwell" <coldwell@redhat.com>,
       "Marc Pignat" <marc.pignat@hevs.ch>,
       "David Brownell" <david-b@pacbell.net>, linux-kernel@vger.kernel.org,
       "Alan Cox" <alan@lxorguk.ukuu.org.uk>
In-Reply-To: <20080130113434.2519f77c@dhcp-252-066.norway.atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080129224316.GA23155@gandalf.sssup.it>
	 <479FB2D7.4020804@gandalf.sssup.it>
	 <20080130104113.48ec376f@dhcp-252-066.norway.atmel.com>
	 <3efb10970801300221h601261edy33cf89dac5abde78@mail.gmail.com>
	 <20080130113434.2519f77c@dhcp-252-066.norway.atmel.com>
X-Google-Sender-Auth: 140b00ad23cd3f9f
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Haavard,

> The code above is from the tasklet, so I don't think that's the problem.
> The interrupt handler doesn't take any locks.
> Or are spinlocks not allowed in softirq context either?

They are allowed there...
So, it has to be something different.

> > I believe I have to look at the latest set of patches, and try to find
> > any regressions. Do you have a location somewhere where I can download
> > the latest versions? Or do I need to dig through LKML to find the
> > latest... ;-)
> They are in -mm. You were Cc'ed I think...

Yes, I saw them, but I did not know if there were any updates in the
mean time, because I had seen some discussions, which confused me a
bit about the current status of the complete set.

> - with full preemption  it runs but the serial line can't be used for
> receiving at high bit rate (using lrz)

A few questions arise here to me:
* What serial port is used here? (DBGU, or something else)
* No DMA was used, was flow-control enabled? (cannot with DBGU)
* If some other UART, why not using DMA?

Notice that the DBGU has no flow control, and just a 1 byte FIFO (thus
no fifo at all).
At high speeds (e.g. >=115200) it is _likely_ that you will miss
characters, nothing can prevent that. DBGU should only be used at
lower speeds, or just as text console. 115200 is running fine here as
text-console.
I would not expect that the behaviour is worse than without the
patchset, because without it it does not work at all on Preempt-RT,
but also: there was done much more in interrupt context previously, so
the chance of buffer overruns was much more likely in the old
situation.
The real interrupt handler (doing the reading from the fifo) must be
as short as possible, to be able to keep up with the data flow.

A simple calculation: 115200bps results in approx. 11520 bytes per second.
This means that the interrupt handler must be capable of handling each
byte on DBGU within 87us. With a worst case interrupt latency of about
85us, and average between 2us and 54us (on Preempt-RT and AT91RM9200),
you can simply understand that this will not match, how good/fast the
interrupt handling will ever be.

So, I suggest to either use flow-control, or DMA for bulkdata... (thus not DBGU)

Kind Regards,

Remy
