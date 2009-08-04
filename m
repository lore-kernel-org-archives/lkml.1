Return-Path: <linux-kernel-owner+w=401wt.eu-S932665AbZHDPby@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932665AbZHDPby (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 11:31:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755012AbZHDPbx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 11:31:53 -0400
Received: from hera.kernel.org ([140.211.167.34]:39755 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753179AbZHDPbw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 11:31:52 -0400
Date: Tue, 4 Aug 2009 15:31:11 GMT
From: tip-bot for Jack Steiner <steiner@sgi.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       steiner@sgi.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       steiner@sgi.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20090727143507.GA7006@sgi.com>
References: <20090727143507.GA7006@sgi.com>
Subject: [tip:x86/urgent] x86, UV: Handle missing blade-local memory correctly
Message-ID: <tip-6c7184b77464261b7d55583a48accbd1350923a3@git.kernel.org>
Git-Commit-ID: 6c7184b77464261b7d55583a48accbd1350923a3
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 04 Aug 2009 15:31:12 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6c7184b77464261b7d55583a48accbd1350923a3
Gitweb:     http://git.kernel.org/tip/6c7184b77464261b7d55583a48accbd1350923a3
Author:     Jack Steiner <steiner@sgi.com>
AuthorDate: Mon, 27 Jul 2009 09:35:07 -0500
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 4 Aug 2009 16:18:01 +0200

x86, UV: Handle missing blade-local memory correctly

UV blades may not have any blade-local memory. Add a field
(nid) to the UV blade structure to indicates whether the node
has local memory. This is needed by the GRU driver (pushed
separately).

Signed-off-by: Jack Steiner <steiner@sgi.com>
Cc: linux-mm@kvack.org
LKML-Reference: <20090727143507.GA7006@sgi.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/include/asm/uv/uv_hub.h   |    7 +++++++
 arch/x86/kernel/apic/x2apic_uv_x.c |    5 +++++
 2 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/uv/uv_hub.h b/arch/x86/include/asm/uv/uv_hub.h
index 341070f..a6dde05 100644
--- a/arch/x86/include/asm/uv/uv_hub.h
+++ b/arch/x86/include/asm/uv/uv_hub.h
@@ -327,6 +327,7 @@ struct uv_blade_info {
 	unsigned short	nr_possible_cpus;
 	unsigned short	nr_online_cpus;
 	unsigned short	pnode;
+	short		memory_nid;
 };
 extern struct uv_blade_info *uv_blade_info;
 extern short *uv_node_to_blade;
@@ -363,6 +364,12 @@ static inline int uv_blade_to_pnode(int bid)
 	return uv_blade_info[bid].pnode;
 }
 
+/* Nid of memory node on blade. -1 if no blade-local memory */
+static inline int uv_blade_to_memory_nid(int bid)
+{
+	return uv_blade_info[bid].memory_nid;
+}
+
 /* Determine the number of possible cpus on a blade */
 static inline int uv_blade_nr_possible_cpus(int bid)
 {
diff --git a/arch/x86/kernel/apic/x2apic_uv_x.c b/arch/x86/kernel/apic/x2apic_uv_x.c
index 096d19a..ad3f0a9 100644
--- a/arch/x86/kernel/apic/x2apic_uv_x.c
+++ b/arch/x86/kernel/apic/x2apic_uv_x.c
@@ -591,6 +591,8 @@ void __init uv_system_init(void)
 	bytes = sizeof(struct uv_blade_info) * uv_num_possible_blades();
 	uv_blade_info = kmalloc(bytes, GFP_KERNEL);
 	BUG_ON(!uv_blade_info);
+	for (blade = 0; blade < uv_num_possible_blades(); blade++)
+		uv_blade_info[blade].memory_nid = -1;
 
 	get_lowmem_redirect(&lowmem_redir_base, &lowmem_redir_size);
 
@@ -629,6 +631,9 @@ void __init uv_system_init(void)
 		lcpu = uv_blade_info[blade].nr_possible_cpus;
 		uv_blade_info[blade].nr_possible_cpus++;
 
+		/* Any node on the blade, else will contain -1. */
+		uv_blade_info[blade].memory_nid = nid;
+
 		uv_cpu_hub_info(cpu)->lowmem_remap_base = lowmem_redir_base;
 		uv_cpu_hub_info(cpu)->lowmem_remap_top = lowmem_redir_size;
 		uv_cpu_hub_info(cpu)->m_val = m_val;
