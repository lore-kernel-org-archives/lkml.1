Return-Path: <linux-kernel-owner+w=401wt.eu-S1759010AbZJPMyG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759010AbZJPMyG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Oct 2009 08:54:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755563AbZJPMyF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Oct 2009 08:54:05 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:42670 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753941AbZJPMyD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Oct 2009 08:54:03 -0400
Date: Fri, 16 Oct 2009 14:53:13 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Robin Holt <holt@sgi.com>
Cc: tglx@linutronix.de, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       Jack Steiner <steiner@sgi.com>, Cliff Whickman <cpw@sgi.com>
Subject: Re: [patch 0/2] x86, UV: fixups for configurations with a large
	number of nodes.
Message-ID: <20091016125313.GB15393@elte.hu>
References: <20091015223959.783988000@alcatraz.americas.sgi.com> <20091016063405.GB20388@elte.hu> <20091016112920.GZ8903@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091016112920.GZ8903@sgi.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Robin Holt <holt@sgi.com> wrote:

> >   uv_nshift = uv_hub_info->m_val;
> > 
> > to (in essence):
> > 
> >               uv_hub_info->m_val & ((1UL << uv_hub_info->n_val) - 1)
> > 
> > which is not the same. Furthermore, the new inline is:
> 
> You have an excellent point there.  That was a bug as well.  That may 
> explain a few of our currently unexplained bau hangs.  The value is 
> supposed to be a pnode instead of the current gnode.

So ... is the commit log message i've put into the commit below correct, 
or is it still only a cleanup patch? You really need to put that kind of 
info into your changelogs - it helps maintainers put it into the right 
kernel release.

	Ingo

------------>
>From 1d21e6e3ffad2939f9d8179817c6f9bc3b811b68 Mon Sep 17 00:00:00 2001
From: Robin Holt <holt@sgi.com>
Date: Fri, 16 Oct 2009 06:29:20 -0500
Subject: [PATCH] x86, UV: Fix and clean up bau code to use uv_gpa_to_pnode()

Create an inline function to extract the pnode from a global
physical address and then convert the broadcast assist unit to
use the newly created uv_gpa_to_pnode function.

The open-coded code was wrong as well - it might explain a
few of our unexplained bau hangs.

Signed-off-by: Robin Holt <holt@sgi.com>
Acked-by: Cliff Whickman <cpw@sgi.com>
Cc: linux-mm@kvack.org
Cc: Jack Steiner <steiner@sgi.com>
LKML-Reference: <20091016112920.GZ8903@sgi.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/uv/uv_hub.h |   16 +++++++++++++++-
 arch/x86/kernel/tlb_uv.c         |    7 ++-----
 2 files changed, 17 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/uv/uv_hub.h b/arch/x86/include/asm/uv/uv_hub.h
index 04eb6c9..94908a0 100644
--- a/arch/x86/include/asm/uv/uv_hub.h
+++ b/arch/x86/include/asm/uv/uv_hub.h
@@ -114,7 +114,7 @@
 /*
  * The largest possible NASID of a C or M brick (+ 2)
  */
-#define UV_MAX_NASID_VALUE	(UV_MAX_NUMALINK_NODES * 2)
+#define UV_MAX_NASID_VALUE	(UV_MAX_NUMALINK_BLADES * 2)
 
 struct uv_scir_s {
 	struct timer_list timer;
@@ -230,6 +230,20 @@ static inline unsigned long uv_gpa(void *v)
 	return uv_soc_phys_ram_to_gpa(__pa(v));
 }
 
+/* gnode -> pnode */
+static inline unsigned long uv_gpa_to_gnode(unsigned long gpa)
+{
+	return gpa >> uv_hub_info->m_val;
+}
+
+/* gpa -> pnode */
+static inline int uv_gpa_to_pnode(unsigned long gpa)
+{
+	unsigned long n_mask = (1UL << uv_hub_info->n_val) - 1;
+
+	return uv_gpa_to_gnode(gpa) & n_mask;
+}
+
 /* pnode, offset --> socket virtual */
 static inline void *uv_pnode_offset_to_vaddr(int pnode, unsigned long offset)
 {
diff --git a/arch/x86/kernel/tlb_uv.c b/arch/x86/kernel/tlb_uv.c
index f99fb6a..1740c85 100644
--- a/arch/x86/kernel/tlb_uv.c
+++ b/arch/x86/kernel/tlb_uv.c
@@ -23,8 +23,6 @@
 static struct bau_control	**uv_bau_table_bases __read_mostly;
 static int			uv_bau_retry_limit __read_mostly;
 
-/* position of pnode (which is nasid>>1): */
-static int			uv_nshift __read_mostly;
 /* base pnode in this partition */
 static int			uv_partition_base_pnode __read_mostly;
 
@@ -723,7 +721,7 @@ uv_activation_descriptor_init(int node, int pnode)
 	BUG_ON(!adp);
 
 	pa = uv_gpa(adp); /* need the real nasid*/
-	n = pa >> uv_nshift;
+	n = uv_gpa_to_pnode(pa);
 	m = pa & uv_mmask;
 
 	uv_write_global_mmr64(pnode, UVH_LB_BAU_SB_DESCRIPTOR_BASE,
@@ -778,7 +776,7 @@ uv_payload_queue_init(int node, int pnode, struct bau_control *bau_tablesp)
 	 * need the pnode of where the memory was really allocated
 	 */
 	pa = uv_gpa(pqp);
-	pn = pa >> uv_nshift;
+	pn = uv_gpa_to_pnode(pa);
 	uv_write_global_mmr64(pnode,
 			      UVH_LB_BAU_INTD_PAYLOAD_QUEUE_FIRST,
 			      ((unsigned long)pn << UV_PAYLOADQ_PNODE_SHIFT) |
@@ -843,7 +841,6 @@ static int __init uv_bau_init(void)
 				       GFP_KERNEL, cpu_to_node(cur_cpu));
 
 	uv_bau_retry_limit = 1;
-	uv_nshift = uv_hub_info->m_val;
 	uv_mmask = (1UL << uv_hub_info->m_val) - 1;
 	nblades = uv_num_possible_blades();
 
