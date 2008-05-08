Return-Path: <linux-kernel-owner+w=401wt.eu-S1757037AbYEHBEk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757037AbYEHBEk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 21:04:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751285AbYEHBE2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 21:04:28 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39981 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751215AbYEHBE1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 21:04:27 -0400
Date: Wed, 7 May 2008 18:02:49 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Andrea Arcangeli <andrea@qumranet.com>
cc: Andrew Morton <akpm@linux-foundation.org>, clameter@sgi.com,
       steiner@sgi.com, holt@sgi.com, npiggin@suse.de, a.p.zijlstra@chello.nl,
       kvm-devel@lists.sourceforge.net, kanojsarcar@yahoo.com,
       rdreier@cisco.com, swise@opengridcomputing.com,
       linux-kernel@vger.kernel.org, avi@qumranet.com, linux-mm@kvack.org,
       general@lists.openfabrics.org, hugh@veritas.com, rusty@rustcorp.com.au,
       aliguori@us.ibm.com, chrisw@redhat.com, marcelo@kvack.org,
       dada1@cosmosbay.com, paulmck@us.ibm.com
Subject: Re: [PATCH 08 of 11] anon-vma-rwsem
In-Reply-To: <20080507233953.GM8276@duo.random>
Message-ID: <alpine.LFD.1.10.0805071757520.3024@woody.linux-foundation.org>
References: <6b384bb988786aa78ef0.1210170958@duo.random> <alpine.LFD.1.10.0805071349200.3024@woody.linux-foundation.org> <20080507212650.GA8276@duo.random> <alpine.LFD.1.10.0805071429170.3024@woody.linux-foundation.org> <20080507222205.GC8276@duo.random>
 <20080507153103.237ea5b6.akpm@linux-foundation.org> <20080507224406.GI8276@duo.random> <20080507155914.d7790069.akpm@linux-foundation.org> <20080507233953.GM8276@duo.random>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 8 May 2008, Andrea Arcangeli wrote:

> Hi Andrew,
> 
> On Wed, May 07, 2008 at 03:59:14PM -0700, Andrew Morton wrote:
> > 	CPU0:			CPU1:
> > 
> > 	spin_lock(global_lock)	
> > 	spin_lock(a->lock);	spin_lock(b->lock);
> 				================== mmu_notifier_register()

If mmy_notifier_register() takes the global lock, it cannot happen here. 
It will be blocked (by CPU0), so there's no way it can then cause an ABBA 
deadlock. It will be released when CPU0 has taken *all* the locks it 
needed to take.

> What we can do is to replace the mm_lock with a
> spin_lock(&global_lock) only if all places that takes i_mmap_lock

NO!

You replace mm_lock() with the sequence that Andrew gave you (and I 
described):

	spin_lock(&global_lock)
	.. get all locks UNORDERED ..
	spin_unlock(&global_lock)

and you're now done. You have your "mm_lock()" (which still needs to be 
renamed - it should be a "mmu_notifier_lock()" or something like that), 
but you don't need the insane sorting. At most you apparently need a way 
to recognize duplicates (so that you don't deadlock on yourself), which 
looks like a simple bit-per-vma.

The global lock doesn't protect any data structures itself - it just 
protects two of these mm_lock() functions from ABBA'ing on each other!

			Linus

