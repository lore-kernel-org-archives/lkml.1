Return-Path: <linux-kernel-owner+w=401wt.eu-S1752472AbYJ0Ouc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752472AbYJ0Ouc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 10:50:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750928AbYJ0OuO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 10:50:14 -0400
Received: from relay1.sgi.com ([192.48.171.29]:40621 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752024AbYJ0OuN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 10:50:13 -0400
Message-ID: <4905D568.20701@sgi.com>
Date: Mon, 27 Oct 2008 07:51:20 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Andi Kleen <andi@firstfloor.org>, Pavel Machek <pavel@suse.cz>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, Jack Steiner <steiner@sgi.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Richard Purdie <rpurdie@rpsys.net>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/1] SGI x86 UV: Update SCIR driver to use idle_cpu function
References: <4901AF28.4070606@sgi.com> <20081024120103.GD1680@elf.ucw.cz> <20081024120544.GA9812@elte.hu> <4901BF30.3090708@sgi.com> <87mygt9815.fsf@basil.nowhere.org> <490249CF.2080308@sgi.com> <49024B1D.1050407@sgi.com> <20081027114205.GB5631@elte.hu>
In-Reply-To: <20081027114205.GB5631@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: SGI x86 UV: Update SCIR driver to use idle_cpu function

> Please send the cpu_idle() cleanup patch separately.

Change UV heartbeat function to use idle_cpu to determine cpu's
"idleness".  Realign uv_hub definitions.

Signed-of-by: Mike Travis <travis@sgi.com>
---
 arch/x86/include/asm/uv/uv_hub.h |   26 +++++++++++++-------------
 arch/x86/kernel/genx2apic_uv_x.c |    4 ++--
 2 files changed, 15 insertions(+), 15 deletions(-)

--- test-tip-latest.orig/arch/x86/include/asm/uv/uv_hub.h
+++ test-tip-latest/arch/x86/include/asm/uv/uv_hub.h
@@ -128,19 +128,19 @@ struct uv_scir_s {
  * They are kept together in a struct to minimize cache misses.
  */
 struct uv_hub_info_s {
-	unsigned long	global_mmr_base;
-	unsigned long	gpa_mask;
-	unsigned long	gnode_upper;
-	unsigned long	lowmem_remap_top;
-	unsigned long	lowmem_remap_base;
-	unsigned short	pnode;
-	unsigned short	pnode_mask;
-	unsigned short	coherency_domain_number;
-	unsigned short	numa_blade_id;
-	unsigned char	blade_processor_id;
-	unsigned char	m_val;
-	unsigned char	n_val;
-	struct uv_scir_s scir;
+	unsigned long		global_mmr_base;
+	unsigned long		gpa_mask;
+	unsigned long		gnode_upper;
+	unsigned long		lowmem_remap_top;
+	unsigned long		lowmem_remap_base;
+	unsigned short		pnode;
+	unsigned short		pnode_mask;
+	unsigned short		coherency_domain_number;
+	unsigned short		numa_blade_id;
+	unsigned char		blade_processor_id;
+	unsigned char		m_val;
+	unsigned char		n_val;
+	struct uv_scir_s	scir;
 };
 
 DECLARE_PER_CPU(struct uv_hub_info_s, __uv_hub_info);
--- test-tip-latest.orig/arch/x86/kernel/genx2apic_uv_x.c
+++ test-tip-latest/arch/x86/kernel/genx2apic_uv_x.c
@@ -371,8 +371,8 @@ static void uv_heartbeat(unsigned long i
 	/* flip heartbeat bit */
 	bits ^= SCIR_CPU_HEARTBEAT;
 
-	/* are we the idle thread? */
-	if (current->pid == 0)
+	/* is this cpu idle? */
+	if (idle_cpu(smp_processor_id()))
 		bits &= ~SCIR_CPU_ACTIVITY;
 	else
 		bits |= SCIR_CPU_ACTIVITY;

