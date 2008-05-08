Return-Path: <linux-kernel-owner+w=401wt.eu-S1756788AbYEHBJT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756788AbYEHBJT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 21:09:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754100AbYEHBJA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 21:09:00 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59051 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753885AbYEHBI6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 21:08:58 -0400
Date: Wed, 7 May 2008 18:07:27 -0700 (PDT)
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
Message-ID: <alpine.LFD.1.10.0805071803240.3024@woody.linux-foundation.org>
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
> Set the vma flag when we locked it and then skip when we find it locked 
> right? This would be in addition to the global lock?

Yes. And clear it before unlocking (and again, testing if it's already 
clear - you mustn't unlock twice, so you must only unlock when the bit 
was set).

You also (obviously) need to have somethign that guarantees that the lists 
themselves are stable over the whole sequence, but I assume you already 
have mmap_sem for reading (since you'd need it anyway just to follow the 
list).

And if you have it for writing, it can obviously *act* as the global lock, 
since it would already guarantee mutual exclusion on that mm->mmap list.

		Linus
