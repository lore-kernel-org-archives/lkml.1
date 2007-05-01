Return-Path: <linux-kernel-owner+w=401wt.eu-S1030805AbXEANAo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030805AbXEANAo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 09:00:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031209AbXEANAo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 09:00:44 -0400
Received: from holomorphy.com ([66.93.40.71]:52951 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030805AbXEANAm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 09:00:42 -0400
Date: Tue, 1 May 2007 06:00:03 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: Nick Piggin <npiggin@suse.de>
Cc: Thomas Gleixner <tglx@linutronix.de>, Kasper Sandberg <lkml@metanurb.dk>,
       Willy Tarreau <w@1wt.eu>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Gene Heskett <gene.heskett@gmail.com>, linux-kernel@vger.kernel.org,
       Con Kolivas <kernel@kolivas.org>, Mike Galbraith <efault@gmx.de>,
       Arjan van de Ven <arjan@infradead.org>,
       Peter Williams <pwil3058@bigpond.net.au>, caglar@pardus.org.tr,
       Mark Lord <lkml@rtr.ca>, Zach Carter <linux@zachcarter.com>,
       buddabrod <buddabrod@gmail.com>
Subject: Re: [patch] CFS scheduler, -v6
Message-ID: <20070501130003.GS31925@holomorphy.com>
References: <20070429053022.GB23638@1wt.eu> <20070429065900.GB32281@elte.hu> <20070429071627.GC23638@1wt.eu> <1177842654.5791.85.camel@localhost.localdomain> <20070429111159.GH23638@1wt.eu> <1177848054.9756.30.camel@localhost> <1177848810.5791.104.camel@localhost.localdomain> <20070429125522.GB31925@holomorphy.com> <1177853867.5791.120.camel@localhost.localdomain> <20070501075515.GD10590@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070501075515.GD10590@wotan.suse.de>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 01, 2007 at 09:55:15AM +0200, Nick Piggin wrote:
> People seem to be confusing scheduler policy with a modular framework.
> First of all, I don't know that any of the schedulers can "just go in"
> and replace the mainline one, because they are still under development
> and have not been sufficiently tested and contrasted IMO.

I've already made noise about separate modular framework patches, so
recast whatever confusion seems apparent to you in those terms.


On Tue, May 01, 2007 at 09:55:15AM +0200, Nick Piggin wrote:
> Secondly, if we want to have a modular framework, it should:
> - be a seperate patchset to any new scheduler policy
> - obviously retain the existing policy for testing / comparison purposes
> - be able to be compiled out. I don't know whether it's CFS policy or
>   the framework (maybe both), but CFS is quite a bit slower at context
>   switching when I last measured with lmbench (several releases ago).

Compiling such things out is interesting at best, as they typically
require significant code restructuring. You can make the indirect calls
conditional by calling some particular driver directly inside wrapper
macros for the indirect calls via case analysis on ->policy, I suppose.

There are issues with using cfs' notion of a modular framework to
verify performance non-regression, in particular the fact it's
incapable of representing mainline. There is also the problem of doing
very little in the way of hiding data, so that in the event of using it
to compare different implementations of the same policy, e.g. competing
SCHED_OTHER implementations, each is stuck maintaining the others'
state variables, save for the case where one or both happens to have
all its state variable updates fit entirely inside the driver operations,
in which case they still take the hit for bloating the task_struct, and
worse yet, some asymmetry in terms of which is exempt from maintaining
the others' state variables occurs which furthermore penalizes the
competitor maintaining the least state or doing the least state updates.
Such a state of affairs must not be allowed to stand.


On Tue, May 01, 2007 at 09:55:15AM +0200, Nick Piggin wrote:
> I still would rather not have a modular framework unless we decide
> that is the only wake to make upstream progress. But if we did have
> the modular framework, we still need to decide on the process of
> avoiding profileration, selecting a default scheduler, and a plan for
> future phasing out of non-default GP schedulers once a new one gets
> selected.

It certainly cuts down on the eye bleed but I suppose that takes a
back seat to performance considerations.


-- wli
