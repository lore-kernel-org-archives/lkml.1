Return-Path: <linux-kernel-owner+w=401wt.eu-S1752543AbYDWHIe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752543AbYDWHIe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 03:08:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750783AbYDWHI0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 03:08:26 -0400
Received: from brick.kernel.dk ([87.55.233.238]:14250 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750776AbYDWHIZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 03:08:25 -0400
Date: Wed, 23 Apr 2008 09:08:21 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Nick Piggin <npiggin@suse.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, linux-arch@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       peterz@infradead.org, sam@ravnborg.org
Subject: Re: [PATCH 2/11] x86: convert to generic helpers for IPI function calls
Message-ID: <20080423070819.GU12774@kernel.dk>
References: <1208890227-24808-1-git-send-email-jens.axboe@oracle.com> <1208890227-24808-3-git-send-email-jens.axboe@oracle.com> <alpine.LFD.1.10.0804221157220.2779@woody.linux-foundation.org> <20080422191213.GA6370@elte.hu> <alpine.LFD.1.10.0804221218410.2779@woody.linux-foundation.org> <20080422192601.GB12588@elte.hu> <alpine.LFD.1.10.0804221244350.2779@woody.linux-foundation.org> <20080423011153.GB17572@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080423011153.GB17572@wotan.suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 23 2008, Nick Piggin wrote:
> On Tue, Apr 22, 2008 at 12:50:30PM -0700, Linus Torvalds wrote:
> > 
> > 
> > On Tue, 22 Apr 2008, Ingo Molnar wrote:
> > > 
> > > ok. In which case the reschedule vector could be consolidated into that 
> > > as well (it's just a special single-CPU call). Then there would be no 
> > > new vector allocations needed at all, just the renaming of 
> > > RESCHEDULE_VECTOR to something more generic.
> > 
> > Yes.
> > 
> > Btw, don't get me wrong - I'm not against multiple vectors per se. I just 
> > wonder if there is any real reason for the code duplication. 
> > 
> > And there certainly *can* be tons of valid reasons for it. For example, 
> > some of the LAPIC can only have something like two pending interrupts per 
> > vector, and after that IPI's would get lost.
> > 
> > However, since the queuing is actually done with the data structures, I 
> > don't think it matters for the IPI's - they don't need any hardware 
> > queuing at all, afaik, since even if two IPI's would be merged into one 
> > (due to lack of hw queueing) the IPI handling code still has its list of 
> > events, so it doesn't matter.
> > 
> > And performance can be a valid reason ("too expensive to check the shared 
> > queue if we only have per-cpu events"), although I$ issues can cause that 
> > argument to go both ways.
> > 
> > I was also wondering whether there are deadlock issues (ie one type of IPI 
> > has to complete even if a lock is held for the other type). 
> > 
> > So I don't dislike the patch per se, I just wanted to understand _why_ the 
> > IPI's wanted separate vectors.
> 
> The "too expensive to check the shared queue" is one aspect of it. The
> shared queue need not have events *for us* (at least, unless Jens has
> changed the implementation a bit) but it can still have events that we
> would need to check through.

That is still the case, the loop works the same way still.

To answer Linus' question on why it was done the way it was - the
thought of sharing the IPI just didn't occur to me. For performance
reasons I'd like to keep the current setup, but it's certainly a viable
alternative for archs with limited number of IPIs available (like the
mips case that Ralf has disclosed).

-- 
Jens Axboe

