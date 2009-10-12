Return-Path: <linux-kernel-owner+w=401wt.eu-S932449AbZJLPBA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932449AbZJLPBA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 11:01:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757021AbZJLPBA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 11:01:00 -0400
Received: from goliath.siemens.de ([192.35.17.28]:15332 "EHLO
	goliath.siemens.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757016AbZJLPA7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 11:00:59 -0400
X-Greylist: delayed 2083 seconds by postgrey-1.27 at vger.kernel.org; Mon, 12 Oct 2009 11:00:59 EDT
Message-ID: <4AD33BB0.8080903@siemens.com>
Date: Mon, 12 Oct 2009 16:22:40 +0200
From: "Hillier, Gernot" <gernot.hillier@siemens.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: x86@kernel.org
CC: linux-kernel@vger.kernel.org, akataria@vmware.com
Subject: [PATCH] x86: avoid modifying global flag tsc_unstable in unsychronized_tsc()
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gernot Hillier <gernot.hillier@siemens.com>

The current behavior of unsynchronized_tsc() prevents the warning for
unsychronized TSCs to be printed: tsc_init() calls unsynchronized_tsc()
first to check for such problems; if found, mark_tsc_unstable() is
called. However, the latter bails out immediately as unsynchronized_
tsc() did already set the global flag tsc_unstable. Thus, the intended
warning message "Marking TSC unstable due to TSCs unsynchronized" won't
show up.

This patch changes the behavior for unsynchronized_tsc() to only *check*
for the quirk condition, but not to modify any global flags. If I'm not
mistaken, the only place to *set* the flag shall be mark_tsc_unstable().

Signed-off-by: Gernot Hillier <gernot.hillier@siemens.com>
Reviewed-by: Jan Kiszka <jan.kiszka@siemens.com>
Reviewed-by: Wolfgang Mauerer <wolfgang.mauerer@siemens.com>

diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
index cd982f4..ffbb786 100644
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -836,10 +836,10 @@ __cpuinit int unsynchronized_tsc(void)
 	if (boot_cpu_data.x86_vendor != X86_VENDOR_INTEL) {
 		/* assume multi socket systems are not synchronized: */
 		if (num_possible_cpus() > 1)
-			tsc_unstable = 1;
+			return 1;
 	}

-	return tsc_unstable;
+	return 0;
 }

 static void __init init_tsc_clocksource(void)

