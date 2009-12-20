Return-Path: <linux-kernel-owner+w=401wt.eu-S1755076AbZLTClt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755076AbZLTClt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Dec 2009 21:41:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754957AbZLTCls
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Dec 2009 21:41:48 -0500
Received: from mail-pz0-f171.google.com ([209.85.222.171]:59784 "EHLO
	mail-pz0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754869AbZLTClr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Dec 2009 21:41:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=JI8SSy0gQKgG9Gnx6LOeicbVybMu/jMCWu8hmXQUkyCUrGLDF8O3cRzDtOXEyHQLW5
         aSxu4AwdDtSf/DRPhVBRzkDzmFO5G4iHtPgRnwNRttw8A4gAoMmNVHKYpBkUiXf+R4NL
         REYB5a/uTmxeRgfnCPmZvXQrWy9Zr5Eol14HA=
Date: Sat, 19 Dec 2009 18:41:42 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Alan Stern <stern@rowland.harvard.edu>, Zhang Rui <rui.zhang@intel.com>,
       LKML <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Vojtech Pavlik <vojtech@suse.cz>
Subject: Re: Async suspend-resume patch w/ completions (was: Re: Async
	suspend-resume patch w/ rwsems)
Message-ID: <20091220024142.GC4073@core.coreip.homeip.net>
References: <Pine.LNX.4.44L0.0912091729530.2672-100000@iolanthe.rowland.org> <200912200040.18944.rjw@sisk.pl> <alpine.LFD.2.00.0912191542570.3712@localhost.localdomain> <200912200053.45988.rjw@sisk.pl> <alpine.LFD.2.00.0912191557320.3712@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0912191557320.3712@localhost.localdomain>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 19, 2009 at 04:09:07PM -0800, Linus Torvalds wrote:
> 
> That said, I still get the feeling that we'd be even better off simply 
> trying to avoid the whole keyboard reset entirely. Apparently we do it for 
> a few HP laptops.

I was mistaken, HP laptops do not like mouse disabled when suspending,
not sure about the rest of the state.

> It's entirely possible that we'd be better off simply 
> not _doing_ the slow thing in the first place.
>

The reset appeared first in 2.5.42. I expect that some BIOSes get very
confused when tehy find mouse speaking something that they do not
unserstand (i.e. synaptics, ALPS or anything else that is not bare PS/2
or intellimouse), but maybe Vojtech remembers better?
 
> For example, we may be _much_ better off doing that whole keyboard reset 
> at resume time than at suspend time.

We do the reset for the different reasons - at resume we want the device
in known state to ensure that it properly responds to the probes we
send to it. At suspend we trying to reset things into original state so
that the firmware will not be confused.

If we want to try to live without reset we could to PSMOUSE_CMD_RESET_DIS
instead of PSMOUSE_CMD_RESET_BAT which is much heavier. We should
probably not wait for .34 then because the bulk of testing will happen
only when .33 is close to be released because that's when most of
regular users will start using the new code and try to suspend and
resume.

Rafael, how long does suspend take if you change call to psmouse_reset()
in psmouse_cleanup() to ps2_command(&psmouse->ps2dev, NULL, PSMOUSE_CMD_RESET_DIS)?
And do the same for atkbd...

BTW, making just serio asynchronous while keeping i8042 synchronous
makes no sense because I serialize access to i8042 - the thing does not
survive simultaneous [command] access to both keyboard and mouse...

-- 
Dmitry
