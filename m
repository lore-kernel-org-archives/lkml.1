Return-Path: <linux-kernel-owner+w=401wt.eu-S1756215AbYC1R3a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756215AbYC1R3a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 13:29:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753999AbYC1R3W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 13:29:22 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39791 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754086AbYC1R3V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 13:29:21 -0400
Date: Fri, 28 Mar 2008 10:27:44 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Pekka Enberg <penberg@cs.helsinki.fi>
cc: Christoph Lameter <clameter@sgi.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Pawel Staszewski <pstaszewski@artcom.pl>,
       LKML <linux-kernel@vger.kernel.org>, Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>
Subject: Re: 2.6.25-rc7-git2: Reported regressions from 2.6.24
In-Reply-To: <84144f020803281015s60370d9dpec0913c33004b6c2@mail.gmail.com>
Message-ID: <alpine.LFD.1.00.0803281017500.14670@woody.linux-foundation.org>
References: <200803272353.51901.rjw@sisk.pl>  <alpine.LFD.1.00.0803271859280.14670@woody.linux-foundation.org>  <Pine.LNX.4.64.0803272002090.11979@schroedinger.engr.sgi.com>  <alpine.LFD.1.00.0803272050290.14670@woody.linux-foundation.org>
 <84144f020803281015s60370d9dpec0913c33004b6c2@mail.gmail.com>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 28 Mar 2008, Pekka Enberg wrote:
> 
> On Fri, Mar 28, 2008 at 6:00 AM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> >  And the fact is, passing in GFP_ZERO from the SLUB code is a bug
> >  regardless, because it unnecessarily does the dual memset().
> 
> We clear GFP_ZERO in new_slab() so the normal kmalloc()/kzalloc() path
> should be fine but don't do it for kmalloc_large() nor
> kmalloc_large_node(). Is that the bug here?

Dammit, NO.

The bug was that the commit I made (which was correct and robust) was then 
partially reverted by Christoph for no good reason. At that point, 
kmalloc_large() didn't even exist, so at that point the change was 
"technically correct" (since the only user of gfpflags really did end up 
clearing it somewhere deep in its callchain).

So when that original 3811dbf67162bd08412f1b0e02e554f353e93bdb happened, 
it wasn't an outright bug - but that doesn't make it right. That commit 
was always just a bug waiting to happen, because it just set things up for 
later problems by retaining that bit when it really shouldn't have been 
retained, and forcing all future callers to be careful. Which they 
obviously were not!

Yes, you can clear GFP_ZERO in multiple illogical places, and it will fix 
the bug. Or you can clear it in *one* place, that is in on the direct 
callchain from the person who actually does the memset(0), and even add a 
comment that says exactly what is going on.

So the fact is, commit 3811dbf67162bd08412f1b0e02e554f353e93bdb is and was 
total and utter crap. I've reverted it in my tree. It's crap not because 
it was buggy when it was put in, but because it was *fragile* when it was 
put in. And that fragility ended up causing a bug later.

I'm getting really tired of slub. It was supposed to be simpler code than 
slab, and yes, it's simpler, but it has been buggy as hell, and part of it 
has been that people just haven't been careful enough, and haven't written 
code to be defensive and easy-to-follow.

So the *last* thing we want to do is to clear GFP_ZERO in multiple subtle 
places based on new random code being added. We want to clear it at the 
top level, so that no other code never ever even has to _think_ about it!

			Linus
