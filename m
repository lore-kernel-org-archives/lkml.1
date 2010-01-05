Return-Path: <linux-kernel-owner+w=401wt.eu-S932109Ab0AEAvX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932109Ab0AEAvX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 19:51:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755156Ab0AEAu4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 19:50:56 -0500
Received: from kroah.org ([198.145.64.141]:34183 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754275Ab0AEAfC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 19:35:02 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Mike Travis <travis@sgi.com>,
       Robin Holt <holt@sgi.com>, Ingo Molnar <mingo@elte.hu>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 28/97] x86: SGI UV: Fix writes to led registers on remote uv hubs
Date: Mon,  4 Jan 2010 16:32:41 -0800
Message-Id: <1262651630-7354-28-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <20100105003133.GA7199@kroah.com>
References: <20100105003133.GA7199@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mike Travis <travis@sgi.com>

commit 39d30770992895d55789de64bad2349510af68d0 upstream.

The wrong address was being used to write the SCIR led regs on
remote hubs.  Also, there was an inconsistency between how BIOS
and the kernel indexed these regs.  Standardize on using the
lower 6 bits of the APIC ID as the index.

This patch fixes the problem of writing to an errant address to
a cpu # >= 64.

Signed-off-by: Mike Travis <travis@sgi.com>
Reviewed-by: Jack Steiner <steiner@sgi.com>
Cc: Robin Holt <holt@sgi.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
LKML-Reference: <4B3922F9.3060905@sgi.com>
[ v2: fix a number of annoying checkpatch artifacts and whitespace noise ]
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 arch/x86/include/asm/uv/uv_hub.h   |   86 ++++++++++++++++++++----------------
 arch/x86/kernel/apic/x2apic_uv_x.c |   12 +++---
 2 files changed, 54 insertions(+), 44 deletions(-)

diff --git a/arch/x86/include/asm/uv/uv_hub.h b/arch/x86/include/asm/uv/uv_hub.h
index d1414af..e90a8a9 100644
--- a/arch/x86/include/asm/uv/uv_hub.h
+++ b/arch/x86/include/asm/uv/uv_hub.h
@@ -31,20 +31,20 @@
  *		  contiguous (although various IO spaces may punch holes in
  *		  it)..
  *
- * 	N	- Number of bits in the node portion of a socket physical
- * 		  address.
+ *	N	- Number of bits in the node portion of a socket physical
+ *		  address.
  *
- * 	NASID   - network ID of a router, Mbrick or Cbrick. Nasid values of
- * 	 	  routers always have low bit of 1, C/MBricks have low bit
- * 		  equal to 0. Most addressing macros that target UV hub chips
- * 		  right shift the NASID by 1 to exclude the always-zero bit.
- * 		  NASIDs contain up to 15 bits.
+ *	NASID   - network ID of a router, Mbrick or Cbrick. Nasid values of
+ *		  routers always have low bit of 1, C/MBricks have low bit
+ *		  equal to 0. Most addressing macros that target UV hub chips
+ *		  right shift the NASID by 1 to exclude the always-zero bit.
+ *		  NASIDs contain up to 15 bits.
  *
  *	GNODE   - NASID right shifted by 1 bit. Most mmrs contain gnodes instead
  *		  of nasids.
  *
- * 	PNODE   - the low N bits of the GNODE. The PNODE is the most useful variant
- * 		  of the nasid for socket usage.
+ *	PNODE   - the low N bits of the GNODE. The PNODE is the most useful variant
+ *		  of the nasid for socket usage.
  *
  *
  *  NumaLink Global Physical Address Format:
@@ -71,12 +71,12 @@
  *
  *
  * APICID format
- * 	NOTE!!!!!! This is the current format of the APICID. However, code
- * 	should assume that this will change in the future. Use functions
- * 	in this file for all APICID bit manipulations and conversion.
+ *	NOTE!!!!!! This is the current format of the APICID. However, code
+ *	should assume that this will change in the future. Use functions
+ *	in this file for all APICID bit manipulations and conversion.
  *
- * 		1111110000000000
- * 		5432109876543210
+ *		1111110000000000
+ *		5432109876543210
  *		pppppppppplc0cch
  *		sssssssssss
  *
