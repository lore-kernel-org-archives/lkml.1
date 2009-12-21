Return-Path: <linux-kernel-owner+w=401wt.eu-S1752475AbZLUHjW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752475AbZLUHjW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Dec 2009 02:39:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751605AbZLUHjV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Dec 2009 02:39:21 -0500
Received: from mail-pz0-f171.google.com ([209.85.222.171]:44129 "EHLO
	mail-pz0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751440AbZLUHjU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Dec 2009 02:39:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Jw4AhAlmQ+5lzD0vdwnGvzdmX88BsoI61WDWENZxcspqg1i1y0frAQGLhpyuj2zEYd
         /6Z5+HwYdXpb3ttLOfc/rDukCpm6LKFulhQAxfc5JjIEE4yM3v8UooHlHsdWhNjXT3xU
         ZWnXFZ1M3LsxRt2Tpd/7qOT3Jq93Ru4fTXc4Y=
Date: Sun, 20 Dec 2009 23:39:15 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-pm@lists.linux-foundation.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Vojtech Pavlik <vojtech@suse.cz>
Subject: Re: [linux-pm] Async suspend-resume patch w/ completions (was: Re:
	Async?suspend-resume patch w/ rwsems)
Message-ID: <20091221073915.GC3234@core.coreip.homeip.net>
References: <Pine.LNX.4.44L0.0912091729530.2672-100000@iolanthe.rowland.org> <alpine.LFD.2.00.0912191557320.3712@localhost.localdomain> <20091220024142.GC4073@core.coreip.homeip.net> <200912202025.25618.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200912202025.25618.rjw@sisk.pl>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 20, 2009 at 08:25:25PM +0100, Rafael J. Wysocki wrote:
> On Sunday 20 December 2009, Dmitry Torokhov wrote:
> > On Sat, Dec 19, 2009 at 04:09:07PM -0800, Linus Torvalds wrote:
> > > 
> > > That said, I still get the feeling that we'd be even better off simply 
> > > trying to avoid the whole keyboard reset entirely. Apparently we do it for 
> > > a few HP laptops.
> > 
> > I was mistaken, HP laptops do not like mouse disabled when suspending,
> > not sure about the rest of the state.
> > 
> > > It's entirely possible that we'd be better off simply 
> > > not _doing_ the slow thing in the first place.
> > >
> > 
> > The reset appeared first in 2.5.42. I expect that some BIOSes get very
> > confused when tehy find mouse speaking something that they do not
> > unserstand (i.e. synaptics, ALPS or anything else that is not bare PS/2
> > or intellimouse), but maybe Vojtech remembers better?
> >  
> > > For example, we may be _much_ better off doing that whole keyboard reset 
> > > at resume time than at suspend time.
> > 
> > We do the reset for the different reasons - at resume we want the device
> > in known state to ensure that it properly responds to the probes we
> > send to it. At suspend we trying to reset things into original state so
> > that the firmware will not be confused.
> > 
> > If we want to try to live without reset we could to PSMOUSE_CMD_RESET_DIS
> > instead of PSMOUSE_CMD_RESET_BAT which is much heavier. We should
> > probably not wait for .34 then because the bulk of testing will happen
> > only when .33 is close to be released because that's when most of
> > regular users will start using the new code and try to suspend and
> > resume.
> > 
> > Rafael, how long does suspend take if you change call to psmouse_reset()
> > in psmouse_cleanup() to ps2_command(&psmouse->ps2dev, NULL, PSMOUSE_CMD_RESET_DIS)?
> > And do the same for atkbd...
> 
> On the nx6325 that appears to reduce the suspend time as much so the effect
> of async is not visible any more.  On the Wind it decreases the total suspend
> time almost by half!
> 
> Please push this patch to Linus. :-)
> 

Let's see if I manage to solicit some testers first. FWIW it seems to be
working on my boxes.

But if this works then I am not sure we even want to bother with async
suspend of i8042 and serios. And serio already does resume
asynchronously through kseriod.

-- 
Dmitry
