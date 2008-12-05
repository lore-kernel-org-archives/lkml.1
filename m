Return-Path: <linux-kernel-owner+w=401wt.eu-S1756389AbYLEReb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756389AbYLEReb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2008 12:34:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752920AbYLEReY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Dec 2008 12:34:24 -0500
Received: from gw1.cosmosbay.com ([86.65.150.130]:38667 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751846AbYLEReX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2008 12:34:23 -0500
Message-ID: <493965F8.6060407@cosmosbay.com>
Date: Fri, 05 Dec 2008 18:33:44 +0100
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 2.0.0.18 (Windows/20081105)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux kernel <linux-kernel@vger.kernel.org>
Subject: [PACH] smp: uninline num_online_cpus() & num_possible_cpus()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Fri, 05 Dec 2008 18:33:45 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

num_online_cpus() and num_possible_cpus() are not performance
critical and are quite large.

Unlining them shrinks kernel text size by 7523 bytes on x86,
if NR_CPUS>32

Signed-off-by: Eric Dumazet <dada1@cosmosbay.com>
---
 include/linux/cpumask.h |    4 ++--
 init/main.c             |   12 ++++++++++++
 2 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/include/linux/cpumask.h b/include/linux/cpumask.h
index 21e1dd4..f9b2b51 100644
--- a/include/linux/cpumask.h
+++ b/include/linux/cpumask.h
@@ -507,8 +507,8 @@ extern cpumask_t cpu_present_map;
 extern cpumask_t cpu_active_map;
 
 #if NR_CPUS > 1
-#define num_online_cpus()	cpus_weight_nr(cpu_online_map)
-#define num_possible_cpus()	cpus_weight_nr(cpu_possible_map)
+extern int num_online_cpus(void);
+extern int num_possible_cpus(void);
 #define num_present_cpus()	cpus_weight_nr(cpu_present_map)
 #define cpu_online(cpu)		cpu_isset((cpu), cpu_online_map)
 #define cpu_possible(cpu)	cpu_isset((cpu), cpu_possible_map)
diff --git a/init/main.c b/init/main.c
index 7e117a2..a1a3e55 100644
--- a/init/main.c
+++ b/init/main.c
@@ -376,6 +376,18 @@ EXPORT_SYMBOL(cpu_mask_all);
 int nr_cpu_ids __read_mostly = NR_CPUS;
 EXPORT_SYMBOL(nr_cpu_ids);
 
+int num_online_cpus(void)
+{
+	return cpus_weight_nr(cpu_online_map);
+}
+EXPORT_SYMBOL(num_online_cpus);
+
+int num_possible_cpus(void)
+{
+	return cpus_weight_nr(cpu_possible_map);
+}
+EXPORT_SYMBOL(num_possible_cpus);
+
 /* An arch may set nr_cpu_ids earlier if needed, so this would be redundant */
 static void __init setup_nr_cpu_ids(void)
 {
