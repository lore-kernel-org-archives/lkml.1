Return-Path: <linux-kernel-owner+w=401wt.eu-S1754364AbXLFUEc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754364AbXLFUEc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 15:04:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751755AbXLFUEY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 15:04:24 -0500
Received: from phunq.net ([64.81.85.152]:32976 "EHLO moonbase.phunq.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751592AbXLFUEX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 15:04:23 -0500
From: Daniel Phillips <phillips@phunq.net>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC] [PATCH] A clean approach to writeout throttling
Date: Thu, 6 Dec 2007 12:04:14 -0800
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>
References: <200712051603.02183.phillips@phunq.net> <200712060148.53805.phillips@phunq.net> <20071206035511.83bef995.akpm@linux-foundation.org>
In-Reply-To: <20071206035511.83bef995.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712061204.14854.phillips@phunq.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 06 December 2007 03:55, Andrew Morton wrote:
> Consider an example.
>
> - We a-priori decide to limit a particular stack's peak memory usage
> to 1MB

Ah, this is the piece I was missing.

> - We empirically discover that the maximum amount of memory which is
>   allocated by that stack on behalf of a single BIO is 16kb.  (ie:
> that's the most it has ever used for a single BIO).
>
> - Now, we refuse to feed any more BIOs into the stack when its
>   instantaneous memory usage exceeds (1MB - 16kb).

And printk a warning, because the programmer's static analysis was
wrong.

> Of course, the _average_ memory-per-BIO is much less than 16kb.  So
> there are a lot of BIOs in flight - probably hundreds, but a minimum
> of 63.

And progress is being made, everybody is happy.

> There is a teeny so-small-it-doesn't-matter chance that the stack
> will exceed the 1MB limit.  If it happens to be at its (1MB-16kb)
> limit and all the memory in the machine is AWOL and then someone
> throws a never-seen-before twirly BIO at it.  Not worth worrying
> about, surely.

OK, I see where you are going.  The programmer statically determines a 
total reservation for the stack, which is big enough that progress is 
guaranteed.  We then throttle based on actual memory consumption, and 
essentially use a heuristic to decide when we are near the upper limit.  
Workable I think, but...

The main idea, current->pages_used_for_block_allocations++ is valid only 
in direct call context.  If a daemon needs to allocate memory on behalf 
of the IO transfer (not unusual) it won't get accounted, which is 
actually the central issue in this whole class of deadlocks.  Any idea 
how to extend the accounting idea to all tasks involved in a particular 
block device stack?

Regards,

Daniel
