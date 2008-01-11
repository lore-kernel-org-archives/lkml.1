Return-Path: <linux-kernel-owner+w=401wt.eu-S1762210AbYAKSXd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762210AbYAKSXd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 13:23:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761497AbYAKSXZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 13:23:25 -0500
Received: from brick.kernel.dk ([87.55.233.238]:8800 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760817AbYAKSXY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 13:23:24 -0500
Date: Fri, 11 Jan 2008 19:23:19 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Daniel Phillips <phillips@phunq.net>
Cc: linux-kernel@vger.kernel.org, chris.mason@oracle.com,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH][RFC] fast file mapping for loop
Message-ID: <20080111182319.GB6258@kernel.dk>
References: <20080109085231.GE6650@kernel.dk> <200801111017.28753.phillips@phunq.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200801111017.28753.phillips@phunq.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 11 2008, Daniel Phillips wrote:
> Hi Jens,
> 
> This looks really useful.
> 
> On Wednesday 09 January 2008 00:52, Jens Axboe wrote:
> > Disadvantages:
> >
> > - The file block mappings must not change while loop is using the
> > file. This means that we have to ensure exclusive access to the file
> > and this is the bit that is currently missing in the implementation.
> > It would be nice if we could just do this via open(), ideas
> > welcome... 
> 
> Get_block methods are pretty fast and you have caching in the level 
> above you, so you might be able to get away with no cache of physical 
> addresses at all, in which case you just need i_mutex and i_alloc_sem 
> at get_block time.  This would save a pile of code and still have the 
> main benefit of avoiding double caching.

I'm not too fond of the tree either, but it serves an important purpose
as well - we need to be careful in calling bmap() as not to deadlock the
fs under vm pressure. So the current code punts to a thread for bmap()
on extents we don't already have stored in loop. And that slows things
down of course, we would have to still punt every IO to loopd instead of
just doing a quick remap. But...

> If you use ->get_block instead of bmap, it will fill in file holes for 
> you, but of course get_block is not exposed, and Al is likely to bark 
> at anyone who exposes it.
> 
> Instead of exposing get_block you could expose an aops method 
> like ->bio_transfer that would hide the use of *_get_block in a library 
> routine, just as __blockdev_direct_IO does.  Chances are, there are 
> other users besides loop that would be interested in a generic way of 
> performing bio transfers to files.
> 
> I presume you would fall back to the existing approach for any 
> filesystem without get_block.  You could handle this transparently with 
> a default library method that does read/write.

... things are already moving forward, Chris has a new interface for
this and tied it in with the loop fastfs mode. I think he'll post it
later today.

-- 
Jens Axboe

