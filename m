Return-Path: <linux-kernel-owner+w=401wt.eu-S1756217AbYDYAQR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756217AbYDYAQR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 20:16:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753247AbYDYAP7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 20:15:59 -0400
Received: from hera.kernel.org ([140.211.167.34]:55121 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752728AbYDYAP5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 20:15:57 -0400
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: stable@kernel.org
Subject: [2.6.25-stable PATCH] regression: powertop says 120K wakeups/sec
Date: Thu, 24 Apr 2008 20:15:19 -0400
User-Agent: KMail/1.9.9
Cc: Linux-acpi@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804242015.19462.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Date:   Wed Apr 9 21:31:46 2008 -0400

commit 0fda6b403f0eca66ad8a7c946b3996e359100443
    
Patch to fix huge number of wakeups reported due to recent changes in
processor_idle.c. The problem was that the entry_method determination was
broken due to one of the recent commits (bc71bec91f987) causing
C1 entry to not to go to halt.
    
http://lkml.org/lkml/2008/3/22/124
    
Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Signed-off-by: Len Brown <len.brown@intel.com>

diff --git a/drivers/acpi/processor_idle.c b/drivers/acpi/processor_idle.c
index 788da97..836362b 100644
--- a/drivers/acpi/processor_idle.c
+++ b/drivers/acpi/processor_idle.c
@@ -848,6 +848,7 @@ static int acpi_processor_get_power_info_default(struct acpi_processor *pr)
 		/* all processors need to support C1 */
 		pr->power.states[ACPI_STATE_C1].type = ACPI_STATE_C1;
 		pr->power.states[ACPI_STATE_C1].valid = 1;
+		pr->power.states[ACPI_STATE_C1].entry_method = ACPI_CSTATE_HALT;
 	}
 	/* the C0 state only exists as a filler in our array */
 	pr->power.states[ACPI_STATE_C0].valid = 1;
@@ -960,6 +961,9 @@ static int acpi_processor_get_power_info_cst(struct acpi_processor *pr)
 				 cx.address);
 		}
 
+		if (cx.type == ACPI_STATE_C1) {
+			cx.valid = 1;
+		}
 
 		obj = &(element->package.elements[2]);
 		if (obj->type != ACPI_TYPE_INTEGER)
