Return-Path: <linux-kernel-owner+w=401wt.eu-S1757492AbYEGXkL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757492AbYEGXkL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 19:40:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756047AbYEGXjp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 19:39:45 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:41856 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759532AbYEGXjk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 19:39:40 -0400
Date: Wed, 7 May 2008 16:39:39 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Andrea Arcangeli <andrea@qumranet.com>, steiner@sgi.com, holt@sgi.com,
       npiggin@suse.de, a.p.zijlstra@chello.nl,
       kvm-devel@lists.sourceforge.net, kanojsarcar@yahoo.com,
       rdreier@cisco.com, swise@opengridcomputing.com,
       linux-kernel@vger.kernel.org, avi@qumranet.com, linux-mm@kvack.org,
       general@lists.openfabrics.org, hugh@veritas.com, rusty@rustcorp.com.au,
       aliguori@us.ibm.com, chrisw@redhat.com, marcelo@kvack.org,
       dada1@cosmosbay.com, paulmck@us.ibm.com
Subject: Re: [PATCH 08 of 11] anon-vma-rwsem
In-Reply-To: <alpine.LFD.1.10.0805071610490.3024@woody.linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0805071637360.14337@schroedinger.engr.sgi.com>
References: <6b384bb988786aa78ef0.1210170958@duo.random>
 <alpine.LFD.1.10.0805071349200.3024@woody.linux-foundation.org>
 <20080507212650.GA8276@duo.random> <alpine.LFD.1.10.0805071429170.3024@woody.linux-foundation.org>
 <20080507222205.GC8276@duo.random> <20080507153103.237ea5b6.akpm@linux-foundation.org>
 <20080507224406.GI8276@duo.random> <20080507155914.d7790069.akpm@linux-foundation.org>
 <alpine.LFD.1.10.0805071610490.3024@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 May 2008, Linus Torvalds wrote:

> The code that can take many locks, will have to get the global lock *and* 
> order the types, but that's still trivial. It's something like
> 
> 	spin_lock(&global_lock);
> 	for (vma = mm->mmap; vma; vma = vma->vm_next) {
> 		if (vma->anon_vma)
> 			spin_lock(&vma->anon_vma->lock);
> 	}
> 	for (vma = mm->mmap; vma; vma = vma->vm_next) {
> 		if (!vma->anon_vma && vma->vm_file && vma->vm_file->f_mapping)
> 			spin_lock(&vma->vm_file->f_mapping->i_mmap_lock);
> 	}
> 	spin_unlock(&global_lock);

Multiple vmas may share the same mapping or refer to the same anonymous 
vma. The above code will deadlock since we may take some locks multiple 
times.
