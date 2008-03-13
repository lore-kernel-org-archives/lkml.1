Return-Path: <linux-kernel-owner+w=401wt.eu-S1755388AbYCMRh0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755388AbYCMRh0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 13:37:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753081AbYCMRhO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 13:37:14 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:43362 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752469AbYCMRhN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 13:37:13 -0400
Subject: Re: 2.6.25-rc5-mm1 - x86_64 boot problem with git-sched.patch
From: Badari Pulavarty <pbadari@us.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>, guichaz@yahoo.fr
Cc: a.p.zijlstra@chello.nl, mingo@elte.hu, vatsa@linux.vnet.ibm.com,
       lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <1205428180.19403.15.camel@dyn9047017100.beaverton.ibm.com>
References: <20080311011434.ad8c8d7d.akpm@linux-foundation.org>
	 <1205345451.23611.6.camel@dyn9047017100.beaverton.ibm.com>
	 <20080312111509.301c9d24.akpm@linux-foundation.org>
	 <1205428180.19403.15.camel@dyn9047017100.beaverton.ibm.com>
Content-Type: text/plain
Date: Thu, 13 Mar 2008 09:40:28 -0800
Message-Id: <1205430028.19403.19.camel@dyn9047017100.beaverton.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.4 (2.0.4-4) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-03-13 at 09:09 -0800, Badari Pulavarty wrote:
> On Wed, 2008-03-12 at 11:15 -0700, Andrew Morton wrote:
> > On Wed, 12 Mar 2008 10:10:50 -0800 Badari Pulavarty <pbadari@gmail.com> wrote:
> > 
> > > On Tue, 2008-03-11 at 01:14 -0700, Andrew Morton wrote:
> > > > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.25-rc5/2.6.25-rc5-mm1/
> > > > 
> > > 
> > > I am having trouble booting rc5-mm1 on my x86_64. (ppc64 boots & works
> > > fine). Seems to be a networking issues (hangs on boot). Here are the 
> > > messages on the console (not really useful to me).
> 
> 
> Hi Andrew,
> 
> Finally narrowed down the problem to git-sched.patch in rc5-mm1.
> I am going to try which individual patch in that git caused my
> amd64 boot hang.
> 

Further narrowed it down to following patch in git-sched.patch.
When I back out this patch from rc5-mm1, my amd64 box boots fine.

commit 60befbc1c0b6d141c9c26e61ddd303aedd1e7396
Author: Guillaume Chazarain <guichaz@yahoo.fr>
Date:   Mon Mar 10 08:16:41 2008 +0100

    sched: make sure jiffies is up to date before calling
__update_rq_clock()

    Now that __update_rq_clock() uses jiffies to detect clock overflows,
    make sure jiffies are up to date before touch_softlockup_watchdog().

    Removed a touch_softlockup_watchdog() call becoming redundant with
the
    added tick_nohz_update_jiffies().

    Signed-off-by: Guillaume Chazarain <guichaz@yahoo.fr>
    Signed-off-by: Ingo Molnar <mingo@elte.hu>

diff --git a/kernel/sched.c b/kernel/sched.c
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -66,6 +66,7 @@
 #include <linux/unistd.h>
 #include <linux/pagemap.h>
 #include <linux/hrtimer.h>
+#include <linux/tick.h>
 
 #include <asm/tlb.h>
 #include <asm/irq_regs.h>
@@ -913,7 +914,7 @@ void sched_clock_idle_wakeup_event(u64 delta_ns)
        rq->prev_clock_raw = now;
        rq->clock += delta_ns;
        spin_unlock(&rq->lock);
-       touch_softlockup_watchdog();
+       tick_nohz_update_jiffies();
 }
 EXPORT_SYMBOL_GPL(sched_clock_idle_wakeup_event);


Thanks,
Badari

