Return-Path: <linux-kernel-owner+w=401wt.eu-S932203AbXIAVA3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932203AbXIAVA3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Sep 2007 17:00:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755863AbXIAVAW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Sep 2007 17:00:22 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:3072 "EHLO
	localhost.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755778AbXIAVAV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Sep 2007 17:00:21 -0400
Message-Id: <20070901205417.305538884@mvista.com>
User-Agent: quilt/0.46-1
Date: Sat, 01 Sep 2007 13:54:17 -0700
From: Daniel Walker <dwalker@mvista.com>
To: akpm@linux-foundation.org
Cc: Andi Kleen <ak@suse.de>
Cc: eranian@hpl.hp.com
Cc: B.Steinbrink@gmx.de
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 1/1] i386: fix a hang on stuck nmi watchdog
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

In the case when an nmi gets stucks the endflag stays equal to zero. This
causes the busy looping on other cpus to continue, even tho the nmi test
is done.

On my machine with out the change below the system would hang right after
check_nmi_watchdog(). The change below just sets endflag prior to checking
if the test was successful or not.

Signed-off-by: Daniel Walker <dwalker@mvista.com>

---
 arch/i386/kernel/nmi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.22/arch/i386/kernel/nmi.c
===================================================================
--- linux-2.6.22.orig/arch/i386/kernel/nmi.c
+++ linux-2.6.22/arch/i386/kernel/nmi.c
@@ -115,12 +115,12 @@ static int __init check_nmi_watchdog(voi
 			atomic_dec(&nmi_active);
 		}
 	}
+	endflag = 1;
 	if (!atomic_read(&nmi_active)) {
 		kfree(prev_nmi_count);
 		atomic_set(&nmi_active, -1);
 		return -1;
 	}
-	endflag = 1;
 	printk("OK.\n");
 
 	/* now that we know it works we can reduce NMI frequency to
-- 

-- 
