Return-Path: <linux-kernel-owner+w=401wt.eu-S1757221AbYCVBFv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757221AbYCVBFv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 21:05:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753599AbYCVBFl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 21:05:41 -0400
Received: from flusers.ccur.com ([12.192.68.2]:28828 "EHLO gamx.iccur.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752933AbYCVBFk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 21:05:40 -0400
Date: Fri, 21 Mar 2008 21:02:35 -0400
From: Joe Korty <joe.korty@ccur.com>
To: Chris Wright <chrisw@sous-sol.org>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org,
       Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: Re: [patch 00/76] 2.6.24-stable review
Message-ID: <20080322010235.GB29191@tsunami.ccur.com>
Reply-To: Joe Korty <joe.korty@ccur.com>
References: <20080321224250.144333319@sous-sol.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080321224250.144333319@sous-sol.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 21, 2008 at 03:42:50PM -0700, Chris Wright wrote:
> This is the start of the stable review cycle for the 2.6.24.4 release.

Hi Chris,
The below is also a candidate for 2.6.24.4.  It should apply cleanly.
Joe

Gitweb:     http://git.kernel.org/git/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=6d2144d355d2a532e5cc3fc12a6ba2a8d4ef15e4
Commit:     6d2144d355d2a532e5cc3fc12a6ba2a8d4ef15e4
Parent:     b6210386787728b84db25adc4f1eba70440a4c73
Author:     Joe Korty <joe.korty@ccur.com>
AuthorDate: Wed Mar 5 15:04:59 2008 -0800
Committer:  Christoph Lameter <clameter@sgi.com>
CommitDate: Thu Mar 6 16:21:50 2008 -0800

    slab: NUMA slab allocator migration bugfix
    
    NUMA slab allocator cpu migration bugfix
    
    The NUMA slab allocator (specifically, cache_alloc_refill)
    is not refreshing its local copies of what cpu and what
    numa node it is on, when it drops and reacquires the irq
    block that it inherited from its caller.  As a result
    those values become invalid if an attempt to migrate the
    process to another numa node occured while the irq block
    had been dropped.
    
    The solution is to make cache_alloc_refill reload these
    variables whenever it drops and reacquires the irq block.
    
    The error is very difficult to hit.  When it does occur,
    one gets the following oops + stack traceback bits in
    check_spinlock_acquired:
    
    	kernel BUG at mm/slab.c:2417
    	cache_alloc_refill+0xe6
    	kmem_cache_alloc+0xd0
    	...
    
    This patch was developed against 2.6.23, ported to and
    compiled-tested only against 2.6.25-rc4.
    
    Signed-off-by: Joe Korty <joe.korty@ccur.com>
    Signed-off-by: Christoph Lameter <clameter@sgi.com>
---
 mm/slab.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/mm/slab.c b/mm/slab.c
index f7faff7..e6c698f 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -2964,11 +2964,10 @@ static void *cache_alloc_refill(struct kmem_cache *cachep, gfp_t flags)
 	struct array_cache *ac;
 	int node;
 
-	node = numa_node_id();
-
+retry:
 	check_irq_off();
+	node = numa_node_id();
 	ac = cpu_cache_get(cachep);
-retry:
 	batchcount = ac->batchcount;
 	if (!ac->touched && batchcount > BATCHREFILL_LIMIT) {
 		/*

