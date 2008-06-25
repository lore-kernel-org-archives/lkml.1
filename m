Return-Path: <linux-kernel-owner+w=401wt.eu-S1758073AbYFYEnm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758073AbYFYEnm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 00:43:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756123AbYFYEhc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 00:37:32 -0400
Received: from 9.sub-70-198-159.myvzw.com ([70.198.159.9]:37463 "EHLO
	mail.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755205AbYFYEhV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 00:37:21 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 05 of 36] x86_64: use write_gdt_entry in vsyscall_set_cpu
X-Mercurial-Node: 4969ab69fb2d847d394b962b3c3b7a57876e8a91
Message-Id: <4969ab69fb2d847d394b.1214367541@localhost>
In-Reply-To: <patchbomb.1214367536@localhost>
Date: Wed, 25 Jun 2008 00:19:01 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
       xen-devel <xen-devel@lists.xensource.com>,
       Stephen Tweedie <sct@redhat.com>, Eduardo Habkost <ehabkost@redhat.com>,
       Mark McLoughlin <markmc@redhat.com>, x86@kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use write_gdt_entry to generate the special vgetcpu descriptor in the
vsyscall page.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/kernel/vsyscall_64.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/vsyscall_64.c b/arch/x86/kernel/vsyscall_64.c
--- a/arch/x86/kernel/vsyscall_64.c
+++ b/arch/x86/kernel/vsyscall_64.c
@@ -250,7 +250,7 @@
    doesn't violate that. We'll find out if it does. */
 static void __cpuinit vsyscall_set_cpu(int cpu)
 {
-	unsigned long *d;
+	unsigned long d;
 	unsigned long node = 0;
 #ifdef CONFIG_NUMA
 	node = cpu_to_node(cpu);
@@ -261,11 +261,11 @@
 	/* Store cpu number in limit so that it can be loaded quickly
 	   in user space in vgetcpu.
 	   12 bits for the CPU and 8 bits for the node. */
-	d = (unsigned long *)(get_cpu_gdt_table(cpu) + GDT_ENTRY_PER_CPU);
-	*d = 0x0f40000000000ULL;
-	*d |= cpu;
-	*d |= (node & 0xf) << 12;
-	*d |= (node >> 4) << 48;
+	d = 0x0f40000000000ULL;
+	d |= cpu;
+	d |= (node & 0xf) << 12;
+	d |= (node >> 4) << 48;
+	write_gdt_entry(get_cpu_gdt_table(cpu), GDT_ENTRY_PER_CPU, &d, DESCTYPE_S);
 }
 
 static void __cpuinit cpu_vsyscall_init(void *arg)


