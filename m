Return-Path: <linux-kernel-owner+w=401wt.eu-S965425AbXCGNhF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965425AbXCGNhF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 08:37:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965437AbXCGNhE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 08:37:04 -0500
Received: from ns.suse.de ([195.135.220.2]:54943 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965425AbXCGNhD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 08:37:03 -0500
Date: Wed, 7 Mar 2007 14:36:49 +0100
From: Nick Piggin <npiggin@suse.de>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Miklos Szeredi <miklos@szeredi.hu>, akpm@linux-foundation.org,
       mingo@elte.hu, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       benh@kernel.crashing.org, Jeff Dike <jdike@addtoit.com>
Subject: Re: [patch 4/6] mm: merge populate and nopage into fault (fixes nonlinear)
Message-ID: <20070307133649.GF18704@wotan.suse.de>
References: <20070307102106.GB5555@wotan.suse.de> <1173263085.6374.132.camel@twins> <20070307103842.GD5555@wotan.suse.de> <1173264462.6374.140.camel@twins> <20070307110035.GE5555@wotan.suse.de> <1173268086.6374.157.camel@twins> <20070307121730.GC18704@wotan.suse.de> <1173271286.6374.166.camel@twins> <20070307130851.GE18704@wotan.suse.de> <1173273562.6374.175.camel@twins>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1173273562.6374.175.camel@twins>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 07, 2007 at 02:19:22PM +0100, Peter Zijlstra wrote:
> On Wed, 2007-03-07 at 14:08 +0100, Nick Piggin wrote:
> 
> > > > The thing is, I don't think anybody who uses these things cares
> > > > about any of the 'problems' you want to fix, do they? We are
> > > > interested in dirty pages only for the correctness issue, rather
> > > > than performance. Same as reclaim.
> > > 
> > > If so, we can just stick to the dead slow but correct 'scan the full
> > > vma' page_mkclean() and nobody would ever trigger it.
> > 
> > Not if we restricted it to root and mlocked tmpfs. But then why
> > wouldn't you just do it with the much more efficient msync walk,
> > so that if root does want to do writeout via these things, it does
> > not blow up?
> 
> This is all used on ram based filesystems right, they all have
> BDI_CAP_NO_WRITEBACK afaik, so page_mkclean will never get called
> anyway. Mlock doesn't avoid getting page_mkclean called.
> 
> Those who use this on a 'real' filesystem will get hit in the face by a
> linear scanning page_mkclean(), but AFAIK nobody does this anyway.

But somebody might do it. I just don't know why you'd want to make
this _worse_ when the msync option would work?

> Restricting it to root for such filesystems is unwanted, that'd severely
> handicap both UML and Oracle as I understand it (are there other users
> of this feature around?)

Why? I think they all use tmpfs backings, don't they?

> msync() might never get called and then we're back with the old
> behaviour where we can surprise the VM with a ton of dirty pages.

But we're root. With your patch, root *can't* do nonlinear writeback
well. Ever. With msync, at least you give them enough rope.

> > > What is the DoS scenario wrt reclaim? We really ought to fix that if
> > > real, those UML farms run on nothing but nonlinear reclaim I'd think.
> > 
> > I guess you can just increase the computational complexity of
> > reclaim quite easily.
> 
> Right, on first glance it doesn't look to be too bad, but I should take
> a closer look.

Well I don't think UML uses nonlinear yet anyway, does it? Can they
make do with restricting nonlinear to mlocked vmas, I wonder? Probably
not.

