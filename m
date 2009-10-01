Return-Path: <linux-kernel-owner+w=401wt.eu-S1755470AbZJACKk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755470AbZJACKk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 22:10:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755456AbZJACKj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 22:10:39 -0400
Received: from cantor.suse.de ([195.135.220.2]:58763 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755436AbZJACKi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 22:10:38 -0400
Date: Thu, 1 Oct 2009 04:10:42 +0200
From: Nick Piggin <npiggin@suse.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 04/33] fs: brlock vfsmount_lock
Message-ID: <20091001021042.GN6327@wotan.suse.de>
References: <20090904065142.114706411@nick.local0.net> <20090904065534.447753909@nick.local0.net> <20090922151751.GM5858@ZenIV.linux.org.uk> <20090927195619.GG6327@wotan.suse.de> <1254144063.15795.3.camel@laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1254144063.15795.3.camel@laptop>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 28, 2009 at 03:21:03PM +0200, Peter Zijlstra wrote:
> On Sun, 2009-09-27 at 21:56 +0200, Nick Piggin wrote:
> > On Tue, Sep 22, 2009 at 04:17:51PM +0100, Al Viro wrote:
> > > On Fri, Sep 04, 2009 at 04:51:45PM +1000, npiggin@suse.de wrote:
> > > > Use a brlock for the vfsmount lock.
> > > 
> > > I like it, but I'd like to see how costly it becomes on heavily SMP boxen.
> > > Creation/removal of bindings as load...
> > 
> > I could test that... Is there some realistic scenario I can try
> > to implement that exercises this? (failing that, I'll happily
> > do a microbenchmark).
> > 
> > I was thinking it *might* be possible to do RCU... but especially
> > coming up with a scheme that avoids synchronize_rcu() in the
> > umount path is not trivial, so perhaps the simple read/write
> > annotations with brlock behind the scenes is a more reasonable step.
> > 
> > I do also actually owe you some documentation with this one too,
> > which I will get around to adding.
> 
> The thing that worries me is that the write-side is very heavy and the
> read sides are spinning on it, yielding rather large spin times on large
> smp boxen.

Well, that might be true. Although I'd say that huge systems that
are doing a reasonable amount of vfs operations will have much
larger spin times today due to pathological queueing on the
global locks (almost to the point of effectively being a livelock).


> It wouldn't nearly be as bad if the read sides could block..
> 
> FWIW, spin_lock_nested is limited to 8 subclasses, so your current
> implementation will explode on anything larger than an 8-way.

So OK, a _mergeable_ sequence for this will basicaly look like:
1. document and add read/write lock variations to the call sites
   which is just a wrapper around existing lock (no functional
   change).
2. add a general brlock implementation, which is nice to lockdep
   (basically could just annotate it as an rwlock and be done)
   And this is where -rt could also do something more appropriate
   if needed.
3. switch vfsmount lock to brlock.

Someone also was interested in using brlocks elsewhere, you'll be
unhappy to know! :) Yes I would really like to see an RCU
implementation _eventually_, but as I say, that is probably a
whole project on its own.

