Return-Path: <linux-kernel-owner+w=401wt.eu-S1752690AbYAPJBo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752690AbYAPJBo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 04:01:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751301AbYAPJBg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 04:01:36 -0500
Received: from iona.labri.fr ([147.210.8.143]:50789 "EHLO iona.labri.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751079AbYAPJBg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 04:01:36 -0500
Message-ID: <478DC7EC.1040101@inria.fr>
Date: Wed, 16 Jan 2008 10:01:32 +0100
From: Brice Goglin <Brice.Goglin@inria.fr>
User-Agent: Mozilla-Thunderbird 2.0.0.9 (X11/20080110)
MIME-Version: 1.0
To: Andrea Arcangeli <andrea@qumranet.com>
CC: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] mmu notifiers #v2
References: <20080113162418.GE8736@v2.random>
In-Reply-To: <20080113162418.GE8736@v2.random>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrea Arcangeli wrote:
> This patch is last version of a basic implementation of the mmu
> notifiers.
>
> In short when the linux VM decides to free a page, it will unmap it
> from the linux pagetables. However when a page is mapped not just by
> the regular linux ptes, but also from the shadow pagetables, it's
> currently unfreeable by the linux VM.
>
> This patch allows the shadow pagetables to be dropped and the page to
> be freed after that, if the linux VM decides to unmap the page from
> the main ptes because it wants to swap out the page.
>
> [...]
>
> Comments welcome... especially from SGI/IBM/Quadrics and all other
> potential users of this functionality.
>   

For HPC, this should be very interesting. Managing the registration 
cache of high-speed networks from user-space is a huge mess. This 
approach should help a lot. In fact, back in 2004, I implemented 
something similar called vmaspy to update the regcache of Myrinet 
drivers. I never submitted any patch because Infiniband would have been 
the only user in the mainline kernel and they were reluctant to these 
ideas [1]. In the meantime, some of them apparently changed their mind 
since they implemented some vmops-overriding hack to do something 
similar [2]. This patch should simplify all this.

One of the difference with my patch is that you attach the notifier list 
to the mm_struct while my code attached it to vmas. But I now don't 
think it was such a good idea since it probably didn't reduce the number 
of notifier calls a lot.

Also, one thing that I looked at in vmaspy was notifying fork. I am not 
sure what happens on Copy-on-write with your code, but for sure C-o-w is 
problematic for shadow page tables. I thought shadow pages should just 
be invalidated when a fork happens and the caller would refill them 
after forcing C-o-w or so. So adding a notifier call there too might be 
nice.

Brice

[1] http://lkml.org/lkml/2005/4/29/175
[2] http://www.osc.edu/~pw/papers/wyckoff-memreg-ccgrid05.pdf

