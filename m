Return-Path: <linux-kernel-owner+w=401wt.eu-S1761264AbXEYI4R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761264AbXEYI4R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 04:56:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752725AbXEYI4C
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 04:56:02 -0400
Received: from smtp1.linux-foundation.org ([207.189.120.13]:35668 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752131AbXEYI4B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 04:56:01 -0400
Date: Fri, 25 May 2007 01:55:44 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Ingo Molnar <mingo@elte.hu>, Satyam Sharma <satyam.sharma@gmail.com>,
       linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [patch] x86_64: fix sched_clock()
Message-Id: <20070525015544.bce3cb99.akpm@linux-foundation.org>
In-Reply-To: <20070525084547.GJ8094@one.firstfloor.org>
References: <20070525073957.GA15207@elte.hu>
	<20070525074316.GA16821@elte.hu>
	<20070525074915.GA18400@elte.hu>
	<20070525075446.GA20140@elte.hu>
	<20070525080209.GE8094@one.firstfloor.org>
	<20070525080415.GB21446@elte.hu>
	<20070525082018.GF8094@one.firstfloor.org>
	<20070525083430.GB27236@elte.hu>
	<20070525084109.GI8094@one.firstfloor.org>
	<20070525084426.GA29973@elte.hu>
	<20070525084547.GJ8094@one.firstfloor.org>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 May 2007 10:45:47 +0200 Andi Kleen <andi@firstfloor.org> wrote:

> On Fri, May 25, 2007 at 10:44:26AM +0200, Ingo Molnar wrote:
> > 
> > * Andi Kleen <andi@firstfloor.org> wrote:
> > 
> > > > arch/i386/kernel/sched-clock.c (now built on x86_64 too with the 
> > > > patch i sent) uses the tsc_disable global flag which is non-existent 
> > > > on x86_64. So my tsc.h change adds that global flag, always-defined 
> > > > to 0.
> > > 
> > > My version of sched_clock.c doesn't have any reference to tsc_disable.
> > 
> > must be an -mm fix. I used -mm as a basis of my work. Please apply my 
> > patch.
> 
> I would prefer to find out why the mm patch was added and then hopefully
> remove it.  IMNSHO it should not be needed.
> 

This?    I sent it to you earlier this week:

From: Rusty Russell <rusty@rustcorp.com.au>

If you set tsc_disable (eg "notsc" on cmdline), sched-clock.c gives a
divide by zero on boot.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/sched-clock.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/i386/kernel/sched-clock.c~fix-x86_64-mm-sched-clock-share arch/i386/kernel/sched-clock.c
--- a/arch/i386/kernel/sched-clock.c~fix-x86_64-mm-sched-clock-share
+++ a/arch/i386/kernel/sched-clock.c
@@ -115,7 +115,7 @@ unsigned long long printk_clock(void)
 static void resync_sc_freq(struct sc_data *sc, unsigned int newfreq)
 {
 	sc->sync_base = jiffies;
-	if (!cpu_has_tsc) {
+	if (!cpu_has_tsc || tsc_disable) {
 		sc->unstable = 1;
 		return;
 	}
_

