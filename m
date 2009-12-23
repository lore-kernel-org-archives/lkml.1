Return-Path: <linux-kernel-owner+w=401wt.eu-S1755995AbZLWVsQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755995AbZLWVsQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 16:48:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752654AbZLWVsO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 16:48:14 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52019 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751686AbZLWVsN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 16:48:13 -0500
Date: Wed, 23 Dec 2009 13:48:09 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Greg KH <gregkh@suse.de>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org
Subject: Re: [GIT PATCH] USB patches for 2.6.33-rc1
In-Reply-To: <20091223194951.GA18101@kroah.com>
Message-ID: <alpine.LFD.2.00.0912231335380.6879@localhost.localdomain>
References: <20091223194951.GA18101@kroah.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 23 Dec 2009, Greg KH wrote:
> 
> They do:
> 	- reorg the device ids in one usb-serial driver.  I took this
> 	  now as it's a merge pressure point, and this is just a code
> 	  move now, no functionality changed at all.  It's odd that git
> 	  didn't show this as a code move in the diffstat, I used:
> 	  	git diff -m --stat --summary
> 	  to generate the diffstat.  Should I be doing something else?
> 	  Or is it because the code is being removed from one file and
> 	  placed in another one?

Since the old file stays around, git doesn't consider it a rename.

Now, you can actually change that a bit. You can use -C instead of -M, 
which enables copy-detection rather than just renames, and then it changes 
from

 drivers/usb/serial/ftdi_sio.c           |    1 +
 drivers/usb/serial/ftdi_sio.h           |  959 +------------------------------
 drivers/usb/serial/ftdi_sio_ids.h       |  986 +++++++++++++++++++++++++++++++

to

 drivers/usb/serial/ftdi_sio.c                     |    1 +
 drivers/usb/serial/ftdi_sio.h                     |  959 +-----------
 drivers/usb/serial/{ftdi_sio.h => ftdi_sio_ids.h} | 1785 ++++++++-------------
 copy drivers/usb/serial/{ftdi_sio.h => ftdi_sio_ids.h} (65%)

which isn't actually any better (since while it notices the copy of the 
data, it _removes_ all the code whily copying, so the total number of 
lines actually goes up!).

So -M doesn't really "help" in that the diff itself does end up larger, 
but at the same time it is somewhat informative in the sense that you do 
see where the data comes from.

To see another facet of it all, you could also use "-B" to say that you 
want to Break all old name associations if a file has changed a lot, and 
then enable rename (or copy) detection, and get

 drivers/usb/serial/ftdi_sio.c                     |    1 +
 drivers/usb/serial/ftdi_sio.h                     | 2063 ++++++---------------
 drivers/usb/serial/{ftdi_sio.h => ftdi_sio_ids.h} | 1785 +++++++------------
 rewrite drivers/usb/serial/ftdi_sio.h (68%)
 rename drivers/usb/serial/{ftdi_sio.h => ftdi_sio_ids.h} (65%)

which is the largest of all diffs but it shows another side of the 
situation: that sio.h file has is now a "rewrite", and the end result is 
substantially different from the original. So git shows it as a "rename in 
place" where the diff shows up as a total delete followed by a total 
addition.

As you can see, git does see that you moved data around, but since a lot 
of the data also _stayed_ in the original file, the copy/break operations 
really don't help. You cannot show "copy this part of this file into that 
other file" as a diff.

Btw, we _do_ do the "copy this part of this file into that other file" 
when you do "git blame -C", so you can now do

	git blame -C drivers/usb/serial/ftdi_sio_ids.h

and it will follow the history of the lines in that file back to the 
ftdi_sio.h file. So the fact that git doesn't show it in the diffs is 
really because diffs always work on a whole-file basis (ie you can show a 
"rename file" diff, but you can't show a "move one function or a set of 
ID's from one file to another" diff.

		Linus
