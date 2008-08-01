Return-Path: <linux-kernel-owner+w=401wt.eu-S1758026AbYHAT75@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758026AbYHAT75 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 15:59:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753392AbYHAT7t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 15:59:49 -0400
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:42223 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753281AbYHAT7t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 15:59:49 -0400
Date: Fri, 1 Aug 2008 20:59:08 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.site
To: Jeremy Fitzhardinge <jeremy@goop.org>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       David Miller <davem@davemloft.net>, mingo@elte.hu,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH] lockdep: lock_set_subclass - reset a held lock's subclass
In-Reply-To: <48935FA4.5010804@goop.org>
Message-ID: <Pine.LNX.4.64.0808012051380.6485@blonde.site>
References: <20080731.155504.167792984.davem@davemloft.net> 
 <20080801.011122.32782916.davem@davemloft.net>  <20080801090100.GA25142@elte.hu>
  <20080801.021348.233313767.davem@davemloft.net> <1217588920.9686.6.camel@twins>
 <489350AE.1030609@goop.org> <alpine.LFD.1.10.0808011113530.3277@nehalem.linux-foundation.org>
 <48935FA4.5010804@goop.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 1 Aug 2008, Jeremy Fitzhardinge wrote:
> 
> I have a function traversing a pagetable in vaddr order (low to high), taking
> pte locks as it builds up batches of pte page updates.  When the batch is
> issued, it releases all the locks, and won't end up holding more than ~16 at a
> time.
> 
> So, I think this is OK.  There are no internal lock ordering issues, and I
> don't think there'll be any bad interactions from someone trying to take pte
> locks for two separate pagetables.  I don't think there's anyone else trying
> to take more than one pte lock at once, but if there were "lock low vaddr then
> high" seems like a reasonable locking rule (or more precisely "lowest" to deal
> with the case of a pte page being aliased at multiple vaddrs).

Please check the spin_lock_nested() in move_ptes() in mm/mremap.c.

If you have down_write(&mm->mmap_sem) then you should be safe,
but may need to do something to placate lockdep.  If you don't
have down_write(&mm->mmap_sem), then I think you're in trouble?

Not a big deal, the move_ptes() locking can be adjusted to suit
your rule, it was just easier to do it the way it is at the time.

Hugh
