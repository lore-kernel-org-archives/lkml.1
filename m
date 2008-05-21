Return-Path: <linux-kernel-owner+w=401wt.eu-S933440AbYEUGul@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933440AbYEUGul (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 02:50:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762810AbYEUGuc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 02:50:32 -0400
Received: from mail51.messagelabs.com ([216.82.244.179]:62539 "EHLO
	mail51.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758555AbYEUGub (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 02:50:31 -0400
X-VirusChecked: Checked
X-Env-Sender: Uwe.Kleine-Koenig@digi.com
X-Msg-Ref: server-13.tower-51.messagelabs.com!1211352629!1130200!1
X-StarScan-Version: 5.5.12.14.2; banners=-,-,-
X-Originating-IP: [66.77.174.13]
Date: Wed, 21 May 2008 08:49:38 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= <Uwe.Kleine-Koenig@digi.com>
To: Magnus Damm <magnus.damm@gmail.com>
CC: "Hans J. Koch" <hjk@linutronix.de>, <linux-kernel@vger.kernel.org>,
       <lethal@linux-sh.org>, <gregkh@suse.de>, <linux-sh@vger.kernel.org>
Subject: Re: [PATCH 00/03][RFC] Reusable UIO Platform Driver
Message-ID: <20080521064938.GA11580@digi.com>
References: <20080520105132.1474.73941.sendpatchset@rx1.opensource.se> <20080520210713.GE3220@local> <aec7e5c30805202031x62b3b463lfde0b9e7eb32d35@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aec7e5c30805202031x62b3b463lfde0b9e7eb32d35@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-OriginalArrivalTime: 21 May 2008 06:49:38.0755 (UTC) FILETIME=[D6C9E130:01C8BB0E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Magnus,

Magnus Damm wrote:
> Hi Hans!
> 
> On Wed, May 21, 2008 at 6:07 AM, Hans J. Koch <hjk@linutronix.de> wrote:
> > On Tue, May 20, 2008 at 07:51:32PM +0900, Magnus Damm wrote:
> >> These patches implement a reusable UIO platform driver.
> >
> > Uwe Kleine-Koenig already submitted such a framework:
> >
> > http://lkml.org/lkml/2008/5/20/94
> >
> > It's his third version, and it looks good. I presume you didn't know
> > about his work. The main difference is that he leaves interrupt handling
> > to platform code. That might look strange (it did to me first), but it
> > has the advantage that you can put hardware dependent stuff in your
> > board support (which depends on hardware anyway).
> 
> I was not aware of this driver, thanks for the pointer!
> 
> > Could you have a look at his patch and tell me if that does what you
> > need?
> 
> The uio_pdrv driver doesn't do what I need at this point, though I may
> be able to extend it with the following:
> - Interrupt enable/disable code
> - Physically contiguous memory support
> 
> The interrupt code may be placed in the board/cpu code, but I need to
> share that code between multiple UIO driver instances. We want to use
> the same UIO driver for many different processor models and hardware
> blocks.
What about adding uio_platform_handler (with a different name) to
uio_pdrv.c?
OTOH I don't see why you want to disable the irq.  Can you describe the
reason?

>         Extending uio_pdrv driver with a chunk of physically
> contiguous memory isn't a big deal though.
I wonder how you use that memory.  Isn't it just some kind of shared
memory?  If so, why not use normal shared memory?  Do you really need
that?

> To be frank, I have my doubts in adding an extra forwarding-only
> platform layer on top of UIO compared to using uio_register_device()
> directly from the board code. I like that the platform layer is using
> struct resource and handles resource ranges for us automatically, but
> wouldn't it make more sense to extend the UIO core to always use
> struct resource instead of struct uio_mem? I'd be happy to help out -
> just point me in the right direction.
That alone doesn't help.  You need a struct device to register a uio
device.  So a platform device is the straight forward approach.
 
> >> The interrupt handling code in uio_platform assumes the device is the
> >> only user of the assigned interrupt.
> >
> > Uwe's approach doesn't have this limitation.
> 
> True, but the uio_pdrv driver is choosing to not deal with interrupts
> at all. I'd like to have shared interrupt handling code. With my
> driver, you just feed it io memory window parameters and an interrupt
> number and off you go. No need for any callbacks.
In my eyes this isn't completly correct.  Just the way you specify your
handler is a bit different.  You can pass a handler via platform data
with my driver, too.
 
BTW, you don't need "depends on UIO" (because it's in a if UIO/endif
block) and "default n" (as this is the default anyhow).  See also 
http://thread.gmane.org/gmane.linux.kernel/663884/focus=683097

Best regards
Uwe

-- 
Uwe Kleine-König, Software Engineer
Digi International GmbH Branch Breisach, Küferstrasse 8, 79206 Breisach, Germany
Tax: 315/5781/0242 / VAT: DE153662976 / Reg. Amtsgericht Dortmund HRB 13962
