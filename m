Return-Path: <linux-kernel-owner+w=401wt.eu-S1757864AbZKXBj4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757864AbZKXBj4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 20:39:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757790AbZKXBjr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 20:39:47 -0500
Received: from relay2.sgi.com ([192.48.179.30]:51451 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757673AbZKXBjq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 20:39:46 -0500
Message-Id: <20091124013950.151955000@alcatraz.americas.sgi.com>
User-Agent: quilt/0.47-1
Date: Mon, 23 Nov 2009 19:39:38 -0600
From: Robin Holt <holt@sgi.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Robin Holt <holt@sgi.com>, Jack Steiner <steiner@sgi.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, linux-mm@vger.kernel.org
Subject: [patch 1/8] x86: UV - Introduce a means to translate from gpa -> socket_paddr.
References: <20091124013937.354595000@alcatraz.americas.sgi.com>
Content-Disposition: inline; filename=uv_gpa_to_soc_phys_ram
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


For SGI UV systems, translate from a global physical address back to
a socket physical address.  This does nothing to ensure the socket
physical address is actually addressable by the kernel.  That is the
responsibility of the user of the function.

To: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Robin Holt <holt@sgi.com>
Cc: Jack Steiner <steiner@sgi.com>
Cc: lkml <linux-kernel@vger.kernel.org>
Cc: linux-mm@vger.kernel.org

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

