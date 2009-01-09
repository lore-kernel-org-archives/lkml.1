Return-Path: <linux-kernel-owner+w=401wt.eu-S1758974AbZAIWDM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758974AbZAIWDM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 17:03:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758472AbZAIWCu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 17:02:50 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:45244 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758693AbZAIWCt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 17:02:49 -0500
Subject: Re: [PATCH] RFC: futex fault handling and futex key references
 (NOT FOR INCLUSION)
From: Peter Zijlstra <peterz@infradead.org>
To: Darren Hart <dvhltc@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, Darren Hart <dvhltc@us.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Nick Piggin <npiggin@suse.de>
In-Reply-To: <20090109075148.2226.5222.stgit@Aeon>
References: <20090109075148.2226.5222.stgit@Aeon>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Fri, 09 Jan 2009 23:02:44 +0100
Message-Id: <1231538564.29452.16.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-01-08 at 23:52 -0800, Darren Hart wrote:
> While trying to bend my brain around the various layers of fault handling in
> futex.c, I think I may have uncovered some logical errors (or at least stale
> code sections).  I've attached two patches that address the alleged problems
> against linux-tip/core/futexes.  They are based on the following assumption:
> 
> Since the uaddr passed to a futex function isn't updated within the function,
> and the mm doesn't change while we're in there, 

That's not quite true, you _can_ change the memory map by issuing
concurrent mmap/munmap/mremap etc.. calls from another thread.

The thing is, afaik futexes have never been completely safe wrt
concurrent mm modifications -- that is, as long as we fail the futex op
with -EFAULT or similar and not crash the kernel we're good.

> there should never be a need to
> make repeat calls to futex_get_key().  Even if the queue_lock is dropped, the
> futex_q might lose it's waiter (requeued) but the key stays the same.

Yes, so when we assume the mmap stable (and fail the op whenever that
assumption proves false) we can say the futex keys are stable and should
never need recomputation.
