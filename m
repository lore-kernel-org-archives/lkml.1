Return-Path: <linux-kernel-owner+w=401wt.eu-S1753029AbXDIVtE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753029AbXDIVtE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 17:49:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753071AbXDIVsf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 17:48:35 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:37400 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753415AbXDIVsb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 17:48:31 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ravikiran G Thirumalai <kiran@scalex86.org>, linux-kernel@vger.kernel.org
Subject: Re: [patch] Pad irq_desc to internode cacheline size
References: <20070409195356.GA5275@localhost.localdomain>
	<20070409135729.a466e9cb.akpm@linux-foundation.org>
Date: Mon, 09 Apr 2007 15:47:52 -0600
In-Reply-To: <20070409135729.a466e9cb.akpm@linux-foundation.org> (Andrew
	Morton's message of "Mon, 9 Apr 2007 13:57:29 -0700")
Message-ID: <m1ejmt1apj.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> writes:

> This will consume nearly 4k per irq won't it?  What is the upper bound
> here, across all configs and all hardware?
>
> Is VSMP the only arch which has ____cacheline_internodealigned_in_smp
> larger than ____cacheline_aligned_in_smp?

Ugh. We set internode aligned to 4k for all of x86_64.

I believe this ups our worst case memory consumption for
the array from 1M to 32M.  Although the low end might be 2M.
I can't recall if an irq_desc takes one cache line or two
after we have put the cpu masks in it.

My gut feel says that what we want to do is delay this until
we are dynamically allocating the array members.  Then we can at
least have the chance of allocating the memory on the proper NUMA
node, and won't need the extra NUMA alignment.

I'm not at all certain I'm impressed by an architecture that has
4K aligned cache lines.  That seems terribly piggy.  We might as
well do distributed shared memory in software on a cluster...

Eric
