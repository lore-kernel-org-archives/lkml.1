Return-Path: <linux-kernel-owner+w=401wt.eu-S1761186AbZCXO3j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761186AbZCXO3j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 10:29:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758876AbZCXO3J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 10:29:09 -0400
Received: from THUNK.ORG ([69.25.196.29]:43262 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758299AbZCXO3G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 10:29:06 -0400
Date: Tue, 24 Mar 2009 10:28:37 -0400
From: Theodore Tso <tytso@mit.edu>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Ingo Molnar <mingo@elte.hu>, Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Nick Piggin <npiggin@suse.de>,
       Jens Axboe <jens.axboe@oracle.com>, David Rees <drees76@gmail.com>,
       Jesper Krogh <jesper@krogh.cc>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29
Message-ID: <20090324142837.GN5814@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>, Ingo Molnar <mingo@elte.hu>,
	Arjan van de Ven <arjan@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	Nick Piggin <npiggin@suse.de>, Jens Axboe <jens.axboe@oracle.com>,
	David Rees <drees76@gmail.com>, Jesper Krogh <jesper@krogh.cc>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <alpine.LFD.2.00.0903231617550.3032@localhost.localdomain> <49C87B87.4020108@krogh.cc> <72dbd3150903232346g5af126d7sb5ad4949a7b5041f@mail.gmail.com> <20090324091545.758d00f5@lxorguk.ukuu.org.uk> <20090324093245.GA22483@elte.hu> <20090324101011.6555a0b9@lxorguk.ukuu.org.uk> <20090324103111.GA26691@elte.hu> <20090324132032.GK5814@mit.edu> <20090324135249.02e2caa2@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090324135249.02e2caa2@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 24, 2009 at 01:52:49PM +0000, Alan Cox wrote:
> 
> At very high rates other things seem to go pear shaped. I've not traced
> it back far enough to be sure but what I suspect occurs from the I/O at
> disk level is that two people are writing stuff out at once - presumably
> the vm paging pressure and the file system - as I see two streams of I/O
> that are each reasonably ordered but are interleaved.

Surely the elevator should have reordered the writes reasonably?  (Or
is that what you meant by "the other one -- #8636 (I assume this is a
kernel Bugzilla #?) seems to be a bug in the I/O schedulers as it goes
away if you use a different I/O sched.?")

> > don't get *that* bad, even with ext3.  At least, I haven't found a
> > workload that doesn't involve either dd if=/dev/zero or a massive
> > amount of data coming in over the network that will cause fsync()
> > delays in the > 1-2 second category.  Ext3 has been around for a long
> 
> I see it with a desktop when it pages hard and also when doing heavy
> desktop I/O (in my case the repeatable every time case is saving large
> images in the gimp - A4 at 600-1200dpi).

Yeah, I could see that doing it.  How big is the image, and out of
curiosity, can you run the fsync-tester.c program I posted while
saving the gimp image, and tell me how much of a delay you end up
seeing?

> > solve.  Simply mounting an ext3 filesystem using ext4, without making
> > any change to the filesystem format, should solve the problem.
> 
> I will try this experiment but not with production data just yet 8)

Where's your bravery, man?  :-)

I've been using it on my laptop since July, and haven't lost
significant amounts of data yet.  (The only thing I did lose was bits
of a git repository fairly early on, and I was able to repair by
replacing the missing objects.)

> > some other users' data files.  This was the reason for Stephen Tweedie
> > implementing the data=ordered mode, and making it the default.
> 
> Yes and in the server environment or for typical enterprise customers
> this is a *big issue*, especially the risk of it being undetected that
> they just inadvertently did something like put your medical data into the
> end of something public during a crash.

True enough; changing the defaults to be data=writeback for the server
environment is probably not a good idea.  (Then again, in the server
environment most of the workloads generally don't end up hitting the
nasty data=ordered failure modes; they tend to be
transaction-oriented, and fsync().)

> > Try ext4, I think you'll like it.  :-)
> 
> I need to, so that I can double check none of the open jbd locking bugs
> are there and close more bugzilla entries (#8147)

More testing would be appreciated --- and yeah, we need to groom the
bugzilla.  For a long time no one in ext3 land was paying attention to
bugzilla, and more recently I've been trying to keep up with the
ext4-related bugs, but I don't get to do ext4 work full-time, and
occasionally Stacey gets annoyed at me when I work late into night...

> Thanks for the reply - I hadn't realised a lot of this was getting fixed
> but in ext4 and quietly

Yeah, there are a bunch of things, like the barrier=1 default, which
akpm has rejected for ext3, but which we've fixed in ext4.  More help
in shaking down the bugs would definitely be appreciated.

   	   	    	       		     - Ted
