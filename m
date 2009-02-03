Return-Path: <linux-kernel-owner+w=401wt.eu-S1755747AbZBCRiU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755747AbZBCRiU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 12:38:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752682AbZBCRiK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 12:38:10 -0500
Received: from smtp3.ultrahosting.com ([74.213.175.254]:58407 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752254AbZBCRiJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 12:38:09 -0500
Date: Tue, 3 Feb 2009 12:33:14 -0500 (EST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@qirst.com
To: Nick Piggin <nickpiggin@yahoo.com.au>
cc: Nick Piggin <npiggin@suse.de>, Pekka Enberg <penberg@cs.helsinki.fi>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Lin Ming <ming.m.lin@intel.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [patch] SLQB slab allocator
In-Reply-To: <200902031253.28078.nickpiggin@yahoo.com.au>
Message-ID: <alpine.DEB.1.10.0902031217390.17910@qirst.com>
References: <20090114155923.GC1616@wotan.suse.de> <20090123155307.GB14517@wotan.suse.de> <alpine.DEB.1.10.0901261225240.1908@qirst.com> <200902031253.28078.nickpiggin@yahoo.com.au>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Feb 2009, Nick Piggin wrote:

> Quite obviously it should. Behaviour of a slab allocation on behalf of
> some task constrained within a given node should not depend on the task
> which has previously run on this CPU and made some allocations. Surely
> you can see this behaviour is not nice.

If you want cache hot objects then its better to use what a prior task
has used. This opportunistic use is only done if the task is not asking
for memory from a specifc node. There is another tradeoff here.

SLABs method there is to ignore all caching advantages even if the task
did not ask for memory from a specific node. So it gets cache cold objects
and if the node to allow from is remote then it always must use the slow
path.

> > Which have similar issues since memory policy application is depending on
> > a task policy and on memory migration that has been applied to an address
> > range.
>
> What similar issues? If a task ask to have slab allocations constrained
> to node 0, then SLUB hands out objects from other nodes, then that's bad.

Of course. A task can ask to have allocations from node 0 and it will get
the object from node 0. But if the task does not care to ask for data
from a specific node then it can be satisfied from the cpu slab which
contains cache hot objects.

> > > But that is wrong. The lists obviously have high water marks that
> > > get trimmed down. Periodic trimming as I keep saying basically is
> > > alrady so infrequent that it is irrelevant (millions of objects
> > > per cpu can be allocated anyway between existing trimming interval)
> >
> > Trimming through water marks and allocating memory from the page allocator
> > is going to be very frequent if you continually allocate on one processor
> > and free on another.
>
> Um yes, that's the point. But you previously claimed that it would just
> grow unconstrained. Which is obviously wrong. So I don't understand what
> your point is.

It will grow unconstrained if you elect to defer queue processing. That
was what we discussed.
