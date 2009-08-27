Return-Path: <linux-kernel-owner+w=401wt.eu-S1753138AbZH0VLQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753138AbZH0VLQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 17:11:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752794AbZH0VLN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 17:11:13 -0400
Received: from cantor.suse.de ([195.135.220.2]:34017 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752757AbZH0VLN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 17:11:13 -0400
Date: Thu, 27 Aug 2009 23:11:13 +0200
From: Jiri Bohac <jbohac@suse.cz>
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>,
       kenneth.w.chen@intel.com
Cc: linux-kernel@vger.kernel.org, linux-ia64@vger.kernel.org
Subject: [RFC][PATCH] ia64: fix csum_ipv6_magic()
Message-ID: <20090827211113.GA22793@midget.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I was seeing "nf_ct_icmpv6: ICMPv6 checksum failed" errors on
every ICMPv6 packet received. The packets did not pass the
netfilter checksum verification but they did pass the standard
verification later and got processed. This happenns with hardware
checksumming turned off or with adapters that do not checksum
ICMP packets (e.g. tg3). I tracked the problem down to the ia64
version of csum_ipv6_magic() introduced by 007d77d0c5.  For some
arguments, it gives differrent results than the generic version.

The following patch fixes the problem for me. IA64 experts, can
you please have a look?

Thanks!


[IA64] fix csum_ipv6_magic()

The 32-bit parameters (len and csum) of csum_ipv6_magic() are passed in 64-bit
registers in3 and in4. The high order 32 bits of the registers were never
cleared, and garbage was sometimes calculated into the checksum.

Fix this by clearing the high order 32 bits of the registers.

Signed-off-by: Jiri Bohac <jbohac@suse.cz>

diff --git a/arch/ia64/lib/ip_fast_csum.S b/arch/ia64/lib/ip_fast_csum.S
index 1f86aeb..9a8d23f 100644
--- a/arch/ia64/lib/ip_fast_csum.S
+++ b/arch/ia64/lib/ip_fast_csum.S
@@ -96,20 +96,22 @@ END(ip_fast_csum)
 GLOBAL_ENTRY(csum_ipv6_magic)
 	ld4	r20=[in0],4
 	ld4	r21=[in1],4
-	dep	r15=in3,in2,32,16
+	zxt4	in3=in3
 	;;
 	ld4	r22=[in0],4
 	ld4	r23=[in1],4
-	mux1	r15=r15,@rev
+	dep	r15=in3,in2,32,16
 	;;
 	ld4	r24=[in0],4
 	ld4	r25=[in1],4
-	shr.u	r15=r15,16
+	mux1	r15=r15,@rev
 	add	r16=r20,r21
 	add	r17=r22,r23
+	zxt4	in4=in4
 	;;
 	ld4	r26=[in0],4
 	ld4	r27=[in1],4
+	shr.u	r15=r15,16
 	add	r18=r24,r25
 	add	r8=r16,r17
 	;;
-- 
Jiri Bohac <jbohac@suse.cz>
SUSE Labs, SUSE CZ

