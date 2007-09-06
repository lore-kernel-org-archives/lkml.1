Return-Path: <linux-kernel-owner+w=401wt.eu-S1757769AbXIFPBQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757769AbXIFPBQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2007 11:01:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755339AbXIFO75
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Sep 2007 10:59:57 -0400
Received: from mx2.suse.de ([195.135.220.15]:40972 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753392AbXIFO7z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2007 10:59:55 -0400
From: Andi Kleen <ak@suse.de>
References: <20070906459.839970000@suse.de>
In-Reply-To: <20070906459.839970000@suse.de>
To: dwalker@mvista.com, patches@x86-64.org, linux-kernel@vger.kernel.org,
       torvalds@osdl.org
Subject: [PATCH for 2.6.23] [3/3] i386: fix a hang on stuck nmi watchdog
Message-Id: <20070906145954.1E47514EE9@wotan.suse.de>
Date: Thu,  6 Sep 2007 16:59:54 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Daniel Walker <dwalker@mvista.com>
In the case when an nmi gets stucks the endflag stays equal to zero. This
causes the busy looping on other cpus to continue, even tho the nmi test
is done.

On my machine with out the change below the system would hang right after
check_nmi_watchdog(). The change below just sets endflag prior to checking
if the test was successful or not.

Signed-off-by: Daniel Walker <dwalker@mvista.com>
Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/i386/kernel/nmi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux/arch/i386/kernel/nmi.c
===================================================================
--- linux.orig/arch/i386/kernel/nmi.c
+++ linux/arch/i386/kernel/nmi.c
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
