Return-Path: <linux-kernel-owner+w=401wt.eu-S933360AbZHVUXU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933360AbZHVUXU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Aug 2009 16:23:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933333AbZHVUXT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Aug 2009 16:23:19 -0400
Received: from mtagate2.de.ibm.com ([195.212.17.162]:57485 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933300AbZHVUXS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Aug 2009 16:23:18 -0400
Date: Sat, 22 Aug 2009 22:23:13 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: dwalker@fifo99.com, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, johnstul@us.ibm.com, tglx@linutronix.de,
       linux-tip-commits@vger.kernel.org
Subject: Re: [tip:timers/core] timekeeping: Increase granularity of
 read_persistent_clock()
Message-ID: <20090822222313.74b9619c@skybase>
In-Reply-To: <20090822153346.GA3313@elte.hu>
References: <20090814134811.013873340@de.ibm.com>
	<tip-d4f587c67fc39e0030ddd718675e252e208da4d7@git.kernel.org>
	<20090822103252.GA32369@elte.hu>
	<20090822171540.1220f50d@skybase>
	<20090822153346.GA3313@elte.hu>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.16.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 22 Aug 2009 17:33:46 +0200
Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Martin Schwidefsky <schwidefsky@de.ibm.com> wrote:
> 
> > > FYI, -tip arch-testing found that this commit broke the PowerPC 
> > > build:
> > > 
> > > /home/mingo/tip/arch/powerpc/kernel/time.c: In function 'read_persistent_clock':
> > > /home/mingo/tip/arch/powerpc/kernel/time.c:788: error: 'return' with a value, in function returning void
> > > /home/mingo/tip/arch/powerpc/kernel/time.c:791: error: 'return' with a value, in function returning void
> > > make[2]: *** [arch/powerpc/kernel/time.o] Error 1
> > > make[2]: *** Waiting for unfinished jobs....
> > > make[1]: *** [arch/powerpc/kernel] Error 2
> > 
> > I overlooked a case in the powerpc version of read_persistent_lock.
> > New patch:
> 
> the patches are already committed and this patch doesnt apply - mind 
> sending a delta fix against tip:master:
> 
>  http://people.redhat.com/mingo/tip.git/README

Here we go:

--
Subject: [PATCH] powerpc: build fix for read_persistent_clock

From: Martin Schwidefsky <schwidefsky@de.ibm.com>

Fix the following build problem on powerpc:

arch/powerpc/kernel/time.c: In function 'read_persistent_clock':
arch/powerpc/kernel/time.c:788: error: 'return' with a value, in function returning void
arch/powerpc/kernel/time.c:791: error: 'return' with a value, in function returning void
make[2]: *** [arch/powerpc/kernel/time.o] Error 1
make[2]: *** Waiting for unfinished jobs....
make[1]: *** [arch/powerpc/kernel] Error 2  

Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---
 arch/powerpc/kernel/time.c |   14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

Index: linux-2.6/arch/powerpc/kernel/time.c
===================================================================
--- linux-2.6.orig/arch/powerpc/kernel/time.c
+++ linux-2.6/arch/powerpc/kernel/time.c
@@ -774,6 +774,7 @@ void read_persistent_clock(struct timesp
 	struct rtc_time tm;
 	static int first = 1;
 
+	ts->tv_nsec = 0;
 	/* XXX this is a litle fragile but will work okay in the short term */
 	if (first) {
 		first = 0;
@@ -781,15 +782,18 @@ void read_persistent_clock(struct timesp
 			timezone_offset = ppc_md.time_init();
 
 		/* get_boot_time() isn't guaranteed to be safe to call late */
-		if (ppc_md.get_boot_time)
-			return ppc_md.get_boot_time() -timezone_offset;
+		if (ppc_md.get_boot_time) {
+			ts->tv_sec = ppc_md.get_boot_time() -timezone_offset;
+			return;
+		}
+	}
+	if (!ppc_md.get_rtc_time) {
+		ts->tv_sec = 0;
+		return;
 	}
-	if (!ppc_md.get_rtc_time)
-		return 0;
 	ppc_md.get_rtc_time(&tm);
 	ts->tv_sec = mktime(tm.tm_year+1900, tm.tm_mon+1, tm.tm_mday,
 			    tm.tm_hour, tm.tm_min, tm.tm_sec);
-	ts->tv_nsec = 0;
 }
 
 /* clocksource code */

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

