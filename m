Return-Path: <linux-kernel-owner+w=401wt.eu-S933187AbXGZRMc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933187AbXGZRMc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 13:12:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762547AbXGZRMY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 13:12:24 -0400
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:60809 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761481AbXGZRMX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 13:12:23 -0400
Date: Thu, 26 Jul 2007 18:11:32 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
cc: Andi Kleen <andi@firstfloor.org>, Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: [patch] mm: reduce pagetable-freeing latencies
In-Reply-To: <1185360414.5439.335.camel@localhost.localdomain>
Message-ID: <Pine.LNX.4.64.0707261758280.370@blonde.wat.veritas.com>
References: <20070724083855.GA858@elte.hu>  <20070724015441.8604d85d.akpm@linux-foundation.org>
  <1185270045.5439.249.camel@localhost.localdomain>  <p73abtmt2y7.fsf@bingen.suse.de>
  <1185312559.5439.276.camel@localhost.localdomain>  <1185345850.8197.64.camel@twins>
 <20070725094605.GA9045@one.firstfloor.org>  <1185358093.5439.325.camel@localhost.localdomain>
  <20070725102608.GB9045@one.firstfloor.org> <1185360414.5439.335.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Brightmail-Verdict: VlJEQwAAAAIAAAABAAAAAAAAAAEAAAAAAAAABmluYm94AGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmcAYWtwbUBsaW51eC1mb3VuZGF0aW9uLm9yZwBiZW5oQGtlcm5lbC5jcmFzaGluZy5vcmcAcGV0ZXJ6QGluZnJhZGVhZC5vcmcAYW5kaUBmaXJzdGZsb29yLm9yZwBtaW5nb0BlbHRlLmh1AA==
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Jul 2007, Benjamin Herrenschmidt wrote:
> 
> In fact, i discussed with peter and I think the best is to only have one
> entry in the stack mmu_gather structure.

Four or eight would be much nicer than one, but you're right there's
a stackdepth worry: good spotting of those unmap_mapping_range cases,
I'd certainly been thinking we were fairly near the top of the stack
in unmap_vmas, which is not so (or not obviously so) in those cases.

> If we fail to allocate a page
> to batch entries, we flush that one and steal it :-) Then we have a page
> to gather more.

That will often be the case for anonymous pages, but not for pagecache
pages.  I had wondered whether to make exit_mmap unmap the stack first
(rather than text first as usually happens), but seems rather a hack.

Hugh
