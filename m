Return-Path: <linux-kernel-owner+w=401wt.eu-S1754488AbYCXVdl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754488AbYCXVdl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2008 17:33:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752329AbYCXVdc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Mar 2008 17:33:32 -0400
Received: from mga02.intel.com ([134.134.136.20]:22612 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752153AbYCXVdc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2008 17:33:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,548,1199692800"; 
   d="scan'208";a="359852181"
Date: Mon, 24 Mar 2008 14:24:10 -0700
From: Venki Pallipadi <venkatesh.pallipadi@intel.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] acpi_unlazy_tlb only on C3 entry
Message-ID: <20080324212410.GB6783@linux-os.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Earlier patch here
http://ussg.iu.edu/hypermail/linux/kernel/0712.2/1451.html
was intending to add acpi_unlazy_tlb() to acpi_idle_enter_bm() routine which is
used for C3 entry. But, some where along the way the call got added to
acpi_idle_enter_simple() (which is C2 entry routine), probably due to identical
context in that function. Move it back to acpi_idle_enter_bm().

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>

---
 drivers/acpi/processor_idle.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

Index: linux-2.6-x86.git/drivers/acpi/processor_idle.c
===================================================================
--- linux-2.6-x86.git.orig/drivers/acpi/processor_idle.c	2008-03-21 08:28:47.000000000 -0700
+++ linux-2.6-x86.git/drivers/acpi/processor_idle.c	2008-03-24 06:43:01.000000000 -0700
@@ -1487,7 +1487,6 @@ static int acpi_idle_enter_simple(struct
 		return 0;
 	}
 
-	acpi_unlazy_tlb(smp_processor_id());
 	/*
 	 * Must be done before busmaster disable as we might need to
 	 * access HPET !
@@ -1577,6 +1576,8 @@ static int acpi_idle_enter_bm(struct cpu
 		return 0;
 	}
 
+	acpi_unlazy_tlb(smp_processor_id());
+
 	/* Tell the scheduler that we are going deep-idle: */
 	sched_clock_idle_sleep_event();
 	/*
