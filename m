Return-Path: <linux-kernel-owner+w=401wt.eu-S1752552AbYKQWoR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752552AbYKQWoR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 17:44:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751515AbYKQWoB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 17:44:01 -0500
Received: from mga02.intel.com ([134.134.136.20]:8031 "EHLO mga02.intel.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751468AbYKQWoA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 17:44:00 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,620,1220252400"; 
   d="scan'208";a="361242279"
Date: Mon, 17 Nov 2008 14:43:58 -0800
From: Venki Pallipadi <venkatesh.pallipadi@intel.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Mike Galbraith <efault@gmx.de>
Subject: Re: [git pull] scheduler updates
Message-ID: <20081117224358.GA27249@linux-os.sc.intel.com>
References: <20081108170224.GA553@elte.hu> <alpine.LFD.2.00.0811081026280.3468@nehalem.linux-foundation.org> <20081108104116.48bd26e6@infradead.org> <alpine.LFD.2.00.0811081051190.3468@nehalem.linux-foundation.org> <20081108190517.GA9806@elte.hu> <alpine.LFD.2.00.0811081115290.3468@nehalem.linux-foundation.org> <20081108192957.GA22219@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081108192957.GA22219@elte.hu>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 08, 2008 at 11:29:57AM -0800, Ingo Molnar wrote:
> 
> * Linus Torvalds <torvalds@linux-foundation.org> wrote:
> 
> > On Sat, 8 Nov 2008, Ingo Molnar wrote:
> > > 
> > > So that's why my change moves it from the __native_read_tsc() over to 
> > > _only_ the vget_cycles().
> > 
> > Ahh. I was looking at native_read_tscp(). Which has no barriers. But then 
> > we don't actually save the actual TSC, we only end up using the "p" part, 
> > so we don't care..
> > 
> > Anyway, even for the vget_cycles(), is there really any reason to 
> > have _two_ barriers? Also, I still think it would be a hell of a lot 
> > more readable and logical to put the barriers in the _caller_, so 
> > that people actually see what the barriers are there for.
> > 
> > When they are hidden, they make no sense. The helper function just 
> > has two insane barriers without explanation, and the caller doesn't 
> > know that the code is serialized wrt something random.
> 
> ok, fully agreed, i've queued up the cleanup for that, see it below.
> 
> sidenote: i still kept the get_cycles() versus vget_cycles() 
> distinction, to preserve the explicit marker that vget_cycles() is 
> used in user-space mode code. We periodically forgot about that in the 
> past. But otherwise, the two inline functions are now identical. 
> (except for the assymetry of its inlining, and the comment about the 
> boot_cpu_data use of the has_tsc check)
> 


Patch being discussed on this thread (commit 0d12cdd) has a regression on
one of the test systems here.

With the patch, I see

checking TSC synchronization [CPU#0 -> CPU#1]:
Measured 28 cycles TSC warp between CPUs, turning off TSC clock.
Marking TSC unstable due to check_tsc_sync_source failed

Whereas, without the patch syncs pass fine on all CPUs

checking TSC synchronization [CPU#0 -> CPU#1]: passed.

Due to this, TSC is marke unstable, when it is not actually unstable.
This is because syncs in check_tsc_wrap() goes away due to this commit.

As per the discussion on this thread, correct way to fix this is to add
explicit syncs as below?

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>

---
 arch/x86/kernel/tsc_sync.c |    4 ++++
 1 file changed, 4 insertions(+)

Index: linux-2.6/arch/x86/kernel/tsc_sync.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/tsc_sync.c	2008-11-10 15:27:12.000000000 -0800
+++ linux-2.6/arch/x86/kernel/tsc_sync.c	2008-11-17 14:13:17.000000000 -0800
@@ -46,7 +46,9 @@ static __cpuinit void check_tsc_warp(voi
 	cycles_t start, now, prev, end;
 	int i;
 
+	rdtsc_barrier();
 	start = get_cycles();
+	rdtsc_barrier();
 	/*
 	 * The measurement runs for 20 msecs:
 	 */
@@ -61,7 +63,9 @@ static __cpuinit void check_tsc_warp(voi
 		 */
 		__raw_spin_lock(&sync_lock);
 		prev = last_tsc;
+		rdtsc_barrier();
 		now = get_cycles();
+		rdtsc_barrier();
 		last_tsc = now;
 		__raw_spin_unlock(&sync_lock);
 
