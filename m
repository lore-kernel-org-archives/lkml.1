Return-Path: <linux-kernel-owner+w=401wt.eu-S933325AbXJOSHo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933325AbXJOSHo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 14:07:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761585AbXJOSHc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 14:07:32 -0400
Received: from outbound-fra.frontbridge.com ([62.209.45.174]:19700 "EHLO
	outbound6-fra-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759332AbXJOSHa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 14:07:30 -0400
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 139.95.251.8;Service: EHS
X-Server-Uuid: C391E81C-6590-4A2B-9214-A04D45AF4E95
Message-ID: <4713AC47.9030905@amd.com>
Date: Mon, 15 Oct 2007 14:07:03 -0400
From: "Barry Kasindorf" <barry.kasindorf@amd.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: "Robert Richter" <robert.richter@amd.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.23] oProfile: op_model_athalon.c support for AMD
 Family10h (Barcelona) Performance Counters
References: <47139CAB.4000107@amd.com>
 <20071015174802.GS11245@erda.amd.com>
In-Reply-To: <20071015174802.GS11245@erda.amd.com>
X-OriginalArrivalTime: 15 Oct 2007 18:07:03.0803 (UTC)
 FILETIME=[30A8C4B0:01C80F56]
X-WSS-ID: 6B0D73C01DW1915164-01-01
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Yes,
I saw this about 3 minutes too late :-).
-Barry


oProfile Driver Module Patch for AMD Family10h Kernel 2.6.23

This patch is for controlling the upper 32bits of the event ctrl msrs.
This includes the upper 4 bits of the event select and the Guest Only 
and Host Only bits
This patch is necessary to make Event Based Profiling work reliably on a 
Family 10h processor

---
  op_model_athlon.c |   22 ++++++++++++++++------
  1 file changed, 16 insertions(+), 6 deletions(-)
---

Signed-off-by: Barry Kasindorf <barry.kasindorf@amd.com>
Signed-off-by: Robert Richter <robert.richter@amd.com>

diff -Naur linux-2.6.23.orig/arch/i386/oprofile/op_model_athlon.c 
linux-2.6.23.pmc/arch/i386/oprofile/op_model_athlon.c
--- linux-2.6.23.orig/arch/i386/oprofile/op_model_athlon.c	2007-10-09 
16:31:38.000000000 -0400
+++ linux-2.6.23.pmc/arch/i386/oprofile/op_model_athlon.c	2007-10-15 
11:02:39.000000000 -0400
@@ -1,6 +1,6 @@
  /**
   * @file op_model_athlon.h
- * athlon / K7 model-specific MSR operations
+ * athlon / K7 / K8 / Family 10h model-specific MSR operations
   *
   * @remark Copyright 2002 OProfile authors
   * @remark Read the file COPYING
@@ -31,12 +31,16 @@
  #define CTRL_WRITE(l,h,msrs,c) do {wrmsr(msrs->controls[(c)].addr, 
(l), (h));} while (0)
  #define CTRL_SET_ACTIVE(n) (n |= (1<<22))
  #define CTRL_SET_INACTIVE(n) (n &= ~(1<<22))
-#define CTRL_CLEAR(x) (x &= (1<<21))
+#define CTRL_CLEAR_LO(x) (x &= (1<<21))
+#define CTRL_CLEAR_HI(x) ( x &= 0xfffffcf0 )
  #define CTRL_SET_ENABLE(val) (val |= 1<<20)
  #define CTRL_SET_USR(val,u) (val |= ((u & 1) << 16))
  #define CTRL_SET_KERN(val,k) (val |= ((k & 1) << 17))
  #define CTRL_SET_UM(val, m) (val |= (m << 8))
-#define CTRL_SET_EVENT(val, e) (val |= e)
+#define CTRL_SET_EVENT_LOW(val, e) (val |= (e & 0xff))
+#define CTRL_SET_EVENT_HIGH(val,e) (val |= ((e >> 8) & 0xf))
+#define CTRL_SET_HOST_ONLY(val, h) (val |= ((h & 1) << 9))
+#define CTRL_SET_GUEST_ONLY(val, h) (val |= ((h & 1) << 8))

  static unsigned long reset_value[NUM_COUNTERS];

@@ -70,7 +74,8 @@
  		if (unlikely(!CTRL_IS_RESERVED(msrs,i)))
  			continue;
  		CTRL_READ(low, high, msrs, i);
-		CTRL_CLEAR(low);
+		CTRL_CLEAR_LO(low);
+		CTRL_CLEAR_HI(high);
  		CTRL_WRITE(low, high, msrs, i);
  	}

@@ -89,12 +94,17 @@
  			CTR_WRITE(counter_config[i].count, msrs, i);

  			CTRL_READ(low, high, msrs, i);
-			CTRL_CLEAR(low);
+			CTRL_CLEAR_LO(low);
+			CTRL_CLEAR_HI(high);
  			CTRL_SET_ENABLE(low);
  			CTRL_SET_USR(low, counter_config[i].user);
  			CTRL_SET_KERN(low, counter_config[i].kernel);
  			CTRL_SET_UM(low, counter_config[i].unit_mask);
-			CTRL_SET_EVENT(low, counter_config[i].event);
+			CTRL_SET_EVENT_LOW(low, counter_config[i].event);
+			CTRL_SET_EVENT_HIGH(high, counter_config[i].event);
+			CTRL_SET_HOST_ONLY(high, 0);
+			CTRL_SET_GUEST_ONLY(high, 0);
+
  			CTRL_WRITE(low, high, msrs, i);
  		} else {
  			reset_value[i] = 0;



Robert Richter wrote:
 > On 15.10.07 13:00:27, Barry Kasindorf wrote:
 >> oProfile Driver Module Patch for AMD Family10h Kernel 2.6.23
 >> This patch is for controlling the upper 32bits of the event ctrl msrs.
 >> This includes the upper 4 bits of the event select and the Guest Only
 >> and Host Only bits
 >> This patch is necessary to make Event Based Profiling work reliably on a
 >> Family10h processor
 >>
 >> ---
 >>  op_model_athlon.c |   22 ++++++++++++++++------
 >>  1 file changed, 16 insertions(+), 6 deletions(-)
 >> ---
 >>
 >> Signed-off-by: Barry Kasindorf <barry.kasindorf@amd.com>
 >> Signed-off-by: Robert Richter <robert.richter@amd.com>
 >>
 >> diff -Naur linux-2.6.23.orig/arch/i386/oprofile/op_model_athlon.c
 >> linux-2.6.23.pmc/arch/i386/oprofile/op_model_athlon.c
 >> --- linux-2.6.23.orig/arch/i386/oprofile/op_model_athlon.c	2007-10-09
 >> 16:31:38.000000000 -0400
 >> +++ linux-2.6.23.pmc/arch/i386/oprofile/op_model_athlon.c	2007-10-15
 >> 11:02:39.000000000 -0400
 >
 > []
 >
 >> @@ -70,7 +74,8 @@
 >>  		if (unlikely(!CTRL_IS_RESERVED(msrs,i)))
 >>  			continue;
 >>  		CTRL_READ(low, high, msrs, i);
 >> -		CTRL_CLEAR(low);
 >> +		CTRL_CLEAR_LO(low);
 >> +		CTRL_CLEAR_HI(low);
 >
 > Should be probably this:
 >
 > CTRL_CLEAR_HI(high);
 >
 >>  		CTRL_WRITE(low, high, msrs, i);
 >>  	}
 >>
 >
 > []
 >



