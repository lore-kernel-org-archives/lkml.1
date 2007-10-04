Return-Path: <linux-kernel-owner+w=401wt.eu-S1762243AbXJDWC0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762243AbXJDWC0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 18:02:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759161AbXJDWCS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 18:02:18 -0400
Received: from mx1.redhat.com ([66.187.233.31]:45992 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758792AbXJDWCR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 18:02:17 -0400
Message-ID: <470562B9.6060200@redhat.com>
Date: Thu, 04 Oct 2007 18:01:29 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: Christian Borntraeger <borntraeger@de.ibm.com>
CC: Luca Tettamanti <kronos.it@gmail.com>, Frans Pop <elendil@planet.nl>,
       Willy Tarreau <w@1wt.eu>, LKML <linux-kernel@vger.kernel.org>,
       =?ISO-8859-1?Q?Ilpo_J=E4rvinen?= <ilpo.jarvinen@helsinki.fi>,
       "Alexander E. Patrakov" <patrakov@ums.usu.ru>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH for testing] Re: Decreasing stime running confuses top
References: <200710031433.34504.elendil@planet.nl> <200710042200.03489.borntraeger@de.ibm.com> <47054B2E.1050906@redhat.com> <200710042310.25223.borntraeger@de.ibm.com>
In-Reply-To: <200710042310.25223.borntraeger@de.ibm.com>
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/04/2007 05:10 PM, Christian Borntraeger wrote:

> <patch reverting to 2.6.22 behavior>

Alternative patch:

procfs: Don't read runtime twice when computing task's stime

Current code reads p->se.sum_exec_runtime twice and goes through
multiple type conversions to calculate stime. Read it once and
skip some of the conversions.

Signed-off-by: Chuck Ebbert <cebbert@redhat.com>

--- linux-2.6.23-rc6-dell.orig/fs/proc/array.c
+++ linux-2.6.23-rc6-dell/fs/proc/array.c
@@ -334,39 +334,38 @@ static cputime_t task_stime(struct task_
 	return p->stime;
 }
 #else
-static cputime_t task_utime(struct task_struct *p)
+static clock_t __task_utime(struct task_struct *p, u64 runtime)
 {
 	clock_t utime = cputime_to_clock_t(p->utime),
 		total = utime + cputime_to_clock_t(p->stime);
-	u64 temp;
 
 	/*
 	 * Use CFS's precise accounting:
 	 */
-	temp = (u64)nsec_to_clock_t(p->se.sum_exec_runtime);
-
 	if (total) {
-		temp *= utime;
-		do_div(temp, total);
+		runtime *= utime;
+		do_div(runtime, total);
 	}
-	utime = (clock_t)temp;
+	return (clock_t)runtime;
+}
 
-	return clock_t_to_cputime(utime);
+static cputime_t task_utime(struct task_struct *p)
+{
+	u64 runtime = (u64)nsec_to_clock_t(p->se.sum_exec_runtime);
+
+	return clock_t_to_cputime(__task_utime(p, runtime));
 }
 
 static cputime_t task_stime(struct task_struct *p)
 {
-	clock_t stime;
+	u64 runtime = (u64)nsec_to_clock_t(p->se.sum_exec_runtime);
 
 	/*
 	 * Use CFS's precise accounting. (we subtract utime from
 	 * the total, to make sure the total observed by userspace
 	 * grows monotonically - apps rely on that):
 	 */
-	stime = nsec_to_clock_t(p->se.sum_exec_runtime) -
-			cputime_to_clock_t(task_utime(p));
-
-	return clock_t_to_cputime(stime);
+	return clock_t_to_cputime(runtime - __task_utime(p, runtime));
 }
 #endif
 

