Return-Path: <linux-kernel-owner+w=401wt.eu-S1753870AbYHSHag@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753870AbYHSHag (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 03:30:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752031AbYHSHa3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 03:30:29 -0400
Received: from one.firstfloor.org ([213.235.205.2]:36242 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751952AbYHSHa2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 03:30:28 -0400
Date: Tue, 19 Aug 2008 09:32:14 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, LKML <linux-kernel@vger.kernel.org>,
       x86@kernel.org, Andi Kleen <andi@firstfloor.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH 0 of 9] x86/smp function calls: convert x86 tlb flushes to use function calls [POST 2]
Message-ID: <20080819073214.GD9807@one.firstfloor.org>
References: <patchbomb.1219083817@localhost> <20080819004531.GI9914@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080819004531.GI9914@elte.hu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> nice stuff!

If only those 35% wouldn't be there ...

> 
> I suspect the extra cost might be worth it for two reasons: 1) we could 
> optimize the cross-call implementation further 2) on systems where TLB 
> flushes actually matter, the ability to overlap multiple TLB flushes to 
> the same single CPU might improve workloads.

If this is getting seriously optimized it would be useful to address
this at a slightly higher level in the generic MM.  As in expose
the queue on the TLB flush interfaces.

While munmap and exit are pretty good at batching flushes vmscan.c is terrible 
and tends to do all the flushing on clearing pages synchronously.

Back in 2.4 I at some point ran into a nasty livelock where 
one CPU would always flush the other and the other would always 
bounce some mm locks with the other and the CPUs were nearly 100% 
busy just doing while swapping. Fortunately that issue disappeared
with 2.6, but I still fear a little it will come back some day.

Also with these queued invalidates right now there is duplication
of data structures with the delayed mmu gather flusher in asm-generic/tlb.h.
Both have their own queue.

If the low level flusher is queuing anyways it might be useful
to do a x86 specific implementation that combines the both and
frees the pages once the queue has been processed. Perhaps
that could amortize part of the 35%? 

-Andi

