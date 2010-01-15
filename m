Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758094Ab0AOTZL (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 15 Jan 2010 14:25:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758056Ab0AOTZJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jan 2010 14:25:09 -0500
Received: from hera.kernel.org ([140.211.167.34]:37617 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751702Ab0AOTZH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jan 2010 14:25:07 -0500
Date: Fri, 15 Jan 2010 19:24:41 GMT
From: tip-bot for Jack Steiner <steiner@sgi.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        steiner@sgi.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        steiner@sgi.com, tglx@linutronix.de
In-Reply-To: <20100112210904.GA24546@sgi.com>
References: <20100112210904.GA24546@sgi.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86, uv: Add function retrieving node controller revision number
Message-ID: <tip-7a1110e861b2666ac09f5708d6fbe71d18ce64bb@git.kernel.org>
Git-Commit-ID: 7a1110e861b2666ac09f5708d6fbe71d18ce64bb
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 15 Jan 2010 19:24:42 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7a1110e861b2666ac09f5708d6fbe71d18ce64bb
Gitweb:     http://git.kernel.org/tip/7a1110e861b2666ac09f5708d6fbe71d18ce64bb
Author:     Jack Steiner <steiner@sgi.com>
AuthorDate: Tue, 12 Jan 2010 15:09:04 -0600
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Fri, 15 Jan 2010 11:08:55 -0800

x86, uv: Add function retrieving node controller revision number

Add function for determining the revision id of the SGI UV
node controller chip (HUB). This function is needed in a
subsequent patch.

Signed-off-by: Jack Steiner <steiner@sgi.com>
LKML-Reference: <20100112210904.GA24546@sgi.com>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/include/asm/uv/uv_hub.h   |   12 ++++++++++++
 arch/x86/kernel/apic/x2apic_uv_x.c |    6 ++++++
 2 files changed, 18 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/uv/uv_hub.h b/arch/x86/include/asm/uv/uv_hub.h
index bc54fa9..40be813 100644
--- a/arch/x86/include/asm/uv/uv_hub.h
+++ b/arch/x86/include/asm/uv/uv_hub.h
@@ -495,5 +495,17 @@ static inline void uv_hub_send_ipi(int pnode, int apicid, int vector)
 	uv_write_global_mmr64(pnode, UVH_IPI_INT, val);
 }
 
+/*
+ * Get the minimum revision number of the hub chips within the partition.
+ *     1 - initial rev 1.0 silicon
+ *     2 - rev 2.0 production silicon
+ */
+static inline int uv_get_min_hub_revision_id(void)
+{
+	extern int uv_min_hub_revision_id;
+
+	return uv_min_hub_revision_id;
+}
+
 #endif /* CONFIG_X86_64 */
 #endif /* _ASM_X86_UV_UV_HUB_H */
diff --git a/arch/x86/kernel/apic/x2apic_uv_x.c b/arch/x86/kernel/apic/x2apic_uv_x.c
index b8bb869..0e48de9 100644
--- a/arch/x86/kernel/apic/x2apic_uv_x.c
+++ b/arch/x86/kernel/apic/x2apic_uv_x.c
@@ -36,6 +36,8 @@ DEFINE_PER_CPU(int, x2apic_extra_bits);
 
 static enum uv_system_type uv_system_type;
 static u64 gru_start_paddr, gru_end_paddr;
+int uv_min_hub_revision_id;
+EXPORT_SYMBOL_GPL(uv_min_hub_revision_id);
 
 static inline bool is_GRU_range(u64 start, u64 end)
 {
@@ -55,6 +57,10 @@ static int early_get_nodeid(void)
 	mmr = early_ioremap(UV_LOCAL_MMR_BASE | UVH_NODE_ID, sizeof(*mmr));
 	node_id.v = *mmr;
 	early_iounmap(mmr, sizeof(*mmr));
+
+	/* Currently, all blades have same revision number */
+	uv_min_hub_revision_id = node_id.s.revision;
+
 	return node_id.s.node_id;
 }
 
