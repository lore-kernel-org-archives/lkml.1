Return-Path: <linux-kernel-owner+w=401wt.eu-S1760588AbXJRXNT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760588AbXJRXNT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 19:13:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752121AbXJRXNJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 19:13:09 -0400
Received: from tomts22.bellnexxia.net ([209.226.175.184]:46469 "EHLO
	tomts22-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751334AbXJRXNI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 19:13:08 -0400
Date: Thu, 18 Oct 2007 19:13:05 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Ken Chen <kenchen@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [patch] sched: schedstat needs a diet
Message-ID: <20071018231305.GA3035@Krystal>
References: <b040c32a0710161337l24d61d45h61be0ded72b54a9f@mail.gmail.com> <20071017072323.GB18044@elte.hu> <1192613387.27435.114.camel@twins> <20071018221957.GA31609@Krystal> <b040c32a0710181557x4741b9ddxeb01edc788defb6@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <b040c32a0710181557x4741b9ddxeb01edc788defb6@mail.gmail.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 19:08:47 up 80 days, 23:27,  4 users,  load average: 3.46, 1.45, 1.18
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Ken Chen (kenchen@google.com) wrote:
> On 10/18/07, Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:
> > Good question indeed. How large is this memory footprint exactly ? If it
> > is as small as you say, I suspect that the real issue could be that
> > these variable are accessed by the scheduler critical paths and
> > therefore trash the caches.
> 
> Maybe my wording was ambiguous, I meant to reduce cache line pollution
> when accessing these schedstat fields.
> 
> With unsigned long, on x86_64, schedstat consumes 288 bytes for each
> sched_domain and 128 bytes in struct rq.  On a extremely small system
> that has a couple of CPU sockets with one level of numa node, there
> will be 704 bytes per CPU for schedstat.  Given the sparseness of
> them, we are probably talking about 11-12 cache line eviction on
> several heavily used scheduler functions.  Reduce cache line pollution
> is the primary goal, actual memory consumption isn't really a concern.
> 

Generally speaking, if such cache trashing is an issue, why don't we
make sure that each task struct member is declared in this structure
following its access frequency ? (except for #ifdef blocks, which should
stay together) It could then statistically save a lot of cachelines.

Or is it already the case ? It doesn't look like it when I see:

struct list_head ptrace_list;

Just beside the 

struct mm_struct *mm, *active_mm;

pointers.

Mathieu

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
