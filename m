Return-Path: <linux-kernel-owner+w=401wt.eu-S1756776AbYA3PZv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756776AbYA3PZv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 10:25:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752818AbYA3PZn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 10:25:43 -0500
Received: from ms01.sssup.it ([193.205.80.99]:35909 "EHLO sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750825AbYA3PZn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 10:25:43 -0500
Message-ID: <47A096F0.4000606@gandalf.sssup.it>
Date: Wed, 30 Jan 2008 16:25:36 +0100
From: michael <trimarchi@gandalf.sssup.it>
User-Agent: Thunderbird 1.5.0.14pre (X11/20071023)
MIME-Version: 1.0
To: Remy Bohmer <linux@bohmer.net>
CC: Haavard Skinnemoen <hskinnemoen@atmel.com>, fabio@gandalf.sssup.it,
       Andrew Victor <linux@maxim.org.za>, Chip Coldwell <coldwell@redhat.com>,
       Marc Pignat <marc.pignat@hevs.ch>, David Brownell <david-b@pacbell.net>,
       linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH -mm v4 6/9] atmel_serial: Split the interrupt handler
References: <20080129224316.GA23155@gandalf.sssup.it>	 <479FB2D7.4020804@gandalf.sssup.it>	 <20080130104113.48ec376f@dhcp-252-066.norway.atmel.com>	 <3efb10970801300221h601261edy33cf89dac5abde78@mail.gmail.com>	 <20080130113434.2519f77c@dhcp-252-066.norway.atmel.com> <3efb10970801300305g693a8371u36011426d3a13b3e@mail.gmail.com>
In-Reply-To: <3efb10970801300305g693a8371u36011426d3a13b3e@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
> A few questions arise here to me:
> * What serial port is used here? (DBGU, or something else)
> * No DMA was used, was flow-control enabled? (cannot with DBGU)
> * If some other UART, why not using DMA?
>
>   
DBGU, so no flow control
> Notice that the DBGU has no flow control, and just a 1 byte FIFO (thus
> no fifo at all).
> At high speeds (e.g. >=115200) it is _likely_ that you will miss
> characters, nothing can prevent that. DBGU should only be used at
> lower speeds, or just as text console. 115200 is running fine here as
> text-console.
>   
Overrun are admitted using DBGU and UART1..n without flow control,
but with the old version of the driver I can send a file using lrz
and with the new and full preemption is impossible.
> I would not expect that the behaviour is worse than without the
> patchset, because without it it does not work at all on Preempt-RT,
> but also: there was done much more in interrupt context previously, so
> the chance of buffer overruns was much more likely in the old
> situation.
> The real interrupt handler (doing the reading from the fifo) must be
> as short as possible, to be able to keep up with the data flow.
>
> A simple calculation: 115200bps results in approx. 11520 bytes per second.
> This means that the interrupt handler must be capable of handling each
> byte on DBGU within 87us. With a worst case interrupt latency of about
> 85us, and average between 2us and 54us (on Preempt-RT and AT91RM9200),
> you can simply understand that this will not match, how good/fast the
> interrupt handling will ever be.
>
> So, I suggest to either use flow-control, or DMA for bulkdata... (thus not DBGU)
>
> Kind Regards,
>
> Remy
>
>   

