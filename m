Return-Path: <linux-kernel-owner+w=401wt.eu-S1760453AbZDBWJT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760453AbZDBWJT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 18:09:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757694AbZDBWJG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 18:09:06 -0400
Received: from relay2.sgi.com ([192.48.179.30]:45806 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755878AbZDBWJF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 18:09:05 -0400
Date: Thu, 2 Apr 2009 17:09:01 -0500
From: Jack Steiner <steiner@sgi.com>
To: Andrew Morton <akpm@linux-foundation.org>, mingo@elte.hu,
       rusty@rustcorp.com.au, sfr@canb.auug.org.au
Cc: linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: [PATCH] - Updated: Fix slab corruption caused by alloc_cpumask_var_node()
Message-ID: <20090402220900.GA15129@sgi.com>
References: <20090402212751.GA11495@sgi.com> <20090402143932.79a15852.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090402143932.79a15852.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix slab corruption caused by alloc_cpumask_var_node() overwriting
the tail end of an off-stack cpumask.

The function zeros out cpumask bits beyond the last possible cpu.
The starting point for zeroing should be the beginning
of the mask offset by a byte count derived from the number
of possible cpus. The offset was calculated in bits instead of bytes.
This resulted in overwriting the end of the cpumask.


v2.6.29 is also affected by this bug.


Signed-off-by: Jack Steiner <steiner@sgi.com>
Acked-by: Mike Travis <travis.sgi.com>
Acked-by: Ingo Molnar <mingo@elte.hu>


---

Corrruption was found in latest linux-next (4/1)
	v2.6.29-12081-g421a9f3



 lib/cpumask.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux/lib/cpumask.c
===================================================================
--- linux.orig/lib/cpumask.c	2009-04-02 15:30:05.000000000 -0500
+++ linux/lib/cpumask.c	2009-04-02 15:57:44.000000000 -0500
@@ -109,10 +109,10 @@ bool alloc_cpumask_var_node(cpumask_var_
 #endif
 	/* FIXME: Bandaid to save us from old primitives which go to NR_CPUS. */
 	if (*mask) {
+		unsigned char *ptr = (unsigned char *)cpumask_bits(*mask);
 		unsigned int tail;
 		tail = BITS_TO_LONGS(NR_CPUS - nr_cpumask_bits) * sizeof(long);
-		memset(cpumask_bits(*mask) + cpumask_size() - tail,
-		       0, tail);
+		memset(ptr + cpumask_size() - tail, 0, tail);
 	}
 
 	return *mask != NULL;
