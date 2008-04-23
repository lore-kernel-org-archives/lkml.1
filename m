Return-Path: <linux-kernel-owner+w=401wt.eu-S934023AbYDWBMO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934023AbYDWBMO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 21:12:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755589AbYDWBL5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 21:11:57 -0400
Received: from ns1.suse.de ([195.135.220.2]:40404 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757473AbYDWBL4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 21:11:56 -0400
Date: Wed, 23 Apr 2008 03:11:54 +0200
From: Nick Piggin <npiggin@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Jens Axboe <jens.axboe@oracle.com>,
       linux-arch@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       peterz@infradead.org, sam@ravnborg.org
Subject: Re: [PATCH 2/11] x86: convert to generic helpers for IPI function calls
Message-ID: <20080423011153.GB17572@wotan.suse.de>
References: <1208890227-24808-1-git-send-email-jens.axboe@oracle.com> <1208890227-24808-3-git-send-email-jens.axboe@oracle.com> <alpine.LFD.1.10.0804221157220.2779@woody.linux-foundation.org> <20080422191213.GA6370@elte.hu> <alpine.LFD.1.10.0804221218410.2779@woody.linux-foundation.org> <20080422192601.GB12588@elte.hu> <alpine.LFD.1.10.0804221244350.2779@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0804221244350.2779@woody.linux-foundation.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 22, 2008 at 12:50:30PM -0700, Linus Torvalds wrote:
> 
> 
> On Tue, 22 Apr 2008, Ingo Molnar wrote:
> > 
> > ok. In which case the reschedule vector could be consolidated into that 
> > as well (it's just a special single-CPU call). Then there would be no 
> > new vector allocations needed at all, just the renaming of 
> > RESCHEDULE_VECTOR to something more generic.
> 
> Yes.
> 
> Btw, don't get me wrong - I'm not against multiple vectors per se. I just 
> wonder if there is any real reason for the code duplication. 
> 
> And there certainly *can* be tons of valid reasons for it. For example, 
> some of the LAPIC can only have something like two pending interrupts per 
> vector, and after that IPI's would get lost.
> 
> However, since the queuing is actually done with the data structures, I 
> don't think it matters for the IPI's - they don't need any hardware 
> queuing at all, afaik, since even if two IPI's would be merged into one 
> (due to lack of hw queueing) the IPI handling code still has its list of 
> events, so it doesn't matter.
> 
> And performance can be a valid reason ("too expensive to check the shared 
> queue if we only have per-cpu events"), although I$ issues can cause that 
> argument to go both ways.
> 
> I was also wondering whether there are deadlock issues (ie one type of IPI 
> has to complete even if a lock is held for the other type). 
> 
> So I don't dislike the patch per se, I just wanted to understand _why_ the 
> IPI's wanted separate vectors.

The "too expensive to check the shared queue" is one aspect of it. The
shared queue need not have events *for us* (at least, unless Jens has
changed the implementation a bit) but it can still have events that we
would need to check through.

I don't think deadlock is a problem (any more than with multiple vectors).


