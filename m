Return-Path: <linux-kernel-owner+w=401wt.eu-S1760664AbXEJTWM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760664AbXEJTWM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 15:22:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757788AbXEJTV6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 15:21:58 -0400
Received: from holomorphy.com ([66.93.40.71]:56802 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757438AbXEJTV6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 15:21:58 -0400
Date: Thu, 10 May 2007 12:22:38 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: linux-kernel@vger.kernel.org, Pekka Enberg <penberg@cs.helsinki.fi>,
       Paul Mundt <lethal@linux-sh.org>
Subject: Re: [RFC] Slab allocators: Drop support for destructors
Message-ID: <20070510192238.GM19966@holomorphy.com>
References: <Pine.LNX.4.64.0705101156190.10663@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0705101156190.10663@schroedinger.engr.sgi.com>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 10, 2007 at 12:00:08PM -0700, Christoph Lameter wrote:
> As far as I can tell there is only a single slab destructor left (there 
> is currently another in i386 but its going to go as soon as Andi merges 
> i386s support for quicklists).
> I wonder how difficult it would be to remove it? If we have no need for 
> destructors anymore then maybe we could remove destructor support from the 
> slab allocators? There is no point in checking for destructor uses in 
> the slab allocators if there are none.
> Or are there valid reason to keep them around? It seems they were mainly 
> used for list management which required them to take a spinlock. Taking a 
> spinlock in a destructor is a bit risky since the slab allocators may run 
> the destructors anytime they decide a slab is no longer needed.
> Or do we want to continue support destructors? If so why?

It used to be that some caches retained attached allocated objects
until the time of a destructor call, at which time they were freed.
I'm not aware of any current use of this idiom. Space consumption
pathologies arise very easily from the use of this idiom, so it's
not clear to me it's worth supporting.

List membership of cached preconstructed objects is part of a more
general idiom of updating such objects at the time of a state change
requiring the preconstructed state to change. It is possible to support
this without a ->dtor() operation by means of the allocator supporting
a flushing operation to dispose of cached preconstructed objects, or
the allocator supporting a generation marker for such state changes so
that stale preconstructed objects are tagged as such and re-constructed
on-demand.

The last idiom I can recall for which ->dtor() operations make sense is
essentially an integrity check. It's possible to support this with an
explicit slab debugging option to verify that freed objects have been
returned to their preconstructed states with superior error reporting
provided that some method of comparing the states is arranged. I'm not
aware of any in-kernel uses of this idiom.

Others may be aware of other idioms ->dtor() operations are used to
implement.


-- wli
