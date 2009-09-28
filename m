Return-Path: <linux-kernel-owner+w=401wt.eu-S1752539AbZI1QUI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752539AbZI1QUI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Sep 2009 12:20:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751302AbZI1QUH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Sep 2009 12:20:07 -0400
Received: from hera.kernel.org ([140.211.167.34]:58019 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752513AbZI1QUG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Sep 2009 12:20:06 -0400
Message-ID: <4AC0E201.2020006@kernel.org>
Date: Tue, 29 Sep 2009 01:19:13 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: Tony Vroon <tony@linx.net>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Christoph Lameter <cl@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH] percpu: fix unit_map[] verification in pcpu_setup_first_chunk()
References: <4ABAC2F1.3020302@kernel.org> <1254055797.2756.1.camel@localhost>
In-Reply-To: <1254055797.2756.1.camel@localhost>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 28 Sep 2009 16:19:17 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pcpu_setup_first_chunk() incorrectly used NR_CPUS as the impossible
unit number while unit number can equal and go over NR_CPUS with
sparse unit map.  This triggers BUG_ON() spuriously on machines which
have non-power-of-two number of cpus.  Use UINT_MAX instead.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Tony Vroon <tony@linx.net>
---
Erghh... stupid mistake.  This should fix it.  Can you please verify?

Thanks.

 mm/percpu.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

Index: work/mm/percpu.c
===================================================================
--- work.orig/mm/percpu.c
+++ work/mm/percpu.c
@@ -1604,7 +1604,7 @@ int __init pcpu_setup_first_chunk(const
 	unit_off = alloc_bootmem(nr_cpu_ids * sizeof(unit_off[0]));

 	for (cpu = 0; cpu < nr_cpu_ids; cpu++)
-		unit_map[cpu] = NR_CPUS;
+		unit_map[cpu] = UINT_MAX;
 	pcpu_first_unit_cpu = NR_CPUS;

 	for (group = 0, unit = 0; group < ai->nr_groups; group++, unit += i) {
@@ -1619,7 +1619,7 @@ int __init pcpu_setup_first_chunk(const
 				continue;

 			BUG_ON(cpu > nr_cpu_ids || !cpu_possible(cpu));
-			BUG_ON(unit_map[cpu] != NR_CPUS);
+			BUG_ON(unit_map[cpu] != UINT_MAX);

 			unit_map[cpu] = unit + i;
 			unit_off[cpu] = gi->base_offset + i * ai->unit_size;
@@ -1632,7 +1632,7 @@ int __init pcpu_setup_first_chunk(const
 	pcpu_nr_units = unit;

 	for_each_possible_cpu(cpu)
-		BUG_ON(unit_map[cpu] == NR_CPUS);
+		BUG_ON(unit_map[cpu] == UINT_MAX);

 	pcpu_nr_groups = ai->nr_groups;
 	pcpu_group_offsets = group_offsets;
