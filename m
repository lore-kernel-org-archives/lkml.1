Return-Path: <linux-kernel-owner+w=401wt.eu-S1756757AbZDPOyj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756757AbZDPOyj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 10:54:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753008AbZDPOya
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 10:54:30 -0400
Received: from thunk.org ([69.25.196.29]:51481 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750990AbZDPOya (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 10:54:30 -0400
Date: Thu, 16 Apr 2009 10:53:57 -0400
From: Theodore Tso <tytso@mit.edu>
To: Andrew Price <andy@andrewprice.me.uk>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: BUG: using rootfstype=ext4 causes oops
Message-ID: <20090416145357.GM21586@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Andrew Price <andy@andrewprice.me.uk>,
	"Rafael J. Wysocki" <rjw@sisk.pl>,
	Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
	linux-kernel@vger.kernel.org
References: <20090415205926.GA28246@sucs.org> <20090416041945.GK21586@mit.edu> <20090416104758.GA433@sucs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090416104758.GA433@sucs.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 16, 2009 at 11:47:58AM +0100, Andrew Price wrote:
> On Thu, Apr 16, 2009 at 12:19:45AM -0400, Theodore Tso wrote:
> > The stack traces are in the IDE interrupt
> > handler, so it seems surprising that ext4 would trigger it but ext3
> > would not.  Have you tried ext4 on any earlier kernel?
> 
> It happened with linux-2.6.git kernels earlier in the week when I
> started trying rootfstype=ext4 but I haven't tried properly bisecting it
> yet.
> 
> > The main difference I can think of is that ext4 enables barriers by
> > default; maybe that's the case of the IDE breakage?  Can you try
> > booting with the boot command option "rootfsflags=barrier=0" as well
> > as "rootfstype=ext4", and see if that helps?
> 
> I added rootflags=barrier=0 ...
> 
> ... and it doesn't panic.
> 
> > If so, it's a bug in the IDE code in that it's not handling barriers
> > correctly.
> 
> Bingo.

OK, can you confirm that you tried using ext4 with either 2.6.29 or
2.6.28, and it was working previously?  That would make it a
regression which Rafael would track.

Also, I'd suggest sending Bartolmiej details about what IDE controller
you have (the dmesg during a boot under ext3 or ext4 w/ barrier=0
would also be useful), so he can track it down.  It might be specific
to a particular IDE controller/device, and not be a generalized IDE
problem, after all.

Anyway, I'll hand this bug off to Raefael's and/or Bartlomiej's very
capable hands, since I suspect you could also reproduce this using
rootfstype=ext3 rootfsflags=barrier=1, and that this is purely an IDE
driver problem.

Regards,

						- Ted

> (aside: the ext4 docs say the param is "barriers" with an s; it isn't).

P.S.  Where in the documentation file do we have the mount option as
"barriers=0".  I went looking for it, and I couldn't find it.  What I
see is:

barrier=<0|1(*)>	This enables/disables the use of write barriers in
			the jbd code.  barrier=0 disables, barrier=1 enables.
			This also requires an IO stack which can support
			barriers, and if jbd gets an error on a barrier
			write, it will disable again with a warning.
			Write barriers enforce proper on-disk ordering
			of journal commits, making volatile disk write caches
			safe to use, at some performance penalty.  If
			your disks are battery-backed in one way or another,
			disabling barriers may safely improve performance.


