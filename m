Return-Path: <linux-kernel-owner+w=401wt.eu-S1161547AbXBHITW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161547AbXBHITW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Feb 2007 03:19:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161550AbXBHITW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Feb 2007 03:19:22 -0500
Received: from mail.suse.de ([195.135.220.2]:48955 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161547AbXBHITV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Feb 2007 03:19:21 -0500
From: Andi Kleen <ak@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [BUG][PATCH] fix mempolcy's check on a system with memory-less-node take2
Date: Thu, 8 Feb 2007 09:19:16 +0100
User-Agent: KMail/1.9.5
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>, clameter@sgi.com,
       GOTO <y-goto@jp.fujitsu.com>
References: <20070208110606.ebf668d3.kamezawa.hiroyu@jp.fujitsu.com> <200702080903.46242.ak@suse.de> <20070208000857.7296b94b.akpm@linux-foundation.org>
In-Reply-To: <20070208000857.7296b94b.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702080919.16879.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 08 February 2007 09:08, Andrew Morton wrote:
> On Thu, 8 Feb 2007 09:03:46 +0100 Andi Kleen <ak@suse.de> wrote:
> 
> > On Thursday 08 February 2007 09:00, Andrew Morton wrote:
> > > On Thu, 8 Feb 2007 08:49:41 +0100 Andi Kleen <ak@suse.de> wrote:
> > > 
> > > > 
> > > > > This panic(hang) was found by a numa test-set on a system with 3 nodes, where
> > > > > node(2) was memory-less-node.
> > > > 
> > > > I still think it's the wrong fix -- just get rid of the memory less node.
> > > 
> > > "Let's break it even more"?
> > 
> > I still don't get what you believe what would be broken then.
> 
> A node with no memory is physical reality.  The kernel should do its best
> handle and report it accurately. 

What would be the advantage of that? 

The reason we present nodes to user space is that we can tell the user
where the memory is. You seem to try to promote it to some abstract entity
beyond that, but that doesn't seem particularly fruitful to me. I think
I prefer "down to earth" memory nodes.

> Pretending that the CPUs on that node are 
> local to a different node's memory (as I understand your proposal) goes
> against that.

Well it is then most local to that node's memory.

> 
> > > > I expect you'll likely run into more problems with that setup anyways.
> > > 
> > > What happens if he doesn't run into more problems?
> > 
> > Then he's lucky. I ran into problems at least when I still had the empty
> > nodes some time ago on x86-64.  Christoph said SN2 is doing the same.
> > 
> > iirc slab blew up at least, but that  might be fixed by now. But it's a little risky 
> > because there is more code now that is node aware.
> > 
> 
> Well...  I'd suggest that we try to struggle on, get it working.  Is there
> a downside to doing that?  

The main problem I used to have was regressions. e.g. having memory
less nodes in different combinations would break in new releases.
(on x86-64 this depends on how the DIMMs are distributed so sometimes
breakage wasn't noticed for a long time. We ended up trying all combinations
on a simulator in the end). Assigning to nearby nodes avoided that special
case.

Ok there is still one other case -- nodes that have memory, but not enough
to do anything useful. This can happen too, but is still somewhat different.
Basically all kmalloc_node() need to fail gratiously.

-Andi
