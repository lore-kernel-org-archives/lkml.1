Return-Path: <linux-kernel-owner+w=401wt.eu-S1757139AbYBIRjS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757139AbYBIRjS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2008 12:39:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754950AbYBIRjF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Feb 2008 12:39:05 -0500
Received: from www.tglx.de ([62.245.132.106]:32926 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753942AbYBIRjC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2008 12:39:02 -0500
Date: Sat, 9 Feb 2008 18:38:50 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andi Kleen <ak@suse.de>
cc: mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [3/5] CPA: Make advised protection check truly
 advisory
In-Reply-To: <200802091756.06553.ak@suse.de>
Message-ID: <alpine.LFD.1.00.0802091809480.3145@apollo.tec.linutronix.de>
References: <20080208536.837219990@suse.de> <20080208163614.DF4FC1B41AA@basil.firstfloor.org> <alpine.LFD.1.00.0802091602260.3145@apollo.tec.linutronix.de> <200802091756.06553.ak@suse.de>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 9 Feb 2008, Andi Kleen wrote:
> On Saturday 09 February 2008 16:38:35 Thomas Gleixner wrote:
> > On Fri, 8 Feb 2008, Andi Kleen wrote:
> > 
> > > 
> > > Only force RO in the advisory protection checks when all pages in the 
> > > range are RO. Previously it would trigger when any page in the range
> > > was ro.
> > > 
> > > I believe this will make try_preserve_large_page much safer to use.
> > 
> > It might be quite useful to know it for sure.
> 
> I wrote that originally when you still had the bogus "AMD fix" 
> in the tree.  I think it was because I hoped it would fix that one,
> but I wasn't sure because I couldn't reproduce it. But Hugh's
> patch fixed that anyways.

The AMD limiting was due to a testing failure on a 64bit X2 and had
nothing to do with the 32bit wreckage, which was fixed by Hugh. 

The fix for the X2 was a missing check for large pmds/puds in the
spurious fault code.

> > Thinking about the whole set of changes, you are right, that the
> > current check for the first page only is not correct, but I don't see
> > how your changes make it more correct.
> 
> With my patch at least NX should be always correct and that is 
> the more important one because it is default and has to be cleared
> and things go horribly wrong when it is incorrect.
> 
> RO on the other hand defaults to off and is only sometimes forced.
>  
> > The correct way to fix this is to check, whether all the small pages,
> > which fit in the range of the large page, which we want to preserve,
> > have the same resulting pgprot flags.
> 
> Ok if you don't like the try_preserve_large_page change
> feel free to drop it or implement it differently.
> 
> My main goal here was to clean up the 32bit direct mapping
> anyways (last patch) and that does just require splitting out the 
> NX checks from the RO checks and having a range (first patches)
> 
> I think at least the range checks are definitely needed
> for correctness though.
> 
> If I cared particularly I would probably implement two modi: 
> one with DEBUG_RODATA and another without. With DEBUG_RODATA 
> advisory protections should be forced (and large pages split),
> without not.

I can understand, what you want to achieve, but I really do not like
the result for following reasons:

1) If there is a bug in some code, then we fix the bug and do not
intermingle it with something else.

2) I care about RO as much as I care about the NX correctness. That's
the same logic and the same problem. If we have overlapping regions,
then we need to split large pages. Otherwise both protections are
useless to a certain degree.

3) For correctness reasons I even ponder to make the NX/RO mandatory.

Thanks,
	tglx
