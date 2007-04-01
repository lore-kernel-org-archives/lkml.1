Return-Path: <linux-kernel-owner+w=401wt.eu-S964785AbXDATUw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964785AbXDATUw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2007 15:20:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933932AbXDATUw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Apr 2007 15:20:52 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:50358 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933928AbXDATUu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2007 15:20:50 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jiri Slaby <jirislaby@gmail.com>
Subject: Re: 2.6.21-rc5: swsusp: Not enough free memory
Date: Sun, 1 Apr 2007 21:23:54 +0200
User-Agent: KMail/1.9.5
Cc: Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       linux-pm@lists.osdl.org, pavel@suse.cz
References: <460B6E4B.3060004@gmail.com> <200703291639.41515.rjw@sisk.pl> <460FF726.7090601@gmail.com>
In-Reply-To: <460FF726.7090601@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704012123.54797.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 1 April 2007 20:17, Jiri Slaby wrote:
> Rafael J. Wysocki napsal(a):
> > On Thursday, 29 March 2007 09:44, Jiri Slaby wrote:
> >> Hi,
> >>
> >> I'm getting this while trying to swsups the machine in -rc5, -rc4 is fine:
> >>
> >> Disabling non-boot CPUs
> >> CPU 1 is now offline
> >> SMP alternatives: switching to UP code
> >> CPU1 is down
> >> swsusp: critical section:
> >> swsusp: Need to copy 131380 pages
> >> swsusp: Not enough free memory
> >> Error -12 suspending
> >> Enabling non-boot CPUs ...
> >>
> >> # cat /sys/power/resume
> >> 8:6
> >> # cat /proc/swaps
> >> Filename                                Type            Size    Used    Priority
> >> /dev/sda6                               partition       1004020 0       -1
> >>
> >> Any other info needed?
> > 
> > Beats me.  There were no changes that could result in such a thing between
> > -rc4 and -rc5, at least not in the swsusp department.
> > 
> > Could you please try to bisect?
> 
> Hm, there is some kind of magic.
> 
> First, I have fglrx, that taints kernel. If I use vesa drv with X, it
> doesn't resume the card. If I try console, it doesn't resume it too.
> 
> fglrx + suspend.sf.net seems to work -- 3 unsuccesfull disk >
> sys/power/state and after s2dsk with backspace during suspend, disk >
> sys/power/state works. But this sceniario happened only once...
> 
> Next, it was so early to utter -rc4 is good, it happens there too, so it's
> not a regression.
> 
> I have no idea what's wrong, is there any possibility to figure out, what
> happens (esp. kick fglrx off)? Disable higmem? Try UP?

Well, I suspect this is somehow related to highmem, so you can try to check
if disabling highmem helps.

Still, I'd like to understand why it occurs (I can't reproduce it, so far) and
I have a theory.  Namely, I think that on your system the initial image size
is greater than 50% of RAM (you can check that by running
"cat /sys/power/image_size" before you suspend for the first time after a
fresh boot) and the memory shrinker fails to do its job in that case.

What s2disk does is to set image_size below 50% of the RAM size and that's why
the subsequent "echo disk > ..." suspend works too.

As a workaround, you can try to change the initial image size so that it's
smaller than a half of the RAM size.  If that works, I'd like to send you a
debug patch, if you don't mind. :-)

Greetings,
Rafael
