Return-Path: <linux-kernel-owner+w=401wt.eu-S1757936AbXLSXkp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757936AbXLSXkp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 18:40:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753452AbXLSXki
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 18:40:38 -0500
Received: from smtp101.mail.mud.yahoo.com ([209.191.85.211]:23172 "HELO
	smtp101.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753932AbXLSXkh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 18:40:37 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=qGwQoIeePMZ9/aM5vLfIoaFKfQfoGUbtwCqtYNnfOJ+C/KzMW/9GChc6IBphaHWLsY4byB45xUgmlQ8ZGtICt03do30BA0kz50RKKh1STGmk/rcFVZsZijWVXzFbP/4zdQNhuhzT6rZAAia8+82cpHLoX92FxZ1gk/tR4nLZ7MY=  ;
X-YMail-OSG: 1ARdZeoVM1loVhCUOkSVNpnmxJ2._7FAnafnohhEepSNZNSjuiK79owDAswc7hDiu5DpN6qZxQ--
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [patch 02/20] make the inode i_mmap_lock a reader/writer lock
Date: Thu, 20 Dec 2007 10:40:28 +1100
User-Agent: KMail/1.9.5
Cc: Lee Schermerhorn <Lee.Schermerhorn@hp.com>, Rik van Riel <riel@redhat.com>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20071218211539.250334036@redhat.com> <1198083218.5333.48.camel@localhost> <1198092503.6484.21.camel@twins>
In-Reply-To: <1198092503.6484.21.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712201040.29040.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 20 December 2007 06:28, Peter Zijlstra wrote:
> On Wed, 2007-12-19 at 11:53 -0500, Lee Schermerhorn wrote:
> > On Wed, 2007-12-19 at 11:31 -0500, Rik van Riel wrote:
> > > On Wed, 19 Dec 2007 10:52:09 -0500
> > >
> > > Lee Schermerhorn <Lee.Schermerhorn@hp.com> wrote:
> > > > I keep these patches up to date for testing.  I don't have conclusive
> > > > evidence whether they alleviate or exacerbate the problem nor by how
> > > > much.
> > >
> > > When the queued locking from Ingo's x86 tree hits mainline,
> > > I suspect that spinlocks may end up behaving a lot nicer.
> >
> > That would be worth testing with our problematic workloads...
> >
> > > Should I drop the rwlock patches from my tree for now and
> > > focus on just the page reclaim stuff?
> >
> > That's fine with me.  They're out there is anyone is interested.  I'll
> > keep them up to date in my tree [and hope they don't conflict with split
> > lru and noreclaim patches too much] for occasional testing.
>
> Of course, someone would need to implement ticket locks for ia64 -
> preferably without the 256 cpu limit.

Yep. Wouldn't be hard at all -- ia64 has a "fetchadd" with acquire
semantics.

The only reason the x86 ticket locks have the 256 CPu limit is that
if they go any bigger, we can't use the partial registers so would
have to have a few more instructions.


> Nick, growing spinlock_t to 64 bits would yield space for 64k cpus
> right? I'm guessing that would be enough for a while, even for SGI.

A 32 bit spinlock would allow 64K cpus (ticket lock has 2 counters,
each would be 16 bits). And it would actually shrink the spinlock in
the case of preempt kernels too (because it would no longer have the
lockbreak field).

And yes, I'll go out on a limb and say that 64k CPUs ought to be
enough for anyone ;)
