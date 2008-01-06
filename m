Return-Path: <linux-kernel-owner+w=401wt.eu-S1754768AbYAFWD2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754768AbYAFWD2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2008 17:03:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757780AbYAFWDS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jan 2008 17:03:18 -0500
Received: from kanga.kvack.org ([66.96.29.28]:49297 "EHLO kanga.kvack.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757329AbYAFWDQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2008 17:03:16 -0500
Date: Sun, 6 Jan 2008 17:03:07 -0500
From: Benjamin LaHaise <bcrl@kvack.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: regression: sysctl_check changes in 2.6.24 are O(n) resulting in slow creation of 10000 network interfaces
Message-ID: <20080106220307.GU28570@kvack.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello folks,

2.6.24-rc6 regresses on the 10000 network interface creation test relative to 
2.6.23.  The cause appears to be the new code in sysctl_check_lookup(), which 
shows up as the #1 item while profiling.  Is a revert of this new code 
possible until its scaling issues are fixed?  2.6.23 can do more than 100 new 
network interfaces per second for the first few thousand devices, but with 
2.6.24-rc6 the results drop off rather dramatically to less than 10 interfaces 
per second.  The 10000 interface test is unbearable with the new sysctl_check 
code.

		time to creat 100 more interfaces
interfaces	v2.6.24-rc6	sysctl_check disabled
0		 0.729s		0.222s
100		 1.791s		0.223s
200		 3.966s		0.230s
300		 7.460s		0.236s
400		10.747s		0.241s
500		13.633s		0.252s

samples  %        app name                 symbol name
524598   33.4231  vmlinux                  sysctl_check_lookup
297996   18.9859  vmlinux                  cpu_idle
130263    8.2993  vmlinux                  __rcu_pending
123953    7.8973  vmlinux                  sysctl_head_next
121691    7.7532  vmlinux                  quicklist_trim
89624     5.7101  vmlinux                  strcmp
87257     5.5593  vmlinux                  rcu_pending
78475     4.9998  vmlinux                  poll_idle
43721     2.7855  vmlinux                  check_pgt_cache
34454     2.1951  vmlinux                  sysctl_parent
7494      0.4775  vmlinux                  rt_run_flush

		-ben


diff --git a/kernel/sysctl_check.c b/kernel/sysctl_check.c
index a68425a..a4468e2 100644
--- a/kernel/sysctl_check.c
+++ b/kernel/sysctl_check.c
@@ -1459,6 +1459,8 @@ static void sysctl_check_bin_path(struct ctl_table *table, const char **fail)
 int sysctl_check_table(struct ctl_table *table)
 {
 	int error = 0;
+	return 0;
+
 	for (; table->ctl_name || table->procname; table++) {
 		const char *fail = NULL;
 
