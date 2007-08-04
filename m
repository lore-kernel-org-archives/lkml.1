Return-Path: <linux-kernel-owner+w=401wt.eu-S1764589AbXHDQLy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764589AbXHDQLy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Aug 2007 12:11:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759572AbXHDQLq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Aug 2007 12:11:46 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54358 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759419AbXHDQLp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Aug 2007 12:11:45 -0400
Date: Sat, 4 Aug 2007 09:11:34 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jeff Chua <jeff.chua.linux@gmail.com>
cc: lkml <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: Linux 2.6.23-rc2
In-Reply-To: <b6a2187b0708040652l28e9d5aal2cc898f8006906f2@mail.gmail.com>
Message-ID: <alpine.LFD.0.999.0708040900170.5037@woody.linux-foundation.org>
References: <alpine.LFD.0.999.0708032031480.5037@woody.linux-foundation.org>
  <b6a2187b0708032213r476204fbh917d3d6672c70528@mail.gmail.com> 
 <b6a2187b0708032234r6ad41be4u5d8142b0b199fcc1@mail.gmail.com>
 <b6a2187b0708040652l28e9d5aal2cc898f8006906f2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 4 Aug 2007, Jeff Chua wrote:
>
> On 8/4/07, Jeff Chua <jeff.chua.linux@gmail.com> wrote:
> > 
> > > After resume from s2ram or switching to console from X, my console is
> > > messed up on rc1 and rc2. Is there a fix for this?
> >
> > This is on IBM X60. i915 chipset. No problem on 2.6.22. If this is a
> > known problem, than I don't need to bisect all over again.
> 
> I managed to bisect down to this commit. Without this, console screen
> can resume without video mess.

[ The commit being 4fd06960f120e02e9abc802a09f9511c400042a5: "Use the new 
  x86 setup code for i386" ]

Very interesting. 

Jeff - do I understand correctly that the "or" means that even *without* a 
suspend-to-ram sequence, and just by going into X and then going back to 
text-mode, the screen is corrupt?

I just want to make sure that there is no suspend-related activity 
required for this at all, and the only common issue is probably just that 
suspend ends up *also* triggering the X mode-setting at resume..

If so, the most likely thing is that we use a different video mode at 
boot, and while it may look similar, it's enough to confuse X. Not 
entirely surprising: X tends to be easily confused, and some VGA registers 
are write-only, so restoring modes can be surprisingly hard.

The other possibility is that the new code sets the same mode, but doesn't 
set some memory value or other that the kernel used to see, and that X 
queried to figure out the mode (ie likely some EDD info-block or other). I 
thought that the X server did all that on its own these days, but that may 
be just the newer "intel" driver, not the older "i810" driver that you 
probably use.

(Side note: if you have a modern distro, you might try to change the line 
that says

	Driver "i810"

in the /etc/X11/xorg.conf to say

	Driver "intel"

instead - just to check. However, the bug that triggered this 
obviously needs to be fixed regardless).

Peter, any ideas?

		Linus
