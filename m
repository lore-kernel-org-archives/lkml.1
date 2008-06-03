Return-Path: <linux-kernel-owner+w=401wt.eu-S1758916AbYFCVIo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758916AbYFCVIo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 17:08:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753158AbYFCVIS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 17:08:18 -0400
Received: from smtp.cs.aau.dk ([130.225.194.6]:45953 "EHLO smtp.cs.aau.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752211AbYFCVIO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 17:08:14 -0400
Subject: Re: CONFIG_PREEMPT causes corruption of application's FPU stack
From: Simon Holm =?ISO-8859-1?Q?Th=F8gersen?= <odie@cs.aau.dk>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: j.mell@t-online.de, Steven Rostedt <rostedt@goodmis.org>,
       linux-kernel@vger.kernel.org, mingo@elte.hu, hpa@zytor.com,
       tglx@linutronix.de, arjan@linux.intel.com, lguest <lguest@ozlabs.org>,
       andi@firstfloor.org
In-Reply-To: <20080603194351.GD25114@linux-os.sc.intel.com>
References: <200806011101.06491.j.mell@t-online.de>
	 <1212340262.5802.8.camel@odie.local>
	 <20080602213136.GA25114@linux-os.sc.intel.com>
	 <1212499410.2955.2.camel@odie.local>
	 <20080603194351.GD25114@linux-os.sc.intel.com>
Content-Type: text/plain; charset=utf-8
Date: Tue, 03 Jun 2008 23:08:04 +0200
Message-Id: <1212527284.2569.7.camel@odie.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

tir, 03 06 2008 kl. 12:43 -0700, skrev Suresh Siddha:
> On Tue, Jun 03, 2008 at 03:23:30PM +0200, Simon Holm Thøgersen wrote:
> > > [patch] x86: fix blocking call (math_state_restore()) condition in __switch_to
> > > 
> > > Add tsk_used_math() checks to prevent calling math_state_restore()
> > > which can sleep in the case of !tsk_used_math(). This prevents
> > > making a blocking call in __switch_to().
> > > 
> > > Apparently "fpu_counter > 5" check is not enough, as in some signal handling
> > > and fork/exec scenarios, fpu_counter > 5 and !tsk_used_math() is possible.
> > > 
> > > Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
> > > ---
> > Hi Suresh,
> > 
> > and thanks for looking into this. The patch did not fix the issue, but
> 
> Ok. You are probably running into different issue (please see below).
> Above patch fixes a real issue and I think it should fix the fpu
> corruption issue encountered by Jürgen. I will wait for Jürgen's test
> results before pushing the above patch.
> 
> > I'm wondering if it is lguest calling math_state_restore in
> > drivers/lguest/x86/core.c that could be the problem?
> 
> I def see a problem. In lguest_arch_run_guest(), MSR_IA32_SYSENTER_CS is not
> restored before making the math_state_restore() call. As the
> math_state_restore() can now block, this can cause issues. Appending
> patch should fix this issue and from your oops report, it is not very
> clear if the below patch should help fix your issue or not. Can you
> please try the below appended patch.
> 
> > 
> > Regardless of whether that is the issue, I think you (and everybody
> > else) will be able to reproduce the issue by running lguest on a 32-bit
> > system with CONFIG_PREEMPT=y and CONFIG_DEBUG_SPINLOCKS_SLEEP=y (I'm
> > also using CONFIG_DEBUG_PREEMPT=y but I don't think that matter). If you
> > download http://xm-test.xensource.com/ramdisks/initrd-1.1-i386.img and
> > run
> > 
> > Documentation/lguest/lguest 64 vmlinux --block=initrd-1.1-i386.img
> > 
> > it will very likely trigger the backtraces I'm getting.
> 
> If the below patch doesn't help fix your issue, then I will try to reproduce
> it locally here.
> 
It didn't, I'm afraid. I had both patches applied, and was able to
reproduce the trace fairly easily. The patches might have made the issue
slightly more difficult to provoke, but I'm not sure.


Simon

