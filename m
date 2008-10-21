Return-Path: <linux-kernel-owner+w=401wt.eu-S1753451AbYJUPbW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753451AbYJUPbW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 11:31:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751194AbYJUPbN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 11:31:13 -0400
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:39540 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751118AbYJUPbM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 11:31:12 -0400
Date: Tue, 21 Oct 2008 11:31:05 -0400
From: Theodore Tso <tytso@mit.edu>
To: =?iso-8859-1?Q?Rog=E9rio?= Brito <rbrito@ime.usp.br>
Cc: Alexandre Lymberopoulos <lymber@gmail.com>, 502583@bugs.debian.org,
       502583-submitter@bugs.debian.org, linux-kernel@vger.kernel.org,
       rafael@debian.org
Subject: Re: Bug#502583: scary messages in dmesg
Message-ID: <20081021153105.GD15685@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	=?iso-8859-1?Q?Rog=E9rio?= Brito <rbrito@ime.usp.br>,
	Alexandre Lymberopoulos <lymber@gmail.com>, 502583@bugs.debian.org,
	502583-submitter@bugs.debian.org, linux-kernel@vger.kernel.org,
	rafael@debian.org
References: <2bfaaf400810172145g4aba4827l87a19e67b9742815@mail.gmail.com> <20081018060400.GB916@ime.usp.br> <2bfaaf400810201654u21c9d950o72b2afa9496ba3da@mail.gmail.com> <20081021101510.GA16244@ime.usp.br> <20081021123348.GB15685@mit.edu> <20081021143500.GA18469@ime.usp.br>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20081021143500.GA18469@ime.usp.br>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 21, 2008 at 12:35:00PM -0200, Rogério Brito wrote:
> > I don't know if you would call it a bug or not.  Fundamentally,
> > yanking out a USB stick without unmounting it first is dangerous, and
> > can lead to data loss.
> 
> At least sync'ing...

I'm loath to suggest "just syncing", because if there is some program
still writing to the USB stick (example: you fire up openoffice and
ask it to "export to PDF".  That command returns instantly, and the
PDF export happens in the background --- as you will discover if you
try to exit OpenOffice.  Well, if a user doesn't try to exit
OpenOffice, and just uses the "sync" command, they could still end up
trashing data.

Also note that for older flash drives, pulling the power while it is
writing could potentially lead to corruption of the USB stick's flash
translation layer (FTL), which could cause the device to become
totally non-functional.  It's for that reason that one particular
Digital SLR's stop writing to the compact flash card the instant the
access door to the flash card is opened, throwing away all of the last
7-8 pictures in the digital camera's write buffer.  I'm assuming they
did this because some users ejected the flash card while it was
writing leading to loss of the flash card plus *all* of the pictures
on the flash card, and they decided the risk of having a Very Unhappy
User was worth the tradeoff of throwing away only the recently taken
photographs that hadn't made it onto the card yet.

If you have a USB stick that has a flashing light to indicate write
activity, and you type the "sync" command, and you wait for the
flashing light to stop, and you *know* nothing else might be trying to
write to the device, sure it might be safe to eject.  But if we have a
command-line user who knows enough to type "sync" into a command-line
shell, wouldn't it be better to create a setuid shell command, call it
something like "usbeject" which finds any USB storage device that was
auto-mounted (i.e., not mounted manually by the user or via an
/etc/fstab entry), and if there is only one such devices,
automatically tries to unmount it?  If there is more than one such
device, it should ask the user (or maybe use lsof to see if there is
only one that appears not to be in use), and if it fails, it should
print a huge warning message as well as the output of "lsof" so the
user knows which program(s) to close before unmounting the device.

Solving this problem for desktop users is harder; probably the best
thing you can do is to throw up "shame" dialog box telling them that
they did Something Wrong, and while they may have gotten lucky this
time, that next time they should close all programs using the USB
storage device, and then right-click on the mounted disk icon and
select "eject".  That's what Windows does, and IIRC, what Mac OS X
does; there really isn't much else that can be done.

Regards,

						- Ted
