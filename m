Return-Path: <linux-kernel-owner+w=401wt.eu-S1759567AbXLLU16@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759567AbXLLU16 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 15:27:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756617AbXLLU1k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 15:27:40 -0500
Received: from homer.mvista.com ([63.81.120.158]:16422 "EHLO
	dwalker1.mvista.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754585AbXLLU1i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 15:27:38 -0500
Message-Id: <20071212201522.061896981@mvista.com>
User-Agent: quilt/0.46-1
Date: Wed, 12 Dec 2007 12:15:22 -0800
Message-Id: <20071212201258.890003246@mvista.com>
User-Agent: quilt/0.46-1
Date: Wed, 12 Dec 2007 12:12:58 -0800
From: Daniel Walker <dwalker@mvista.com>
To: rostedt@goodmis.org
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org,
       linux-rt-users@vger.kernel.org, johnstul@us.ibm.com
Subject: [PATCH -rt] cycles_to_usecs rounding fix
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

do_div() rounds down, so we add have the divisor to round up. This effected my
change to preempt_max_latency. Each time you read preempt_max_latency it gets 
rounded lower.

Signed-off-by: Daniel Walker <dwalker@mvista.com>


---
 kernel/time/timekeeping.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

Index: linux-2.6.23/kernel/time/timekeeping.c
===================================================================
--- linux-2.6.23.orig/kernel/time/timekeeping.c
+++ linux-2.6.23/kernel/time/timekeeping.c
@@ -144,7 +144,8 @@ unsigned long notrace cycles_to_usecs(cy
 {
 	u64 ret = cyc2ns(clock, cycles);
 
-	do_div(ret, 1000);
+	ret += NSEC_PER_USEC/2; /* For rounding in do_div() */
+	do_div(ret, NSEC_PER_USEC);
 
 	return ret;
 }
-- 

-- 
