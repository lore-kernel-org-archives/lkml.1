Return-Path: <linux-kernel-owner+w=401wt.eu-S1761476AbYGJSJZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761476AbYGJSJZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 14:09:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761410AbYGJSJF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 14:09:05 -0400
Received: from perninha.conectiva.com.br ([200.140.247.100]:42374 "EHLO
	perninha.conectiva.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761406AbYGJSJE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 14:09:04 -0400
Date: Thu, 10 Jul 2008 15:08:41 -0300
From: "Luiz Fernando N. Capitulino" <lcapitulino@mandriva.com.br>
To: Roman Mindalev <lists@r000n.net>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: [Bug #11035] System hangs on 2.6.26-rc8
Message-ID: <20080710150841.139c2a71@doriath.conectiva>
In-Reply-To: <487600B3.2010008@r000n.net>
References: <Vu1KV8Wj_GP.A.qW.DzLcIB@albercik>
	<uBi7uNfg81L.A.xt.SzLcIB@albercik>
	<487600B3.2010008@r000n.net>
Organization: Mandriva
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.13.4; i586-mandriva-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="MP_/FxRWw45TbWmoKPpf4pmqQzB"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--MP_/FxRWw45TbWmoKPpf4pmqQzB
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Em Thu, 10 Jul 2008 16:29:39 +0400
Roman Mindalev <lists@r000n.net> escreveu:

| Rafael J. Wysocki wrote:
| > This message has been generated automatically as a part of a report
| > of recent regressions.
| > 
| > The following bug entry is on the current list of known regressions
| > from 2.6.25.  Please verify if it still should be listed.
| > 
| > 
| > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11035
| > Subject		: System hangs on 2.6.26-rc8
| > Submitter	: Roman Mindalev <lists@r000n.net>
| > Date		: 2008-07-02 14:25 (5 days old)
| > References	: http://marc.info/?l=linux-kernel&m=121500871414995&w=4
| > 
| > 
| > 
| I have this problem with 2.6.25 too.
| Unfortunately, I can't check 2.6.24. With config from 2.6.26-rc8 I got
| error of compiling:
| 
|   LD      .tmp_vmlinux1
| kernel/built-in.o: In function `timespec_add_ns':
| /usr/src/kernels/linux-2.6.24/include/linux/time.h:179: undefined
| reference to `__umoddi3'

 [...]

 You're trying to compile with gcc 4.3, right? You can try the
attached fix or the following cherry-pick if you're compiling
from a git tree:

$ git cherry-pick 38332cb98772f5ea757e6486bed7ed0381cb5f98

 But I can't tell whether the compiler and/or the fix will
change the behaivor of the bug you're reporting.

-- 
Luiz Fernando N. Capitulino

--MP_/FxRWw45TbWmoKPpf4pmqQzB
Content-Type: text/x-patch; name=time.patch
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=time.patch

commit 38332cb98772f5ea757e6486bed7ed0381cb5f98
Author: Segher Boessenkool <segher@kernel.crashing.org>
Date:   Tue Mar 4 14:59:54 2008 -0800

    time: prevent the loop in timespec_add_ns() from being optimised away
    
    Since some architectures don't support __udivdi3().
    
    Signed-off-by: Segher Boessenkool <segher@kernel.crashing.org>
    Cc: john stultz <johnstul@us.ibm.com>
    Cc: Ingo Molnar <mingo@elte.hu>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

diff --git a/include/linux/time.h b/include/linux/time.h
index 2091a19..d32ef0a 100644
--- a/include/linux/time.h
+++ b/include/linux/time.h
@@ -174,6 +174,10 @@ static inline void timespec_add_ns(struct timespec *a, u64 ns)
 {
 	ns += a->tv_nsec;
 	while(unlikely(ns >= NSEC_PER_SEC)) {
+		/* The following asm() prevents the compiler from
+		 * optimising this loop into a modulo operation.  */
+		asm("" : "+r"(ns));
+
 		ns -= NSEC_PER_SEC;
 		a->tv_sec++;
 	}

--MP_/FxRWw45TbWmoKPpf4pmqQzB--
