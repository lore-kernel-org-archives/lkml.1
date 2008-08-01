Return-Path: <linux-kernel-owner+w=401wt.eu-S1758991AbYHAXU0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758991AbYHAXU0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 19:20:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752628AbYHAXUP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 19:20:15 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:55870
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752684AbYHAXUO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 19:20:14 -0400
Date: Fri, 01 Aug 2008 16:20:13 -0700 (PDT)
Message-Id: <20080801.162013.06459319.davem@davemloft.net>
To: hugh@veritas.com
Cc: jeremy@goop.org, torvalds@linux-foundation.org, a.p.zijlstra@chello.nl,
       mingo@elte.hu, linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH] lockdep: lock_set_subclass - reset a held lock's
 subclass
From: David Miller <davem@davemloft.net>
In-Reply-To: <Pine.LNX.4.64.0808012051380.6485@blonde.site>
References: <alpine.LFD.1.10.0808011113530.3277@nehalem.linux-foundation.org>
	<48935FA4.5010804@goop.org>
	<Pine.LNX.4.64.0808012051380.6485@blonde.site>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hugh Dickins <hugh@veritas.com>
Date: Fri, 1 Aug 2008 20:59:08 +0100 (BST)

> On Fri, 1 Aug 2008, Jeremy Fitzhardinge wrote:
> > 
> > I have a function traversing a pagetable in vaddr order (low to high), taking
> > pte locks as it builds up batches of pte page updates.  When the batch is
> > issued, it releases all the locks, and won't end up holding more than ~16 at a
> > time.
> > 
> > So, I think this is OK.  There are no internal lock ordering issues, and I
> > don't think there'll be any bad interactions from someone trying to take pte
> > locks for two separate pagetables.  I don't think there's anyone else trying
> > to take more than one pte lock at once, but if there were "lock low vaddr then
> > high" seems like a reasonable locking rule (or more precisely "lowest" to deal
> > with the case of a pte page being aliased at multiple vaddrs).
> 
> Please check the spin_lock_nested() in move_ptes() in mm/mremap.c.

It won't work because spin_lock_nested() is limited to a depth
of 8 and he aparently needs 16.

Taking more than a few locks of the same class at once is bad
news and it's better to find an alternative method.

