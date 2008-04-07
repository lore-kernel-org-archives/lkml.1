Return-Path: <linux-kernel-owner+w=401wt.eu-S1754142AbYDGGGi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754142AbYDGGGi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2008 02:06:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751989AbYDGGGa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Apr 2008 02:06:30 -0400
Received: from host36-195-149-62.serverdedicati.aruba.it ([62.149.195.36]:54441
	"EHLO mx.cpushare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751749AbYDGGG3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2008 02:06:29 -0400
Date: Mon, 7 Apr 2008 08:06:02 +0200
From: Andrea Arcangeli <andrea@qumranet.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: Robin Holt <holt@sgi.com>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       kvm-devel@lists.sourceforge.net,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, general@lists.openfabrics.org,
       steiner@sgi.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [patch 02/10] emm: notifier logic
Message-ID: <20080407060602.GE9309@duo.random>
References: <20080404223048.374852899@sgi.com> <20080404223131.469710551@sgi.com> <20080405005759.GH14784@duo.random> <Pine.LNX.4.64.0804062246030.18148@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0804062246030.18148@schroedinger.engr.sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 06, 2008 at 10:48:56PM -0700, Christoph Lameter wrote:
> On Sat, 5 Apr 2008, Andrea Arcangeli wrote:
> 
> > > +	rcu_assign_pointer(mm->emm_notifier, e);
> > > +	mm_unlock(mm);
> > 
> > My mm_lock solution makes all rcu serialization an unnecessary
> > overhead so you should remove it like I already did in #v11. If it
> > wasn't the case, then mm_lock wouldn't be a definitive fix for the
> > race.
> 
> There still could be junk in the cache of one cpu. If you just read the 
> new pointer but use the earlier content pointed to then you have a 
> problem.

There can't be junk, spinlocks provides semantics of proper memory
barriers, just like rcu, so it's entirely superflous.

There could be junk only if any of the mmu_notifier_* methods would be
invoked _outside_ the i_mmap_lock and _outside_ the anon_vma and
outside the mmap_sem, that is never the case of course.

> So a memory fence / barrier is needed to guarantee that the contents 
> pointed to are fetched after the pointer.

It's not needed... if you were right we could never possibly run a
list_for_each inside any spinlock protected critical section and we'd
always need to use the _rcu version instead. The _rcu version is
needed only when the list walk happens outside the spinlock critical
section of course (rcu = no spinlock cacheline exlusive write
operation in the read side, here the read side takes the spinlock big time).
