Return-Path: <linux-kernel-owner+w=401wt.eu-S1758151AbYCNAk1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758151AbYCNAk1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 20:40:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753678AbYCNAkN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 20:40:13 -0400
Received: from qb-out-0506.google.com ([72.14.204.236]:57472 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752610AbYCNAkM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 20:40:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=sw2v3m0toUCCEqqwCfm4Fnhsbu6c1xFoscGsjkgTax0oWQYJ9UD2+VFO6J3V61FD4pTwEoVjqNjV7wySt8nD8jqkZM0PHk675ym3SkfjijuF1yWHvVUucP1AdDbW2hJwD17WihQGTEOQ164nUl3lXX+tWraJIXk7BeiWiWQuV5Q=
Message-ID: <9810cff90803131740w6a71b61dy1183956132fa89a3@mail.gmail.com>
Date: Thu, 13 Mar 2008 17:40:08 -0700
From: "Bill Huey (hui)" <bill.huey@gmail.com>
To: "Gregory Haskins" <ghaskins@novell.com>, mingo@elte.hu
Subject: Re: [PATCH RT 0/6] lockstat measurement extensions
Cc: a.p.zijlstra@chello.nl, tglx@linutronix.de, rostedt@goodmis.org,
       linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org,
       kevin@hilman.org, cminyard@mvista.com, dsingleton@mvista.com,
       dwalker@mvista.com, npiggin@suse.de, dsaxena@plexity.net, ak@suse.de,
       pavel@ucw.cz, acme@redhat.com, gregkh@suse.de, sdietrich@novell.com,
       pmorreale@novell.com, mkohari@novell.com
In-Reply-To: <9810cff90803131726m55e11b62o5cdebd078626283f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <9810cff90803131703t3626d83fq727b04242f407c13@mail.gmail.com>
	 <9810cff90803131726m55e11b62o5cdebd078626283f@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry missing the patch. At Thomas's urging, this is inlined:

--- linux-2.6.24/kernel/sched.c	2008-02-25 15:32:05.000000000 -0800
+++ linux-2.6.24.working/kernel/sched.c	2008-03-13 13:53:24.000000000 -0700
@@ -1175,6 +1175,20 @@
 	return cpu_curr(task_cpu(p)) == p;
 }

+int task_spinnable(struct task_struct *p)
+{
+/*
+ * The use of task_curr can crash the system since the struct
thread_info seems
+ * to disappear when dereferenced arbitrarily, so becareful.
+ */
+#ifdef CONFIG_SMP
+	if (p && p->se.on_rq && task_curr(p))
+		return 1;
+#else
+	return 0;
+#endif
+}
+
 /* Used instead of source_load when we know the type == 0 */
 unsigned long weighted_cpuload(const int cpu)
 {
@@ -1239,6 +1253,11 @@
 		      *new_cfsrq = cpu_cfs_rq(old_cfsrq, new_cpu);
 	u64 clock_offset;

+//--billh
+//	if (old_cpu >= NR_CPUS)
+//		panic("bogus cpu id %u\n", old_cpu);
+//
+//
 	clock_offset = old_rq->clock - new_rq->clock;

 #ifdef CONFIG_SCHEDSTATS
