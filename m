Return-Path: <linux-kernel-owner+w=401wt.eu-S1754930AbZINIEq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754930AbZINIEq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 04:04:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754573AbZINIEp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 04:04:45 -0400
Received: from hera.kernel.org ([140.211.167.34]:42575 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750749AbZINIEo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 04:04:44 -0400
Message-ID: <4AADF8FE.1060208@kernel.org>
Date: Mon, 14 Sep 2009 17:04:14 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       lenb@kernel.org, mingo@elte.hu, peterz@infradead.org,
       yanmin_zhang@linux.intel.com, torvalds@linux-foundation.org,
       jens.axboe@oracle.com, David Howells <dhowells@redhat.com>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Subject: Re: PATCH] cpuidle: A new variant of the menu governor to boost IO
 performance
References: <20090911174019.1ed02737@infradead.org> <20090914004301.105196cc.akpm@linux-foundation.org>
In-Reply-To: <20090914004301.105196cc.akpm@linux-foundation.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 14 Sep 2009 08:04:17 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> This fails to compile in linux-next:
> 
> drivers/cpuidle/governors/menu-tng.o:(.discard+0x0): multiple definition of `__pcpu_unique_menu_devices'
> drivers/cpuidle/governors/menu.o:(.discard+0x0): first defined here
> 
> because we have
> 
> static DEFINE_PER_CPU(struct menu_device, menu_devices);
> 
> in both menu.c and menu-tng.c.
> 
> Despite the `static', the percpu changes in
> 
> commit 7c756e6e19e71f0327760d8955f7077118ebb2b1
> Author:     Tejun Heo <tj@kernel.org>
> AuthorDate: Wed Jun 24 15:13:50 2009 +0900
> Commit:     Tejun Heo <tj@kernel.org>
> CommitDate: Wed Jun 24 15:13:50 2009 +0900
> 
>     percpu: implement optional weak percpu definitions
> 
> are emitting global symbol derived from `menu_devices' and they clash.
> 
> I'll rename menu_devices to fix that up, but we have a problem...

Unfortunately, this was the only way we could come up with to get
alpha and s390 working with the new percpu allocator.  On other archs,
the global definition isn't necessary but config option
DEBUG_FORCE_WEAK_PER_CPU enables it so that alpha and s390 don't choke
on generic code later.

The core of the problem is that the memory model used by gcc on those
two archs assume that static symbols are reachable with small offset
but percpu variables, static or not, always end up way away.  Making
all percpu variables weak and using global symbols to enforce global
uniqueness works around the problem but with the side effect you're
seeing.

If someone has any better ideas, I would happy to remove the annoying
restriction.

Thanks.

-- 
tejun
