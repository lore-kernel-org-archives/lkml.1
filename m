Return-Path: <linux-kernel-owner+w=401wt.eu-S1758403AbYEHBmB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758403AbYEHBmB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 21:42:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754887AbYEHBlv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 21:41:51 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39941 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754839AbYEHBlt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 21:41:49 -0400
Date: Wed, 7 May 2008 18:39:48 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Christoph Lameter <clameter@sgi.com>
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
In-Reply-To: <Pine.LNX.4.64.0805071752490.14829@schroedinger.engr.sgi.com>
Message-ID: <alpine.LFD.1.10.0805071833450.3024@woody.linux-foundation.org>
References: <6b384bb988786aa78ef0.1210170958@duo.random> <alpine.LFD.1.10.0805071349200.3024@woody.linux-foundation.org> <20080507212650.GA8276@duo.random> <alpine.LFD.1.10.0805071429170.3024@woody.linux-foundation.org> <20080507222205.GC8276@duo.random>
 <20080507153103.237ea5b6.akpm@linux-foundation.org> <20080507224406.GI8276@duo.random> <20080507155914.d7790069.akpm@linux-foundation.org> <alpine.LFD.1.10.0805071610490.3024@woody.linux-foundation.org> <Pine.LNX.4.64.0805071637360.14337@schroedinger.engr.sgi.com>
 <alpine.LFD.1.10.0805071655100.3024@woody.linux-foundation.org> <Pine.LNX.4.64.0805071752490.14829@schroedinger.engr.sgi.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 7 May 2008, Christoph Lameter wrote:
> 
> > (That said, we're not running out of vm flags yet, and if we were, we 
> > could just add another word. We're already wasting that space right now on 
> > 64-bit by calling it "unsigned long").
> 
> We sure have enough flags.

Oh, btw, I was wrong - we wouldn't want to mark the vma's (they are 
unique), we need to mark the address spaces/anonvma's. So the flag would 
need to be in the "struct anon_vma" (and struct address_space), not in the 
vma itself. My bad. So the flag wouldn't be one of the VM_xyzzy flags, and 
would require adding a new field to "struct anon_vma()"

And related to that brain-fart of mine, that obviously also means that 
yes, the locking has to be stronger than "mm->mmap_sem" held for writing, 
so yeah, it would have be a separate global spinlock (or perhaps a 
blocking lock if you have some reason to protect anything else with this 
too).

			Linus
