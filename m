Return-Path: <linux-kernel-owner+w=401wt.eu-S1759996AbZKZJ5m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759996AbZKZJ5m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 04:57:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759364AbZKZJ5i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 04:57:38 -0500
Received: from hera.kernel.org ([140.211.167.34]:41479 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759962AbZKZJ5e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 04:57:34 -0500
Date: Thu, 26 Nov 2009 09:56:54 GMT
From: tip-bot for Jack Steiner <steiner@sgi.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       steiner@sgi.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       steiner@sgi.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20091125162018.GA25445@sgi.com>
References: <20091125162018.GA25445@sgi.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] x86: SGI UV: Map low MMR ranges
Message-ID: <tip-918bc960dc630b1a79c0d2991a81985812ff69f5@git.kernel.org>
Git-Commit-ID: 918bc960dc630b1a79c0d2991a81985812ff69f5
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  918bc960dc630b1a79c0d2991a81985812ff69f5
Gitweb:     http://git.kernel.org/tip/918bc960dc630b1a79c0d2991a81985812ff69f5
Author:     Jack Steiner <steiner@sgi.com>
AuthorDate: Wed, 25 Nov 2009 10:20:19 -0600
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 26 Nov 2009 10:52:36 +0100

x86: SGI UV: Map low MMR ranges

Explicitly mmap the UV chipset MMR address ranges used to
access blade-local registers. Although these same MMRs are also
mmaped at higher addresses, the low range is more
convenient when accessing blade-local registers.

The low range addresses always alias to the local blade
regardless of the blade id.

Signed-off-by: Jack Steiner <steiner@sgi.com>
LKML-Reference: <20091125162018.GA25445@sgi.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/apic/x2apic_uv_x.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/apic/x2apic_uv_x.c b/arch/x86/kernel/apic/x2apic_uv_x.c
index f5f5886..6d42549 100644
--- a/arch/x86/kernel/apic/x2apic_uv_x.c
+++ b/arch/x86/kernel/apic/x2apic_uv_x.c
@@ -409,6 +409,12 @@ static __init void map_mmioh_high(int max_pnode)
 		map_high("MMIOH", mmioh.s.base, shift, max_pnode, map_uc);
 }
 
+static __init void map_low_mmrs(void)
+{
+	init_extra_mapping_uc(UV_GLOBAL_MMR32_BASE, UV_GLOBAL_MMR32_SIZE);
+	init_extra_mapping_uc(UV_LOCAL_MMR_BASE, UV_LOCAL_MMR_SIZE);
+}
+
 static __init void uv_rtc_init(void)
 {
 	long status;
@@ -550,6 +556,8 @@ void __init uv_system_init(void)
 	unsigned long mmr_base, present, paddr;
 	unsigned short pnode_mask;
 
+	map_low_mmrs();
+
 	m_n_config.v = uv_read_local_mmr(UVH_SI_ADDR_MAP_CONFIG);
 	m_val = m_n_config.s.m_skt;
 	n_val = m_n_config.s.n_skt;
