Return-Path: <linux-kernel-owner+w=401wt.eu-S1754068AbZEDSkZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754068AbZEDSkZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 14:40:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752015AbZEDSkH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 14:40:07 -0400
Received: from hera.kernel.org ([140.211.167.34]:42287 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752013AbZEDSkG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 14:40:06 -0400
Date: Mon, 4 May 2009 18:39:34 GMT
From: tip-bot for Andreas Herrmann <andreas.herrmann3@amd.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       rusty@rustcorp.com.au, andreas.herrmann3@amd.com, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       andreas.herrmann3@amd.com, rusty@rustcorp.com.au, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <20090504182859.GA29045@alberich.amd.com>
References: <20090504182859.GA29045@alberich.amd.com>
Subject: [tip:x86/urgent] x86: show number of core_siblings instead of thread_siblings in /proc/cpuinfo
Message-ID: <tip-35d11680a9d82c93eb92f08f9702b72877427b4a@git.kernel.org>
Git-Commit-ID: 35d11680a9d82c93eb92f08f9702b72877427b4a
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 04 May 2009 18:39:36 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  35d11680a9d82c93eb92f08f9702b72877427b4a
Gitweb:     http://git.kernel.org/tip/35d11680a9d82c93eb92f08f9702b72877427b4a
Author:     Andreas Herrmann <andreas.herrmann3@amd.com>
AuthorDate: Mon, 4 May 2009 20:28:59 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 4 May 2009 20:36:49 +0200

x86: show number of core_siblings instead of thread_siblings in /proc/cpuinfo

Commit 7ad728f98162cb1af06a85b2a5fc422dddd4fb78
(cpumask: x86: convert cpu_sibling_map/cpu_core_map to cpumask_var_t)
changed the output of /proc/cpuinfo for siblings:

Example on an AMD Phenom:

  physical id   : 0
  siblings : 1
  core id	   : 3
  cpu cores  : 4

Before that commit it was:

  physical id	: 0
  siblings : 4
  core id	   : 3
  cpu cores  : 4

Instead of cpu_core_mask it now uses cpu_sibling_mask to count siblings.
This is due to the following hunk of above commit:

|  --- a/arch/x86/kernel/cpu/proc.c
|  +++ b/arch/x86/kernel/cpu/proc.c
|  @@ -14,7 +14,7 @@ static void show_cpuinfo_core(struct seq_file *m, struct cpuinf
|          if (c->x86_max_cores * smp_num_siblings > 1) {
|                  seq_printf(m, "physical id\t: %d\n", c->phys_proc_id);
|                  seq_printf(m, "siblings\t: %d\n",
|  -                          cpus_weight(per_cpu(cpu_core_map, cpu)));
|  +                          cpumask_weight(cpu_sibling_mask(cpu)));
|                  seq_printf(m, "core id\t\t: %d\n", c->cpu_core_id);
|                  seq_printf(m, "cpu cores\t: %d\n", c->booted_cores);
|                  seq_printf(m, "apicid\t\t: %d\n", c->apicid);

This was a mistake, because the impact line shows that this side-effect
was not anticipated:

   Impact: reduce per-cpu size for CONFIG_CPUMASK_OFFSTACK=y

So revert the respective hunk to restore the old behavior.

[ Impact: fix sibling-info regression in /proc/cpuinfo ]

Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
LKML-Reference: <20090504182859.GA29045@alberich.amd.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/cpu/proc.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/cpu/proc.c b/arch/x86/kernel/cpu/proc.c
index f93047f..d5e3039 100644
--- a/arch/x86/kernel/cpu/proc.c
+++ b/arch/x86/kernel/cpu/proc.c
@@ -14,7 +14,7 @@ static void show_cpuinfo_core(struct seq_file *m, struct cpuinfo_x86 *c,
 	if (c->x86_max_cores * smp_num_siblings > 1) {
 		seq_printf(m, "physical id\t: %d\n", c->phys_proc_id);
 		seq_printf(m, "siblings\t: %d\n",
-			   cpumask_weight(cpu_sibling_mask(cpu)));
+			   cpumask_weight(cpu_core_mask(cpu)));
 		seq_printf(m, "core id\t\t: %d\n", c->cpu_core_id);
 		seq_printf(m, "cpu cores\t: %d\n", c->booted_cores);
 		seq_printf(m, "apicid\t\t: %d\n", c->apicid);
