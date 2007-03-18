Return-Path: <linux-kernel-owner+w=401wt.eu-S1752776AbXCRO0c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752776AbXCRO0c (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Mar 2007 10:26:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752781AbXCRO0c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Mar 2007 10:26:32 -0400
Received: from netrider.rowland.org ([192.131.102.5]:1413 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752776AbXCRO0b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Mar 2007 10:26:31 -0400
Date: Sun, 18 Mar 2007 10:26:26 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Jiri Slaby <jirislaby@gmail.com>
cc: Jiri Kosina <jikos@jikos.cz>, <linux-kernel@vger.kernel.org>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Keyboard stops working after *lock [Was: 2.6.21-rc2-mm1]
In-Reply-To: <45FCFC74.2020407@gmail.com>
Message-ID: <Pine.LNX.4.44L0.0703181012440.18068-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 18 Mar 2007, Jiri Slaby wrote:

> Alan Stern napsal(a):
> > Nothing in the log stands out.  Can you collect an equivalent log using a
> > version of uhci-hcd with the "eliminate skeleton QHs" patch reverted?  
> > Perhaps there will be a significant difference.  Although I doubt it...

...

> The diff after trimming address and timestamps is:
> @@ -1,9 +1,5 @@
> -C Ii:001:01 -2 0
> -S Ci:001:00 s 80 00 0000 0000 0002 2 <
> -C Ci:001:00 0 2 = 0300
> +C Ii:001:01 0 1 = 04
>   S Ii:001:01 -115 2 <
> -S Ci:001:00 s a3 00 0000 0001 0004 4 <
> -C Ci:001:00 0 4 = 00010000
>   S Ci:001:00 s a3 00 0000 0002 0004 4 <
>   C Ci:001:00 0 4 = 01010100
>   S Co:001:00 s 23 01 0010 0002 0000 0

Those differences were caused by your own action: the amount of time 
between insmod uhci-hcd.ko and plugging in the keyboard.  In the first 
test the time was long enough for the root hub to be autosuspended; in the 
second test it wasn't.  As a result, the first test includes the sequences 
used in waking up the root hub.

> @@ -28,8 +24,6 @@
>   C Ci:000:00 0 8 = 12011001 09000008
>   S Co:001:00 s 23 03 0004 0002 0000 0
>   C Co:001:00 0 0
> -C Ii:001:01 0 1 = 04
> -S Ii:001:01 -115 2 <
>   S Ci:001:00 s a3 00 0000 0002 0004 4 <
>   C Ci:001:00 0 4 = 03010000
>   S Co:001:00 s 23 01 0014 0002 0000 0
> @@ -63,8 +57,6 @@
>   S Co:002:00 s 23 03 0008 0003 0000 0
>   C Co:002:00 0 0
>   S Ii:002:01 -115 1 <
> -S Ci:001:00 s a3 00 0000 0002 0004 4 <
> -C Ci:001:00 0 4 = 03010000
>   S Ci:002:00 s a3 00 0000 0001 0004 4 <
>   C Ci:002:00 0 4 = 01010100
>   S Co:002:00 s 23 01 0010 0001 0000 0

Those differences were just accidents of timing.  The driver has a kernel
timer that fires every 250 ms.  In the first test it happened to fire in
the middle of an update sequence and in the second test it didn't.

> @@ -131,3 +123,5 @@
>   S Ii:003:01 -115 8 <
>   S Co:003:00 s 21 09 0200 0000 0001 1 = 01
>   C Co:003:00 0 1 >
> +C Ii:003:01 0 8 = 00000000 00000000
> +S Ii:003:01 -115 8 <

And that difference, of course, is the failure we're trying to fix.  It is 
the NumLock-release message from the keyboard.  So we haven't learned 
anything.

> > I'm running out of ideas.  I tried doing exactly the same thing with a USB
> > keyboard+hub on my system, and it worked perfectly.  This suggests that
> > you might be seeing some weird hardware flaw that is somehow exposed by
> > the patch.
> > 
> > Can you borrow a different USB keyboard and see if it behaves the same 
> > way?  Or can you try using your keyboard on a different computer (one with 
> > UHCI)?
> 
> I'll try my best, but I doubt so, there is neither other linux running around 
> with uhci nor another USB keyboard :(, AFAIK.

I did manage to think of something else for you to try.  It may help pin 
down the source of the problem.

In drivers/usb/host/uhci-q.c, near the start is a function named
uhci_fsbr_on().  Put a "return" statement right at its beginning so that
the function doesn't do anything.  Does that make any difference?

Alan Stern

