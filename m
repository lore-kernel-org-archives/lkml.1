Return-Path: <linux-kernel-owner+w=401wt.eu-S1760102AbYHNSrj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760102AbYHNSrj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 14:47:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754283AbYHNSqy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 14:46:54 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:59579 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752191AbYHNSqv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 14:46:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:references:user-agent:date:from:to:cc:subject
         :content-disposition;
        b=DmkVRJ1pzpEdonKeIRA0XA/zcuC0OOced4E3xOuVK1lc0HUXgU8kG3jFoBMpmbTZur
         VnOn8N3C/wstwQcJLh82NCC0c5IEs86hSydtTcvK7XNmKE8nBnP3asN6PlF8iqD8k+qF
         uh9fD7BugO07on8AqGTGbYKYQTLbQ7QVVDMSA=
Message-Id: <20080814184651.681143113@gmail.com>
References: <20080814183428.550709025@gmail.com>
User-Agent: quilt/0.46-1
Date: Thu, 01 Jan 1970 03:00:03 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: macro@linux-mips.org, mingo@elte.hu, tglx@linutronix.de
Cc: hpa@zytor.com, yhlu.kernel@gmail.com, linux-kernel@vger.kernel.org,
       Cyrill Gorcunov <gorcunov@gmail.com>
Subject: [patch 3/8] x86: apic - unify __setup_APIC_LVTT
Content-Disposition: inline; filename=x86-apic-unify-__setup_APIC_LVTT.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To be able to unify this function we RE-introduce
APIC_DIVISOR for 64bit mode. This snipped was eliminated
in some time ago in a sake of clenup but now we need it
again since it allow up to get rid of #ifdef(s).

And lapic_is_integrated call is added in apic_64.c but
since we always have APIC integrated on 64bit cpu compiler
will ignore this call.

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
---

diff --git a/arch/x86/kernel/apic_64.c b/arch/x86/kernel/apic_64.c
index 1e0b5d9..5d07689 100644
--- a/arch/x86/kernel/apic_64.c
+++ b/arch/x86/kernel/apic_64.c
@@ -244,6 +244,9 @@ int lapic_get_maxlvt(void)
 	return APIC_INTEGRATED(GET_APIC_VERSION(v)) ? GET_APIC_MAXLVT(v) : 2;
 }
 
+/* Clock divisor is set to 1 */
+#define APIC_DIVISOR 1
+
 /*
  * This function sets up the local APIC timer, with a timeout of
  * 'clocks' APIC bus clock. During calibration we actually call
@@ -262,6 +265,9 @@ static void __setup_APIC_LVTT(unsigned int clocks, int oneshot, int irqen)
 	lvtt_value = LOCAL_TIMER_VECTOR;
 	if (!oneshot)
 		lvtt_value |= APIC_LVT_TIMER_PERIODIC;
+	if (!lapic_is_integrated())
+		lvtt_value |= SET_APIC_TIMER_BASE(APIC_TIMER_BASE_DIV);
+
 	if (!irqen)
 		lvtt_value |= APIC_LVT_MASKED;
 
@@ -276,7 +282,7 @@ static void __setup_APIC_LVTT(unsigned int clocks, int oneshot, int irqen)
 				| APIC_TDR_DIV_16);
 
 	if (!oneshot)
-		apic_write(APIC_TMICT, clocks);
+		apic_write(APIC_TMICT, clocks / APIC_DIVISOR);
 }
 
 /*
@@ -450,7 +456,7 @@ static int __init calibrate_APIC_clock(void)
 	lapic_clockevent.min_delta_ns =
 		clockevent_delta2ns(0xF, &lapic_clockevent);
 
-	calibration_result = result / HZ;
+	calibration_result = (result * APIC_DIVISOR) / HZ;
 
 	/*
 	 * Do a sanity check on the APIC calibration result

-- 
