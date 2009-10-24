Return-Path: <linux-kernel-owner+w=401wt.eu-S1753044AbZJXBEf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753044AbZJXBEf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Oct 2009 21:04:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753048AbZJXBEc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Oct 2009 21:04:32 -0400
Received: from hera.kernel.org ([140.211.167.34]:51670 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752993AbZJXBEa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Oct 2009 21:04:30 -0400
Date: Sat, 24 Oct 2009 01:03:53 GMT
From: tip-bot for Robin Holt <holt@sgi.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       holt@sgi.com, mort@sgi.com, steiner@sgi.com, stable@kernel.org,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       holt@sgi.com, mort@sgi.com, steiner@sgi.com, stable@kernel.org,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20091020193620.877322000@alcatraz.americas.sgi.com>
References: <20091020193620.877322000@alcatraz.americas.sgi.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:branch?] x86, UV: Set DELIVERY_MODE=4 for vector=NMI_VECTOR in uv_hub_send_ipi()
Message-ID: <tip-02dd0a0613e0d84c7dd8315e3fe6204d005b7c79@git.kernel.org>
Git-Commit-ID: 02dd0a0613e0d84c7dd8315e3fe6204d005b7c79
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  02dd0a0613e0d84c7dd8315e3fe6204d005b7c79
Gitweb:     http://git.kernel.org/tip/02dd0a0613e0d84c7dd8315e3fe6204d005b7c79
Author:     Robin Holt <holt@sgi.com>
AuthorDate: Tue, 20 Oct 2009 14:36:15 -0500
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 21 Oct 2009 13:31:13 +0200

x86, UV: Set DELIVERY_MODE=4 for vector=NMI_VECTOR in uv_hub_send_ipi()

When sending a NMI_VECTOR IPI using the UV_HUB_IPI_INT register,
we need to ensure the delivery mode field of that register has
NMI delivery selected.

This makes those IPIs true NMIs, instead of flat IPIs. It
matters to reboot sequences and KGDB, both of which use NMI
IPIs.

Signed-off-by: Robin Holt <holt@sgi.com>
Acked-by: Jack Steiner <steiner@sgi.com>
Cc: Martin Hicks <mort@sgi.com>
Cc: <stable@kernel.org>
LKML-Reference: <20091020193620.877322000@alcatraz.americas.sgi.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/uv/uv_hub.h |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/uv/uv_hub.h b/arch/x86/include/asm/uv/uv_hub.h
index 94908a0..d1414af 100644
--- a/arch/x86/include/asm/uv/uv_hub.h
+++ b/arch/x86/include/asm/uv/uv_hub.h
@@ -19,6 +19,8 @@
 #include <asm/types.h>
 #include <asm/percpu.h>
 #include <asm/uv/uv_mmrs.h>
+#include <asm/irq_vectors.h>
+#include <asm/io_apic.h>
 
 
 /*
@@ -435,9 +437,14 @@ static inline void uv_set_cpu_scir_bits(int cpu, unsigned char value)
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
