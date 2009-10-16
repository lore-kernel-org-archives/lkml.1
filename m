Return-Path: <linux-kernel-owner+w=401wt.eu-S1756716AbZJPHYW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756716AbZJPHYW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Oct 2009 03:24:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756383AbZJPHYV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Oct 2009 03:24:21 -0400
Received: from hera.kernel.org ([140.211.167.34]:38832 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756125AbZJPHYU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Oct 2009 03:24:20 -0400
Date: Fri, 16 Oct 2009 07:22:12 GMT
From: tip-bot for Robin Holt <holt@sgi.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       steiner@sgi.com, holt@sgi.com, cpw@sgi.com, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       steiner@sgi.com, holt@sgi.com, cpw@sgi.com, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <20091015224946.396355000@alcatraz.americas.sgi.com>
References: <20091015224946.396355000@alcatraz.americas.sgi.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86, UV: Fix information in __uv_hub_info structure
Message-ID: <tip-036ed8ba61b72c19dc5759446d4fe0844aa88255@git.kernel.org>
Git-Commit-ID: 036ed8ba61b72c19dc5759446d4fe0844aa88255
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 16 Oct 2009 07:22:12 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  036ed8ba61b72c19dc5759446d4fe0844aa88255
Gitweb:     http://git.kernel.org/tip/036ed8ba61b72c19dc5759446d4fe0844aa88255
Author:     Robin Holt <holt@sgi.com>
AuthorDate: Thu, 15 Oct 2009 17:40:00 -0500
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 16 Oct 2009 08:18:34 +0200

x86, UV: Fix information in __uv_hub_info structure

A few parts of the uv_hub_info structure are initialized
incorrectly.

 - n_val is being loaded with m_val.
 - gpa_mask is initialized with a bytes instead of an unsigned long.
 - Handle the case where none of the alias registers are used.

Lastly I converted the bau over to using the uv_hub_info->m_val
which is the correct value.

Without this patch, booting a large configuration hits a
problem where the upper bits of the gnode affect the pnode
and the bau will not operate.

Signed-off-by: Robin Holt <holt@sgi.com>
Acked-by: Jack Steiner <steiner@sgi.com>
Cc: Cliff Whickman <cpw@sgi.com>
Cc: stable@kernel.org
LKML-Reference: <20091015224946.396355000@alcatraz.americas.sgi.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/apic/x2apic_uv_x.c |    8 ++++----
 arch/x86/kernel/tlb_uv.c           |    4 ++--
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/apic/x2apic_uv_x.c b/arch/x86/kernel/apic/x2apic_uv_x.c
index f5f5886..326c254 100644
--- a/arch/x86/kernel/apic/x2apic_uv_x.c
+++ b/arch/x86/kernel/apic/x2apic_uv_x.c
@@ -352,14 +352,14 @@ static __init void get_lowmem_redirect(unsigned long *base, unsigned long *size)
 
 	for (i = 0; i < ARRAY_SIZE(redir_addrs); i++) {
 		alias.v = uv_read_local_mmr(redir_addrs[i].alias);
-		if (alias.s.base == 0) {
+		if (alias.s.enable && alias.s.base == 0) {
 			*size = (1UL << alias.s.m_alias);
 			redirect.v = uv_read_local_mmr(redir_addrs[i].redirect);
 			*base = (unsigned long)redirect.s.dest_base << DEST_SHIFT;
 			return;
 		}
 	}
-	BUG();
+	*base = *size = 0;
 }
 
 enum map_type {map_wb, map_uc};
@@ -619,12 +619,12 @@ void __init uv_system_init(void)
 		uv_cpu_hub_info(cpu)->lowmem_remap_base = lowmem_redir_base;
 		uv_cpu_hub_info(cpu)->lowmem_remap_top = lowmem_redir_size;
 		uv_cpu_hub_info(cpu)->m_val = m_val;
-		uv_cpu_hub_info(cpu)->n_val = m_val;
+		uv_cpu_hub_info(cpu)->n_val = n_val;
 		uv_cpu_hub_info(cpu)->numa_blade_id = blade;
 		uv_cpu_hub_info(cpu)->blade_processor_id = lcpu;
 		uv_cpu_hub_info(cpu)->pnode = pnode;
 		uv_cpu_hub_info(cpu)->pnode_mask = pnode_mask;
-		uv_cpu_hub_info(cpu)->gpa_mask = (1 << (m_val + n_val)) - 1;
+		uv_cpu_hub_info(cpu)->gpa_mask = (1UL << (m_val + n_val)) - 1;
 		uv_cpu_hub_info(cpu)->gnode_upper = gnode_upper;
 		uv_cpu_hub_info(cpu)->gnode_extra = gnode_extra;
 		uv_cpu_hub_info(cpu)->global_mmr_base = mmr_base;
diff --git a/arch/x86/kernel/tlb_uv.c b/arch/x86/kernel/tlb_uv.c
index 503c1f2..f99fb6a 100644
--- a/arch/x86/kernel/tlb_uv.c
+++ b/arch/x86/kernel/tlb_uv.c
@@ -843,8 +843,8 @@ static int __init uv_bau_init(void)
 				       GFP_KERNEL, cpu_to_node(cur_cpu));
 
 	uv_bau_retry_limit = 1;
-	uv_nshift = uv_hub_info->n_val;
-	uv_mmask = (1UL << uv_hub_info->n_val) - 1;
+	uv_nshift = uv_hub_info->m_val;
+	uv_mmask = (1UL << uv_hub_info->m_val) - 1;
 	nblades = uv_num_possible_blades();
 
 	uv_bau_table_bases = (struct bau_control **)
