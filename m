Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934888Ab0CMB3F (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 20:29:05 -0500
Received: from kroah.org ([198.145.64.141]:60697 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934891Ab0CMAUA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 19:20:00 -0500
X-Mailbox-Line: From gregkh@kvm.kroah.org Fri Mar 12 16:15:08 2010
Message-Id: <20100313001508.598177460@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Fri, 12 Mar 2010 16:12:17 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Robert Richter <robert.richter@amd.com>
Subject: [patch 039/123] oprofile/x86: fix msr access to reserved counters
In-Reply-To: <20100313001618.GA9811@kroah.com>
In-Reply-To: <20100313001618.GA9811@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let me know.

-----------------

From: Robert Richter <robert.richter@amd.com>

commit cfc9c0b450176a077205ef39092f0dc1a04e020a upstream.

During switching virtual counters there is access to perfctr msrs. If
the counter is not available this fails due to an invalid
address. This patch fixes this.

Signed-off-by: Robert Richter <robert.richter@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/oprofile/op_model_amd.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

--- a/arch/x86/oprofile/op_model_amd.c
+++ b/arch/x86/oprofile/op_model_amd.c
@@ -85,7 +85,7 @@ static void op_mux_switch_ctrl(struct op
 	/* enable active counters */
 	for (i = 0; i < NUM_COUNTERS; ++i) {
 		int virt = op_x86_phys_to_virt(i);
-		if (!counter_config[virt].enabled)
+		if (!reset_value[virt])
 			continue;
 		rdmsrl(msrs->controls[i].addr, val);
 		val &= model->reserved;
@@ -121,7 +121,8 @@ static void op_amd_setup_ctrs(struct op_
 
 	/* setup reset_value */
 	for (i = 0; i < NUM_VIRT_COUNTERS; ++i) {
-		if (counter_config[i].enabled)
+		if (counter_config[i].enabled
+		    && msrs->counters[op_x86_virt_to_phys(i)].addr)
 			reset_value[i] = counter_config[i].count;
 		else
 			reset_value[i] = 0;
@@ -146,9 +147,7 @@ static void op_amd_setup_ctrs(struct op_
 	/* enable active counters */
 	for (i = 0; i < NUM_COUNTERS; ++i) {
 		int virt = op_x86_phys_to_virt(i);
-		if (!counter_config[virt].enabled)
-			continue;
-		if (!msrs->counters[i].addr)
+		if (!reset_value[virt])
 			continue;
 
 		/* setup counter registers */


