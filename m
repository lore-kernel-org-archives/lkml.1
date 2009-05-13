Return-Path: <linux-kernel-owner+w=401wt.eu-S1757006AbZEMBgX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757006AbZEMBgX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 21:36:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753335AbZEMBgN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 21:36:13 -0400
Received: from hera.kernel.org ([140.211.167.34]:35329 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753296AbZEMBgM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 21:36:12 -0400
Message-ID: <4A0A23A7.4080901@kernel.org>
Date: Tue, 12 May 2009 18:34:31 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Jack Steiner <steiner@sgi.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
CC: David Rientjes <rientjes@google.com>, Andi Kleen <andi@firstfloor.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Mike Travis <travis@sgi.com>
Subject: [PATCH] x86: fix system without memory on node0
References: <4A05269D.8000701@kernel.org> <4A0527CB.4020807@kernel.org> <20090511175312.GA27905@sgi.com> <alpine.DEB.2.00.0905111218520.23739@chino.kir.corp.google.com> <4A0894A5.9000209@zytor.com> <alpine.DEB.2.00.0905111509570.2234@chino.kir.corp.google.com> <20090512150622.GA10015@sgi.com>
In-Reply-To: <20090512150622.GA10015@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Jack found that crash with doesn't have memory on node0.

it turns out with per_cpu changeset, node_number for BSP will be alway 0,
and it is consistent to cpu_to_node() that is to near node already.
aka when numa_set_node() for node0 is called early before per_cpu area is
setup

try to set the node_number for boot cpu, after we get per_cpu area setup.

[ Impact: fix crashing on memoryless node 0]

Reported-by: Jack Steiner <steiner@sgi.com>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/kernel/setup_percpu.c |    8 ++++++++
 1 file changed, 8 insertions(+)

Index: linux-2.6/arch/x86/kernel/setup_percpu.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/setup_percpu.c
+++ linux-2.6/arch/x86/kernel/setup_percpu.c
@@ -423,6 +423,14 @@ void __init setup_per_cpu_areas(void)
 	early_per_cpu_ptr(x86_cpu_to_node_map) = NULL;
 #endif
 
+#if defined(CONFIG_X86_64) && defined(CONFIG_NUMA)
+	/*
+	 * make sure boot cpu node_number is right, when boot cpu is on the
+	 * node that doesn't have mem installed
+	 */
+	per_cpu(node_number, boot_cpu_id) = cpu_to_node(boot_cpu_id);
+#endif
+
 	/* Setup node to cpumask map */
 	setup_node_to_cpumask_map();
 
