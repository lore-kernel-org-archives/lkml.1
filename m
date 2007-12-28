Return-Path: <linux-kernel-owner+w=401wt.eu-S1754576AbXL1CT6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754576AbXL1CT6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2007 21:19:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753587AbXL1CTt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Dec 2007 21:19:49 -0500
Received: from relay2.sgi.com ([192.48.171.30]:45737 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753519AbXL1CTt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2007 21:19:49 -0500
Date: Thu, 27 Dec 2007 18:19:46 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Al Viro <viro@ZenIV.linux.org.uk>
cc: Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: SLUB sysfs support
In-Reply-To: <20071228004504.GK27894@ZenIV.linux.org.uk>
Message-ID: <Pine.LNX.4.64.0712271811470.2053@schroedinger.engr.sgi.com>
References: <20071224233701.GB9784@kernel.org>
 <Pine.LNX.4.64.0712261330030.16904@schroedinger.engr.sgi.com>
 <20071226221631.GD27894@ZenIV.linux.org.uk>
 <Pine.LNX.4.64.0712262149000.19009@schroedinger.engr.sgi.com>
 <Pine.LNX.4.64.0712271222190.31582@schroedinger.engr.sgi.com>
 <20071227225947.GH27894@ZenIV.linux.org.uk> <Pine.LNX.4.64.0712271508080.917@schroedinger.engr.sgi.com>
 <Pine.LNX.4.64.0712271552420.1154@schroedinger.engr.sgi.com>
 <20071227235804.GJ27894@ZenIV.linux.org.uk> <Pine.LNX.4.64.0712271601200.1294@schroedinger.engr.sgi.com>
 <20071228004504.GK27894@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 Dec 2007, Al Viro wrote:

> Oh, lovely.  So we can have module A do kmem_cache_create(), calling
> cache "foo".  Then module B does (without any knowlegde about A)
> completely unrelated kmem_cache_create(), calling the sucker "bar".
> mm/slub decides that they are mergable.  Then we get rmmod A... and
> no way to find out if that's foo or bar going away - kmem_cache_destroy()
> doesn't have enough information to figure that out.  So we have to keep
> both slab/foo and slab/bar around until both are gone or until somebody
> kind enough creates a cache called foo.  Better yet, on some systems you
> get things like slab/nfsd4_delegations sticking around long after nfsd is
> gone just because slub.c decides that it's sharable, but in the next
> kernel version the thing it's shared with gets different object size and
> behaviour suddenly changes - now it's gone as soon as nfsd is gone.
> Brilliant interface, that...

Just enable slab debugging and all of that goes away and you get the usual 
error messages. Otherwise slub tries to compress the memory use as much as 
possible. The advantage here is that you can add an abitrary amount of 
kmem_cache_create() without increasing memory use significantly. Its cheap 
to do kmem_cache creations. Thus you can create open arbitrary caches not 
worrying about memory use and have meaningful variables on which you do 
kmem_cache_alloc instead of kmalloc/kfree. kmalloc/kfree wastes space 
since they go to powers of two. And kmalloc/kfree have to calculate the
cache at runtime whereas kmem_cache_alloc/free does the lookup once.

The amount of per cpu stuff we keep around that is idle is reduced by 50%. 
Increasing cpu cache usage and reduces memory footprint. per cpu stuff 
has to hold per cpu reserves and it is not good to waste too much memory 
there.

nfsd4_delegations? What is this about?

How do I scan for the symlinks in sysfs?

