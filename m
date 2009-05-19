Return-Path: <linux-kernel-owner+w=401wt.eu-S1754705AbZESIKV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754705AbZESIKV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 04:10:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754395AbZESIJ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 04:09:56 -0400
Received: from mga11.intel.com ([192.55.52.93]:18638 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754142AbZESIJy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 04:09:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.41,214,1241420400"; 
   d="scan'208";a="458438674"
Date: Tue, 19 May 2009 16:09:54 +0800
From: Shaohua Li <shaohua.li@intel.com>
To: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Cc: mingo@redhat.com, thisistempbox@yahoo.com, lenb@kernel.org
Subject: [PATCH 2/2]cpuidle: makes AMD C1E works in suspend/resume path
Message-ID: <20090519080954.GB12117@sli10-desk.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When AMD C1E is enabled, local APIC timer will stop even in C1. To avoid
suspend/resume hang, this patch removes C1 and replace it with a cpu_relax() in
suspend/resume path. This hasn't any impact in runtime path.

http://bugzilla.kernel.org/show_bug.cgi?id=13233

[ impact: avoid suspend/resume hang in AMD CPU with C1E enabled ]

Tested-by: Dmitry Lyzhyn <thisistempbox@yahoo.com>
Signed-off-by: Shaohua Li <shaohua.li@intel.com>
---
 drivers/acpi/processor_idle.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux/drivers/acpi/processor_idle.c
===================================================================
--- linux.orig/drivers/acpi/processor_idle.c	2009-05-19 09:56:59.000000000 +0800
+++ linux/drivers/acpi/processor_idle.c	2009-05-19 10:01:23.000000000 +0800
@@ -834,8 +834,8 @@ static int acpi_idle_enter_c1(struct cpu
 
 	/* Do not access any ACPI IO ports in suspend path */
 	if (acpi_idle_suspend) {
-		acpi_safe_halt();
 		local_irq_enable();
+		cpu_relax();
 		return 0;
 	}
 
