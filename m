Return-Path: <linux-kernel-owner+w=401wt.eu-S1753989AbZCSLla@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753989AbZCSLla (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 07:41:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751241AbZCSLlU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 07:41:20 -0400
Received: from viefep11-int.chello.at ([62.179.121.31]:39829 "EHLO
	viefep11-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750804AbZCSLlT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 07:41:19 -0400
X-SourceIP: 213.93.53.227
Subject: Re: [RFC][PATCH 09/11] perf_counter: revamp syscall input ABI
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Paul Mackerras <paulus@samba.org>
Cc: mingo@elte.hu, rostedt@goodmis.org, linux-kernel@vger.kernel.org
In-Reply-To: <18881.29300.669876.820286@cargo.ozlabs.ibm.com>
References: <20090317215606.037073805@chello.nl>
	 <20090317220421.336322251@chello.nl>
	 <18880.23662.233043.833458@drongo.ozlabs.ibm.com>
	 <1237366063.5069.64.camel@laptop>
	 <18881.29300.669876.820286@cargo.ozlabs.ibm.com>
Content-Type: text/plain
Date: Thu, 19 Mar 2009 12:41:07 +0100
Message-Id: <1237462867.7867.43.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-03-19 at 09:15 +1100, Paul Mackerras wrote:
> Peter Zijlstra writes:
> 
> > Ah, I thought we should keep a pure 64 bit raw value. You never know
> > what hardware will do.
> 
> Oh I see, you use hw_event->raw_event if hw_event->raw is set.  I
> missed that before.
> 
> Still, you're putting that into hwc->config along with other bits like
> ARCH_PERFMON_EVENTSEL_USR and ARCH_PERFMON_EVENTSEL_OS, so I would
> think we could spare two bits for the type, leaving 62 bits for the
> raw event code.  And if that isn't enough, there's the
> hw_event.extra_config_len field, which allows userspace to pass in
> arbitrary amounts of extra PMU configuration data.

Good point, overflow interrupt, and usr/os/hv event filter and enable
bits are usually in the config word.

OK, how about the below? I didn't cut it to 2 bits, as that would
already exhaust the TYPE space -- then again, 60 does feel cramped a
bit..

Index: linux-2.6/include/linux/perf_counter.h
===================================================================
--- linux-2.6.orig/include/linux/perf_counter.h
+++ linux-2.6/include/linux/perf_counter.h
@@ -27,6 +27,12 @@ enum perf_event_types {
 	PERF_TYPE_HARDWARE		= 0,
 	PERF_TYPE_SOFTWARE		= 1,
 	PERF_TYPE_TRACEPOINT		= 2,
+
+	/*
+	 * available TYPE space, raw is the max value.
+	 */
+
+	PERF_TYPE_RAW			= 15,
 };
 
 /*
@@ -79,14 +85,8 @@ enum perf_counter_record_type {
  * Hardware event to monitor via a performance monitoring counter:
  */
 struct perf_counter_hw_event {
-	union {
-		__u64			raw_event;
-		struct {
-			__u64		event_id	: 32,
-					type		:  8,
-					__reserved_0	: 24;
-		};
-	};
+	__u64			event_id	: 60,
+				type		:  4;
 
 	__u64			irq_period;
 	__u64			record_type;
@@ -94,7 +94,6 @@ struct perf_counter_hw_event {
 
 	__u64			disabled       :  1, /* off by default        */
 				nmi	       :  1, /* NMI sampling          */
-				raw	       :  1, /* raw event type        */
 				inherit	       :  1, /* children inherit it   */
 				pinned	       :  1, /* must always be on PMU */
 				exclusive      :  1, /* only group on PMU     */
@@ -103,7 +102,7 @@ struct perf_counter_hw_event {
 				exclude_hv     :  1, /* ditto hypervisor      */
 				exclude_idle   :  1, /* don't count when idle */
 
-				__reserved_1   : 54;
+				__reserved_1   : 55;
 
 	__u32			extra_config_len;
 	__u32			__reserved_4;


