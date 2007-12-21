Return-Path: <linux-kernel-owner+w=401wt.eu-S1758490AbXLULD4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758490AbXLULD4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2007 06:03:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752847AbXLULDt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Dec 2007 06:03:49 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:56591 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751286AbXLULDs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2007 06:03:48 -0500
Date: Fri, 21 Dec 2007 12:03:37 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Meelis Roos <mroos@linux.ee>
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: Warnings from sched_debug.c
Message-ID: <20071221110336.GB29047@elte.hu>
References: <Pine.SOC.4.64.0712211217170.16480@math.ut.ee>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.SOC.4.64.0712211217170.16480@math.ut.ee>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Meelis Roos <mroos@linux.ee> wrote:

> This happens on sparc64 with 2.6.24-rc6 (gcc-4.2):
> 
>   CC      kernel/sched.o
> In file included from kernel/sched.c:879:
> kernel/sched_debug.c: In function 'nsec_high':
> kernel/sched_debug.c:38: warning: comparison of distinct pointer types lacks a cast
> kernel/sched_debug.c:41: warning: comparison of distinct pointer types lacks a cast
> kernel/sched_debug.c: In function 'nsec_low':
> kernel/sched_debug.c:51: warning: comparison of distinct pointer types lacks a cast

it should be harmless. Does the patch below fix the warnings?

	Ingo

-------------->
Subject: sched: fix gcc warnings
From: Ingo Molnar <mingo@elte.hu>

Meelis Roos reported these warnings on sparc64:

  CC      kernel/sched.o
  In file included from kernel/sched.c:879:
  kernel/sched_debug.c: In function 'nsec_high':
  kernel/sched_debug.c:38: warning: comparison of distinct pointer types lacks a cast

the debug check in do_div() is over-eager here, because the long long
is always positive in these places. Mark this by casting them to
unsigned long long.

no change in code output:

   text    data     bss     dec     hex filename
  51471    6582     376   58429    e43d sched.o.before
  51471    6582     376   58429    e43d sched.o.after

  md5:
   7f7729c111f185bf3ccea4d542abc049  sched.o.before.asm
   7f7729c111f185bf3ccea4d542abc049  sched.o.after.asm

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched_debug.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

Index: linux/kernel/sched_debug.c
===================================================================
--- linux.orig/kernel/sched_debug.c
+++ linux/kernel/sched_debug.c
@@ -31,9 +31,9 @@
 /*
  * Ease the printing of nsec fields:
  */
-static long long nsec_high(long long nsec)
+static long long nsec_high(unsigned long long nsec)
 {
-	if (nsec < 0) {
+	if ((long long)nsec < 0) {
 		nsec = -nsec;
 		do_div(nsec, 1000000);
 		return -nsec;
@@ -43,9 +43,9 @@ static long long nsec_high(long long nse
 	return nsec;
 }
 
-static unsigned long nsec_low(long long nsec)
+static unsigned long nsec_low(unsigned long long nsec)
 {
-	if (nsec < 0)
+	if ((long long)nsec < 0)
 		nsec = -nsec;
 
 	return do_div(nsec, 1000000);
