Return-Path: <linux-kernel-owner+w=401wt.eu-S1758216AbYAFQGA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758216AbYAFQGA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2008 11:06:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752951AbYAFQFw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jan 2008 11:05:52 -0500
Received: from mgw1.diku.dk ([130.225.96.91]:54273 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752769AbYAFQFv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2008 11:05:51 -0500
Date: Sun, 6 Jan 2008 17:05:48 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: davej@codemonkey.org.uk, cpufreq@lists.linux.org.uk,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH] drivers/cpufreq: Add calls to cpufreq_cpu_put
Message-ID: <Pine.LNX.4.64.0801061704500.24950@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

A call to cpufreq_cpu_get should be matched by a call to cpufreq_cpu_put.


The problem was fixed using the following semantic patch.
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@@
type T;
identifier E;
expression E1, E2;
int ret;
statement S;
@@

  T E;
  ... when any
(
  E = cpufreq_cpu_get(...);
  if (E == NULL) S
|
  if ((E = cpufreq_cpu_get(...)) == NULL) S
)
  ... when != E2 = E
      when strict
(
  cpufreq_cpu_put(E);
|
  E1 = E;
|
+ cpufreq_cpu_put(E);
  return;
|
+ cpufreq_cpu_put(E);
  return ret;
)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
---

diff -u -p a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
--- a/drivers/cpufreq/cpufreq.c 2008-01-06 11:51:40.000000000 +0100
+++ b/drivers/cpufreq/cpufreq.c 2008-01-06 12:01:47.000000000 +0100
@@ -649,8 +649,10 @@ static ssize_t show(struct kobject * kob
 	if (!policy)
 		return -EINVAL;
 
-	if (lock_policy_rwsem_read(policy->cpu) < 0)
+	if (lock_policy_rwsem_read(policy->cpu) < 0) {
+		cpufreq_cpu_put(policy);
 		return -EINVAL;
+	}
 
 	if (fattr->show)
 		ret = fattr->show(policy, buf);
@@ -673,8 +675,10 @@ static ssize_t store(struct kobject * ko
 	if (!policy)
 		return -EINVAL;
 
-	if (lock_policy_rwsem_write(policy->cpu) < 0)
+	if (lock_policy_rwsem_write(policy->cpu) < 0) {
+		cpufreq_cpu_put(policy);
 		return -EINVAL;
+	}
 
 	if (fattr->store)
 		ret = fattr->store(policy, buf, count);
