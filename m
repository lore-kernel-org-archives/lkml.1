Return-Path: <linux-kernel-owner+w=401wt.eu-S1759948AbXJEJFo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759948AbXJEJFo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2007 05:05:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753581AbXJEJFg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Oct 2007 05:05:36 -0400
Received: from gw.goop.org ([64.81.55.164]:53389 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753493AbXJEJFf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2007 05:05:35 -0400
Message-ID: <4705FE5C.4060807@goop.org>
Date: Fri, 05 Oct 2007 02:05:32 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Keir Fraser <Keir.Fraser@xensource.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Hugh Dickens <hugh@veritas.com>,
       David Rientjes <rientjes@google.com>, Zachary Amsden <zach@vmware.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <ak@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: race with page_referenced_one->ptep_test_and_clear_young and
 pagetable setup/pulldown
References: <C32B9BEC.E711%keir@xensource.com>
In-Reply-To: <C32B9BEC.E711%keir@xensource.com>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Keir Fraser wrote:
>
> Hang on! How is the access unlocked? By my reading
> page_referenced_one()->page_check_address()->spin_lock(pte_lockptr()).
>

Ah, OK.  I'd overlooked that.

> The problem here is most likely insufficient locking in the pin/unpin
> table-walking code, in light of the fact that you are probably running
> with
> per-page spinlocks (SPLIT_PTLOCK_CPUS). Because we nobble that option
> in our
> own kernel ports it suffices to take the page_table_lock when doing the
> walk-[un]pin-remap routine. This is *not* true with SPLIT_PTLOCK_CPUS.
>

Hm, I see.

> Fortuitously, Jan Beulich has a patch to fix this. It's not going to be
> directly applicable to 2.6.23-rc series, but should be easily ported:
> <http://lists.xensource.com/archives/html/xen-devel/2007-03/msg01200.html>.
>

OK, I can use that.


Andi says:
> Do I misread that patch or does it really walk the complete address
> space and try to take all possible locks? Isn't that very slow?
>   

That's pretty much what it has to do.  Pinning/unpinning walks the whole
pagetable anyway, so it shouldn't be much more expensive.  And they're
relatively rare operations (fork, exec, exit).

    J