@@ -89,9 +89,9 @@
  *	Note: Processor only supports 12 bits in the APICID register. The ACPI
  *	      tables hold all 16 bits. Software needs to be aware of this.
  *
- * 	      Unless otherwise specified, all references to APICID refer to
- * 	      the FULL value contained in ACPI tables, not the subset in the
- * 	      processor APICID register.
+ *	      Unless otherwise specified, all references to APICID refer to
+ *	      the FULL value contained in ACPI tables, not the subset in the
+ *	      processor APICID register.
  */
 
 
@@ -151,16 +151,16 @@ struct uv_hub_info_s {
 };
 
 DECLARE_PER_CPU(struct uv_hub_info_s, __uv_hub_info);
-#define uv_hub_info 		(&__get_cpu_var(__uv_hub_info))
+#define uv_hub_info		(&__get_cpu_var(__uv_hub_info))
 #define uv_cpu_hub_info(cpu)	(&per_cpu(__uv_hub_info, cpu))
 
 /*
  * Local & Global MMR space macros.
- * 	Note: macros are intended to be used ONLY by inline functions
- * 	in this file - not by other kernel code.
- * 		n -  NASID (full 15-bit global nasid)
- * 		g -  GNODE (full 15-bit global nasid, right shifted 1)
- * 		p -  PNODE (local part of nsids, right shifted 1)
+ *	Note: macros are intended to be used ONLY by inline functions
+ *	in this file - not by other kernel code.
+ *		n -  NASID (full 15-bit global nasid)
+ *		g -  GNODE (full 15-bit global nasid, right shifted 1)
+ *		p -  PNODE (local part of nsids, right shifted 1)
  */
 #define UV_NASID_TO_PNODE(n)		(((n) >> 1) & uv_hub_info->pnode_mask)
 #define UV_PNODE_TO_GNODE(p)		((p) |uv_hub_info->gnode_extra)
@@ -213,8 +213,8 @@ DECLARE_PER_CPU(struct uv_hub_info_s, __uv_hub_info);
 /*
  * Macros for converting between kernel virtual addresses, socket local physical
  * addresses, and UV global physical addresses.
- * 	Note: use the standard __pa() & __va() macros for converting
- * 	      between socket virtual and socket physical addresses.
+ *	Note: use the standard __pa() & __va() macros for converting
+ *	      between socket virtual and socket physical addresses.
  */
 
 /* socket phys RAM --> UV global physical address */
@@ -265,21 +265,18 @@ static inline int uv_apicid_to_pnode(int apicid)
  * Access global MMRs using the low memory MMR32 space. This region supports
  * faster MMR access but not all MMRs are accessible in this space.
  */
-static inline unsigned long *uv_global_mmr32_address(int pnode,
-				unsigned long offset)
+static inline unsigned long *uv_global_mmr32_address(int pnode, unsigned long offset)
 {
 	return __va(UV_GLOBAL_MMR32_BASE |
 		       UV_GLOBAL_MMR32_PNODE_BITS(pnode) | offset);
 }
 
-static inline void uv_write_global_mmr32(int pnode, unsigned long offset,
-				 unsigned long val)
+static inline void uv_write_global_mmr32(int pnode, unsigned long offset, unsigned long val)
 {
 	writeq(val, uv_global_mmr32_address(pnode, offset));
 }
 
-static inline unsigned long uv_read_global_mmr32(int pnode,
-						 unsigned long offset)
+static inline unsigned long uv_read_global_mmr32(int pnode, unsigned long offset)
 {
 	return readq(uv_global_mmr32_address(pnode, offset));
 }
