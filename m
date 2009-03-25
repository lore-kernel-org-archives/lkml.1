Return-Path: <linux-kernel-owner+w=401wt.eu-S1760765AbZCYLst@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760765AbZCYLst (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 07:48:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755251AbZCYLsk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 07:48:40 -0400
Received: from viefep16-int.chello.at ([62.179.121.36]:63813 "EHLO
	viefep16-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753229AbZCYLsk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 07:48:40 -0400
X-SourceIP: 213.93.53.227
Subject: Re: [PATCH] perf_counter: allow and require one-page mmap on
 counting counters
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
In-Reply-To: <18889.59409.260586.87939@cargo.ozlabs.ibm.com>
References: <18889.59409.260586.87939@cargo.ozlabs.ibm.com>
Content-Type: text/plain
Date: Wed, 25 Mar 2009 12:48:31 +0100
Message-Id: <1237981712.7972.812.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-03-25 at 19:15 +1100, Paul Mackerras wrote:
> Impact: bug fix
> 
> Currently the mmap code requires that the length of the mmap be at least
> two pages.  That is fine for sampling counters, but for counting
> counters the second and subsequent pages are just wasted, since counting
> counters don't generate events.
> 
> This changes the code to require that the mmap be one page in length
> for counting counters, and applies the existing check to sampling
> counters.

Does the below work for you Paul?

---
Subject: perf_counter: allow one-page mmap on counters
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Wed Mar 25 12:44:16 CET 2009

A brainfart stopped single page mmap()s working. The rest of the code
should be perfectly fine with not having any data pages.

Reported-by: Paul Mackerras <paulus@samba.org>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/perf_counter.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

Index: linux-2.6/kernel/perf_counter.c
===================================================================
--- linux-2.6.orig/kernel/perf_counter.c
+++ linux-2.6/kernel/perf_counter.c
@@ -1369,7 +1369,11 @@ static int perf_mmap(struct file *file, 
 	vma_size = vma->vm_end - vma->vm_start;
 	nr_pages = (vma_size / PAGE_SIZE) - 1;
 
-	if (nr_pages == 0 || !is_power_of_2(nr_pages))
+	/*
+	 * If we have data pages ensure they're a power-of-two number, so we
+	 * can do bitmasks instead of modulo.
+	 */
+	if (nr_pages != 0 && !is_power_of_2(nr_pages))
 		return -EINVAL;
 
 	if (vma_size != PAGE_SIZE * (1 + nr_pages))


