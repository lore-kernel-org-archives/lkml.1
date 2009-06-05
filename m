Return-Path: <linux-kernel-owner+w=401wt.eu-S1756540AbZFER5z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756540AbZFER5z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 13:57:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752813AbZFER5t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 13:57:49 -0400
Received: from hera.kernel.org ([140.211.167.34]:38716 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752106AbZFER5s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 13:57:48 -0400
Message-ID: <4A295C76.3050900@kernel.org>
Date: Fri, 05 Jun 2009 10:57:10 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Ingo Molnar <mingo@elte.hu>
CC: Avi Kivity <avi@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] cpumask: alloc blank cpumask left over
References: <4A2835D8.6040903@kernel.org> <200906051428.08299.rusty@rustcorp.com.au> <4A28B3A9.3010505@kernel.org> <200906052311.57762.rusty@rustcorp.com.au> <alpine.LFD.2.01.0906051026030.6847@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.01.0906051026030.6847@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It seems we could remove that FIXME now.
cpumask_size is referred rather later.

Subject: [PATCH] use nr_cpumask_bits for cpumask_size calculating

so alloc_cpusmask_var could save some space when MAXSMP is used aka NR_CPUS
is 4096 on small conf system

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 include/linux/cpumask.h |    4 +---
 lib/cpumask.c           |    8 --------
 2 files changed, 1 insertion(+), 11 deletions(-)

Index: linux-2.6/include/linux/cpumask.h
===================================================================
--- linux-2.6.orig/include/linux/cpumask.h
+++ linux-2.6/include/linux/cpumask.h
@@ -996,9 +996,7 @@ static inline int cpulist_parse(const ch
  */
 static inline size_t cpumask_size(void)
 {
-	/* FIXME: Once all cpumask assignments are eliminated, this
-	 * can be nr_cpumask_bits */
-	return BITS_TO_LONGS(NR_CPUS) * sizeof(long);
+	return BITS_TO_LONGS(nr_cpumask_bits) * sizeof(long);
 }
 
 /*
Index: linux-2.6/lib/cpumask.c
===================================================================
--- linux-2.6.orig/lib/cpumask.c
+++ linux-2.6/lib/cpumask.c
@@ -100,14 +100,6 @@ bool alloc_cpumask_var_node(cpumask_var_
 		dump_stack();
 	}
 #endif
-	/* FIXME: Bandaid to save us from old primitives which go to NR_CPUS. */
-	if (*mask) {
-		unsigned char *ptr = (unsigned char *)cpumask_bits(*mask);
-		unsigned int tail;
-		tail = BITS_TO_LONGS(NR_CPUS - nr_cpumask_bits) * sizeof(long);
-		memset(ptr + cpumask_size() - tail, 0, tail);
-	}
-
 	return *mask != NULL;
 }
 EXPORT_SYMBOL(alloc_cpumask_var_node);
