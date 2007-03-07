Return-Path: <linux-kernel-owner+w=401wt.eu-S1423006AbXCGWBj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423006AbXCGWBj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 17:01:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423009AbXCGWBj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 17:01:39 -0500
Received: from www.osadl.org ([213.239.205.134]:40214 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1423006AbXCGWBh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 17:01:37 -0500
Subject: Re: + stupid-hack-to-make-mainline-build.patch added to -mm tree
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: Dan Hecht <dhecht@vmware.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, Zachary Amsden <zach@vmware.com>,
       Ingo Molnar <mingo@elte.hu>, akpm@linux-foundation.org, ak@suse.de,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       LKML <linux-kernel@vger.kernel.org>, john stultz <johnstul@us.ibm.com>
In-Reply-To: <45EF31AE.1070800@vmware.com>
References: <200703060654.l266sVxr014860@shell0.pdx.osdl.net>
	 <45ED16D2.3000202@vmware.com> <20070306084258.GA15745@elte.hu>
	 <20070306084647.GA16280@elte.hu>  <45ED2C82.3080008@vmware.com>
	 <1173178774.24738.311.camel@localhost.localdomain>
	 <45EDD82F.90204@vmware.com>
	 <1173225182.24738.507.camel@localhost.localdomain>
	 <45EE0628.1080108@goop.org>  <45EE08E8.2020008@vmware.com>
	 <1173228544.24738.514.camel@localhost.localdomain>
	 <45EE0D10.7070807@vmware.com>
	 <1173230305.24738.529.camel@localhost.localdomain>
	 <45EE1EA3.90803@vmware.com>
	 <1173256666.24738.576.camel@localhost.localdomain>
	 <45EEF966.6060902@goop.org>
	 <1173300032.24738.750.camel@localhost.localdomain>
	 <45EF31AE.1070800@vmware.com>
Content-Type: text/plain
Date: Wed, 07 Mar 2007 23:07:46 +0100
Message-Id: <1173305267.24738.839.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-03-07 at 13:42 -0800, Dan Hecht wrote:
> On 03/07/2007 12:40 PM, Thomas Gleixner wrote:
> > Real hardware copes well with relative deltas for the events, even when
> > it is match register based. I thought long about the support for
> > absolute expiry values in cycles and decided against them to avoid that
> > math hackery, which you folks now demand.
> 
> First of all, I'm not "demanding" anything. I'm just trying to have a 
> technical discussion about the issues.  If it comes out that absolute 
> expiry can't be done cleanly, and the cost out weighs the benefit, then 
> so be it.  But, what's so wrong about having the discussion?
> 
> When you do have match register (or count and compare, whatever you want 
> to call it) based timers in real hardware, the relative expiry interface 
> in software is a bit suboptimal.  You still have no idea how much time 
> has already gone by between the time you calculated the delta and when 
> you setup the hardware (you have a pretty good estimate, but can't know 
> for sure unless you disable caches and all other sources of 
> non-determinate latencies).  So, you will always be a little late in 
> your timer firing.  You may argue that no client of clockevents cares 
> about this little bit of lateness.  But, it does exist, and can be 
> solved with a software interface that talks in terms of absolute expiries.

With sane hardware yes. But there is no sane hardware. You need a (<=)
match machinery instead of the available (==) ones, which introduce
extra latencies and incorrectness. See arch/i386/kernel/hpet.c. We can
end up with returning -ETIME and an interrupt, as we have no control
over SMM code and such crap at all. For such devices the delta based
expiry is actually faster, as it avoids the calculation of wraps and the
possible 128 bit math in the reprogramming path.

This correctness discussion is purely hypothetical on current real world
hardware.

> Perhaps we can't get around the 128-bit math problem, or maybe we can 
> think of a clever solution.  If we can't, then maybe fixing the lateness 
> is not worth the cost 128-bit math.  But, maybe there is a clean way 
> around the 128-bit math and we just need to approach it from another angle.

Please put the clever solution inside of the clockevent. I can provide
the absolute time in nanoseconds without making you touch the
clockevent->next_event variable.

	tglx


