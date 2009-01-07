Return-Path: <linux-kernel-owner+w=401wt.eu-S1756346AbZAGQkX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756346AbZAGQkX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 11:40:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754475AbZAGQju
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 11:39:50 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55299 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754144AbZAGQjt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 11:39:49 -0500
Date: Wed, 7 Jan 2009 08:39:01 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Peter Zijlstra <peterz@infradead.org>
cc: Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org,
       linux-mm <linux-mm@kvack.org>, Nick Piggin <npiggin@suse.de>
Subject: Re: Increase dirty_ratio and dirty_background_ratio?
In-Reply-To: <1231345546.11687.314.camel@twins>
Message-ID: <alpine.LFD.2.00.0901070833430.3057@localhost.localdomain>
References: <20090107154517.GA5565@duck.suse.cz> <1231345546.11687.314.camel@twins>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 7 Jan 2009, Peter Zijlstra wrote:
> 
> >   So the question is: What kind of workloads are lower limits supposed to
> > help? Desktop? Has anybody reported that they actually help? I'm asking
> > because we are probably going to increase limits to the old values for
> > SLES11 if we don't see serious negative impact on other workloads...
> 
> Adding some CCs.
> 
> The idea was that 40% of the memory is a _lot_ these days, and writeback
> times will be huge for those hitting sync or similar. By lowering these
> you'd smooth that out a bit.

Not just a bit. If you have 4GB of RAM (not at all unusual for even just a 
regular desktop, never mind a "real" workstation), it's simply crazy to 
allow 1.5GB of dirty memory. Not unless you have a really wicked RAID 
system with great write performance that can push it out to disk (with 
seeking) in just a few seconds.

And few people have that.

For a server, where throughput matters but latency generally does not, go 
ahead and raise it. But please don't raise it for anything sane. The only 
time it makes sense upping that percentage is for some odd special-case 
benchmark that otherwise can fit the dirty data set in memory, and never 
syncs it (ie it deletes all the files after generating them).

In other words, yes, 40% dirty can make a big difference to benchmarks, 
but is almost never actually a good idea any more.

That said, the _right_ thing to do is to 

 (a) limit dirty by number of bytes (in addition to having a percentage 
     limit). Current -git adds support for that.

 (b) scale it dynamically by your IO performance. No, current -git does 
     _not_ support this.

but just upping the percentage is not a good idea.

		Linus
