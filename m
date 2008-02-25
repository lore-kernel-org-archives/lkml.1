Return-Path: <linux-kernel-owner+w=401wt.eu-S1756515AbYBYRln@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756515AbYBYRln (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 12:41:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753335AbYBYRlf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 12:41:35 -0500
Received: from gateway.drzeus.cx ([85.8.24.16]:33291 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752855AbYBYRle (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 12:41:34 -0500
Date: Mon, 25 Feb 2008 18:41:02 +0100
From: Pierre Ossman <drzeus-mmc@drzeus.cx>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Zdenek Kabelac <zdenek.kabelac@gmail.com>,
       David Brownell <david-b@pacbell.net>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: Bugs in MMC [was: [Bug 10030] Suspend doesn't work when SD card
 is inserted]
Message-ID: <20080225184102.0a2e2bb5@mjolnir.drzeus.cx>
In-Reply-To: <Pine.LNX.4.44L0.0802240941440.29504-100000@netrider.rowland.org>
References: <200802241500.41969.rjw@sisk.pl>
	<Pine.LNX.4.44L0.0802240941440.29504-100000@netrider.rowland.org>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 24 Feb 2008 10:33:34 -0500 (EST)
Alan Stern <stern@rowland.harvard.edu> wrote:

> 
> Well, the patch itself isn't really adequate; it was just a first pass 
> intended to illustrate the nature of the problem.
> 
> The problems in the MMC subsystem go deeper.
> 
> The first is the way it uses flush_workqueue().  This is almost always 
> a bad function to call, because it introduces unnecessary dependencies.  
> cancel_delayed_work_sync() is much better.
> 
> But even changing that won't solve the second issue, which is a genuine
> bug.  There is a race between detect events and suspend events.  The
> mmc_suspend_host() routine starts out by flushing the kmmcd workqueue
> before calling the host's suspend routine.  So what happens if another
> detect event occurs in between?
> 

The idea is that host drivers shouldn't do that. Once they've called
mmc_suspend_host(), then they shouldn't be poking the MMC core in any
other way. None of this is of course properly documented. :/

> This whole area of synchronization between card insertion, card
> removal, suspend, and resume needs to be thought out better.  
> Especially keeping in mind that device registration or unregistration
> during a system sleep is likely to block until the sleep is over.

Trying to keep up with the PM changes is a full time job. For now I've
mostly ignored it as I don't even have time for the other stuff.
Patches welcome.

> 
> Lastly, there are some other questions about confusing aspects of the
> subsystem.  What's the story with __mmc_claim_host()?  Is it really
> nothing more than an abortable mutex_lock()?  Why does it ever need to
> be aborted?  Why is its second argument an atomic_t instead of a normal
> int?
> 

It got that way when SDIO got in. It was needed to make it abortable to
solve a rather nasty deadlock situation. I don't remember the details
right now, but it should be in the LKML archives.

> Why are mmc_detect() and related routines described in comments as
> "Card detection callback from host"?  They don't handle card
> _detection_ -- they handle card _removal_.

They handle both.

> 
> What's the purpose of the card-counting loop in 
> host/omap.c:mmc_omap_switch_handler()?  It looks like dead code.
> 

I'm not too familiar with that driver, but they've been playing around
with multiplexing several cards into one controller. Might be bits and
pieces of that.

Rgds
-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org
