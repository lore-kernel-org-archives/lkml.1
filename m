Return-Path: <linux-kernel-owner+w=401wt.eu-S1753253AbZKSRcG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753253AbZKSRcG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 12:32:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753551AbZKSRcD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 12:32:03 -0500
Received: from relay2.sgi.com ([192.48.179.30]:54916 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753253AbZKSRcA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 12:32:00 -0500
From: Robin Holt <holt@sgi.com>
Message-Id: <20091119173205.969721000@alcatraz.americas.sgi.com>
User-Agent: quilt/0.47-1
Date: Thu, 19 Nov 2009 11:31:58 -0600
To: Ingo Molnar <mingo@elte.hu>, tglx@linutronix.de
Cc: Robin Holt <holt@sgi.com>, Jack Steiner <steiner@sgi.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: [patch 1/8] x86: UV - Introduce a means to translate from gpa -> socket_paddr.
References: <20091119173157.337874000@alcatraz.americas.sgi.com>
Content-Disposition: inline; filename=uv_gpa_to_soc_phys_ram
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


For SGI UV systems, translate from a global physical address back to
a socket physical address.  This does nothing to ensure the socket
physical address is actually addressable by the kernel.  That is the
responsibility of the user of the function.

To: Ingo Molnar <mingo@elte.hu>
To: tglx@linutronix.de
Signed-off-by: Robin Holt <holt@sgi.com>
Cc: Jack Steiner <steiner@sgi.com>
Cc: lkml <linux-kernel@vger.kernel.org>

---
 arch/x86/include/asm/uv/uv_hub.h |   13 +++++++++++++
 1 file changed, 13 insertions(+)
Index: linux-x86/arch/x86/include/asm/uv/uv_hub.h
===================================================================
--- linux-x86.orig/arch/x86/include/asm/uv/uv_hub.h	2009-11-09 08:46:25.000000000 -0600
+++ linux-x86/arch/x86/include/asm/uv/uv_hub.h	2009-11-09 08:50:25.000000000 -0600
@@ -232,6 +232,19 @@ static inline unsigned long uv_gpa(void 
 	return uv_soc_phys_ram_to_gpa(__pa(v));
 }
 
+/* UV global physical address --> socket phys RAM */
+static inline unsigned long uv_gpa_to_soc_phys_ram(unsigned long gpa)
+{
+	unsigned long paddr = gpa & uv_hub_info->gpa_mask;
+	unsigned long remap_base = uv_hub_info->lowmem_remap_base;
+	unsigned long remap_top =  uv_hub_info->lowmem_remap_top;
+
+	if (paddr >= remap_base && paddr < remap_base + remap_top)
+		paddr -= remap_base;
+	return paddr;
+}
+
+
 /* gnode -> pnode */
 static inline unsigned long uv_gpa_to_gnode(unsigned long gpa)
 {

