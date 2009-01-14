Return-Path: <linux-kernel-owner+w=401wt.eu-S1757530AbZANKIQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757530AbZANKIQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 05:08:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754327AbZANKH5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 05:07:57 -0500
Received: from smtp.nokia.com ([192.100.105.134]:16769 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751675AbZANKH4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 05:07:56 -0500
Message-ID: <496DBC4B.2000609@nokia.com>
Date: Wed, 14 Jan 2009 12:19:55 +0200
From: Adrian Hunter <ext-adrian.hunter@nokia.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: Adrian Hunter <ext-adrian.hunter@nokia.com>
CC: Tony Lindgren <tony@atomide.com>,
       Russell King - ARM Linux <linux@arm.linux.org.uk>,
       lkml <linux-kernel@vger.kernel.org>,
       Pierre Ossman <drzeus-mmc@drzeus.cx>,
       linux-omap Mailing List <linux-omap@vger.kernel.org>
Subject: Re: [PATCH 2/2] OMAP: HSMMC: Fix response type for busy after response
References: <20090113133827.29474.92645.sendpatchset@ahunter-laptop> <20090113133841.29474.15852.sendpatchset@ahunter-laptop>
In-Reply-To: <20090113133841.29474.15852.sendpatchset@ahunter-laptop>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 14 Jan 2009 10:07:39.0479 (UTC) FILETIME=[EE90FE70:01C9762F]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Hunter wrote:
>>From 410bc62034c021f8767c8dae469c3215783992ca Mon Sep 17 00:00:00 2001
> From: Adrian Hunter <ext-adrian.hunter@nokia.com>
> Date: Mon, 12 Jan 2009 16:13:08 +0200
> Subject: [PATCH] OMAP: HSMMC: Fix response type for busy after response
> 
> Some MMC commands result in the card becoming busy after
> the response is received.  This needs to be specified
> for the omap_hsmmc host controller, which is what this
> patch does.  However, the effect is that some commands
> with no data will cause a Transfer Complete (TC) interrupt
> in addition to the Command Complete (CC) interrupt.
> In order to deal with that, the irq handler has needed
> a few changes also.
> 
> The benefit of this change is that the omap_hsmmc host
> controller driver now waits for the TC interrupt while
> the card is busy, so the mmc_block driver needs to poll
> the card status just once instead of repeatedly.
> i.e. the net result is more sleep and less cpu.
> 
> This also fixes the hidden problem that the controller
> was turning off the clock to the card while the card
> was busy - the clock was then switched on for the
> duration of each Send Status command used for polling,
> which is why writes did not lock up altogether.
> i.e. really dysfunctional.

That paragraph is not true.  According to the standard:

"The host is allowed to shut down the clock of a “busy” card. The card will complete the programming
operation regardless of the host clock. However, the host must provide a clock edge for the card to turn
off its busy signal. Without a clock edge the card (unless previously disconnected by a deselect command
-CMD7) will force the DAT0 line down, forever."

i.e. during busy state the clock is only needed to check whether the busy state is over.

I will resend the patch, without that paragraph and with a fix to report the
error code when there is a timeout error in the busy state.
