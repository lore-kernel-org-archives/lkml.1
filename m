Return-Path: <linux-kernel-owner+w=401wt.eu-S1759933AbZCXMYd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759933AbZCXMYd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 08:24:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754558AbZCXMYX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 08:24:23 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:57879 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753805AbZCXMYW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 08:24:22 -0400
Date: Tue, 24 Mar 2009 12:23:26 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Arjan van de Ven <arjan@infradead.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Nick Piggin <npiggin@suse.de>,
       Theodore Tso <tytso@mit.edu>, Jens Axboe <jens.axboe@oracle.com>,
       David Rees <drees76@gmail.com>, Jesper Krogh <jesper@krogh.cc>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29
Message-ID: <20090324122326.6be519f2@lxorguk.ukuu.org.uk>
In-Reply-To: <20090324041249.1133efb6.akpm@linux-foundation.org>
References: <alpine.LFD.2.00.0903231617550.3032@localhost.localdomain>
	<49C87B87.4020108@krogh.cc>
	<72dbd3150903232346g5af126d7sb5ad4949a7b5041f@mail.gmail.com>
	<20090324091545.758d00f5@lxorguk.ukuu.org.uk>
	<20090324093245.GA22483@elte.hu>
	<20090324101011.6555a0b9@lxorguk.ukuu.org.uk>
	<20090324103111.GA26691@elte.hu>
	<20090324041249.1133efb6.akpm@linux-foundation.org>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The proposed tweak to kjournald is a bad fix - partly because it will
> elevate the priority of vast amounts of IO whose priority we don't _want_
> elevated.

Its a huge improvement in practice because it both fixes the stupid
stalls and smooths out the rest of the I/O traffic. I spend a lot of my
time looking at what the disk driver is getting fed and its not a good
mix. Even more revealing is the noop scheduler and the fact this
frequently outperforms all the fancy I/O scheduling we do even on
relatively dumb hardware (as well as showing how mixed up our I/O
patterns currently are).

> But mainly because the problem lies elsewhere - in an area of contention
> between the committing and running transactions which we knowingly and
> reluctantly added to fix a bug in

The problem emerges about 2007 not 2002, so its not that simple.

> The number of people who can be looked at to do serious ext3/JBD work is
> pretty small now.  Ted, Stephen and I got old and died.  Jan does good work
> but is spread thinly.

Which is all the more reason to use a temporary fix in the meantime so
the OS is usable. I think its pretty poor that for over a year those in
the know who need a good performing system are having to apply out of
tree trivial patches rejected on the basis that "eventually like maybe
whenever perhaps we'll possibly some day you know consider fixing this,
but don't hold your breath"

There is a second reason to do this: If ext4 is the future then it is far
better to fix this stuff in ext4 properly and leave ext3 clear of
extremely invasive high risk fixes when a quick bandaid will do just fine
for the remaining lifetime of fs/jbd

Also not kjournald is only one of the afflicted threads - the same is
true of the crypto, and of the vm writeback. Also note the other point
about the disk scheduler defaults being terrible for some streaming I/O
patterns and the patch for that is also stuck in bugzilla.

If picking "no-op" speeds up my generic x86 box with random onboard SATA
we are doing something very non-optimal
