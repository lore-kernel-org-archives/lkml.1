Return-Path: <linux-kernel-owner+w=401wt.eu-S1755626Ab0A0AB2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755626Ab0A0AB2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 19:01:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754213Ab0A0ABX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 19:01:23 -0500
Received: from kroah.org ([198.145.64.141]:35169 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754061Ab0AZXnV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 18:43:21 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jan 26 15:39:24 2010
Message-Id: <20100126233924.543880691@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 26 Jan 2010 15:33:54 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Rusty Russell <rusty@rustcorp.com.au>, peterz@infradead.org,
       Ingo Molnar <mingo@elte.hu>
Subject: [28/98] sched: Fix isolcpus boot option
In-Reply-To: <20100126233950.GA5372@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Rusty Russell <rusty@rustcorp.com.au>

commit bdddd2963c0264c56f18043f6fa829d3c1d3d1c0 upstream.

Anton Blanchard wrote:

> We allocate and zero cpu_isolated_map after the isolcpus
> __setup option has run. This means cpu_isolated_map always
> ends up empty and if CPUMASK_OFFSTACK is enabled we write to a
> cpumask that hasn't been allocated.

I introduced this regression in 49557e620339cb13 (sched: Fix
boot crash by zalloc()ing most of the cpu masks).

Use the bootmem allocator if they set isolcpus=, otherwise
allocate and zero like normal.

Reported-by: Anton Blanchard <anton@samba.org>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Cc: peterz@infradead.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: <stable@kernel.org>
LKML-Reference: <200912021409.17013.rusty@rustcorp.com.au>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Tested-by: Anton Blanchard <anton@samba.org>

---
 kernel/sched.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -8061,6 +8061,7 @@ static cpumask_var_t cpu_isolated_map;
 /* Setup the mask of cpus configured for isolated domains */
 static int __init isolated_cpu_setup(char *str)
 {
+	alloc_bootmem_cpumask_var(&cpu_isolated_map);
 	cpulist_parse(str, cpu_isolated_map);
 	return 1;
 }
@@ -9591,7 +9592,9 @@ void __init sched_init(void)
 	zalloc_cpumask_var(&nohz.cpu_mask, GFP_NOWAIT);
 	alloc_cpumask_var(&nohz.ilb_grp_nohz_mask, GFP_NOWAIT);
 #endif
-	zalloc_cpumask_var(&cpu_isolated_map, GFP_NOWAIT);
+	/* May be allocated at isolcpus cmdline parse time */
+	if (cpu_isolated_map == NULL)
+		zalloc_cpumask_var(&cpu_isolated_map, GFP_NOWAIT);
 #endif /* SMP */
 
 	perf_event_init();


