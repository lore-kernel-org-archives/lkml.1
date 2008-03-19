Return-Path: <linux-kernel-owner+w=401wt.eu-S1756665AbYCSUen@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756665AbYCSUen (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 16:34:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757704AbYCSTlV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 15:41:21 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43244 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757691AbYCSTlT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 15:41:19 -0400
Date: Tue, 18 Mar 2008 18:28:19 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
cc: Anders Eriksson <aeriksson@fastmail.fm>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Jens Axboe <jens.axboe@oracle.com>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.25-rc4
In-Reply-To: <200803190221.58968.bzolnier@gmail.com>
Message-ID: <alpine.LFD.1.00.0803181814170.3020@woody.linux-foundation.org>
References: <alpine.LFD.1.00.0803042044460.12253@woody.linux-foundation.org> <20080318133259.E71EE2DC044@tippex.mynet.homeunix.org> <alpine.LFD.1.00.0803180751200.3020@woody.linux-foundation.org> <200803190221.58968.bzolnier@gmail.com>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 19 Mar 2008, Bartlomiej Zolnierkiewicz wrote:
> 
> Which is with compliance with PIO-in protocol specification and years of
> usage of the task_in_intr() code for fs code paths and HDIO_DRIVE_TASKFILE
> ioctl has proven that real hardware also works this way (please note that
> the changed code was used only for HDIO_DRIVE_CMD ioctl requests).

.. and years of drive_cmd_intr() which is much more widely used is *not* 
in agreement.

> If INTRQ is asserted and "BSY is cleared to zero and DRQ is cleared, then
> the device has completed the command with an error." (thus task_in_intr()
> assumed ERR bit to be set), otherwise the value ERR may not be defined
> (however task_in_intr() still assumed that it is OK to check ERR bit).

First off, the patch I sent out _works_.

Secondly, it's a hell of a lot more robust than yours is, exactly because 
it doesn't get confused if the data direction or size bit disagrees with 
the particular command in question.

> This is SMART command with SMART ENABLE ATTRIBUTE AUTOSAVE sub-command
> (feat == 0xd2, nsect == 0xf1) but it should use no-data protocol instead of
> PIO-in which brings us back to commit 18a056feccabdfa9764016a615121b194828bc72
> ("ide: don't enable local IRQs for PIO-in in driver_cmd_intr() (take 2)"):

.. and what about all the magic special IDE commands that may be 
drive-specific? What are we going to do about them?

In other words, we should not try to create an impossible-to-maintain 
piece of shit code that does the wrong thing if you send a command to the 
drive that the IDE layer doesn't understand (but the sending code 
hopefully does).

We should make the core IDE code *robust*. 

Your "real fix" is nothing of the sort. It's just a workaround for the 
fragility of the code that looks at the drive status. The real fix is to 
be robust in the face of even unexpected drive status codes, *especially* 
for the code that handles commands injected by the user!

In other words, you can talk about protocol specifications for things like 
the regular filesystem READ/WRITE commands. But don't create total crap 
like this that depends on the code knowing all possible outcomes of every 
single possible command.

Your patch is utter crap.

You say (about commit 18a056feccabdfa9764016a615121b194828bc72):

> as can be seen before this patch protocol to use was decided basing on DRQ bit
> being set - what would you call _that_ if taskfile code is horrible, he? ;-)

I would call that *correct*.

And my point is, we used to be better. You made the code buggy and fragile 
with that crap commit, and with the others like it (ie the already 
much-mentioned commit 4d977e43d8ae758434e603cf2455d955f71c77c4).

And that is and was *exactly* my point. The reason I called the taskfile 
code horrible was exactly the fact that it only worked if it thought it 
knew exactly what was going on.

Deciding what to do based on the DRQ bit (and the READY/BUSY/ERROR bits) 
is the *right* thing to do. It's the intelligent approach - actually 
tekign the response of the hardware into account, and being robust. The 
*stupid* and horrible thing to do is to think that you know better than 
what the hardware tells you, and think that you can look up every command 
that the user sends in the spec and use *that* to figure out what to do.

Trust the hardware, not the paper. Don't make the code only work when you 
think you know what is going on. Make the code work _always_.

In short, there is no way in hell I'll apply a workaround patch for crap 
code, when we already know what the robust solution is.

		Linus
