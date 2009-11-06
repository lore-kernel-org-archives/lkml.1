Return-Path: <linux-kernel-owner+w=401wt.eu-S1760497AbZKFWeq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760497AbZKFWeq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 17:34:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932558AbZKFWeP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 17:34:15 -0500
Received: from kroah.org ([198.145.64.141]:56903 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760092AbZKFWXC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 17:23:02 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Nov  6 14:15:45 2009
Message-Id: <20091106221545.409589249@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 06 Nov 2009 14:14:47 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Robin Holt <holt@sgi.com>, Jack Steiner <steiner@sgi.com>,
       Cliff Whickman <cpw@sgi.com>, Ingo Molnar <mingo@elte.hu>
Subject: [49/99] x86, UV: Fix information in __uv_hub_info structure
References: <20091106221358.309857998@mini.kroah.org>
Content-Disposition: inline; filename=x86-uv-fix-information-in-__uv_hub_info-structure.patch
In-Reply-To: <20091106221850.GA15408@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Robin Holt <holt@sgi.com>

commit 036ed8ba61b72c19dc5759446d4fe0844aa88255 upstream.

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
LKML-Reference: <20091015224946.396355000@alcatraz.americas.sgi.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kernel/apic/x2apic_uv_x.c |    8 ++++----
 arch/x86/kernel/tlb_uv.c           |    4 ++--
 2 files changed, 6 insertions(+), 6 deletions(-)

--- a/arch/x86/kernel/apic/x2apic_uv_x.c
+++ b/arch/x86/kernel/apic/x2apic_uv_x.c
@@ -352,14 +352,14 @@ static __init void get_lowmem_redirect(u
 
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
@@ -609,12 +609,12 @@ void __init uv_system_init(void)
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


