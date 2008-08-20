Return-Path: <linux-kernel-owner+w=401wt.eu-S1755057AbYHTADt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755057AbYHTADt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 20:03:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753450AbYHTADl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 20:03:41 -0400
Received: from tau.jukie.net ([216.239.93.128]:40290 "EHLO tau.jukie.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753421AbYHTADk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 20:03:40 -0400
Date: Tue, 19 Aug 2008 20:03:39 -0400
From: Bart Trojanowski <bart@jukie.net>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Cc: Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: vfat BKL/lock_super regression in v2.6.26-rc3-g8f59342
Message-ID: <20080820000339.GB28029@jukie.net>
References: <20080819220311.GA28029@jukie.net> <alpine.LFD.1.10.0808191505590.3324@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0808191505590.3324@nehalem.linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Linus Torvalds <torvalds@linux-foundation.org> [080819 18:19]:
> And I think you hit this issue because you probably mounted the USB stick 
> as a "sync" (or dirsync) mount - which is what some distros do by default, 
> even if it is known to cause problems for some flash cards that don't do a 
> good job at wear levelling.

You're right.  I turned on sync a while back so I could just pull the
stick out w/o the need to do a manual sync... probably not a good idea
on my part with respect to the wear of the media.

> But it's good that you did that, because all _my_ testing (which was 
> admittedly very deficient) had been done with a default mount without that 
> thing.

My ignorance paid off!

> Btw, quite often, the right solution may be to remove one of the locks 
> entirely. FAT should actually have been largely BKL free, and my 
> conversion of BKL to super-lock was "overly eager" exactly because it's 
> easier to find deadlocks (and debug things carefully and handle them as 
> they pop up) than it is to find races (which are almost impossible to 
> debug and pinpoint).

I totally agree.  After spending a couple of hours (while doing other
things) bisecting the tree, I found the commit that introduced the
regression.  In contrast, I was able to find the double-lock in 5
minutes.

> In particular, I think fat_write_inode() really is safe.

I wasn't sure there.

> So I'm pretty sure the right fix is to just remove [un]lock_super() 
> entirely from fat_write_inode(). 

Ok, I will test your patch and let you know in a few minutes.

-Bart

-- 
				WebSig: http://www.jukie.net/~bart/sig/
