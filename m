Return-Path: <linux-kernel-owner+w=401wt.eu-S1761379AbYEEVqc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761379AbYEEVqc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 17:46:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757908AbYEEVqY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 17:46:24 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:39430 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755386AbYEEVqX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 17:46:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=CNhWr18iJLJ234f6vwxIhCil2ptJyTyt1sGMUY1DDnw8DijDeJVuYU/xH6yoL5+8taWmQf453SkzSncPD+l/QNTVho5xEQ3ULw7DOKG2yEZ8bI46ztG1EMdyun2HOatn4ZvgC23hU5rmrKxfXjPGZIE8u2OCxGYNcLIQzFo1yeg=
Subject: [PATCH, minor] sched: check for SD_SERIALIZE atomically in
	rebalance_domains()
From: Dmitry Adamushko <dmitry.adamushko@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, dmitry.adamushko@gmail.com
Content-Type: text/plain
Date: Mon, 05 May 2008 23:46:19 +0200
Message-Id: <1210023979.6220.9.camel@earth>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Nothing really serious here, mainly just a matter of nit-picking :-/


From: Dmitry Adamushko <dmitry.adamushko@gmail.com>
Subject: sched: check for SD_SERIALIZE atomically in rebalance_domains()
    
For CONFIG_SCHED_DEBUG && CONFIG_SYSCT configs, sd->flags can be altered
while being manipulated in rebalance_domains(). Let's do an atomic check.
We rely here on the atomicity of read/write accesses for aligned words.

Signed-off-by: Dmitry Adamushko <dmitry.adamushko@gmail.com>

---

diff --git a/kernel/sched.c b/kernel/sched.c
index 4a378bc..e106e61 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -4153,6 +4153,7 @@ static void rebalance_domains(int cpu, enum cpu_idle_type idle)
 	/* Earliest time when we have to do rebalance again */
 	unsigned long next_balance = jiffies + 60*HZ;
 	int update_next_balance = 0;
+	int need_serialize;
 	cpumask_t tmp;
 
 	for_each_domain(cpu, sd) {
@@ -4170,8 +4171,9 @@ static void rebalance_domains(int cpu, enum cpu_idle_type idle)
 		if (interval > HZ*NR_CPUS/10)
 			interval = HZ*NR_CPUS/10;
 
+		need_serialize = sd->flags & SD_SERIALIZE;
 
-		if (sd->flags & SD_SERIALIZE) {
+		if (need_serialize) {
 			if (!spin_trylock(&balancing))
 				goto out;
 		}
@@ -4187,7 +4189,7 @@ static void rebalance_domains(int cpu, enum cpu_idle_type idle)
 			}
 			sd->last_balance = jiffies;
 		}
-		if (sd->flags & SD_SERIALIZE)
+		if (need_serialize)
 			spin_unlock(&balancing);
 out:
 		if (time_after(next_balance, sd->last_balance + interval)) {


