Return-Path: <linux-kernel-owner+w=401wt.eu-S1946836AbXD3VvR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946836AbXD3VvR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 17:51:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946840AbXD3VvR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 17:51:17 -0400
Received: from py-out-1112.google.com ([64.233.166.182]:44516 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946836AbXD3VvN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 17:51:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=dhnSBYRvg0EbJY9QFgIrN/eKtYzPw6q8K19HjRR4Elr8rFS9YYuydER2GK/q1O1zFdhtOIWQH8AOfW1/GtWGrmDC0/tOPvW6C8l8z6NApghtAqbG9i9Mw8PYzKs3Cx4IDuoX0TEsEeW0lxyv8cK5XYwYMJzu3SY9MFtHedvjcsk=
Subject: Re: X display shift with disabled console blanking
From: "Antonino A. Daplas" <adaplas@gmail.com>
To: James Pearson <james-p@moving-picture.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <4635E810.80809@moving-picture.com>
References: <46322E08.3040303@moving-picture.com>
	 <1177727097.7568.6.camel@daplas>  <4635E810.80809@moving-picture.com>
Content-Type: text/plain
Date: Tue, 01 May 2007 05:51:05 +0800
Message-Id: <1177969865.4372.23.camel@daplas>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-04-30 at 13:58 +0100, James Pearson wrote:
> Antonino A. Daplas wrote:
> > On Fri, 2007-04-27 at 18:08 +0100, James Pearson wrote:
> > 
> >>I have a problem whereby the X display 'shifts' to left when anything 
> >>writes to /dev/console - where console screen blanking has been disabled 
> >>i.e. doing something like:
> >>
> >>boot to run level 3
> >>
> >>If not root, then make sure /dev/console is writeable
> >>
> >>login and type:
> >>
> >>setterm -blank 0
> >>
> >>start X
> >>
> >>type into an xterm:
> >>
> >>echo "some random text" > /dev/console
> >>(may have to repeat the echo above a few times)
> >>
> >>... and the whole X display jumps (and wraps) to the left
> >>
> >>I'm using a RHEL4 based distro with a vanilla 2.6.21 x86_64 kernel 
> >>(although I've seen the problem with various x86_64 and i686 2.6.X kernels).
> >>
> >>I've seen this problem on a number of different nVidia cards - using 
> >>the vesa driver (same problem occurs with nVidia's binary driver). I 
> >>haven't tried using other makes of graphics cards.
> >>
> >>
> >>OK, this may be a strange combination of disabling the text console 
> >>blanking and running X, but something isn't right somewhere ...
> > 
> > 
> > Yep, it's strange because I can't reproduce this. And the console write
> > should not succeed if the current console is in KD_GRAPHICS mode, which
> > is done by X (unless your version is different).
> 
> I've just installed a vanilla CentOS 4.4 on an i686 SMP machine - with 
> an nVidia Quadro4 980 XGL card.
> 
> By default, this sets up X using the 'nv' driver (using RedHat's 
> xorg-x11-6.8.2-1.EL.13.37).
> 
> If I follow my 'recipe' above, then the screen shifts - note: it looks 
> like you have to write several lines of text to /dev/console (at least 
> 30) to trigger the problem (e.g. run the echo to /dev/console in a loop) 
> - also, I've found that switching to the console and back to X 
> (Ctrl-Alt-F1 then Ctrl-Alt-F7) while this echo loop is running can force 
> the shift to start ...

I would understand that switching from text to graphics and vice versa
can trigger display problems (it shouldn't, but it happens), but not
while you are only echoing text to the system console in graphics mode.

> 
> This is with the RedHat based 2.6.9-42.ELsmp kernel - but I also get the 
> problem with a vanilla 2.6.21 kernel.
> 
> >>Any ideas?
> > 
> > 
> > I don't.  But, what is your current console?  Is it VGA, or framebuffer?
> > Can you try doing this again in both VGA and vesafb?
> 
> I'm not sure what the current console is - whatever is the default with 
> RHEL4/CentOS4 - how do I select a different type of console?
> 

dmesg | grep "Console:"



> > And this does not happen if there is no previous setterm -blank 0
> > command?
> 
> It doesn't happen if there is no previous 'setterm -blank 0' - so, 
> arguably, this is the 'fix' ...

Weird. The only thing I can think of is that console blanking is being
triggered while the console is in graphics mode, which is not legal. 

How about 'setterm -blank 1', do an infinite echo loop and wait for at
least 1 minute?

Also, can you open drivers/char/vt.c and look for the function
do_blank_screen?  You should have this particular segment.

Change this

if (console_blanked) {
	if (blank_state == blank_vesa_wait) {
		blank_state = blank_off;
		vc->vc_sw->con_blank(vc, vesa_blank_mode + 1, 0);
	}
	return;
}

to

if (console_blanked && vc->vc_mode == KD_TEXT && !entering_gfx ) {
	if (blank_state == blank_vesa_wait) {
		blank_state = blank_off;
		vc->vc_sw->con_blank(vc, vesa_blank_mode + 1, 0);
	}
	return;
}

Let me know if that even makes a difference.

Tony


