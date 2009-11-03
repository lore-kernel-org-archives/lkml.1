Return-Path: <linux-kernel-owner+w=401wt.eu-S1755831AbZKCE05@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755831AbZKCE05 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 23:26:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755541AbZKCE04
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 23:26:56 -0500
Received: from ozlabs.org ([203.10.76.45]:39419 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755395AbZKCE04 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 23:26:56 -0500
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
From: Rusty Russell <rusty@rustcorp.com.au>
Message-Id: <200911031456.59923.rusty@rustcorp.com.au>
Date: Tue, 3 Nov 2009 14:56:59 +1030
CC: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6/14] cpumask: use cpu_online in kernel/perf_event.c
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Also, we want to check against nr_cpu_ids, not num_possible_cpus().
The latter works, but the correct bounds check is < nr_cpu_ids.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
To: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/perf_event.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/perf_event.c b/kernel/perf_event.c
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -1596,7 +1596,7 @@ static struct perf_event_context *find_g
 		if (perf_paranoid_cpu() && !capable(CAP_SYS_ADMIN))
 			return ERR_PTR(-EACCES);
 
-		if (cpu < 0 || cpu > num_possible_cpus())
+		if (cpu < 0 || cpu >= nr_cpu_ids)
 			return ERR_PTR(-EINVAL);
 
 		/*
@@ -1604,7 +1604,7 @@ static struct perf_event_context *find_g
 		 * offline CPU and activate it when the CPU comes up, but
 		 * that's for later.
 		 */
-		if (!cpu_isset(cpu, cpu_online_map))
+		if (!cpu_online(cpu))
 			return ERR_PTR(-ENODEV);
 
 		cpuctx = &per_cpu(perf_cpu_context, cpu);

