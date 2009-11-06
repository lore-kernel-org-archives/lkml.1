Return-Path: <linux-kernel-owner+w=401wt.eu-S932492AbZKFWXM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932492AbZKFWXM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 17:23:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760202AbZKFWXH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 17:23:07 -0500
Received: from kroah.org ([198.145.64.141]:56911 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760190AbZKFWXD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 17:23:03 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Nov  6 14:15:45 2009
Message-Id: <20091106221545.557546609@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 06 Nov 2009 14:14:48 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Robin Holt <holt@sgi.com>, Jack Steiner <steiner@sgi.com>,
       Martin Hicks <mort@sgi.com>, Ingo Molnar <mingo@elte.hu>
Subject: [50/99] x86, UV: Set DELIVERY_MODE=4 for vector=NMI_VECTOR in uv_hub_send_ipi()
References: <20091106221358.309857998@mini.kroah.org>
Content-Disposition: inline; filename=x86-uv-set-delivery_mode-4-for-vector-nmi_vector-in-uv_hub_send_ipi.patch
In-Reply-To: <20091106221850.GA15408@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Robin Holt <holt@sgi.com>

commit 02dd0a0613e0d84c7dd8315e3fe6204d005b7c79 upstream.

When sending a NMI_VECTOR IPI using the UV_HUB_IPI_INT register,
we need to ensure the delivery mode field of that register has
NMI delivery selected.

This makes those IPIs true NMIs, instead of flat IPIs. It
matters to reboot sequences and KGDB, both of which use NMI
IPIs.

Signed-off-by: Robin Holt <holt@sgi.com>
Acked-by: Jack Steiner <steiner@sgi.com>
Cc: Martin Hicks <mort@sgi.com>
LKML-Reference: <20091020193620.877322000@alcatraz.americas.sgi.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/include/asm/uv/uv_hub.h |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/arch/x86/include/asm/uv/uv_hub.h
+++ b/arch/x86/include/asm/uv/uv_hub.h
@@ -18,6 +18,8 @@
 #include <asm/types.h>
 #include <asm/percpu.h>
 #include <asm/uv/uv_mmrs.h>
+#include <asm/irq_vectors.h>
+#include <asm/io_apic.h>
 
 
 /*
@@ -420,9 +422,14 @@ static inline void uv_set_cpu_scir_bits(
 static inline void uv_hub_send_ipi(int pnode, int apicid, int vector)
 {
 	unsigned long val;
+	unsigned long dmode = dest_Fixed;
+
+	if (vector == NMI_VECTOR)
+		dmode = dest_NMI;
 
 	val = (1UL << UVH_IPI_INT_SEND_SHFT) |
 			((apicid) << UVH_IPI_INT_APIC_ID_SHFT) |
+			(dmode << UVH_IPI_INT_DELIVERY_MODE_SHFT) |
 			(vector << UVH_IPI_INT_VECTOR_SHFT);
 	uv_write_global_mmr64(pnode, UVH_IPI_INT, val);
 }


