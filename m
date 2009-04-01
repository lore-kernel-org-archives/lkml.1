Return-Path: <linux-kernel-owner+w=401wt.eu-S1756837AbZDADtO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756837AbZDADtO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 23:49:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755389AbZDADs6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 23:48:58 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:58035 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754511AbZDADs5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 23:48:57 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18898.58399.957182.181124@drongo.ozlabs.ibm.com>
Date: Wed, 1 Apr 2009 14:48:47 +1100
From: Paul Mackerras <paulus@samba.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 13/15] perf_counter: provide generic callchain bits
In-Reply-To: <1238508032.8530.278.camel@twins>
References: <20090330170701.856843742@chello.nl>
	<20090330171024.254266860@chello.nl>
	<18897.46177.528910.51044@cargo.ozlabs.ibm.com>
	<1238481552.28248.1384.camel@twins>
	<49D1C544.7020403@linux.vnet.ibm.com>
	<18897.56973.324304.995540@cargo.ozlabs.ibm.com>
	<1238508032.8530.278.camel@twins>
X-Mailer: VM 8.0.12 under 22.2.1 (powerpc-unknown-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra writes:

> That still has the record and read things separate, but as one unified
> overflow output.

I take it PERF_EVENT_OVERFLOW refers to counter overflow, not ring
buffer overflow?  That had me confused for a bit, so more explicit
naming, or at least some comments, would be good.

>  /*
> + * Bits that can be set in hw_event.record_type to request information
> + * in the overflow packets.
> + */
> +enum perf_counter_record_format {
> +	PERF_RECORD_IP		= 1U << 0,
> +	PERF_RECORD_TID		= 1U << 1,
> +	PERF_RECORD_GROUP	= 1U << 2,
> +	PERF_RECORD_CALLCHAIN	= 1U << 3,
> +};
[snip]
>  enum perf_event_type {
>  
> -	PERF_EVENT_GROUP	= 1,
> -
> -	PERF_EVENT_MMAP		= 2,
> -	PERF_EVENT_MUNMAP	= 3,
> +	PERF_EVENT_MMAP		= 1,
> +	PERF_EVENT_MUNMAP	= 2,
>  
>  	PERF_EVENT_OVERFLOW	= 1UL << 31,
>  	__PERF_EVENT_IP		= 1UL << 30,
>  	__PERF_EVENT_TID	= 1UL << 29,
> -	__PERF_EVENT_CALLCHAIN  = 1UL << 28,
> +	__PERF_EVENT_GROUP	= 1UL << 28,
> +	__PERF_EVENT_CALLCHAIN  = 1UL << 27,

Could we use the same value (and even the same name) for
PERF_RECORD_IP/__PERF_EVENT_IP, PERF_RECORD_TID/__PERF_EVENT_TID,
etc.?

Also, I haven't looked at the callchain stuff much, but does the
callchain info contain a recognizable end delimiter?  At present the
callchain comes last, but if we add more output elements they'll
presumably go after it, so working out where the callchain ends may
become tricky if we're not careful.

Also, let's add PERF_RECORD/PERF_EVENT bits for:

* EVENT_INSTR_ADDR
* EVENT_DATA_ADDR
* EVENT_INSTR_FLAGS
* EVENT_CPU_FLAGS	(so we can distinguish hypervisor/kernel/user)

We would have to call into arch code to get the values for these.

Paul.
