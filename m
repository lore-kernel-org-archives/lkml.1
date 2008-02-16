Return-Path: <linux-kernel-owner+w=401wt.eu-S1757910AbYBPTbV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757910AbYBPTbV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2008 14:31:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756173AbYBPTbL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Feb 2008 14:31:11 -0500
Received: from relay2.sgi.com ([192.48.171.30]:40089 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756132AbYBPTbK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2008 14:31:10 -0500
Date: Sat, 16 Feb 2008 11:31:09 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Brice Goglin <Brice.Goglin@inria.fr>,
       Andrea Arcangeli <andrea@qumranet.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [patch 1/6] mmu_notifier: Core code
In-Reply-To: <20080216025803.40d8ccbc.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0802161129020.25573@schroedinger.engr.sgi.com>
References: <20080215064859.384203497@sgi.com> <20080215064932.371510599@sgi.com>
 <20080215193719.262c03a1.akpm@linux-foundation.org> <47B6BDDF.90502@inria.fr>
 <20080216025803.40d8ccbc.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 16 Feb 2008, Andrew Morton wrote:

> "looks good" maybe.  But it's in the details where I fear this will come
> unstuck.  The likelihood that some callbacks really will want to be able to
> block in places where this interface doesn't permit that - either to wait
> for IO to complete or to wait for other threads to clear critical regions.

We can get the invalidate_range to always be called without spinlocks if 
we deal with the case of the inode_mmap_lock being held in truncate case.

If you always want to be able to sleep then we could drop the 
invalidate_page() that is called while pte locks held and require the use 
of a device driver rmap?

> >From that POV it doesn't look like a sufficiently general and useful
> design.  Looks like it was grafted onto the current VM implementation in a
> way which just about suits two particular clients if they try hard enough.

You missed KVM. We did the best we could being as least invasive as 
possible.

> Which is all perfectly understandable - it would be hard to rework core MM
> to be able to make this interface more general.  But I do think it's
> half-baked and there is a decent risk that future (or present) code which
> _could_ use something like this won't be able to use this one, and will
> continue to futz with mlock, page-pinning, etc.
> 
> Not that I know what the fix to that is..

You do not see a chance of this being okay if we adopt the two measures 
that I mentioned above?
 
