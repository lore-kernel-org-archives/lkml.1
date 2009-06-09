Return-Path: <linux-kernel-owner+w=401wt.eu-S1759205AbZFIIPq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759205AbZFIIPq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 04:15:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759229AbZFIIP3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 04:15:29 -0400
Received: from viefep13-int.chello.at ([62.179.121.33]:55886 "EHLO
	viefep13-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759220AbZFIIPY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 04:15:24 -0400
X-SourceIP: 213.93.53.227
Subject: Re: [tip:perfcounters/core] perf_counter: Implement generalized
 cache event types
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, efault@gmx.de, mtosatti@redhat.com,
       tglx@linutronix.de, cjashfor@linux.vnet.ibm.com, mingo@elte.hu
Cc: linux-tip-commits@vger.kernel.org
In-Reply-To: <tip-8326f44da090d6d304d29b9fdc7fb3e20889e329@git.kernel.org>
References: <new-submission>
	 <tip-8326f44da090d6d304d29b9fdc7fb3e20889e329@git.kernel.org>
Content-Type: text/plain
Date: Tue, 09 Jun 2009 10:15:26 +0200
Message-Id: <1244535326.13761.10021.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-06-06 at 11:16 +0000, tip-bot for Ingo Molnar wrote:
> Commit-ID:  8326f44da090d6d304d29b9fdc7fb3e20889e329
> Gitweb:     http://git.kernel.org/tip/8326f44da090d6d304d29b9fdc7fb3e20889e329
> Author:     Ingo Molnar <mingo@elte.hu>
> AuthorDate: Fri, 5 Jun 2009 20:22:46 +0200
> Committer:  Ingo Molnar <mingo@elte.hu>
> CommitDate: Sat, 6 Jun 2009 13:14:47 +0200
> 
> perf_counter: Implement generalized cache event types
> 
> Extend generic event enumeration with the PERF_TYPE_HW_CACHE
> method.
> 
> This is a 3-dimensional space:
> 
>        { L1-D, L1-I, L2, ITLB, DTLB, BPU } x
>        { load, store, prefetch } x
>        { accesses, misses }
> 
> User-space passes in the 3 coordinates and the kernel provides
> a counter. (if the hardware supports that type and if the
> combination makes sense.)
> 
> Combinations that make no sense produce a -EINVAL.
> Combinations that are not supported by the hardware produce -ENOTSUP.
> 
> Extend the tools to deal with this, and rewrite the event symbol
> parsing code with various popular aliases for the units and
> access methods above. So 'l1-cache-miss' and 'l1d-read-ops' are
> both valid aliases.
> 
> ( x86 is supported for now, with the Nehalem event table filled in,
>   and with Core2 and Atom having placeholder tables. )
> 

> +++ b/include/linux/perf_counter.h
> @@ -28,6 +28,7 @@ enum perf_event_types {
>  	PERF_TYPE_HARDWARE		= 0,
>  	PERF_TYPE_SOFTWARE		= 1,
>  	PERF_TYPE_TRACEPOINT		= 2,
> +	PERF_TYPE_HW_CACHE		= 3,
>  
>  	/*
>  	 * available TYPE space, raw is the max value.
> @@ -56,6 +57,39 @@ enum attr_ids {
>  };
>  
>  /*
> + * Generalized hardware cache counters:
> + *
> + *       { L1-D, L1-I, L2, LLC, ITLB, DTLB, BPU } x
> + *       { read, write, prefetch } x
> + *       { accesses, misses }
> + */
> +enum hw_cache_id {
> +	PERF_COUNT_HW_CACHE_L1D,
> +	PERF_COUNT_HW_CACHE_L1I,
> +	PERF_COUNT_HW_CACHE_L2,
> +	PERF_COUNT_HW_CACHE_DTLB,
> +	PERF_COUNT_HW_CACHE_ITLB,
> +	PERF_COUNT_HW_CACHE_BPU,
> +
> +	PERF_COUNT_HW_CACHE_MAX,
> +};
> +
> +enum hw_cache_op_id {
> +	PERF_COUNT_HW_CACHE_OP_READ,
> +	PERF_COUNT_HW_CACHE_OP_WRITE,
> +	PERF_COUNT_HW_CACHE_OP_PREFETCH,
> +
> +	PERF_COUNT_HW_CACHE_OP_MAX,
> +};
> +
> +enum hw_cache_op_result_id {
> +	PERF_COUNT_HW_CACHE_RESULT_ACCESS,
> +	PERF_COUNT_HW_CACHE_RESULT_MISS,
> +
> +	PERF_COUNT_HW_CACHE_RESULT_MAX,
> +};

May I suggest we do the below instead? Some hardware doesn't make the
read/write distinction and would therefore have an utterly empty table.

Furthermore, also splitting the hit/miss into a bitfield allows us to
have hit/miss and the combined value.

---
diff --git a/include/linux/perf_counter.h b/include/linux/perf_counter.h
index 3586df8..1fb72fc 100644
--- a/include/linux/perf_counter.h
+++ b/include/linux/perf_counter.h
@@ -64,29 +64,32 @@ enum attr_ids {
  *       { accesses, misses }
  */
 enum hw_cache_id {
-	PERF_COUNT_HW_CACHE_L1D,
-	PERF_COUNT_HW_CACHE_L1I,
-	PERF_COUNT_HW_CACHE_L2,
-	PERF_COUNT_HW_CACHE_DTLB,
-	PERF_COUNT_HW_CACHE_ITLB,
-	PERF_COUNT_HW_CACHE_BPU,
+	PERF_COUNT_HW_CACHE_L1D		= 0,
+	PERF_COUNT_HW_CACHE_L1I		= 1,
+	PERF_COUNT_HW_CACHE_L2		= 2,
+	PERF_COUNT_HW_CACHE_DTLB	= 3,
+	PERF_COUNT_HW_CACHE_ITLB	= 4,
+	PERF_COUNT_HW_CACHE_BPU		= 5,
 
 	PERF_COUNT_HW_CACHE_MAX,
 };
 
 enum hw_cache_op_id {
-	PERF_COUNT_HW_CACHE_OP_READ,
-	PERF_COUNT_HW_CACHE_OP_WRITE,
-	PERF_COUNT_HW_CACHE_OP_PREFETCH,
+	PERF_COUNT_HW_CACHE_OP_READ		= 0x1,
+	PERF_COUNT_HW_CACHE_OP_WRITE		= 0x2,
+	PERF_COUNT_HW_CACHE_OP_ACCESS		= 0x3, /* either READ or WRITE */
+	PERF_COUNT_HW_CACHE_OP_PREFETCH		= 0x4, /* XXX should we qualify this with either READ/WRITE? */
 
-	PERF_COUNT_HW_CACHE_OP_MAX,
+
+	PERF_COUNT_HW_CACHE_OP_MAX		= 0x8,
 };
 
 enum hw_cache_op_result_id {
-	PERF_COUNT_HW_CACHE_RESULT_ACCESS,
-	PERF_COUNT_HW_CACHE_RESULT_MISS,
+	PERF_COUNT_HW_CACHE_RESULT_HIT		= 0x1,
+	PERF_COUNT_HW_CACHE_RESULT_MISS		= 0x2,
+	PERF_COUNT_HW_CACHE_RESULT_SUM		= 0x3,
 
-	PERF_COUNT_HW_CACHE_RESULT_MAX,
+	PERF_COUNT_HW_CACHE_RESULT_MAX		= 0x4,
 };
 
 /*


