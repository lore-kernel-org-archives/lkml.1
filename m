Return-Path: <linux-kernel-owner+w=401wt.eu-S1751799AbZLaVHD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751799AbZLaVHD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Dec 2009 16:07:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751524AbZLaVHB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Dec 2009 16:07:01 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:48656 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751336AbZLaVHA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Dec 2009 16:07:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=wYzaTXdZdgcGxUy04DVoPcTiQf3AxDl1mHWwMSc27Z0t1xmNUy4mi8kLpjHtznfysK
         JOYCploEnfDlIwuVssWkimBXAAE5bx7xd1eSvHx9Bp/aUdBZ0jrhcjGbOgGu8OEnyj3W
         KUywEGt6Vg+VLpFMVPps9bWTNy+bgFMdS3Vek=
Date: Thu, 31 Dec 2009 13:06:54 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>
Subject: Re: [git pull] Input updates for 2.6.33-rc2
Message-ID: <20091231210654.GA3874@core.coreip.homeip.net>
References: <20091227214924.GB16279@core.coreip.homeip.net>
 <alpine.LFD.2.00.0912301257340.11961@localhost.localdomain>
 <C08FBDE4-7143-46E4-9DB8-912E870D0008@gmail.com>
 <20091231012252.GA13512@core.coreip.homeip.net>
 <alpine.LFD.2.00.0912311125310.11961@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0912311125310.11961@localhost.localdomain>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 31, 2009 at 11:50:59AM -0800, Linus Torvalds wrote:
> 
> 
> On Wed, 30 Dec 2009, Dmitry Torokhov wrote:
> >
> > Dmitry Torokhov (7):
> >       Input: speed up suspend/shutdown for PS/2 mice and keyboards
> 
> Btw, the thing I like best about this commit is how it adds some comments 
> on the keyboard commands.
> 
> That said, the naming and the comments aren't all that wonderful. I don't 
> think you should use the word "RESET" for command f5/f6: the command is 
> called "Set Default" (and ".. Disable" for f5), and there is no actual 
> reset involved. 
> 

I guess it is just a matter of wording. For me "reset" and "revert to
initial state" are pretty much the same.

> So I suspect the command should be renamed to
> 
> 	#define ATKBD_CMD_SET_DEFAULTS_AND_DISABLE	0x00f5

ATKBD_CMD_SET_DEFAULTS_AND_DISABLE_DATA_REPORTING :) I was just trying
to follow the existing naming style. It was there before me and it does
make sense to me still so I did not feel the neet to change it.

> 	#define ATKBD_CMD_SET_DEFAULTS			0x00f6
> 
> and then the comments wouldn't even be needed (and anybody reading the 
> code would not have to look them up in the header file).
> 
> And then "ATKBD_CMD_RESET_BAT" should probably just be "ATKBD_CMD_RESET" 
> (I wonder what the "BAT" part is all about?)

That came from Vojtech but I am pretty sure this stands for Basic
Assurance Test since full reset for touchpads for example involves
recalibration. See this excerpt from Synaptics docs:

"At power-on, the PS/2 TouchPad performs a self-test and calibration,
then transmits the completion code $AA and ID code $00. If the TouchPad
fails its self-test, it transmits error code $FC and ID code $00.  This
processing also occurs when a software Reset ($FF) command is received.
The host should not attempt to send commands to the TouchPad until the
calibration/self-test is complete."

> 
> Oh, and command F5h is not always a "set defaults and disable". For some 
> (all?) PS/2 mice it seems to be _just_ a "disable",

Exactly, that is why it is called PSMOUSE_CMD_DISABLE when used in mouse
context. However snippets of docs I have indicate that for keyboards it
also causes them to reset to defaults.

> and I'm not at all 
> sure you should have used it for the psmouse_cleanup() function.

I am using PSMOUSE_CMD_RESET_DIS (0xf6) in psmouse_cleanup().

> You used 
> to do a
> 
> 	psmouse_reset(psmouse);
> 
> which sent a full reset to the mouse (and waits for the two-byte ACK). It 
> did _not_ disable the mouse - 

It does actually, at least for some devices (incidentally the ones that
may give trouble to the BIOS if left as is):

"The reset state of the TouchPad is as follows:
- Reported sample rate is 100 samples per second (see page 30).
- Reported resolution is 4 counts per mm (see page 32).
- Scaling is 1:1.
- Stream mode is selected.
- Data reporting is disabled. <---------------
- Absolute mode is disabled."

> that happened earlier in 
> psmouse_deactivate(), when you sent it the PSMOUSE_CMD_DISABLE command.

What happened before doing psmouse_reset() (which is PSMOUSE_CMD_RESET_BAT)
should not matter because all previous state should be reset after it.

> 
> You changed that 'psmouse_reset()' to
> 
> 	/*
> 	 * Reset the mouse to defaults (bare PS/2 protocol).
> 	 */
> 	        ps2_command(&psmouse->ps2dev, NULL, PSMOUSE_CMD_RESET_DIS);
> 
> which now disables it again, only to then later do
>         
> 	/*      
> 	 * Some boxes, such as HP nx7400, get terribly confused if mouse
> 	 * is not fully enabled before suspending/shutting down.
> 	 */     
> 	        ps2_command(&psmouse->ps2dev, NULL, PSMOUSE_CMD_ENABLE);
> 
> which seems odd. IOW, Why do you do a "set defaults and disable" followed 
> by a "enable", when you already had it disabled?

We do not have "light reset" option, so we have to use "light reset and
disable" to return to the bare 3-byte PS/2 protocol. Then we have to
re-enable the device because BIOS on some HP notebooks would get
confused and not suspend (or resume, I don't quite remember) if mouse
left disabled.

> 
> I think the PSMOUSE_CMD_RESET that _used_ to be there would re-enable most 
> mice, but now that you don't even do that any more, I get the feeling that 
> the "set defaults and disable" should be just a "set defaults".

There is no such command for mice unfortunately.

> 
> (You may have good reasons for having picked the "and disable" command. I 
> just wonder what they are)
> 
> 		Linus

-- 
Dmitry
