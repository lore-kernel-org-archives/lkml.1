Return-Path: <linux-kernel-owner+w=401wt.eu-S934341AbZJMULg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934341AbZJMULg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 16:11:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934317AbZJMULe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 16:11:34 -0400
Received: from ey-out-2122.google.com ([74.125.78.24]:50063 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934318AbZJMULc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 16:11:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:user-agent:date:from:to:cc:subject:references
         :content-disposition;
        b=rr/yFDWp9qo5vIuOjusLuSQIyWn0+4UV5It8ZkN86h43bSgN0j+MSleLPrFeqvVg5H
         sdQPK8EkhpX45N3BETJM2yukOw2dNlvtPsV2RoVtchrNC9rJvcXIUelKMMqtmSJMn6vz
         kSPaHhNKd1HX8w4y8JSjGlzlKS/OLHRik8mIo=
Message-Id: <20091013201022.747817361@openvz.org>
User-Agent: quilt/0.47-1
Date: Wed, 14 Oct 2009 00:07:04 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: mingo@elte.hu
Cc: x86@kernel.org, yinghai@kernel.org, macro@linux-mips.org,
       linux-kernel@vger.kernel.org, Cyrill Gorcunov <gorcunov@openvz.org>
Subject: [patch 2/3] x86,apic -- use apic noop driver
References: <20091013200702.019870576@openvz.org>
Content-Disposition: inline; filename=x86-apic-use-noop
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In case if apic were disabled we may use the whole apic
NOOP driver instead of sparse poking the some functions
in apic driver. Also NOOP would catch any inappropriate
apic operation calls (not just read/write).

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
---
 arch/x86/kernel/apic/apic.c |   22 +++-------------------
 1 file changed, 3 insertions(+), 19 deletions(-)

Index: linux-2.6.git/arch/x86/kernel/apic/apic.c
=====================================================================
--- linux-2.6.git.orig/arch/x86/kernel/apic/apic.c
+++ linux-2.6.git/arch/x86/kernel/apic/apic.c
@@ -241,28 +241,12 @@ static int modern_apic(void)
 }
 
 /*
- * bare function to substitute write operation
- * and it's _that_ fast :)
- */
-static void native_apic_write_dummy(u32 reg, u32 v)
-{
-	WARN_ON_ONCE((cpu_has_apic || !disable_apic));
-}
-
-static u32 native_apic_read_dummy(u32 reg)
-{
-	WARN_ON_ONCE((cpu_has_apic && !disable_apic));
-	return 0;
-}
-
-/*
- * right after this call apic->write/read doesn't do anything
- * note that there is no restore operation it works one way
+ * right after this call apic become NOOP driven
+ * so apic->write/read doesn't do anything
  */
 void apic_disable(void)
 {
-	apic->read = native_apic_read_dummy;
-	apic->write = native_apic_write_dummy;
+	apic = &apic_noop;
 }
 
 void native_apic_wait_icr_idle(void)

