Return-Path: <linux-kernel-owner+w=401wt.eu-S1754405AbZCVK0a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754405AbZCVK0a (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Mar 2009 06:26:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752462AbZCVK0W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Mar 2009 06:26:22 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:35616 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752102AbZCVK0V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Mar 2009 06:26:21 -0400
Date: Sun, 22 Mar 2009 11:25:34 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Frank Ch. Eigler" <fche@redhat.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>, Roland McGrath <roland@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Steven Rostedt <rostedt@goodmis.org>, utrace-devel@redhat.com,
       linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 3/3] utrace-based ftrace "process" engine, v2
Message-ID: <20090322102534.GC19826@elte.hu>
References: <20090321041954.72b99e69.akpm@linux-foundation.org> <20090321115141.GA3566@redhat.com> <20090321050422.d1d99eec.akpm@linux-foundation.org> <20090321154501.GA2707@elte.hu> <20090321143413.75ead1aa.akpm@linux-foundation.org> <20090321215145.GB5262@redhat.com> <alpine.LFD.2.00.0903211501060.3030@localhost.localdomain> <20090321222030.GA5157@redhat.com> <20090321223759.GA22770@x200.localdomain> <20090321233839.GB5157@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090321233839.GB5157@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Frank Ch. Eigler <fche@redhat.com> wrote:

> Hi -
> 
> On Sun, Mar 22, 2009 at 01:37:59AM +0300, Alexey Dobriyan wrote:
> > [...]
> > struct task_struct::utrace became embedded struct. This is good and
> > should remove quite a few of utrace bugs. Better late than never.
> 
> Yeah.
> 
> > However, "rewrite-ptrace-via-utrace" patch was omitted, so 
> > almost noone can easily see by how much situation improved. 
> > [...]  Will ptrace(2) will be rewritten through utrace?
> 
> Yes, I believe that is Roland's intent.  I believe it was 
> separated from the current suite of patches for staging purposes, 
> to merge the most solid code up first.  The code is available from 
> the utrace git tree in the utrace-ptrace branch.

i think they should be submitted together.

Here's the histogram of utrace bugs on kerneloops.org:

  2.6.27.5          1 x
  2.6.27.15         1 x
  2.6.27.12         2 x
  2.6.27-rc4        2 x
  2.6.26.6          1 x
  2.6.26.5         43 x
  2.6.26.3       1102 x
  2.6.26.2          2 x
  2.6.26.1          3 x
  2.6.26            1 x
  2.6.25            3 x

That peak in 2.6.26.3 is what i referred to. The latest F10 kernel 
rpm is kernel-2.6.27.12-170.2.5.fc10, and it does include the 
utrace-ptrace engine as well:

  # grep UTRACE /boot/config-2.6.27.19-170.2.35.fc10.i686
  CONFIG_UTRACE=y
  CONFIG_UTRACE_PTRACE=y

So the bug i referred to was fixed and the bug count has gone down - 
but still we have the utrace core submission here without any 
(tested) mainline kernel usage of the core code.

My suggestion would be to:

 - submit the ptrace-on-utrace engine as well (with Oleg's signoff?)

 - perhaps also submit with a well-tested ftrace plugin that tries 
   to utilize _all_ aspects of utrace and ftrace (and hence gives 
   good and continuous burn-in testing via the ftrace bootup 
   self-tests, etc.)

ideally we want both, because:

 - tracing corner-case bugs tend to be found much faster than ptrace
   corner case bugs - partly because tracing is much more invasive
   when activated system-wide.

 - ptrace-over-utrace on the other hand utilizes utrace more deeply
   than passive tracing ever can. (for example UML does full,
   active virtualization via ptrace - this depth of functional
   utrace usage is not possible via a tracing plugin.)

And i think the ptrace-via-utrace engine is actually fully ready, 
just perhaps it was not submitted out of caution to keep the 
logistics simple.

So i do think we've still got a shot at merging it, in this merge 
window.

        Ingo
