Return-Path: <linux-kernel-owner+w=401wt.eu-S934091AbYEGWdb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934091AbYEGWdb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 18:33:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764277AbYEGWdC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 18:33:02 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59319 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760904AbYEGWc7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 18:32:59 -0400
Date: Wed, 7 May 2008 15:31:03 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Andrea Arcangeli <andrea@qumranet.com>
Cc: torvalds@linux-foundation.org, clameter@sgi.com, steiner@sgi.com,
       holt@sgi.com, npiggin@suse.de, a.p.zijlstra@chello.nl,
       kvm-devel@lists.sourceforge.net, kanojsarcar@yahoo.com,
       rdreier@cisco.com, swise@opengridcomputing.com,
       linux-kernel@vger.kernel.org, avi@qumranet.com, linux-mm@kvack.org,
       general@lists.openfabrics.org, hugh@veritas.com, rusty@rustcorp.com.au,
       aliguori@us.ibm.com, chrisw@redhat.com, marcelo@kvack.org,
       dada1@cosmosbay.com, paulmck@us.ibm.com
Subject: Re: [PATCH 08 of 11] anon-vma-rwsem
Message-Id: <20080507153103.237ea5b6.akpm@linux-foundation.org>
In-Reply-To: <20080507222205.GC8276@duo.random>
References: <6b384bb988786aa78ef0.1210170958@duo.random>
	<alpine.LFD.1.10.0805071349200.3024@woody.linux-foundation.org>
	<20080507212650.GA8276@duo.random>
	<alpine.LFD.1.10.0805071429170.3024@woody.linux-foundation.org>
	<20080507222205.GC8276@duo.random>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 May 2008 00:22:05 +0200
Andrea Arcangeli <andrea@qumranet.com> wrote:

> > No, the simple solution is to just make up a whole new upper-level lock, 
> > and get that lock *first*. You can then take all the multiple locks at a 
> > lower level in any order you damn well please. 
> 
> Unfortunately the lock you're talking about would be:
> 
> static spinlock_t global_lock = ...
> 
> There's no way to make it more granular.
> 
> So every time before taking any ->i_mmap_lock _and_ any anon_vma->lock
> we'd need to take that extremely wide spinlock first (and even worse,
> later it would become a rwsem when XPMEM is selected making the VM
> even slower than it already becomes when XPMEM support is selected at
> compile time).

Nope.  We only need to take the global lock before taking *two or more* of
the per-vma locks.

I really wish I'd thought of that.
