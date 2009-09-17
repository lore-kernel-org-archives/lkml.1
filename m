Return-Path: <linux-kernel-owner+w=401wt.eu-S1753378AbZIQI3H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753378AbZIQI3H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 04:29:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750883AbZIQI3G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 04:29:06 -0400
Received: from mail.pawisda.de ([213.157.4.156]:44000 "EHLO mail.pawisda.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750838AbZIQI3D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 04:29:03 -0400
Subject: Re: RCU callbacks and TREE_PREEMPT_RCU
From: Eric Sesterhenn <eric.sesterhenn@lsexperts.de>
To: paulmck@linux.vnet.ibm.com
Cc: Catalin Marinas <catalin.marinas@arm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20090916232609.GK6737@linux.vnet.ibm.com>
References: <1253110641.31751.92.camel@pc1117.cambridge.arm.com>
	 <20090916152929.GA6737@linux.vnet.ibm.com>
	 <1253115255.31751.96.camel@pc1117.cambridge.arm.com>
	 <20090916154716.GC6737@linux.vnet.ibm.com>
	 <20090916155719.GA10588@linux.vnet.ibm.com> <1253143186.9006.0.camel@queen>
	 <20090916232609.GK6737@linux.vnet.ibm.com>
Content-Type: text/plain
Date: Thu, 17 Sep 2009 10:29:02 +0200
Message-Id: <1253176142.3615.3.camel@queen>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-09-16 at 16:26 -0700, Paul E. McKenney wrote:
> On Thu, Sep 17, 2009 at 01:19:46AM +0200, Eric Sesterhenn wrote:
> > On Wed, 2009-09-16 at 08:57 -0700, Paul E. McKenney wrote:
> > > On Wed, Sep 16, 2009 at 08:47:16AM -0700, Paul E. McKenney wrote:
> > > > On Wed, Sep 16, 2009 at 04:34:15PM +0100, Catalin Marinas wrote:
> > > > > On Wed, 2009-09-16 at 08:29 -0700, Paul E. McKenney wrote:
> > > > > > On Wed, Sep 16, 2009 at 03:17:21PM +0100, Catalin Marinas wrote:
> > > > > > > When TREE_PREEMPT_RCU is enabled, the rcu list traversing above fails
> > > > > > > with access to 0x6b6b6b6b but it is fine with TREE_PREEMPT_RCU=n and
> > > > > > > TREE_RCU=y. During clean-up, kmemleak objects should no longer be freed
> > > > > > > by other means since kmemleak was disabled and all callbacks are
> > > > > > > ignored. The system is a 900Mhz P3, 256MB RAM, CONFIG_SMP=n.
> > > > > > > 
> > > > > > > Is there something I'm doing wrong in kmemleak or a bug with RCU
> > > > > > > preemption? The kernel oops looks like this:
> > > > > > 
> > > > > > From your description and the code above, I must suspect a bug with
> > > > > > RCU preemption.  A new one, as the only bugs I am currently chasing
> > > > > > involve NR_CPUS>32 (>64 on 64-bit systems).
> > > > > > 
> > > > > > CONFIG_SMP=n implies NR_CPUS==1 in your build, correct?
> > > > > 
> > > > > CONFIG_NR_CPUS=1.
> > > > 
> > > > I was afraid of that.  ;-)
> > > 
> > > PS to previous -- there -is- a bug in mainline for TREE_PREEMPT_RCU for
> > > single-CPU operation, but it is with synchronize_rcu() rather than
> > > call_rcu().  The fix is in tip/core/urgent, commit #366b04ca.  Or see
> > > the following patch.
> > > 
> > > So, could you please give the following patch a try?
> > 
> > Sadly this does not fix the issue, is there any further information I
> > can provide to you?
> 
> :-(
> 
> Would you be willing to give the attached diagnostic patch a go?
> 
> 							Thanx, Paul

It does not apply cleanly against current -git
(rcu_preempt_check_blocked_tasks is missing in my rcutree_plugin.h for
example) I tried to apply it by hand as good as possible, and will test
it today.

root@whiterabbit:/usr/src/linux# patch -p1 < ~/RCU_callbacks_and_TREE_PREEMPT_RCU-debug
patching file kernel/rcutree.c
Hunk #1 FAILED at 623.
Hunk #2 FAILED at 657.
Hunk #3 succeeded at 722 (offset 19 lines).
Hunk #4 succeeded at 740 (offset 19 lines).
Hunk #5 succeeded at 765 (offset 19 lines).
Hunk #6 succeeded at 877 (offset 19 lines).
Hunk #7 succeeded at 886 (offset 19 lines).
2 out of 7 hunks FAILED -- saving rejects to file kernel/rcutree.c.rej
patching file kernel/rcutree_plugin.h
Hunk #1 FAILED at 206.
Hunk #2 succeeded at 206 (offset -10 lines).
Hunk #3 FAILED at 270.
Hunk #4 succeeded at 283 (offset -22 lines).
Hunk #5 succeeded at 296 (offset -22 lines).
Hunk #6 succeeded at 473 (offset -23 lines).
2 out of 6 hunks FAILED -- saving rejects to file
kernel/rcutree_plugin.h.rej

Regards, Eric



