Return-Path: <linux-kernel-owner+w=401wt.eu-S1754603AbYLBX0w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754603AbYLBX0w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 18:26:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752812AbYLBX0n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 18:26:43 -0500
Received: from artax.karlin.mff.cuni.cz ([195.113.26.195]:54769 "EHLO
	artax.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752800AbYLBX0n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 18:26:43 -0500
X-Greylist: delayed 1489 seconds by postgrey-1.27 at vger.kernel.org; Tue, 02 Dec 2008 18:26:42 EST
Date: Wed, 3 Dec 2008 00:01:52 +0100 (CET)
From: Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>
To: Pavel Machek <pavel@suse.cz>
cc: clock@atrey.karlin.mff.cuni.cz, kernel list <linux-kernel@vger.kernel.org>,
       aviro@redhat.com
Subject: Re: writing file to disk: not as easy as it looks
In-Reply-To: <20081202094059.GA2585@elf.ucw.cz>
Message-ID: <Pine.LNX.4.64.0812022330160.18533@artax.karlin.mff.cuni.cz>
References: <20081202094059.GA2585@elf.ucw.cz>
X-Personality-Disorder: Schizoid
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2 Dec 2008, Pavel Machek wrote:

> Actually, it looks like POSIX file interface is on the lowest step of
> Rusty's scale: one that is impossible to use correctly. Yes, it seems
> impossible to reliably&safely write file to disk under Linux. Double
> plus uncool.
> 
> So... how to write file to disk and wait for it to reach the stable
> storage, with proper error handling?
> 
> > file
> 
> 	...does not work, because it fails to check for errors.
> 
> touch file || error_handling.
> 
> 	Is not a lot better, unless you mount your filesystems "sync"
> 	... and noone does that.
> 
> dd conv=fsync if=something of=file 2> /dev/zero || error_handling
> 
> 	Is a bit better; not much, unless you mount your filesystems
> 	"dirsync", because you have file data on disk, but they do not have
> 	directory entry pointing to them. Noone uses dirsync.
> 
> 	So you need something like
> 
> dd conv=fsync if=something of=file 2> /dev/zero || error_handling
> fsync . || error_handling
> fsync .. || error_handling
> fsync ../.. || error_handling
> fsync ../../.. || error_handling
> 
> 	... which mostly works...
> 
> 	If you are alone on the filesystem... fsync only returns
> 	errors to the first process. So if you have other process that
> 	does fsync ., maybe it gets "your" error and you do not learn
> 	of the problem.
> 
> Question is... Is there way that I missed and that actually works?
> 									Pavel	

Hi!

I think you are right about this. There's no way how to fsync directory 
reliably.


My idea is that when the filesystem hits metadata write error, it should 
stop commiting any transactions and return error to all writes.

Write errors don't happen because of physical errors on media --- all 
current disks have sector realocation. Write errors can happen because of 
bad cabling, voltage drops, firmware bugs, corruption of PCI bus by rogue 
card, etc. Most of these cases are fixable by the administrator.

If you continue operating the filesystem after a write error (it doesn't 
matter if you report the error to userspace or not), you are risking 
filesystem damage (for example, cross linked files if there was error 
writing the bitmap) or security breach (users reading blocks containing 
deleted data of other users). If you freeze the filesystem on write error 
and do not allow further writes, the administrator can fix the underlying 
problem and the computer will run without any data damage and security 
problems.


It happened to me just yesterday, my disk was spinning down & up 
repeatedly and returning errors because of insufficient power. My kernel 
kicked spadfs filesystem off on the first write error and didn't allow any 
further commits. I fixed the problem by adding the second power supply and 
connecting some disks to it --- and now, after the incident, there are 
zero corruptions. Just imagine what massacre would happen on the 
filesystem if the kernel didn't kick it off and if it were operting under 
the condition "some writes get through - some not" unattended for some 
time.

Mikulas
