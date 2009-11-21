Return-Path: <linux-kernel-owner+w=401wt.eu-S1754854AbZKUO7d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754854AbZKUO7d (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Nov 2009 09:59:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754578AbZKUO7d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Nov 2009 09:59:33 -0500
Received: from h3281.serverkompetenz.net ([81.169.158.52]:60278 "EHLO
	h3281.serverkompetenz.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754379AbZKUO7c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Nov 2009 09:59:32 -0500
X-Greylist: delayed 656 seconds by postgrey-1.27 at vger.kernel.org; Sat, 21 Nov 2009 09:59:32 EST
Message-ID: <4B07FDBF.3070509@hillier.de>
Date: Sat, 21 Nov 2009 15:48:31 +0100
From: Gernot Hillier <gernot@hillier.de>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: x86@kernel.org, Ingo Molnar <mingo@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
CC: linux-kernel@vger.kernel.org
Subject: [PATCH] x86: fix warning for unsynchronized TSCs (was: avoid modifying
 global flag tsc_unstable in unsychronized)
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gernot Hillier <gernot.hillier@siemens.com>

This is a small reminder for a patch I sent some weeks ago. 
It was already confirmed by Alok (see 
http://article.gmane.org/gmane.linux.kernel/901641). I also 
decided to give it a better summary. Here's the original 
description from last mail:

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
Reviewed-by: Alok Kataria <akataria@vmware.com>

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
