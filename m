Return-Path: <linux-kernel-owner+w=401wt.eu-S1752215AbYIXV6G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752215AbYIXV6G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 17:58:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752170AbYIXV5y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 17:57:54 -0400
Received: from gw.goop.org ([64.81.55.164]:55263 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752162AbYIXV5x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 17:57:53 -0400
Message-ID: <48DAB7E2.5030009@goop.org>
Date: Wed, 24 Sep 2008 14:57:54 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: benh@kernel.crashing.org
CC: Hugh Dickins <hugh@veritas.com>,
       Linux Memory Management List <linux-mm@kvack.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Nick Piggin <npiggin@suse.de>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Peter Chubb <peterc@gelato.unsw.edu.au>
Subject: Re: PTE access rules & abstraction
References: <1221846139.8077.25.camel@pasglop>  <48D739B2.1050202@goop.org>	 <1222117551.12085.39.camel@pasglop>	 <Pine.LNX.4.64.0809241919520.575@blonde.site> <1222291248.8277.90.camel@pasglop>
In-Reply-To: <1222291248.8277.90.camel@pasglop>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Benjamin Herrenschmidt wrote:
> Well, the current set accessor, as far as I'm concerned is a big pile of
> steaming shit that evolved from x86-specific gunk raped in different
> horrible ways to make it looks like it fits on other architectures and
> additionally mashed with goo to make it somewhat palatable by
> virtualization stuff. Yes, bugs can be fixed but it's still an horrible
> mess.
>   

What do you propose then?  Ideally one would like to get something that
works for powerpc, s390, all the wacky ia64 modes as well as x86.  The
ia64 folks proposed something, but I've not looked at it closely.  From
an x86 virtualization perspective, something that's basically x86 with
as much scope for batching and deferring as possible would be fine.

As a start, what's the state machine for a pte?  What states can it be
in, and how does it move from state to state?  It sounds like powerpc
has at least one extra state above x86 (hashed, with the hash key stored
in the pte itself?).

> Now, regarding the above bug, I'm afraid the only approaches I see that
> would work would be to have either a ptep_get_and_clear_flush(), which I
> suppose x86 virt. people will hate, or maybe to actually have a powerpc
> specific variant of the new start/commit hooks that does the flush.
>   

ptep_get_and_clear() is not batchable anyway, because the x86
implementation requires an atomic xchg on the pte, which will likely
result in some sort of trap (and if it doesn't then it doesn't need
batching).  The start/commit API was specifically so that we can do the
mprotect (and fork COW updates) in a batchable way (in Xen its
implemented with a pte update hypercall which updates the pte without
affecting the A/D bits).

    J
