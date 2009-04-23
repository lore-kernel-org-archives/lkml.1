Return-Path: <linux-kernel-owner+w=401wt.eu-S1758137AbZDWHkB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758137AbZDWHkB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 03:40:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756369AbZDWHaM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 03:30:12 -0400
Received: from sous-sol.org ([216.99.217.87]:50356 "EHLO x200.localdomain"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754817AbZDWHaJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 03:30:09 -0400
Message-Id: <20090423072401.322478151@sous-sol.org>
User-Agent: quilt/0.47-1
Date: Thu, 23 Apr 2009 00:20:49 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org, jejb@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Jack Steiner <steiner@sgi.com>,
       Mike Travis <travis@sgi.com>, Ingo Molnar <mingo@elte.hu>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Stephen Rothwell <sfr@canb.auug.org.au>
Subject: [patch 029/100] cpumask: fix slab corruption caused by alloc_cpumask_var_node()
References: <20090423072020.428683652@sous-sol.org>
Content-Disposition: inline; filename=cpumask-fix-slab-corruption-caused-by-alloc_cpumask_var_node.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Jack Steiner <steiner@sgi.com>

upstream commit: 4f032ac4122a77dbabf7a24b2739b2790448180f

Fix slab corruption caused by alloc_cpumask_var_node() overwriting the
tail end of an off-stack cpumask.

The function zeros out cpumask bits beyond the last possible cpu.  The
starting point for zeroing should be the beginning of the mask offset by a
byte count derived from the number of possible cpus.  The offset was
calculated in bits instead of bytes.  This resulted in overwriting the end
of the cpumask.

Signed-off-by: Jack Steiner <steiner@sgi.com>
Acked-by: Mike Travis <travis@sgi.com>
Acked-by: Ingo Molnar <mingo@elte.hu>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 lib/cpumask.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/lib/cpumask.c
+++ b/lib/cpumask.c
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

