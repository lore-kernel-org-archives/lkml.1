Return-Path: <linux-kernel-owner+w=401wt.eu-S1752892AbZFBMKl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752892AbZFBMKl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 08:10:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752358AbZFBMKe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 08:10:34 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33010 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751601AbZFBMKd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 08:10:33 -0400
Date: Tue, 2 Jun 2009 14:10:31 +0200
From: Nick Piggin <npiggin@suse.de>
To: Andi Kleen <andi@firstfloor.org>
Cc: hugh@veritas.com, riel@redhat.com, akpm@linux-foundation.org,
       chris.mason@oracle.com, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, fengguang.wu@intel.com
Subject: Re: [PATCH] [13/16] HWPOISON: The high level memory error handler in the VM v3
Message-ID: <20090602121031.GC1392@wotan.suse.de>
References: <200905271012.668777061@firstfloor.org> <20090527201239.C2C9C1D0294@basil.firstfloor.org> <20090528082616.GG6920@wotan.suse.de> <20090528093141.GD1065@one.firstfloor.org> <20090528120854.GJ6920@wotan.suse.de> <20090528134520.GH1065@one.firstfloor.org> <20090601120537.GF5018@wotan.suse.de> <20090601185147.GT1065@one.firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090601185147.GT1065@one.firstfloor.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 01, 2009 at 08:51:47PM +0200, Andi Kleen wrote:
> On Mon, Jun 01, 2009 at 02:05:38PM +0200, Nick Piggin wrote:
> > On Thu, May 28, 2009 at 03:45:20PM +0200, Andi Kleen wrote:
> > > On Thu, May 28, 2009 at 02:08:54PM +0200, Nick Piggin wrote:
> > > > Then the data can not have been consumed, by DMA or otherwise? What
> > > 
> > > When the data was consumed we get a different machine check
> > > (or a different error if it was consumed by a IO device)
> > > 
> > > This code right now just handles the case of "CPU detected a page is broken
> > > is wrong, but hasn't consumed it yet"
> > 
> > OK. Out of curiosity, how often do you expect to see uncorrectable ECC
> > errors?
> 
> That's a difficult question. It depends on a lot of factors, e.g. 
> how much memory you have (but memory sizes are growing all the time), 
> how many machines you have (large clusters tend to turn infrequent errors 
> into frequent ones), how well your cooling and power supply works etc.
> 
> I can't give you a single number at this point, sorry.

That's OK. I don't doubt they happen, I was just curious. Although
for me with my pesant amounts of memory I never even see corrected
transient ECC errors ;)

 
> > Just extract the part where it has the page locked into a common
> > function.
> 
> That doesn't do some stuff we want to do, like try_to_release_buffers
> And there's the page count problem with remove_mapping
> 
> That could be probably fixed, but to be honest I'm uncomfortable
> fiddling with truncate internals.

You're looking at invalidate, which is different. See my
last patch.


> > > Is there anything concretely wrong with the current code?
> > 
> > 
> > /*
> >  * Truncate does the same, but we're not quite the same
> >  * as truncate. Needs more checking, but keep it for now.
> >  */
> > 
> > I guess that it duplicates this tricky truncate code and also
> > says it is different (but AFAIKS it is doing exactly the same
> > thing).
> 
> It's not, there are various differences (like the reference count)

No. If there are, then it *really* needs better documentation. I
don't think there are, though.

 
> > > > Well, the dirty data has never been corrupted before (ie. the data
> > > > in pagecache has been OK). It was just unable to make it back to
> > > > backing store. So a program could retry the write/fsync/etc or
> > > > try to write the data somewhere else.
> > > 
> > > In theory it could, but in practice it is very unlikely it would.
> > 
> > very unlikely to try rewriting the page again or taking evasive
> > action to save the data somewhere else? I think that's a bold
> > assumption.
> > 
> > At the very least, having a prompt "IO error, check your hotplug
> > device / network connection / etc and try again" I don't think
> > sounds unreasonable at all.
> 
> I'm not sure what you're suggesting here. Are you suggesting
> corrupted dirty page should return a different errno than a traditional 
> IO error?
> 
> I don't think having a different errno for this would be a good
> idea. Programs expect EIO on IO error and not something else.
> And from the POV of the program it's an IO error.
> 
> Or are you suggesting there should be a mechanism where
> an application could query about more details about a given
> error it retrieved before? I think the later would be useful
> in some cases, but probably hard to implement. Definitely
> out of scope for this effort.

I'm suggesting that EIO is traditionally for when the data still
dirty in pagecache and was not able to get back to backing
store. Do you deny that?

And I think the application might try to handle the case of a
page becoming corrupted differently. Do you deny that?

OK, given the range of errors that APIs are defined to return,
then maybe EIO is the best option. I don't suppose it is possible
to expand them to return something else?


> > > > Just seems overengineered. We could rewrite any if/switch statement like
> > > > that (and actually the compiler probably will if it is beneficial).
> > > 
> > > The reason I like it is that it separates the functions cleanly,
> > > without that there would be a dispatcher from hell. Yes it's a bit
> > > ugly that there is a lot of manual bit checking around now too,
> > > but as you go into all the corner cases originally clean code
> > > always tends to get more ugly (and this is a really ugly problem)
> > 
> > Well... it is just writing another dispatcher from hell in a
> > different way really, isn't it? How is it so much better than
> > a simple switch or if/elseif/else statement?
> 
> switch () wouldn't work, it relies on the order.

Order of what?


> if () would work, but it would be larger and IMHO much harder
> to read than the table. I prefer the table, which is a reasonably
> clean mechanism to do that.

OK. Maybe I'll try send a patch to remove it and see how it looks
sometime. I think it's totally overengineered, but that's just me.


