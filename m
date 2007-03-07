Return-Path: <linux-kernel-owner+w=401wt.eu-S965489AbXCGNx4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965489AbXCGNx4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 08:53:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965494AbXCGNx4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 08:53:56 -0500
Received: from mail-gw3.sa.ew.hu ([212.108.200.82]:41677 "EHLO
	mail-gw3.sa.ew.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965489AbXCGNxz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 08:53:55 -0500
To: npiggin@suse.de
CC: a.p.zijlstra@chello.nl, miklos@szeredi.hu, akpm@linux-foundation.org,
       mingo@elte.hu, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       benh@kernel.crashing.org, jdike@addtoit.com
In-reply-to: <20070307133649.GF18704@wotan.suse.de> (message from Nick Piggin
	on Wed, 7 Mar 2007 14:36:49 +0100)
Subject: Re: [patch 4/6] mm: merge populate and nopage into fault (fixes nonlinear)
References: <20070307102106.GB5555@wotan.suse.de> <1173263085.6374.132.camel@twins> <20070307103842.GD5555@wotan.suse.de> <1173264462.6374.140.camel@twins> <20070307110035.GE5555@wotan.suse.de> <1173268086.6374.157.camel@twins> <20070307121730.GC18704@wotan.suse.de> <1173271286.6374.166.camel@twins> <20070307130851.GE18704@wotan.suse.de> <1173273562.6374.175.camel@twins> <20070307133649.GF18704@wotan.suse.de>
Message-Id: <E1HOwZn-0000TI-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 07 Mar 2007 14:53:07 +0100
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Wed, Mar 07, 2007 at 02:19:22PM +0100, Peter Zijlstra wrote:
> > On Wed, 2007-03-07 at 14:08 +0100, Nick Piggin wrote:
> > 
> > > > > The thing is, I don't think anybody who uses these things cares
> > > > > about any of the 'problems' you want to fix, do they? We are
> > > > > interested in dirty pages only for the correctness issue, rather
> > > > > than performance. Same as reclaim.
> > > > 
> > > > If so, we can just stick to the dead slow but correct 'scan the full
> > > > vma' page_mkclean() and nobody would ever trigger it.
> > > 
> > > Not if we restricted it to root and mlocked tmpfs. But then why
> > > wouldn't you just do it with the much more efficient msync walk,
> > > so that if root does want to do writeout via these things, it does
> > > not blow up?
> > 
> > This is all used on ram based filesystems right, they all have
> > BDI_CAP_NO_WRITEBACK afaik, so page_mkclean will never get called
> > anyway. Mlock doesn't avoid getting page_mkclean called.
> > 
> > Those who use this on a 'real' filesystem will get hit in the face by a
> > linear scanning page_mkclean(), but AFAIK nobody does this anyway.
> 
> But somebody might do it. I just don't know why you'd want to make
> this _worse_ when the msync option would work?
> 
> > Restricting it to root for such filesystems is unwanted, that'd severely
> > handicap both UML and Oracle as I understand it (are there other users
> > of this feature around?)
> 
> Why? I think they all use tmpfs backings, don't they?
> 
> > msync() might never get called and then we're back with the old
> > behaviour where we can surprise the VM with a ton of dirty pages.
> 
> But we're root. With your patch, root *can't* do nonlinear writeback
> well. Ever. With msync, at least you give them enough rope.

Restricting to root doesn't buy you much, nobody wants to be root.
Restricting to mlock is similarly pointless.  UML _will_ want to get
swapped out if there's no activity.

Restricting to tmpfs makes sense, but it's probably not what UML
wants.

Conclusion: there's no good solution for UML in kernel-space.

Miklos