@@ -288,25 +285,32 @@ static inline unsigned long uv_read_global_mmr32(int pnode,
  * Access Global MMR space using the MMR space located at the top of physical
  * memory.
  */
-static inline unsigned long *uv_global_mmr64_address(int pnode,
-				unsigned long offset)
+static inline unsigned long *uv_global_mmr64_address(int pnode, unsigned long offset)
 {
 	return __va(UV_GLOBAL_MMR64_BASE |
 		    UV_GLOBAL_MMR64_PNODE_BITS(pnode) | offset);
 }
 
-static inline void uv_write_global_mmr64(int pnode, unsigned long offset,
-				unsigned long val)
+static inline void uv_write_global_mmr64(int pnode, unsigned long offset, unsigned long val)
 {
 	writeq(val, uv_global_mmr64_address(pnode, offset));
 }
 
-static inline unsigned long uv_read_global_mmr64(int pnode,
-						 unsigned long offset)
+static inline unsigned long uv_read_global_mmr64(int pnode, unsigned long offset)
 {
 	return readq(uv_global_mmr64_address(pnode, offset));
 }
 
+static inline void uv_write_global_mmr8(int pnode, unsigned long offset, unsigned char val)
+{
+	writeb(val, uv_global_mmr64_address(pnode, offset));
+}
+
+static inline unsigned char uv_read_global_mmr8(int pnode, unsigned long offset)
+{
+	return readb(uv_global_mmr64_address(pnode, offset));
+}
+
 /*
  * Access hub local MMRs. Faster than using global space but only local MMRs
  * are accessible.
@@ -426,11 +430,17 @@ static inline void uv_set_scir_bits(unsigned char value)
 	}
 }
 
+static inline unsigned long uv_scir_offset(int apicid)
+{
+	return SCIR_LOCAL_MMR_BASE | (apicid & 0x3f);
+}
+
 static inline void uv_set_cpu_scir_bits(int cpu, unsigned char value)
 {
 	if (uv_cpu_hub_info(cpu)->scir.state != value) {
+		uv_write_global_mmr8(uv_cpu_to_pnode(cpu),
+				uv_cpu_hub_info(cpu)->scir.offset, value);
 		uv_cpu_hub_info(cpu)->scir.state = value;
-		uv_write_local_mmr8(uv_cpu_hub_info(cpu)->scir.offset, value);
 	}
 }
 
diff --git a/arch/x86/kernel/apic/x2apic_uv_x.c b/arch/x86/kernel/apic/x2apic_uv_x.c
index 326c254..2ab3535 100644
--- a/arch/x86/kernel/apic/x2apic_uv_x.c
+++ b/arch/x86/kernel/apic/x2apic_uv_x.c
@@ -607,8 +607,10 @@ void __init uv_system_init(void)
 	uv_rtc_init();
 
 	for_each_present_cpu(cpu) {
+		int apicid = per_cpu(x86_cpu_to_apicid, cpu);
+
 		nid = cpu_to_node(cpu);
-		pnode = uv_apicid_to_pnode(per_cpu(x86_cpu_to_apicid, cpu));
+		pnode = uv_apicid_to_pnode(apicid);
 		blade = boot_pnode_to_blade(pnode);
 		lcpu = uv_blade_info[blade].nr_possible_cpus;
 		uv_blade_info[blade].nr_possible_cpus++;
@@ -629,15 +631,13 @@ void __init uv_system_init(void)
 		uv_cpu_hub_info(cpu)->gnode_extra = gnode_extra;
 		uv_cpu_hub_info(cpu)->global_mmr_base = mmr_base;
 		uv_cpu_hub_info(cpu)->coherency_domain_number = sn_coherency_id;
-		uv_cpu_hub_info(cpu)->scir.offset = SCIR_LOCAL_MMR_BASE + lcpu;
+		uv_cpu_hub_info(cpu)->scir.offset = uv_scir_offset(apicid);
 		uv_node_to_blade[nid] = blade;
 		uv_cpu_to_blade[cpu] = blade;
 		max_pnode = max(pnode, max_pnode);
 
-		printk(KERN_DEBUG "UV: cpu %d, apicid 0x%x, pnode %d, nid %d, "
-			"lcpu %d, blade %d\n",
-			cpu, per_cpu(x86_cpu_to_apicid, cpu), pnode, nid,
-			lcpu, blade);
+		printk(KERN_DEBUG "UV: cpu %d, apicid 0x%x, pnode %d, nid %d, lcpu %d, blade %d\n",
+			cpu, apicid, pnode, nid, lcpu, blade);
 	}
 
 	/* Add blade/pnode info for nodes without cpus */
-- 
1.6.6

