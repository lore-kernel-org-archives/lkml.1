Return-Path: <linux-kernel-owner+w=401wt.eu-S1756756AbZGPNhn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756756AbZGPNhn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 09:37:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756609AbZGPNhn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 09:37:43 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:44685 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756205AbZGPNhm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 09:37:42 -0400
Subject: Re: RFC for a new Scheduling policy/class in the Linux-kernel
From: Peter Zijlstra <peterz@infradead.org>
To: "James H. Anderson" <anderson@cs.unc.edu>
Cc: Raistlin <raistlin@linux.it>, Ted Baker <baker@cs.fsu.edu>,
       Chris Friesen <cfriesen@nortel.com>,
       Noah Watkins <jayhawk@soe.ucsc.edu>,
       Douglas Niehaus <niehaus@ittc.ku.edu>, Henrik Austad <henrik@austad.us>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Bill Huey <billh@gnuppy.monkey.org>,
       Linux RT <linux-rt-users@vger.kernel.org>,
       Fabio Checconi <fabio@gandalf.sssup.it>,
       Thomas Gleixner <tglx@linutronix.de>,
       Dhaval Giani <dhaval.giani@gmail.com>,
       KUSP Google Group <kusp@googlegroups.com>,
       Tommaso Cucinotta <cucinotta@sssup.it>,
       Giuseppe Lipari <lipari@retis.sssup.it>,
       "Bjoern B. Brandenburg" <bbb@email.unc.edu>
In-Reply-To: <4A5F2423.10802@cs.unc.edu>
References: <200907102350.47124.henrik@austad.us>
	 <1247336891.9978.32.camel@laptop> <4A594D2D.3080101@ittc.ku.edu>
	 <1247412708.6704.105.camel@laptop> <1247499843.8107.548.camel@Palantir>
	 <1247505941.7500.39.camel@twins>
	 <5B78D181-E446-4266-B9DD-AC0A2629C638@soe.ucsc.edu>
	 <20090713201305.GA25386@cs.fsu.edu> <4A5BAAE7.5020906@nortel.com>
	 <20090715231109.GH14993@cs.fsu.edu>  <1247731113.15471.24.camel@twins>
	 <1247746671.5775.279.camel@Palantir>  <4A5F2423.10802@cs.unc.edu>
Content-Type: text/plain
Date: Thu, 16 Jul 2009 15:37:02 +0200
Message-Id: <1247751422.6586.16.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-07-16 at 08:59 -0400, James H. Anderson wrote:
> 
> Raistlin wrote:
> > Also, I'm not sure I can find in the FMLP paper information about the
> > possibility of a task to suspend itself (e.g., I/O completion) while
> > holding a short lock... I assume this is not recommended, but may be
> > wrong, and, in that case, I hope Prof. Anderson and Bjorn will excuse
> > and correct me. :-)
> >
> >   
> This is a really excellent point and something I probably should have 
> mentioned.  We developed the FMLP strictly for real-time (only) 
> workloads.  We were specifically looking at protecting memory-resident 
> resources (not I/O).  The FMLP would have to be significantly extended 
> to work in settings where these assumptions don't hold.

One thing I've been thinking about is extending lockdep to help verify
things like this.

If we were to annotate a syscall/trap with something like:

  lockdep_assume_rt()

And teach lockdep about non-RT blocking objects, we could validate that
the callchain down from lockdep_assume_rt() would not indeed contain a
non-RT resource, but also that we don't take locks which might in other
another code path.

That is, suppose:

  sys_foo()
    lockdep_assume_rt()
    mutex_lock(&my_lock)

vs

  sys_bar()
    mutex_lock(&my_lock)
      down_read(&mm->mmap_sem)

vs

  page-fault
    down_read(&mm->mmap_sem)
      lock_page(page)

Would indeed generate a warning because mmap_sem is known to block on
IO, and there is a dependency (through sys_bar()) between my_lock and
mmap_sem, therefore sys_foo()'s assumption is invalid.



