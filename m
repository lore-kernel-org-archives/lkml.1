Return-Path: <linux-kernel-owner+w=401wt.eu-S1756810AbZCFSZZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756810AbZCFSZZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 13:25:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756763AbZCFSYx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 13:24:53 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:34454 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756798AbZCFSYw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 13:24:52 -0500
Date: Fri, 6 Mar 2009 12:24:51 -0600
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>,
       Christoph Hellwig <hch@infradead.org>,
       containers <containers@lists.linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH 00/11] track files for checkpointability
Message-ID: <20090306182451.GA6307@us.ibm.com>
References: <20090305174037.GA2274@x200.localdomain> <1236280567.22399.99.camel@nimitz> <20090305210840.GA2499@x200.localdomain> <1236288427.22399.122.camel@nimitz> <20090305220044.GA2819@x200.localdomain> <1236291865.22399.139.camel@nimitz> <20090306143425.GA31250@us.ibm.com> <1236354509.10626.29.camel@nimitz> <20090306162337.GA3040@us.ibm.com> <1236357965.10626.51.camel@nimitz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1236357965.10626.51.camel@nimitz>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Dave Hansen (dave@linux.vnet.ibm.com):
> On Fri, 2009-03-06 at 10:23 -0600, Serge E. Hallyn wrote:
> > Which imo is fine, but my question is whether that leaves any actual
> > value in the persistent per-resource uncheckpointable flag.
> 
> OK, let's take a look back at this discussion a little bit and how we
> got here.
> 
> Ingo quotes:
> > Yeah, per resource it should be. That's per task in the normal 
> > case - except for threaded workloads where it's shared by 
> > threads.
> 
> > Uncheckpointable should be a one-way flag anyway. We want this 
> > to become usable, so uncheckpointable functionality should be as 
> > painful as possible, to make sure it's getting fixed ...
> 
> > Is there any automated test that could discover C/R breakage via 
> > brute force? All that matters in such cases is to get the "you 
> > broke stuff" information as soon as possible. If it comes at an 
> > early stage developers can generally just fix stuff.
> 
> You add these things together and you get what I posted.  My patch is:
> 1. per resource
> 2. has a one way flag
> 3. Gives messages to developers at an early stage (dmesg) and lets them
>    explore it more thoroughly (/proc)
> 
> But, these "early stage" messages are completely opposed to an approach
> that uses sys_checkpoint() in some form (like with a -1 fd as an
> argument).

Well I disagree with that.  The 'early stage' messages could be seen as
either:

	1. a short-term way to prioritize resources to support
	or
	2. a long-term way to catch new resources introduced
	without checkpoint/restart support

I don't believe 2. would work.  I think 1. would work, but that we
risk imposing permanent code changes to support a temporary goal.

In contrast, the sys_checkpoint() check will always be needed to
check whether a particular application is checkpointable.  For
instance a task will never be checkpointable if it shares a mm-struct
with a task not being checkpointed.

> Think of it like lockdep.  We *could* have designed lockdep to simply
> give us a nice message whenever we do an a/b b/a deadlock.  That would
> be helpful.  Or, we could design it to record all lock acquisitions that
> didn't deadlock to see if they ever possibly deadlock.  (We did the
> second one, btw).  That gave an early, useful, warning that developers
> could fix before we encounter an actual problem.  I'm advocating such a
> mechanism for c/r.  

If you can convince me that it'll do that you'll have me on board :)

-serge
