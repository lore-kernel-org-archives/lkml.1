Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755636Ab0AOBxo (ORCPT <rfc822;list-kernel77@spinics.net>);
	Thu, 14 Jan 2010 20:53:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754554Ab0AOBxm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 20:53:42 -0500
Received: from mga11.intel.com ([192.55.52.93]:27425 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750984Ab0AOBxm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 20:53:42 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,278,1262592000"; 
   d="scan'208";a="531463715"
Message-Id: <20100115014209.844297000@intel.com>
References: <20100115013957.027452000@intel.com>
User-Agent: quilt/0.46-1
Date: Thu, 14 Jan 2010 17:39:58 -0800
From: "Venkatesh Pallipadi" <venkatesh.pallipadi@intel.com>
To: "Ingo Molnar" <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        "Thomas Gleixner" <tglx@linutronix.de>, "Len Brown" <lenb@kernel.org>,
        "Mark Hounschell" <markh@compro.net>
Cc: linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
        "Alain Knaff" <alain@knaff.lu>,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        "Li, Shaohua" <shaohua.li@intel.com>
Subject: [patch 1/4] acpi: acpi_cpu_soft_notify() not getting called on resume
Content-Disposition: inline; filename=0002-acpi_cpu_soft_notify-seems-to-be-calling-ppc-cst.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

acpi_cpu_soft_notify() seems to be calling ppc, cst and tstate routines
only on CPU_ONLINE and not on CPU_ONLINE_FROZEN, which means these
routines are getting called on logical CPU offline-online but not
getting called for any non-boot CPUs during suspend-resume.

One side effect of this that I noticed is that,
tick_broadcast_mask changes from 0000000f to 00000001 after
suspend-resume. I haven't seen any functionality issue with this. But,
seems wrong. I am not sure whether this can result in any other
bugs/issues. But, here is the fix.

This patch is a pre-requisite for followup patches that tries to fix
clockevent source ratings.

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
---
 drivers/acpi/processor_core.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/acpi/processor_core.c b/drivers/acpi/processor_core.c
index 9863c98..4513395 100644
--- a/drivers/acpi/processor_core.c
+++ b/drivers/acpi/processor_core.c
@@ -695,7 +695,7 @@ static int acpi_cpu_soft_notify(struct notifier_block *nfb,
 	unsigned int cpu = (unsigned long)hcpu;
 	struct acpi_processor *pr = per_cpu(processors, cpu);
 
-	if (action == CPU_ONLINE && pr) {
+	if ((action == CPU_ONLINE || action == CPU_ONLINE_FROZEN) && pr) {
 		acpi_processor_ppc_has_changed(pr, 0);
 		acpi_processor_cst_has_changed(pr);
 		acpi_processor_tstate_has_changed(pr);
-- 
1.6.0.6

-- 

