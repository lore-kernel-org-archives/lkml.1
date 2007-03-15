Return-Path: <linux-kernel-owner+w=401wt.eu-S1753401AbXCOXB0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753401AbXCOXB0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 19:01:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753405AbXCOXB0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 19:01:26 -0400
Received: from holomorphy.com ([66.93.40.71]:51010 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753401AbXCOXBZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 19:01:25 -0400
Date: Thu, 15 Mar 2007 15:59:55 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Eric Dumazet <dada1@cosmosbay.com>, Ulrich Drepper <drepper@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Andi Kleen <ak@suse.de>, Ravikiran G Thirumalai <kiran@scalex86.org>,
       "Shai Fultheim (Shai@scalex86.org)" <shai@scalex86.org>,
       pravin b shelar <pravin.shelar@calsoftinc.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] FUTEX : introduce private hashtables
Message-ID: <20070315225955.GX2986@holomorphy.com>
References: <20060808070708.GA3931@localhost.localdomain> <200608090826.28249.dada1@cosmosbay.com> <200608090843.52893.dada1@cosmosbay.com> <200703152016.25703.dada1@cosmosbay.com> <45F9ABD1.70204@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45F9ABD1.70204@yahoo.com.au>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 16, 2007 at 07:25:53AM +1100, Nick Piggin wrote:
> I would just avoid the complexity and setup/teardown costs, and just
> use a vmalloc'ed global hash for NUMA.

This patch is not the way to go, but neither are vmalloc()'d global
hashtables. When you just happen to hash to the wrong node, you're in
for quasi-unreproducible poor performance. The size is never right, at
which point RCU resizing is required with all its overhead and memory
freeing delays and failure to resize (even if only to contract) under
pressure. Better would be to use a different data structure admitting
locality of reference and adaptively sizing itself, furthermore
localized to the appropriate sharing domain.  For file-backed futexes,
this would be the struct address_space. For anonymous-backed futexes,
this would be the COW sharing group, which an anon_vma could almost be
used to represent. Using an object to properly represent the COW
sharing group (i.e. Hugh's struct anon) would do the trick, and one
might as well move the rmap code over to it while we're at it since the
anon_vma scanning tricks are all pointless overhead once the COW
sharing group is accurately tracked (the scanning around for nearby vmas
with ->anon_vma set is not great anyway, though the overhead is hidden
in the noise of large teardown and setup operations; inheriting on
fork() is much simpler and faster).

In such a manner localization is accomplished while no interface
extensions are required.


-- wli
