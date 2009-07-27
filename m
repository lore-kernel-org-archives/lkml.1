Return-Path: <linux-kernel-owner+w=401wt.eu-S1754530AbZG0UAX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754530AbZG0UAX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 16:00:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754513AbZG0UAW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 16:00:22 -0400
Received: from mx2.redhat.com ([66.187.237.31]:45987 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754505AbZG0UAU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 16:00:20 -0400
Message-ID: <4A6E0431.30000@redhat.com>
Date: Mon, 27 Jul 2009 09:46:57 -1000
From: Zachary Amsden <zamsden@redhat.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090317)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org, axboe@kernel.dk, hch@infradead.org,
       akpm@linux-foundation.org, Paul.Clements@steeleye.com, tytso@mit.edu,
       Tejun Heo <tj@kernel.org>, miklos <miklos@szeredi.hu>
Subject: Re: [PATCH] Allow userspace block device implementation
References: <4A6D79F6.3050509@redhat.com>	<1248699365.6987.1628.camel@twins> <20090727142536.465799aa@lxorguk.ukuu.org.uk>
In-Reply-To: <20090727142536.465799aa@lxorguk.ukuu.org.uk>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
>> Somehow this made me think of FUSE/CUSE... should this be named aBUSE?
>> Oh wait it is :-), what I'm after is I guess is, can we share some of
>> the FUSE/CUSE code?

Well, it is A Block device in User SpacE :)  I don't think there is a
lot of code sharing benefit in some 800 odd lines, but I could be wrong.

> It reminds me of the existing and perfectly functional network block
> device (nbd) we already have and which has also been present for years.

Yes, I agree, in fact I looked at nbd as I was writing this, but I
believe it is different enough to warrant further investigation.

The network block device requires access to a socket, which the code at
least seems to imply brings up the potential for deadlocks when
self-hosting.  This was designed to explicitly support self-hosting.

This device can be used without CONFIG_NET (not a big advantage, I
agree), and is completely connectionless, which I would argue is a big
advantage.

NBD is perfectly functional, but it seemed more complicated than
necessary for a purely local implementation.  A fully functional null
server (just returns zeros, full error checking and normal whitespace)
can be implemented in about 60 lines of C code, which I don't think is
the case for NBD.  Of course, I'm sure it is possible with PERL bindings
as a one-liner, but the fundamental argument isn't about lines, it's
about complexity.  NBD requires socket allocation, listening and
connection; this requires only opening of a device node.

Can you swap over NBD?  Assuming one had pinned the userspace program
and it pre-allocated all memory so no pagein / alloc was required, would
it be deadlock proof?  I believe there are structure allocations
required for the socket implementation that go beyond the basic BIO
allocations, therefore making it impossible.  In /theory/, one should be
able to swap over this device.  In practice, it's probably a really bad
idea.

It seems then that NBD is a strict subset of the functionality provided
by this type of module.

Zach
