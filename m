Return-Path: <linux-kernel-owner+w=401wt.eu-S1753827AbYLFW03@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753827AbYLFW03 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2008 17:26:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753462AbYLFW0A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Dec 2008 17:26:00 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52882 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753298AbYLFWZ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2008 17:25:57 -0500
Date: Sat, 6 Dec 2008 14:24:55 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Alan Stern <stern@rowland.harvard.edu>, Takashi Iwai <tiwai@suse.de>,
       Greg KH <greg@kroah.com>, LKML <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [linux-pm] [PATCH 1/3] PCI: Rework default handling of suspend
 and resume
In-Reply-To: <200812062236.44111.rjw@sisk.pl>
Message-ID: <alpine.LFD.2.00.0812061420190.3425@nehalem.linux-foundation.org>
References: <Pine.LNX.4.44L0.0812061324260.13426-100000@netrider.rowland.org> <200812062236.44111.rjw@sisk.pl>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 6 Dec 2008, Rafael J. Wysocki wrote:
> 
> However, I'm not quite sure about the freeing and requesting IRQs during
> suspend and resume.  Many drivers do that, many others don't.  Still,
> apparently some drivers don't work correctly after resume if this is not done.
> So, if that should generally be done, I also think that moving it to the core
> might be a good idea.

I'd suggest against it.

A lot of drivers that want to disable (or unregister) interrupts almost 
certainly want to do it simply because they are not ready and willing to 
handle any interrupts after having run their "suspend()" function. 

So if the generic layer does it _after_ calling ->suspend() (or at 
suspend_late()) time, it's too late.

And the generic layer certainly must not disable/unregister interrupts 
_before_ calling ->suspend(), since the driver may well need to handle 
interrupts for suspending.

So there is no right time for the generic layer to do this. Not to mention 
that the generic layer doesn't even know what kind of interrupt (if any - 
or if perhaps even _multiple_) that the driver has registered.

I also suspect that a lot of drivers simply do not want or need to 
unregister the interrupt handler. I'm personally pretty sure that the only 
reason that drivers do this in the first place is exactly because they do 
their suspend() thing with interrupts enabled in the first place, and 
moving the core suspend routines to inside the irq-off region just means 
that they don't even want/need to do anything about interrupts.

			Linus
