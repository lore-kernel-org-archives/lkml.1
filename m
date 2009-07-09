Return-Path: <linux-kernel-owner+w=401wt.eu-S1760184AbZGIL5x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760184AbZGIL5x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 07:57:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756935AbZGIL5o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 07:57:44 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:42010 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756498AbZGIL5n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 07:57:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=Abwg2xirh0rP79XPxBxO+pihaHuSkDMmj7dyZwyJjgy6Ktosd5zERgIh20tkgjIa9c
         zHy0t8H9rTLYg1J2e2J3askEZuimVarTkupUrChzUHdMa/HPOAFxn4OhP2BZlWEKGRPr
         EserC0mP54Or5V8JhkCIlsojgkTFDJKxU6aPk=
MIME-Version: 1.0
In-Reply-To: <193b0f820907080939sf0bec93n16ee4b5aca6e1a7a@mail.gmail.com>
References: <193b0f820907080848m5b72e2a9l52944ae3de785d90@mail.gmail.com> 
	<1247068556.9777.58.camel@twins> <193b0f820907080905u643e90ddi42a719e6163b0bc@mail.gmail.com> 
	<193b0f820907080939sf0bec93n16ee4b5aca6e1a7a@mail.gmail.com>
From: Lucas De Marchi <lucas.de.marchi@gmail.com>
Date: Thu, 9 Jul 2009 13:57:20 +0200
Message-ID: <193b0f820907090457s7a3662f4gcdecdc22fcae857b@mail.gmail.com>
Subject: Re: possible migration bug with hotplug cpu
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So, I found the problem.

These fields are currently not initialized upon fork. I noted that when I
updated to 2.6.31-rc2; commit 6c594c21fcb02c662f11c97be4d7d2b73060a205 was
merged into kernel by Ingo (not present yet in 2.6.30), but it only initializes
nr_migrations. Why the other fields are not initialized to 0? Even when there
are more processors, these fields may be wrong if not zeroed when a new task
is started. Below the fast way to fix it. This fixed the counters for me.

What do you think of creating a struct sched_statistics embedded into
sched_entity so we coudl memset it to zero all at once? All fields of
SCHED_STATS piece should be initialized, right?

Lucas De Marchi


diff --git a/kernel/sched.c b/kernel/sched.c
index fd3ac58..b8d75cf 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2572,15 +2572,37 @@ static void __sched_fork(struct task_struct *p)
 	p->se.avg_wakeup		= sysctl_sched_wakeup_granularity;

 #ifdef CONFIG_SCHEDSTATS
-	p->se.wait_start		= 0;
-	p->se.sum_sleep_runtime		= 0;
-	p->se.sleep_start		= 0;
-	p->se.block_start		= 0;
-	p->se.sleep_max			= 0;
-	p->se.block_max			= 0;
-	p->se.exec_max			= 0;
-	p->se.slice_max			= 0;
-	p->se.wait_max			= 0;
+	p->se.wait_start			= 0;
+	p->se.wait_max				= 0;
+	p->se.wait_count			= 0;
+	p->se.wait_sum				= 0;
+
+	p->se.sleep_start			= 0;
+	p->se.sleep_max				= 0;
+	p->se.sum_sleep_runtime			= 0;
+
+	p->se.block_start			= 0;
+	p->se.block_max				= 0;
+	p->se.exec_max				= 0;
+	p->se.slice_max				= 0;
+
+	p->se.nr_migrations_cold		= 0;
+	p->se.nr_failed_migrations_affine	= 0;
+	p->se.nr_failed_migrations_running	= 0;
+	p->se.nr_failed_migrations_hot		= 0;
+	p->se.nr_forced_migrations		= 0;
+	p->se.nr_forced2_migrations		= 0;
+
+	p->se.nr_wakeups			= 0;
+	p->se.nr_wakeups_sync			= 0;
+	p->se.nr_wakeups_migrate		= 0;
+	p->se.nr_wakeups_local			= 0;
+	p->se.nr_wakeups_remote			= 0;
+	p->se.nr_wakeups_affine			= 0;
+	p->se.nr_wakeups_affine_attempts	= 0;
+	p->se.nr_wakeups_passive		= 0;
+	p->se.nr_wakeups_idle			= 0;
+
 #endif

 	INIT_LIST_HEAD(&p->rt.run_list);
