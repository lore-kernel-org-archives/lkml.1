Return-Path: <linux-kernel-owner+w=401wt.eu-S1756189AbYKPAAq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756189AbYKPAAq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Nov 2008 19:00:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752214AbYKPAAi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Nov 2008 19:00:38 -0500
Received: from ozlabs.org ([203.10.76.45]:39434 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751873AbYKPAAh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Nov 2008 19:00:37 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Christoph Lameter <cl@linux-foundation.org>
Subject: Re: [PATCH] Allocate module.ref array dynamically
Date: Sun, 16 Nov 2008 10:30:33 +1030
User-Agent: KMail/1.10.1 (Linux/2.6.27-7-generic; KDE/4.1.2; i686; ; )
Cc: Eric Dumazet <dada1@cosmosbay.com>, Takashi Iwai <tiwai@suse.de>,
       Andreas Gruenbacher <agruen@suse.de>, Jan Blunck <jblunck@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Mike Travis <travis@sgi.com>
References: <s5htzaekp6o.wl%tiwai@suse.de> <200811141019.49493.rusty@rustcorp.com.au> <Pine.LNX.4.64.0811131759250.7010@quilx.com>
In-Reply-To: <Pine.LNX.4.64.0811131759250.7010@quilx.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811161030.34054.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 14 November 2008 10:50:41 Christoph Lameter wrote:
> On Fri, 14 Nov 2008, Rusty Russell wrote:
> > It is defined to be zeroing.
>
> But some uses do not need zeroing. They currently have no choice.

OK, of the 32 in-tree users, only 4 don't need zeroing (rough audit; they 
might need zeroing in some subtle way).  Performance arguments are not valid 
in any of these cases though, and it's hard to see that they would be.

> And other flags can become necessary if percpu areas gain the ability of
> being dynamically extended.

And other flags become impossible, eg. GFP_ATOMIC.

> > It absolutely does.  That's why it takes a type!
>
> alloc_percpu is based on __alloc_percpu which currently does not take an
> alignment. Guess we could get there by removing the intermediate
> functions and making alloc_percpu call cpu_alloc.

Yes.  When I originally wrote this, it hooked up to the percpu allocator which 
took an alignment (this was reduced to the old module.c percpu allocator in 
the end).

The strange indirection was from someone's failed experiment at only 
allocating only online cpus.  We should kill that as a separate patch.

> However, there are only a few places that use allocpercpu and all of
> those are touched by necesssity by the full cpu alloc patchset.

No, that's my point.  There are 28 places whihc use alloc_percpu, and they 
should be left.  There are 4 places which use __alloc_percpu, and all of them 
can be converted to alloc_percpu (see patch below).

Then, you change alloc_percpu(type) to hand the size and align to your 
infrastructure (call it __alloc_percpu(size, align) if you want, or stick with 
cpu_alloc()).

> At mininum
> we need to add the allocation flags and add cpu ops as well as review the
> preemption at each call site etcin order to use the correct
> call. So why bother with the old API?

We don't need a flags arg, there's no evidence of any problem, and it's 
useless churn to change it.

There are several seperate things here (this is to make sure my head is 
straight and to clarify for others skimming):

1) Make the dynamic percpu allocator use the static percpu system.
   - Agreed, always the aim, never quite happened.

2) Make zeroing optional
   - Disagree, adds API complexity for corner case with no gain.  Using
     gfp_t for it is even worse, since it implies GFP_ATOMIC is valid or
     sensible.

3) Change API to use CAPS for macros
   - Strongly disagree, Linus doesn't use CAPS for type-taking macros
     (list_entry, container_of, min_t), it's ugly, and status-quo wins.

4) Get rid of unused "online-only" percpu allocators.
   - Agree, and will simplify implementation and macro tangle.

5) Make dynamic percpu var access more efficient.
   - Agree, obviously.  x86 for the moment, the rest can follow (or not).

6) Use percpu allocations more widely.
   - Definitely, I have some other patches which use it too.  And makes even
     more sense once (5) is done.

7) Make percpu area grow dynamically.
   - Yes, but a thorny tangle esp. with IA64.  The cmdline hack is probably
     sufficient meanwhile, and parallels can be drawn with vmalloc.

Cheers,
Rusty.
