Return-Path: <linux-kernel-owner+w=401wt.eu-S1754973AbYHLO6Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754973AbYHLO6Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 10:58:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751651AbYHLO6R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 10:58:17 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:44286 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751993AbYHLO6Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 10:58:16 -0400
Subject: Re: checkpoint/restart ABI
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Theodore Tso <tytso@mit.edu>, Arnd Bergmann <arnd@arndb.de>,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Peter Chubb <peterc@gelato.unsw.edu.au>,
       Daniel Lezcano <daniel.lezcano@fr.ibm.com>
In-Reply-To: <48A0CD86.6030704@goop.org>
References: <20080807224033.FFB3A2C1@kernel>
	 <200808090013.41999.arnd@arndb.de> <20080811152201.GB25930@us.ibm.com>
	 <200808111853.13854.arnd@arndb.de> <1218484114.5598.43.camel@nimitz>
	 <48A0CD86.6030704@goop.org>
Content-Type: text/plain
Date: Tue, 12 Aug 2008 07:58:11 -0700
Message-Id: <1218553091.5598.76.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-08-11 at 16:38 -0700, Jeremy Fitzhardinge wrote:
> This feature, as it currently stands, is essentially useless for any 
> practical purpose.  Self-checkpointing a single process with no handling 
> of non-file file descriptors and no proper handling of file 
> file-descriptors is not very useful.
> 
> My understanding that this is basically a prototype for a more useful 
> multi-process or container-wide checkpoint facility.

Yes, that's exactly it.  We're diverging from discussing the important
bits as it is, and I think we'd do that more and more with extra
code. :)

> While you could try to come up with an extensible file format that would 
> be able to handle any future extensions, the chances are you'd get it 
> wrong and need to break file format compatibility anyway.

Amen to that.  I won't speak for the rest of the whackos interested in
this stuff, but I *KNOW* I'm not clever enough to pull it off.

> I'm more interested in seeing a description of how you're doing to 
> handle things like:
> 
>     * multiple processes
>     * pipes
>     * UNIX domain sockets
>     * INET sockets (both inter and intra machine)
>     * unlinked open files
>     * checkpointing file content
>     * closed files (ie, files which aren't currently open, but will be
>       soon, esp tmp files)
>     * shared memory
>     * (Peter, what have I forgotten?)
> 
> Having gone through this before, I don't think an all-kernel solution 
> can work except for the most simple cases.

So, there's a lot of stuff there.  The networking stuff is way out of my
league, so I'll cc Daniel and make him answer. :)

All of the other stuff has been done in various in-kernel
implementations.  OpenVZ, IBM's Metacluster, Zap (Oren's work at
Columbia).  Most of it *can* be done from userspace, but some of it is
very painful.  There are some good OLS papers describing most of these
things.  Zap might have had one or two academic papers written about it.
Maybe.  ;)

Unlinked files, for instance, are actually available in /proc.  You can
freeze the app, write a helper that opens /proc/1234/fd, then copies its
contents to a linked file (ooooh, with splice!)  Anyway, if we can do it
in userspace, we can surely do it in the kernel.

I'm not sure what you mean by "closed files".  Either the app has a fd,
it doesn't, or it is in sys_open() somewhere.  We have to get the app
into a quiescent state before we can checkpoint, so we basically just
say that we won't checkpoint things that are *in* the kernel.

Is there anything specific you are thinking of that particularly worries
you?  I could write pages on the list you have there.

> Which, come to think of it, is an important point.  What are the 
> expected use-cases for this feature?  Do you really mean 
> checkpoint/restart?  Do you expect to be able to checkpoint a process, 
> leave it running, then "rewind" by restoring the image?  Or does 
> checkpoint always atomically kill the source process(es)?  Are you 
> expecting to be able to resume on another machine?

Yes.

We all want different things, and there are a lot of people interested
in this stuff.  So, I think all of what you've mentioned above are
goals, at least long term.  Some, *really* long term.

I don't want to get into a full virtualization vs. containers debate,
but we also want it for all the same reasons that you migrate Xen
partitions.

> Lightweight filesystem checkpointing, such as btrfs provides, would seem 
> like a powerful mechanism for handling a lot of the filesystem state 
> problems.  It would have been useful when we did this...

Yup.  We were just chatting about that with some filesystem folks last
week.  But, as the OpenVZ dudes like to mention, the poor man's way of
moving filesystem snapshots around is always rsync.

-- Dave

