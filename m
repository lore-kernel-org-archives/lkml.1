Return-Path: <linux-kernel-owner+w=401wt.eu-S2992554AbXEBAgE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992554AbXEBAgE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 20:36:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992553AbXEBAgE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 20:36:04 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:44158 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992436AbXEBAgB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 20:36:01 -0400
Date: Wed, 2 May 2007 01:35:57 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Josh Triplett <josh@freedesktop.org>, linux-sparse@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: sparse -Wptr-subtraction-blows: still needed?
Message-ID: <20070502003557.GK4095@ftp.linux.org.uk>
References: <4637AC3D.6000008@freedesktop.org> <alpine.LFD.0.98.0705011442320.3808@woody.linux-foundation.org> <4637D47D.7040203@freedesktop.org> <alpine.LFD.0.98.0705011719520.3808@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.98.0705011719520.3808@woody.linux-foundation.org>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 01, 2007 at 05:24:54PM -0700, Linus Torvalds wrote:
> The only thing that was gcc-specific about it is that gcc goes to some 
> extreme lengths to turn the constant-sized division into a sequence of 
> shifts/multiples/subtracts, and can often turn a division into something 
> like ten cheaper operations instead.
> 
> But that optimization was also what made gcc take such a long time if the 
> constant division is very common (ie a header file with an inline 
> function, whether that function is actually _used_ or not apparently 
> didn't matter to gcc)

There used to be a Dumb Algorithm(tm) in there - basically, gcc went through
all decompositions of constant it was multiplying at and it did it in the
dumbest way possible (== without keeping track of the things like "oh, we'd
already looked at the best way to multiply by 69, no need to redo that
again and again)").  _That_ is what blew the build time to hell for a while.
And yes, that particular idiocy got fixed (they added a moderately-sized
LRU of triplets <constant, price, best way to multiply on it>, which killed
recalculation from scratch for each pointer subtraction and got complexity
of dealing with individual subtraction into tolerable range).

That's separate from runtime issues, of course.
