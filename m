Return-Path: <linux-kernel-owner+w=401wt.eu-S1755363AbYKTMWz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755363AbYKTMWz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 07:22:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754036AbYKTMWq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 07:22:46 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:34499 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751663AbYKTMWp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 07:22:45 -0500
Date: Thu, 20 Nov 2008 13:22:41 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.28-rc5 00/11] Kernel memory leak detector (updated)
Message-ID: <20081120122241.GH20724@elte.hu>
References: <20081120112903.16607.68902.stgit@pc1117.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081120112903.16607.68902.stgit@pc1117.cambridge.arm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Catalin Marinas <catalin.marinas@arm.com> wrote:

> The main changes (for those who remember the original features):
> 
> - it now uses a priority search tree to make it easier for looking up
>   intervals rather than just fixed values (the initial implementation
>   was with radix tree and changed to hash array because of
>   kmem_cache_alloc calls in the former)
> - internal memory allocator to avoid recursive calls into
>   kmemleak. This is a simple lock-free, per-cpu allocator using
>   pages. The number of pages allocated is bounded, though there could
>   be (very unlikely) situations on SMP systems where page occupation
>   isn't optimal
> - support for all three memory allocators - slab, slob and slub
> - finer-grained locking - there is no global lock held during memory
>   scanning
> - more information reported for leaked objects - current task's
>   command line and pid, jiffies and the stack trace

these are very nice improvements! In particular the sharp reduction in 
false positives and annotations is encouraging.

I'd like to try it in the -tip automated testing setup, provided the 
few details i just commented on are solved, and provided that these 
things are addressed as well:

> Things still to be done:
> 
> - kernel thread to scan and report leaked objects periodically
>   (currently done only when reading the /sys/kernel/debug/memleak
>   file)
> - run-time and boot-time configuration like task stacks scanning,
>   disabling kmemleak, enabling/disabling the automatic scanning

the .config driven automatic "report currently known/suspected leaks 
60 seconds after bootup" feature would be nice to have. Should be 
fairly easy to add, right? Otherwise i'd have no good way of getting a 
leak report out of it, in an automated way.

	Ingo
