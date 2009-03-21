Return-Path: <linux-kernel-owner+w=401wt.eu-S1754837AbZCUKYz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754837AbZCUKYz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Mar 2009 06:24:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751423AbZCUKYq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Mar 2009 06:24:46 -0400
Received: from viefep14-int.chello.at ([62.179.121.34]:63108 "EHLO
	viefep14-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753116AbZCUKYp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Mar 2009 06:24:45 -0400
X-SourceIP: 213.93.53.227
Subject: Re: [PATCH] perfcounters: fix type/event_id layout on big-endian
 systems
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
In-Reply-To: <18884.29385.854691.357234@cargo.ozlabs.ibm.com>
References: <18884.29385.854691.357234@cargo.ozlabs.ibm.com>
Content-Type: text/plain
Date: Sat, 21 Mar 2009 11:24:30 +0100
Message-Id: <1237631070.24626.107.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-03-21 at 15:53 +1100, Paul Mackerras wrote:
> Impact: build fix for powerpc
> 
> Commit db3a944aca35ae61 ("perf_counter: revamp syscall input ABI")
> expanded the hw_event.type field into a union of structs containing
> bitfields.  In particular it introduced a type field and a raw_type
> field, with the intention that the 1-bit raw_type field should
> overlay the most-significant bit of the 8-bit type field, and in fact
> perf_counter_alloc() now assumes that (or at least, assumes that
> raw_type doesn't overlay any of the bits that are 1 in the values of
> PERF_TYPE_{HARDWARE,SOFTWARE,TRACEPOINT}).
> 
> Unfortunately this is not true on big-endian systems such as PowerPC,
> where bitfields are laid out from left to right, i.e. from most
> significant bit to least significant.  This means that setting
> hw_event.type = PERF_TYPE_SOFTWARE will set hw_event.raw_type to 1.
> 
> This fixes it by making the layout depend on whether or not
> __BIG_ENDIAN_BITFIELD is defined.  It's a bit ugly, but that's what
> we get for using bitfields in a user/kernel ABI.

Hmm, does userspace know about __BIG_ENDIAN_BITFIELD too? If not, we've
got ourselves a problem here.

Sorry about missing those powerpc bits, I guess I should dust-off the
cross-compiler.

> diff --git a/include/linux/perf_counter.h b/include/linux/perf_counter.h
> index a4b76c0..98f5990 100644
> --- a/include/linux/perf_counter.h
> +++ b/include/linux/perf_counter.h
> @@ -15,6 +15,7 @@
>  
>  #include <linux/types.h>
>  #include <linux/ioctl.h>
> +#include <asm/byteorder.h>
>  
>  /*
>   * User-space ABI bits:
> @@ -86,6 +87,7 @@ enum perf_counter_record_type {
>   */
>  struct perf_counter_hw_event {
>  	union {
> +#ifndef __BIG_ENDIAN_BITFIELD
>  		struct {
>  			__u64			event_id	: 56,
>  						type		:  8;
> @@ -94,6 +96,16 @@ struct perf_counter_hw_event {
>  			__u64			raw_event_id	: 63,
>  						raw_type	:  1;
>  		};
> +#else
> +		struct {
> +			__u64			type		:  8,
> +						event_id	: 56;
> +		};
> +		struct {
> +			__u64			raw_type	:  1,
> +						raw_event_id	: 63;
> +		};
> +#endif /* __BIT_ENDIAN_BITFIELD */
>  		__u64		event_config;
>  	};
>  

