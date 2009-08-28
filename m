Return-Path: <linux-kernel-owner+w=401wt.eu-S1751309AbZH1VTV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751309AbZH1VTV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Aug 2009 17:19:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751129AbZH1VTT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Aug 2009 17:19:19 -0400
Received: from mga03.intel.com ([143.182.124.21]:23087 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751106AbZH1VTS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Aug 2009 17:19:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,271,1249282800"; 
   d="scan'208";a="181642422"
From: "Yu, Fenghua" <fenghua.yu@intel.com>
To: "'Jiri Bohac'" <jbohac@suse.cz>, "Luck, Tony" <tony.luck@intel.com>,
       "'kenneth.w.chen@intel.com'" <kenneth.w.chen@intel.com>
CC: "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
       "'linux-ia64@vger.kernel.org'" <linux-ia64@vger.kernel.org>
Date: Fri, 28 Aug 2009 14:19:19 -0700
Subject: RE: [RFC][PATCH] ia64: fix csum_ipv6_magic()
Thread-Topic: [RFC][PATCH] ia64: fix csum_ipv6_magic()
Thread-Index: AconWvEAa+4eQKLrQiy33kv/p2DeaQAyae7Q
Message-ID: <A6AD88C3F2289247BE726C37303E1EB8B954B4A6@orsmsx505.amr.corp.intel.com>
References: <20090827211113.GA22793@midget.suse.cz>
In-Reply-To: <20090827211113.GA22793@midget.suse.cz>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>I was seeing "nf_ct_icmpv6: ICMPv6 checksum failed" errors on
>every ICMPv6 packet received. The packets did not pass the
>netfilter checksum verification but they did pass the standard
>verification later and got processed. This happenns with hardware
>checksumming turned off or with adapters that do not checksum
>ICMP packets (e.g. tg3). I tracked the problem down to the ia64
>version of csum_ipv6_magic() introduced by 007d77d0c5.  For some
>arguments, it gives differrent results than the generic version.
>
>The following patch fixes the problem for me. IA64 experts, can
>you please have a look?
>
>Thanks!
>
>
>[IA64] fix csum_ipv6_magic()
>
>The 32-bit parameters (len and csum) of csum_ipv6_magic() are passed in 64-
>bit
>registers in3 and in4. The high order 32 bits of the registers were never
>cleared, and garbage was sometimes calculated into the checksum.
>
>Fix this by clearing the high order 32 bits of the registers.
>
>Signed-off-by: Jiri Bohac <jbohac@suse.cz>
>
>diff --git a/arch/ia64/lib/ip_fast_csum.S b/arch/ia64/lib/ip_fast_csum.S
>index 1f86aeb..9a8d23f 100644
>--- a/arch/ia64/lib/ip_fast_csum.S
>+++ b/arch/ia64/lib/ip_fast_csum.S
>@@ -96,20 +96,22 @@ END(ip_fast_csum)
> GLOBAL_ENTRY(csum_ipv6_magic)
> 	ld4	r20=[in0],4
> 	ld4	r21=[in1],4
>-	dep	r15=in3,in2,32,16
>+	zxt4	in3=in3
> 	;;
> 	ld4	r22=[in0],4
> 	ld4	r23=[in1],4
>-	mux1	r15=r15,@rev
>+	dep	r15=in3,in2,32,16
> 	;;
> 	ld4	r24=[in0],4
> 	ld4	r25=[in1],4
>-	shr.u	r15=r15,16
>+	mux1	r15=r15,@rev
> 	add	r16=r20,r21
> 	add	r17=r22,r23
>+	zxt4	in4=in4
> 	;;
> 	ld4	r26=[in0],4
> 	ld4	r27=[in1],4
>+	shr.u	r15=r15,16
> 	add	r18=r24,r25
> 	add	r8=r16,r17
> 	;;

Looks good to me. Do you know the caller function for the failed csum_ipv6_magic()?

Thanks.

-Fenghua
