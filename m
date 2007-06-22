Return-Path: <linux-kernel-owner+w=401wt.eu-S1756319AbXFVWzL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756319AbXFVWzL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 18:55:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759593AbXFVWyw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 18:54:52 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:58613 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759525AbXFVWyu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 18:54:50 -0400
Date: Fri, 22 Jun 2007 15:54:40 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Hugh Dickins <hugh@veritas.com>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Nicolas Ferre <nicolas.ferre@rfo.atmel.com>,
       ARM Linux Mailing List 
	<linux-arm-kernel@lists.arm.linux.org.uk>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Marc Pignat <marc.pignat@hevs.ch>, Andrew Victor <andrew@sanpeople.com>,
       Pierre Ossman <drzeus@drzeus.cx>,
       Andrew Morton <akpm@linux-foundation.org>,
       Russell King <rmk@arm.linux.org.uk>
Subject: Re: Oops in a driver while using SLUB as a SLAB allocator
In-Reply-To: <Pine.LNX.4.64.0706222110250.13850@blonde.wat.veritas.com>
Message-ID: <Pine.LNX.4.64.0706221531520.19704@schroedinger.engr.sgi.com>
References: <467A4532.40301@rfo.atmel.com> <Pine.LNX.4.64.0706212244090.19755@blonde.wat.veritas.com>
 <Pine.LNX.4.64.0706211835070.11608@schroedinger.engr.sgi.com>
 <Pine.LNX.4.64.0706220539050.11131@blonde.wat.veritas.com>
 <alpine.LFD.0.98.0706220937271.3593@woody.linux-foundation.org>
 <Pine.LNX.4.64.0706221040310.17139@schroedinger.engr.sgi.com>
 <Pine.LNX.4.64.0706221931370.4699@blonde.wat.veritas.com>
 <Pine.LNX.4.64.0706221143190.17958@schroedinger.engr.sgi.com>
 <Pine.LNX.4.64.0706221955360.9081@blonde.wat.veritas.com>
 <Pine.LNX.4.64.0706221206130.18210@schroedinger.engr.sgi.com>
 <Pine.LNX.4.64.0706222110250.13850@blonde.wat.veritas.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Jun 2007, Hugh Dickins wrote:

> On Fri, 22 Jun 2007, Christoph Lameter wrote:
> > 
> > We need to fix any remaining weird slab object uses right now. Your check 
> > leaves a lot of holes open. 2.6.22 removes all other such strange slab 
> > uses in other arches. It would be inconsistent if we left these things in 
> > ARM (and maybe PA-RISC).
> 
> As I understand it, that driver used to work right with SLAB, then
> oopsed with SLUB, and now works okay again with the page_mapping patch?

Try to enable debugging then it may fail again despite your patch. You 
just scratched the surface with this and are enabling a dangerous usage 
mode with SLUB that we explicitly did not want to support anymore.
 
> I'm unclear how it comes about that you removed "all other such strange
> slab uses in other arches", yet missed this?  That suggests there may
> be further unexpected uses.

There could be other uses that were missed. I looked for slabs created by 
kmem_cache_create. The trouble is that any kmalloc could also be used for 
engineer these weird things (as seen here) and there are gazillions of 
kmallocs. That is why a VM_BUG_ON is useful. However, it requires some 
effort even with SLAB to create these things and--given that we have 
tested extensively on lots of arches--I am hopeful that 
we have caught everything.

> It worries me that any use which catches you by surprise has to be
> fixed up in the caller, rather than in slub itself: slab/slub is a
> service, not a master.  But I'm rather repeating myself.

SLUB used to implement the same special casing as SLAB did (which results 
in the fragile scenarios in which the above is possible). But we made the 
decision to clean up the slab interface and we dropped the emulation of 
the SLAB frills from SLUB.

Messy and problematic code like this should be removed. That improves the 
quality of the kernel. The removal is a straightfoward process. And the 
cases that we are discussing here are in remote corners of the kernel.
