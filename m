Return-Path: <linux-kernel-owner+w=401wt.eu-S965082AbZLQE0Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965082AbZLQE0Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 23:26:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935639AbZLQEE5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 23:04:57 -0500
Received: from kroah.org ([198.145.64.141]:55722 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935655AbZLQEEs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 23:04:48 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Wed Dec 16 19:56:54 2009
Message-Id: <20091217035654.014917448@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 16 Dec 2009 19:56:23 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [086/151] xen: restore runstate_info even if !have_vcpu_info_placement
In-Reply-To: <20091217040208.GA26571@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

commit 3905bb2aa7bb801b31946b37a4635ebac4009051 upstream.

Even if have_vcpu_info_placement is not set, we still need to set up
the runstate area on each resumed vcpu.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/xen/enlighten.c |   25 +++++++++++--------------
 1 file changed, 11 insertions(+), 14 deletions(-)

--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -138,26 +138,23 @@ static void xen_vcpu_setup(int cpu)
  */
 void xen_vcpu_restore(void)
 {
-	if (have_vcpu_info_placement) {
-		int cpu;
+	int cpu;
 
-		for_each_online_cpu(cpu) {
-			bool other_cpu = (cpu != smp_processor_id());
+	for_each_online_cpu(cpu) {
+		bool other_cpu = (cpu != smp_processor_id());
 
-			if (other_cpu &&
-			    HYPERVISOR_vcpu_op(VCPUOP_down, cpu, NULL))
-				BUG();
+		if (other_cpu &&
+		    HYPERVISOR_vcpu_op(VCPUOP_down, cpu, NULL))
+			BUG();
 
-			xen_setup_runstate_info(cpu);
+		xen_setup_runstate_info(cpu);
 
+		if (have_vcpu_info_placement)
 			xen_vcpu_setup(cpu);
 
-			if (other_cpu &&
-			    HYPERVISOR_vcpu_op(VCPUOP_up, cpu, NULL))
-				BUG();
-		}
-
-		BUG_ON(!have_vcpu_info_placement);
+		if (other_cpu &&
+		    HYPERVISOR_vcpu_op(VCPUOP_up, cpu, NULL))
+			BUG();
 	}
 }
 


