Return-Path: <linux-kernel-owner+w=401wt.eu-S1759900AbXIQWhx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759900AbXIQWhx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 18:37:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755969AbXIQWhp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 18:37:45 -0400
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:49895 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753573AbXIQWhp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 18:37:45 -0400
Date: Mon, 17 Sep 2007 23:36:38 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Balbir Singh <balbir@linux.vnet.ibm.com>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH mm] fix swapoff breakage; however...
In-Reply-To: <46EEE81A.1010404@linux.vnet.ibm.com>
Message-ID: <Pine.LNX.4.64.0709172312390.19506@blonde.wat.veritas.com>
References: <Pine.LNX.4.64.0709171947130.15413@blonde.wat.veritas.com>
 <46EED1A7.5080606@linux.vnet.ibm.com> <Pine.LNX.4.64.0709172038090.25512@blonde.wat.veritas.com>
 <46EEE81A.1010404@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Sep 2007, Balbir Singh wrote:
> Hugh Dickins wrote:
> > 
> > What would make sense is (what I meant when I said swap counted
> > along with RSS) not to count pages out and back in as they are
> > go out to swap and back in, just keep count of instantiated pages
> > 
> 
> I am not sure how you define instantiated pages. I suspect that
> you mean RSS + pages swapped out (swap_pte)?

That's it.  (Whereas file pages counted out when paged out,
then counted back in when paged back in.)

> If a swapoff is going to push a container over it's limit, then
> we break the container and the isolation it provides.

Is it just my traditional bias, that makes me prefer you break
your container than my swapoff?  I'm not sure.

> Upon swapoff
> failure, may be we could get the container to print a nice
> little warning so that anyone else with CAP_SYS_ADMIN can fix the
> container limit and retry swapoff.

And then they hit the next one... rather like trying to work out
the dependencies of packages for oneself: a very tedious process.

If the swapoff succeeds, that does mean there was actually room
in memory (+ other swap) for everyone, even if some have gone over
their nominal limits.  (But if the swapoff runs out of memory in
the middle, yes, it might well have assigned the memory unfairly.)

The appropriate answer may depend on what you do when a container
tries to fault in one more page than its limit.  Apparently just
fail it (no attempt to page out another page from that container).

So, if the whole system is under memory pressure, kswapd will
be keeping the RSS of all tasks low, and they won't reach their
limits; whereas if the system is not under memory pressure,
tasks will easily approach their limits and so fail.

Please tell me my understanding is wrong!

Hugh
