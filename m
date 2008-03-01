Return-Path: <linux-kernel-owner+w=401wt.eu-S1760086AbYCAOJV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760086AbYCAOJV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2008 09:09:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755539AbYCAOJI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Mar 2008 09:09:08 -0500
Received: from gateway.drzeus.cx ([85.8.24.16]:34287 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755847AbYCAOJH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2008 09:09:07 -0500
Date: Sat, 1 Mar 2008 15:08:10 +0100
From: Pierre Ossman <drzeus-list@drzeus.cx>
To: Simon Huggins <huggie@earth.li>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Scheduler broken? sdhci issues with scheduling
Message-ID: <20080301150810.09bed3d0@mjolnir.drzeus.cx>
In-Reply-To: <20080301124203.GL24533@paranoidfreak.co.uk>
References: <20080229115256.GG24533@paranoidfreak.co.uk>
	<20080229133433.GA15532@elte.hu>
	<20080229135137.GA23781@elte.hu>
	<20080229140024.GA26342@elte.hu>
	<20080229115256.GG24533@paranoidfreak.co.uk>
	<20080229133433.GA15532@elte.hu>
	<20080229193951.GI24533@paranoidfreak.co.uk>
	<20080229203914.GD27212@elte.hu>
	<20080301124203.GL24533@paranoidfreak.co.uk>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 1 Mar 2008 12:42:04 +0000
Simon Huggins <huggie@earth.li> wrote:

> > so neither precise, nor imprecise timings help??
> 
> I don't know.  I don't really understand the patches I applied I'm
> afraid; I'm just reporting the results.
> 
> I've cc'd Pierre Ossman so he might have a look from the sdhci point of
> view.
> 
> Pierre, the thread starts here:
> http://lkml.org/lkml/2008/2/29/118
> 

I'm afraid I can't add that much...

Ingo, the basic problem is this:

The sdhci controllers are not supposed to signal "card insertion" before they have a stable connection with the card. But most (all?) hardware ignores this and signals immediately. This means we need a delay to handle bouncing connectors. This delay is supposed to be 500 ms, but on Simon's system it is in the order of tens of milliseconds.

The mechanism is not msleep(), nor mdelay(), but a delayed work queue. That's why I told Simon to talk to you as that seems like scheduler territory.

The call chain is:

1. sdhci_irq()
2. sdhci_tasklet_card() <- delay is calculated here
3. mmc_detect_change()
4. mmc_schedule_delayed_work()
5. queue_delayed_work()

msleep() and mdelay() are also affected, but this is the major symptom.

Rgds

-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org
