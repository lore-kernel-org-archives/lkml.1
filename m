Return-Path: <linux-kernel-owner+w=401wt.eu-S1762155AbYCSUBS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762155AbYCSUBS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 16:01:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756998AbYCSTiF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 15:38:05 -0400
Received: from mx1.redhat.com ([66.187.233.31]:55887 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756958AbYCSTh4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 15:37:56 -0400
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, tglx@linutronix.de, mingo@elte.hu, ak@suse.de,
       Glauber Costa <gcosta@redhat.com>
Subject: [PATCH 29/79] [PATCH] fill bios cpu to apicid maps
Date: Wed, 19 Mar 2008 14:25:24 -0300
Message-Id: <12059477063046-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <1205947702588-git-send-email-gcosta@redhat.com>
References: <12059475744092-git-send-email-gcosta@redhat.com> <1205947580526-git-send-email-gcosta@redhat.com> <12059475853453-git-send-email-gcosta@redhat.com> <12059475892790-git-send-email-gcosta@redhat.com> <12059475944070-git-send-email-gcosta@redhat.com> <12059475982810-git-send-email-gcosta@redhat.com> <12059476032561-git-send-email-gcosta@redhat.com> <1205947607406-git-send-email-gcosta@redhat.com> <12059476123203-git-send-email-gcosta@redhat.com> <12059476162900-git-send-email-gcosta@redhat.com> <12059476212769-git-send-email-gcosta@redhat.com> <1205947625472-git-send-email-gcosta@redhat.com> <12059476302473-git-send-email-gcosta@redhat.com> <12059476351524-git-send-email-gcosta@redhat.com> <12059476393279-git-send-email-gcosta@redhat.com> <12059476441057-git-send-email-gcosta@redhat.com> <12059476482875-git-send-email-gcosta@redhat.com> <12059476531095-git-send-email-gcosta@redhat.com> <1205947657993-git-send-email-gcosta@redhat.com> <1205947661385-git-send-email-g!
 costa@redhat.com> <12059476663034-git-send-email-gcosta@redhat.com> <12059476703608-git-send-email-gcosta@redhat.com> <1205947675605-git-send-email-gcosta@redhat.com> <12059476802159-git-send-email-gcosta@redhat.com> <12059476844196-git-send-email-gcosta@redhat.com> <12059476883852-git-send-email-gcosta@redhat.com> <12059476932397-git-send-email-gcosta@redhat.com> <12059476971309-git-send-email-gcosta@redhat.com> <1205947702588-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Glauber Costa <gcosta@redhat.com>

We fill the per-cpu (or array) that maps
bios cpu id to apicid in mpparse_32.c, the way x86_64 does

Signed-off-by: Glauber Costa <gcosta@redhat.com>
---
 arch/x86/kernel/mpparse_32.c |   11 ++++++++---
 1 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/mpparse_32.c b/arch/x86/kernel/mpparse_32.c
index c6a9789..56fb828 100644
--- a/arch/x86/kernel/mpparse_32.c
+++ b/arch/x86/kernel/mpparse_32.c
@@ -76,8 +76,6 @@ unsigned disabled_cpus __cpuinitdata;
 /* Bitmask of physically existing CPUs */
 physid_mask_t phys_cpu_present_map;
 
-u8 bios_cpu_apicid[NR_CPUS] = { [0 ... NR_CPUS-1] = BAD_APICID };
-
 /*
  * Intel MP BIOS table parsing routines:
  */
@@ -221,7 +219,14 @@ static void __cpuinit MP_processor_info (struct mpc_config_processor *m)
 			def_to_bigsmp = 1;
 		}
 	}
-	bios_cpu_apicid[num_processors - 1] = m->mpc_apicid;
+	/* are we being called early in kernel startup? */
+	if (x86_cpu_to_apicid_early_ptr) {
+		u16 *bios_cpu_apicid = x86_bios_cpu_apicid_early_ptr;
+		bios_cpu_apicid[num_processors - 1] = m->mpc_apicid;
+	} else {
+		int cpu = num_processors - 1;
+		per_cpu(x86_bios_cpu_apicid, cpu) = m->mpc_apicid;
+	}
 }
 
 static void __init MP_bus_info (struct mpc_config_bus *m)
-- 
1.5.0.6

