Return-Path: <linux-kernel-owner+w=401wt.eu-S1765675AbZDHNij@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765675AbZDHNij (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 09:38:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760822AbZDHNiG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 09:38:06 -0400
Received: from mx1.redhat.com ([66.187.233.31]:35311 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765632AbZDHNiF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 09:38:05 -0400
Date: Wed, 8 Apr 2009 09:37:56 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@hs20-bc2-1.build.redhat.com
To: Jens Axboe <jens.axboe@oracle.com>
cc: device-mapper development <dm-devel@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       ak@linux.intel.com, "MASON, CHRISTOPHER" <CHRIS.MASON@oracle.com>
Subject: Re: [dm-devel] Barriers still not passing on simple dm devices...
In-Reply-To: <20090403081131.GP5178@kernel.dk>
Message-ID: <Pine.LNX.4.64.0904080855340.28196@hs20-bc2-1.build.redhat.com>
References: <20090324143034.GW27476@kernel.dk>
 <Pine.LNX.4.64.0903241033070.4088@hs20-bc2-1.build.redhat.com>
 <20090324150517.GX27476@kernel.dk> <Pine.LNX.4.64.0903251106520.27750@hs20-bc2-1.build.redhat.com>
 <20090325152751.GV27476@kernel.dk> <Pine.LNX.4.64.0903251825310.8027@hs20-bc2-1.build.redhat.com>
 <20090326084205.GG27476@kernel.dk> <Pine.LNX.4.64.0903302314500.6158@hs20-bc2-1.build.redhat.com>
 <20090331104933.GJ5178@kernel.dk> <Pine.LNX.4.64.0904021923040.19415@hs20-bc2-1.build.redhat.com>
 <20090403081131.GP5178@kernel.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > So I'm wondering why Linux developers designed a barrier interface with 
> > complex specification, complex implementation and the interface is useless 
> > to provide any request ordering and it's no better than q->issue_flush_fn 
> > method or whatever was there beffore. Obviously, the whole barrier thing 
> > was designed by a person who never used it in a filesystem.
> 
> That's not quite true, it was done in conjunction with file system
> people.
> ...
> Nobody was interested in barriers when they were done. Nobody.

That's a contradiction :-)


Some times ago I wrote a piece of code that uses barriers for performance 
enhancement 
(http://artax.karlin.mff.cuni.cz/~mikulas/spadfs/download/spadfs-0.9.10.tar.gz).

The used trick is basically to take a lock that prevents filesystem-wide 
updates, submit remaining writes (don't wait), submit the barrier that 
causes transition to new generation (don't wait) and release the lock. The 
lock is held for minimum time, no IO is waited for inside the lock. This 
trick can't be done without barriers, without barriers you'd have to wait 
inside the lock.

And the requirement for this code is that barriers are supported for the 
whole lifetime of the filesystem --- which is what the Linux kernel 
doesn't support! If barrier support is lost, consistency is damaged. 

With barriers, the code does [submit A, submit barrier B, submit C].
If you don't have barriers, you must modify this sequence to: [submit A, 
wait for A endio, submit B, wait for B endio, submit C]

--- and now you are getting the point why failing barriers can't ever work 
--- by the time request B completes, you find out that the device lost 
barrier support and you realize that you should have inserted the waits in 
the past --- but it's too late, there is no way to insert them 
retroactively.

AFAIK this is the only piece of code that uses barriers to improve 
performance. All the other filesystems use barriers just as a way to flush 
cache and don't overlap barrier request with any other requests.

So there are two ways:

- either support only what all in-kernel filesystems do. Using barrier 
reqiests to flush hw cache. You can remove support for barriers with data, 
leave just zero-data barrier, you can remove ordering restrictions. 
In-kernel filesystems never overlap barrier with another metadata request 
(see above why such overlap can't work), so you can freely reorder 
zero-data barriers and simplify the code ... because all the requests that 
could be submitted in paralel with the barrier are either for different 
partition or non-metadata requests to the same partition from prefetch, 
direct io or so.

- or you can allow barriers to be used for purposes as I did. And then, 
there must be clean indicator "this device supports barriers 
*and*will*support*them*in*the*future*". Currently there is no such 
indicator.

Mikulas

> -- 
> Jens Axboe
> 
