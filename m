Return-Path: <linux-kernel-owner+w=401wt.eu-S1753417AbZBAAct@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753417AbZBAAct (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Jan 2009 19:32:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752147AbZBAAci
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Jan 2009 19:32:38 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53370 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751517AbZBAAch (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Jan 2009 19:32:37 -0500
Date: Sat, 31 Jan 2009 16:32:31 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Parag Warudkar <parag.lkml@gmail.com>,
       Matt Carlson <mcarlson@broadcom.com>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "David S. Miller" <davem@davemloft.net>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: 2.6.29-rc3: tg3 dead after resume
In-Reply-To: <200902010111.08433.rjw@sisk.pl>
Message-ID: <alpine.LFD.2.00.0901311623520.3067@localhost.localdomain>
References: <alpine.DEB.2.00.0901281858380.5048@parag-desktop> <200901312346.35265.rjw@sisk.pl> <alpine.LFD.2.00.0901311450550.2978@localhost.localdomain> <200902010111.08433.rjw@sisk.pl>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 1 Feb 2009, Rafael J. Wysocki wrote:
> > The problems happen on purely the suspend path. How the f*ck do you know 
> > that the drivers behind the bridge don't do everything at 'suspend_late' 
> > time, and expect to be working up until that time?
> 
> DMA from suspend_late?  Come on.

Rafael. Stop being a total idiot.

Read what I wrote.

I'm saying that the driver may not do anything at all at suspend() time, 
and leaves everything until suspend_late. Then, at suspend_late(), it 
finally really shuts down.

That's actually a very reasonable thing to do in some circumstances. It 
simplifies everything, in particular all interrupt handling, since the 
device is now fully live all the way while interrupts can happen.

For a USB host controller, for example, it really could make sense to do 
that - just leave all the core host controller stuff running, and the only 
thing the "suspend()" callback does is to send the commands to the actual 
devices, it doesn't necessarily touch the host controller itself at all.

Then, at suspend_late time, you just clear the "running" bit in the 
controller (and perhaps not even that - because you want to still push 
things out for debugging). End result: you never actually had to shut 
anything down at all, and you could (for example) still run a USB serial 
port console all the way to shutdown.

And yes, I wanted to do basically exactly that when I was debugging some 
issues a year or two ago.

See? The device and driver may be totally alive over a ->suspend() call. 
And that means that the bridge CANNOT KNOW that it's ok to shut down DMA. 
Because DMA may be the only way the device communicates (again: USB 
actually works that way).

So dammit, just admit that you were wrong, instead of continually sending 
these _idiotic_ replies. That "turn off bus mastering" was bogus and 
idiotic, and had no real cause. Ok to just admit it already?

		Linus
