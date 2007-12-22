Return-Path: <linux-kernel-owner+w=401wt.eu-S1752334AbXLVBOh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752334AbXLVBOh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2007 20:14:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750836AbXLVBOa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Dec 2007 20:14:30 -0500
Received: from thunk.org ([69.25.196.29]:60271 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750724AbXLVBO3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2007 20:14:29 -0500
Date: Fri, 21 Dec 2007 20:14:00 -0500
From: Theodore Tso <tytso@mit.edu>
To: Andrew Lutomirski <luto@myrealbox.com>
Cc: Phillip Susi <psusi@cfl.rr.com>, David Newall <david@davidnewall.com>,
       John Reiser <jreiser@bitwagon.com>, Matt Mackall <mpm@selenic.com>,
       linux-kernel@vger.kernel.org, security@kernel.org
Subject: Re: /dev/urandom uses uninit bytes, leaks user data
Message-ID: <20071222011400.GE8601@thunk.org>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Andrew Lutomirski <luto@myrealbox.com>,
	Phillip Susi <psusi@cfl.rr.com>,
	David Newall <david@davidnewall.com>,
	John Reiser <jreiser@bitwagon.com>, Matt Mackall <mpm@selenic.com>,
	linux-kernel@vger.kernel.org, security@kernel.org
References: <20071214201305.GL19691@waste.org> <20071214232322.GE17344@thunk.org> <47632010.6030709@BitWagon.com> <20071215043208.GF17344@thunk.org> <4766A40D.4080804@BitWagon.com> <20071217173623.GC7070@thunk.org> <476719E5.1010505@myrealbox.com> <cb0375e10712192018l66671b34r1680077765e89fb0@mail.gmail.com> <476ACDBE.2070600@cfl.rr.com> <cb0375e10712210810p36fc9995s345d23b7dff5a3b3@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cb0375e10712210810p36fc9995s345d23b7dff5a3b3@mail.gmail.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 21, 2007 at 11:10:36AM -0500, Andrew Lutomirski wrote:
> > > Step 1: Boot a system without a usable entropy source.
> > > Step 2: add some (predictable) "entropy" from userspace which isn't a
> > > multiple of 4, so up to three extra bytes get added.
> > > Step 3: Read a few bytes of /dev/random and send them over the network.
> >
> > Only root can do 1 and 2, at which point, it's already game over.
> 
> Again, no.  Root could do this accidentally.  Step 1 happens all the
> time (see the comments on non-unique UUIDs).  

Actually, it doesn't happen *all* the time.  That was a situation of
an rpm post-install script trying to use a random UUID generation
facility from a kick-start install where there was no keyboard
activity and apparently no other entropy added.  (Note that in such an
environment, generation of host ssh keys at install time without any
entropy is an even bigger problem, and that *is* something that people
should be thinking about.)

> Step 2 just requires a
> program to put data which it things is OK to go into the pool next to
> data that shouldn't be there in memory.  

Um, no, that's incorrect.  Simply putting data which is OK to put into
the pool next to data that shouldn't isn't enough.  First of all, the
issue is using unitialized kernel stack garbage.  Read that again,
slowly --- kernel stack.  How you arrange your data in user memory
doesn't matter.  Secondly, as I've said earlier, I'm not aware of any
program that actually tries to write into the entropy pool on most
modern Linux systems other than dd in /etc/init.d/random which
initializes the random pool from pre-seeded entropy on disk. 

    	       	    	 	    	    - Ted
