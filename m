Return-Path: <linux-kernel-owner+w=401wt.eu-S1755172AbZEQWqU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755172AbZEQWqU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 May 2009 18:46:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753517AbZEQWqK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 May 2009 18:46:10 -0400
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:40699 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753298AbZEQWqJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 May 2009 18:46:09 -0400
Date: Sun, 17 May 2009 23:45:04 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.anvils
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andi Kleen <ak@linux.intel.com>, Ian Campbell <ian.campbell@citrix.com>,
       Jakub Jelinek <jakub@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jesper Nilsson <jesper.nilsson@axis.com>,
       Johannes Weiner <hannes@cmpxchg.org>,
       Arjan van de Ven <arjan@linux.intel.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Fix print out of function which called WARN_ON()
In-Reply-To: <alpine.LFD.2.01.0905171502160.3301@localhost.localdomain>
Message-ID: <Pine.LNX.4.64.0905172335170.23616@blonde.anvils>
References: <1242404236-17624-1-git-send-email-ian.campbell@citrix.com>
 <alpine.LFD.2.01.0905151018370.3343@localhost.localdomain>
 <4A0DC797.7040502@linux.intel.com> <alpine.LFD.2.01.0905161342150.3301@localhost.localdomain>
 <Pine.LNX.4.64.0905171536470.23834@blonde.anvils>
 <alpine.LFD.2.01.0905171502160.3301@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 17 May 2009, Linus Torvalds wrote:
> On Sun, 17 May 2009, Hugh Dickins wrote:
> > On Sat, 16 May 2009, Linus Torvalds wrote:
> > > 
> > > This patch not only avoids the warnings and gets the right caller 
> > > information, it cleans up the code too:
> > > 
> > >  - it uses '%pS' instead of of sprint_symbol
> > 
> > > -	char function[KSYM_SYMBOL_LEN];
> > 
> > This should be a big improvement, because that buffer on the stack
> > was netting lots of stale return addresses, printed out with ?s in
> > the warning's dump_stack().  I had been wanting to add a memset,
> > but your %pS should circumvent the need for that nicely.
> 
> Are you sure it was that function[] array?

No, not sure at all, that was just a conclusion I jumped to.
Though I think I was seeing it on x86-32 too.

> 
> The thing is, on at least x86-64, any function using va_start() will 
> allocate something like 64 bytes of stack space for the reg-save area. I'm 
> not quite sure _why_ it does that, but it's very irritating, and it showed 
> up quite clearly in some of the stackspace usage things.
> 
> I even sent the gcc people a patch to fix the worst of it (gcc used to 
> allocate about twice as much space because it also had a XMM save area 
> even if you compiled without XMM support or something like that), but my 
> point is, I'm afraid there is still a noticeable gap on the stack due to 
> this, at least for the _fmt() case.
> 
> But yes, for the _null() case we now have neither that function buffer 
> _nor_ the stupid va_list save area, so that case should be much better.
> 
> Of course, we could avoid that entirely if we were to just pass in the 
> right stack pointer to dump_stack(), and the "warn_slowpath_xyz()" 
> functions could just pass in the stack of their caller. Sadly, we 
> currently have no way to do that :(
> 
> We could change the dump_stack() calling convention to give a stack 
> pointer or NULL, and then use __builtin_frame_address(0) in the caller.. 
> But we have a _lot_ of "dump_stack()" users.

Not to mention the astonishing array of dump_stack, show_stack,
show_trace, dump_trace, etc etc, layers we've now accumulated,
in x86 at least.  I ran away the last time I looked there.

Hugh
