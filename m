Return-Path: <linux-kernel-owner+w=401wt.eu-S1751443AbZLaTvG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751443AbZLaTvG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Dec 2009 14:51:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751336AbZLaTvE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Dec 2009 14:51:04 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49582 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751316AbZLaTvD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Dec 2009 14:51:03 -0500
Date: Thu, 31 Dec 2009 11:50:59 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>
Subject: Re: [git pull] Input updates for 2.6.33-rc2
In-Reply-To: <20091231012252.GA13512@core.coreip.homeip.net>
Message-ID: <alpine.LFD.2.00.0912311125310.11961@localhost.localdomain>
References: <20091227214924.GB16279@core.coreip.homeip.net> <alpine.LFD.2.00.0912301257340.11961@localhost.localdomain> <C08FBDE4-7143-46E4-9DB8-912E870D0008@gmail.com> <20091231012252.GA13512@core.coreip.homeip.net>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 30 Dec 2009, Dmitry Torokhov wrote:
>
> Dmitry Torokhov (7):
>       Input: speed up suspend/shutdown for PS/2 mice and keyboards

Btw, the thing I like best about this commit is how it adds some comments 
on the keyboard commands.

That said, the naming and the comments aren't all that wonderful. I don't 
think you should use the word "RESET" for command f5/f6: the command is 
called "Set Default" (and ".. Disable" for f5), and there is no actual 
reset involved. 

So I suspect the command should be renamed to

	#define ATKBD_CMD_SET_DEFAULTS_AND_DISABLE	0x00f5
	#define ATKBD_CMD_SET_DEFAULTS			0x00f6

and then the comments wouldn't even be needed (and anybody reading the 
code would not have to look them up in the header file).

And then "ATKBD_CMD_RESET_BAT" should probably just be "ATKBD_CMD_RESET" 
(I wonder what the "BAT" part is all about?)

Oh, and command F5h is not always a "set defaults and disable". For some 
(all?) PS/2 mice it seems to be _just_ a "disable", and I'm not at all 
sure you should have used it for the psmouse_cleanup() function. You used 
to do a

	psmouse_reset(psmouse);

which sent a full reset to the mouse (and waits for the two-byte ACK). It 
did _not_ disable the mouse - that happened earlier in 
psmouse_deactivate(), when you sent it the PSMOUSE_CMD_DISABLE command.

You changed that 'psmouse_reset()' to

	/*
	 * Reset the mouse to defaults (bare PS/2 protocol).
	 */
	        ps2_command(&psmouse->ps2dev, NULL, PSMOUSE_CMD_RESET_DIS);

which now disables it again, only to then later do
        
	/*      
	 * Some boxes, such as HP nx7400, get terribly confused if mouse
	 * is not fully enabled before suspending/shutting down.
	 */     
	        ps2_command(&psmouse->ps2dev, NULL, PSMOUSE_CMD_ENABLE);

which seems odd. IOW, Why do you do a "set defaults and disable" followed 
by a "enable", when you already had it disabled?

I think the PSMOUSE_CMD_RESET that _used_ to be there would re-enable most 
mice, but now that you don't even do that any more, I get the feeling that 
the "set defaults and disable" should be just a "set defaults".

(You may have good reasons for having picked the "and disable" command. I 
just wonder what they are)

		Linus
