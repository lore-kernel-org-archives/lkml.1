Return-Path: <linux-kernel-owner+w=401wt.eu-S1762130AbYEGXUa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762130AbYEGXUa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 19:20:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754405AbYEGXUR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 19:20:17 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38997 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753450AbYEGXUP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 19:20:15 -0400
Date: Wed, 7 May 2008 16:19:05 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Andrea Arcangeli <andrea@qumranet.com>, clameter@sgi.com, steiner@sgi.com,
       holt@sgi.com, npiggin@suse.de, a.p.zijlstra@chello.nl,
       kvm-devel@lists.sourceforge.net, kanojsarcar@yahoo.com,
       rdreier@cisco.com, swise@opengridcomputing.com,
       linux-kernel@vger.kernel.org, avi@qumranet.com, linux-mm@kvack.org,
       general@lists.openfabrics.org, hugh@veritas.com, rusty@rustcorp.com.au,
       aliguori@us.ibm.com, chrisw@redhat.com, marcelo@kvack.org,
       dada1@cosmosbay.com, paulmck@us.ibm.com
Subject: Re: [PATCH 08 of 11] anon-vma-rwsem
In-Reply-To: <20080507155914.d7790069.akpm@linux-foundation.org>
Message-ID: <alpine.LFD.1.10.0805071610490.3024@woody.linux-foundation.org>
References: <6b384bb988786aa78ef0.1210170958@duo.random> <alpine.LFD.1.10.0805071349200.3024@woody.linux-foundation.org> <20080507212650.GA8276@duo.random> <alpine.LFD.1.10.0805071429170.3024@woody.linux-foundation.org> <20080507222205.GC8276@duo.random>
 <20080507153103.237ea5b6.akpm@linux-foundation.org> <20080507224406.GI8276@duo.random> <20080507155914.d7790069.akpm@linux-foundation.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 7 May 2008, Andrew Morton wrote:
> 
> Now, if we need to take both anon_vma->lock AND i_mmap_lock in the newly
> added mm_lock() thing and we also take both those locks at the same time in
> regular code, we're probably screwed.

No, just use the normal static ordering for that case: one type of lock 
goes before the other kind. If those locks nest in regular code, you have 
to do that *anyway*.

The code that can take many locks, will have to get the global lock *and* 
order the types, but that's still trivial. It's something like

	spin_lock(&global_lock);
	for (vma = mm->mmap; vma; vma = vma->vm_next) {
		if (vma->anon_vma)
			spin_lock(&vma->anon_vma->lock);
	}
	for (vma = mm->mmap; vma; vma = vma->vm_next) {
		if (!vma->anon_vma && vma->vm_file && vma->vm_file->f_mapping)
			spin_lock(&vma->vm_file->f_mapping->i_mmap_lock);
	}
	spin_unlock(&global_lock);

and now everybody follows the rule that "anon_vma->lock" precedes 
"i_mmap_lock". So there can be no ABBA deadlock between the normal users 
and the many-locks version, and there can be no ABBA deadlock between 
many-locks-takers because they use the global_lock to serialize.

This really isn't rocket science, guys.

(I really hope and believe that they don't nest anyway, and that you can 
just use a single for-loop for the many-lock case)

		Linus
