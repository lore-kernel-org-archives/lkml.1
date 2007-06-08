Return-Path: <linux-kernel-owner+w=401wt.eu-S938503AbXFHHma@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938503AbXFHHma (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 03:42:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967787AbXFHHYc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 03:24:32 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:55206 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S938334AbXFHHYb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 03:24:31 -0400
Message-Id: <20070608072219.380820000@sous-sol.org>
References: <20070608072127.352723000@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Fri, 08 Jun 2007 00:22:00 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org,
       torvalds@linux-foundation.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Andi Kleen <ak@suse.de>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 33/54] x86: fix oprofile double free
Content-Disposition: inline; filename=x86-fix-oprofile-double-free.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Chris Wright <chrisw@sous-sol.org>

Chuck reports that the recent fix from Andi to oprofile
6c977aad03a18019015035958c65b6729cd0574c introduces a double free.  Each
cpu's cpu_msrs is setup to point to cpu 0's, which causes free_msrs to free
cpu 0's pointers for_each_possible_cpu.  Rather than copy the pointers, do
a deep copy instead.

[acme@redhat.com: allocate_msrs() was using for_each_online_cpu()]
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Cc: Andi Kleen <ak@suse.de>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Dave Jones <davej@redhat.com>
Cc: Chuck Ebbert <cebbert@redhat.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---

 arch/i386/oprofile/nmi_int.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

--- linux-2.6.21.4.orig/arch/i386/oprofile/nmi_int.c
+++ linux-2.6.21.4/arch/i386/oprofile/nmi_int.c
@@ -154,7 +154,7 @@ static int allocate_msrs(void)
 	size_t counters_size = sizeof(struct op_msr) * model->num_counters;
 
 	int i;
-	for_each_online_cpu(i) {
+	for_each_possible_cpu(i) {
 		cpu_msrs[i].counters = kmalloc(counters_size, GFP_KERNEL);
 		if (!cpu_msrs[i].counters) {
 			success = 0;
@@ -211,8 +211,14 @@ static int nmi_setup(void)
 	/* Assume saved/restored counters are the same on all CPUs */
 	model->fill_in_addresses(&cpu_msrs[0]);
 	for_each_possible_cpu (cpu) {
-		if (cpu != 0)
-			cpu_msrs[cpu] = cpu_msrs[0];
+		if (cpu != 0) {
+			memcpy(cpu_msrs[cpu].counters, cpu_msrs[0].counters,
+				sizeof(struct op_msr) * model->num_counters);
+
+			memcpy(cpu_msrs[cpu].controls, cpu_msrs[0].controls,
+				sizeof(struct op_msr) * model->num_controls);
+		}
+
 	}
 	on_each_cpu(nmi_save_registers, NULL, 0, 1);
 	on_each_cpu(nmi_cpu_setup, NULL, 0, 1);

-- 
