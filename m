Return-Path: <linux-kernel-owner+w=401wt.eu-S1754639AbYH3LRp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754639AbYH3LRp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2008 07:17:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751567AbYH3LRg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Aug 2008 07:17:36 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:57076 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751292AbYH3LRg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2008 07:17:36 -0400
Subject: Re: [RT PATCH v2] seqlock: serialize against writers
From: Peter Zijlstra <peterz@infradead.org>
To: Gregory Haskins <ghaskins@novell.com>
Cc: mingo@elte.hu, rostedt@goodmis.org, tglx@linutronix.de,
       linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org,
       gregory.haskins@gmail.com, andi@firstfloor.org, shemminger@vyatta.com
In-Reply-To: <20080829180135.22450.54780.stgit@dev.haskins.net>
References: <20080829154237.1196.66825.stgit@dev.haskins.net>
	 <20080829180135.22450.54780.stgit@dev.haskins.net>
Content-Type: text/plain
Date: Sat, 30 Aug 2008 13:17:23 +0200
Message-Id: <1220095043.8426.16.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-08-29 at 14:03 -0400, Gregory Haskins wrote:
> *Patch submitted for inclusion in PREEMPT_RT 26-rt4.  Applies to 2.6.26.3-rt3*
> 
> Hi Ingo, Steven, Thomas,
>   Please consider for -rt4.  This fixes a nasty deadlock on my systems under
>   heavy load.
> 
> [
> Changelog:
> 	v2: only touch seqlock_t because raw_seqlock_t doesn't require
> 	    serialization and userspace cannot modify data during a read
> 
> 	v1: initial release
> ]
> 
> -Greg
> 
> ----
> seqlock: serialize against writers
> 
> Seqlocks have always advertised that readers do not "block", but this was
> never really true.  Readers have always logically blocked at the head of
> the critical section under contention with writers, regardless of whether
> they were allowed to run code or not.
> 
> Recent changes in this space (88a411c07b6fedcfc97b8dc51ae18540bd2beda0)
> have turned this into a more explicit blocking operation in mainline.
> However, this change highlights a short-coming in -rt because the
> normal seqlock_ts are preemptible.  This means that we can potentially
> deadlock should a reader spin waiting for a write critical-section to end
> while the writer is preempted.

Ah, the point I was missing is higher-priority realtime task, in which
case the write side will never run because it wont preempt.

> This patch changes the internal implementation to use a rwlock and forces
> the readers to serialize with the writers under contention.  This will
> have the advantage that -rt seqlocks_t will sleep the reader if deadlock
> were imminent, and it will pi-boost the writer to prevent inversion.
> 
> This fixes a deadlock discovered under testing where all high prioritiy
> readers were hogging the cpus and preventing a writer from releasing the
> lock.
> 
> Since seqlocks are designed to be used as rarely-write locks, this should
> not affect the performance in the fast-path

Still dont like this patch, once you have a rwlock you might as well go
all the way. Esp since this half-arsed construct defeats PI in certain
cases.

