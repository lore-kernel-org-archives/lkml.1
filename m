Return-Path: <linux-kernel-owner+w=401wt.eu-S1758939AbZFYTie@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758939AbZFYTie (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 15:38:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752695AbZFYTi1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 15:38:27 -0400
Received: from thunk.org ([69.25.196.29]:47814 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752552AbZFYTi0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 15:38:26 -0400
Date: Thu, 25 Jun 2009 15:38:06 -0400
From: Theodore Tso <tytso@mit.edu>
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, penberg@cs.helsinki.fi,
       arjan@infradead.org, linux-kernel@vger.kernel.org,
       cl@linux-foundation.org, npiggin@suse.de
Subject: Re: upcoming kerneloops.org item: get_page_from_freelist
Message-ID: <20090625193806.GA6472@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	David Rientjes <rientjes@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	penberg@cs.helsinki.fi, arjan@infradead.org,
	linux-kernel@vger.kernel.org, cl@linux-foundation.org,
	npiggin@suse.de
References: <20090624120617.1e6799b5.akpm@linux-foundation.org> <alpine.LFD.2.01.0906241211550.3154@localhost.localdomain> <20090624123624.26c93459.akpm@linux-foundation.org> <alpine.LFD.2.01.0906241240360.3154@localhost.localdomain> <20090624130121.99321cca.akpm@linux-foundation.org> <alpine.LFD.2.01.0906241312090.3154@localhost.localdomain> <alpine.LFD.2.01.0906241334260.3154@localhost.localdomain> <20090624150714.c7264768.akpm@linux-foundation.org> <20090625132544.GB9995@mit.edu> <alpine.DEB.2.00.0906251135440.30090@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0906251135440.30090@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 25, 2009 at 11:51:40AM -0700, David Rientjes wrote:
> 
> There's no way to indicate that the page allocator should "try really 
> hard" because the VM implementation should already do that for every 
> allocation before failure.  A subsequent attempt after the first failure 
> could try GFP_ATOMIC, though, which allows allocation beyond the minimum 
> watermark and is more likely to succeed than GFP_NOFS.  Such an 
> allocation should be short-lived and not rely on additional memory to free 
> to avoid depleting most of the memory reserves available to atomic 
> allocations, direct reclaim, and oom killed tasks.

Hmm, is there a reason to avoid using GFP_ATOMIC on the first
allocation, and only adding GFP_ATOMIC after the first failure?

In the case of ext4, after we finish the commit, we will release quite
a bit of memory to the system, so using GFP_ATOMIC to complete is a
good thing.  Of course, preallocating some of these data structures
before the commit would be better, since we can return ENOMEM to
userspace applications when they are calling a system call.

> > Hmm.... it may be possible to do the memory allocation in advance,
> > before we get to the commit, and make it be easier to fail and return
> > ENOMEM to userspace --- which I bet most applications won't handle
> > gracefully, either (a) not checking error codes and losing data, or
> > (b) dieing on the spot, so it would be effectively be an OOM kill.
> 
> If this would still be a GFP_NOFS allocation, the oom killer will not be 
> triggered (it only gets called when __GFP_FS is set to avoid killing tasks 
> when reclaim was not possible).

I didn't mean that it would really be an OOM kill --- just that many
applications don't have very sophisticated error checking themselves,
and will either not do error checking at all, or if they get an ENOMEM
from a system call, will probably just immediately do a something like
'perror("Yikes!"); exit(1);' --- so it might as _well_ be an OOM kill.

On the other hand, by returning an ENOMEM to userspace, we at least
allow the competent application writers to try to do something
intelligent (cynical kernel programmers who don't believe there are
many such, lets leave that aside for the bar room discussion :-), and
if you're out of memory, you're out of memory, and whether programs
die from an OOM or an untested NULL defeference in an error path in
the application, or an explicit 'perror("Yikes!"); exit(1);', doesn't
much matter.

   	    		       		  	       - Ted
