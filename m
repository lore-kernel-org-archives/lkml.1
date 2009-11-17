Return-Path: <linux-kernel-owner+w=401wt.eu-S1754840AbZKQIdr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754840AbZKQIdr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 03:33:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754633AbZKQIdq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 03:33:46 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:33843 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754617AbZKQIdq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 03:33:46 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: David Rientjes <rientjes@google.com>
Subject: Re: [PATCH 0/7] Kill PF_MEMALLOC abuse
Cc: kosaki.motohiro@jp.fujitsu.com, linux-mm <linux-mm@kvack.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <alpine.DEB.2.00.0911170004380.1564@chino.kir.corp.google.com>
References: <20091117161551.3DD4.A69D9226@jp.fujitsu.com> <alpine.DEB.2.00.0911170004380.1564@chino.kir.corp.google.com>
Message-Id: <20091117172802.3DF4.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue, 17 Nov 2009 17:33:48 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Tue, 17 Nov 2009, KOSAKI Motohiro wrote:
> 
> > 
> > PF_MEMALLOC have following effects.
> >   (1) Ignore zone watermark
> >   (2) Don't call reclaim although allocation failure, instead return ENOMEM
> >   (3) Don't invoke OOM Killer
> >   (4) Don't retry internally in page alloc
> > 
> > Some subsystem paid attention (1) only, and start to use PF_MEMALLOC abuse.
> > But, the fact is, PF_MEMALLOC is the promise of "I have lots freeable memory.
> > if I allocate few memory, I can return more much meory to the system!".
> > Non MM subsystem must not use PF_MEMALLOC. Memory reclaim
> > need few memory, anyone must not prevent it. Otherwise the system cause
> > mysterious hang-up and/or OOM Killer invokation.
> > 
> > if many subsystem will be able to use emergency memory without any
> > usage rule, it isn't for emergency. it can become empty easily.
> > 
> > Plus, characteristics (2)-(4) mean PF_MEMALLOC don't fit to general
> > high priority memory allocation.
> > 
> > Thus, We kill all PF_MEMALLOC usage in no MM subsystem.
> 
> I agree in principle with removing non-VM users of PF_MEMALLOC, but I 
> think it should be left to the individual subsystem maintainers to apply 
> or ack since the allocations may depend on the __GFP_NORETRY | ~__GFP_WAIT 
> behavior of PF_MEMALLOC.  This could be potentially dangerous for a 
> PF_MEMALLOC user if allocations made by the kthread, for example, should 
> never retry for orders smaller than PAGE_ALLOC_COSTLY_ORDER or block on 
> direct reclaim.

if there is so such reason. we might need to implement another MM trick.
but keeping this strage usage is not a option. All memory freeing activity
(e.g. page out, task killing) need some memory. we need to protect its
emergency memory. otherwise linux reliability decrease dramatically when
the system face to memory stress.





