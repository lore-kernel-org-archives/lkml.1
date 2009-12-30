Return-Path: <linux-kernel-owner+w=401wt.eu-S1753192AbZL3SBc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753192AbZL3SBc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Dec 2009 13:01:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753168AbZL3SBa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Dec 2009 13:01:30 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:52627 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752778AbZL3SB2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Dec 2009 13:01:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=IAatwSy8hwsmx/+tvacEv1Au2o7PFHZWmf/j9w2IwgsVuo3TpHDpfzLsQ66FWys2Dn
         s3fIKCBYpFQvg9VoTW5aySUt+64L4XtBMZZn+XUK6y/95b04tY0IQ8odeXbVRNbKOh0D
         p3JVmLcKg81jiVUMfk9G/CnYf9dMgLS/hKxoQ=
Date: Wed, 30 Dec 2009 19:01:24 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Jason Wessel <jason.wessel@windriver.com>
Cc: Jan Kiszka <jan.kiszka@web.de>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>, lkml <linux-kernel@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC] Fix 2.6.33 x86 regression to kgdb hw breakpoints - dueto
	perf API changes
Message-ID: <20091230180122.GA6322@nowhere>
References: <4B227F2C.7050403@windriver.com> <20091212132428.GB22389@elte.hu> <20091212135216.GA18597@elte.hu> <4B2404C6.2050003@windriver.com> <20091230163903.GA5024@nowhere> <4B3B8577.6050801@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B3B8577.6050801@windriver.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 30, 2009 at 10:53:11AM -0600, Jason Wessel wrote:
> Frederic Weisbecker wrote:
> > We could probably have a helper that allocates a disabled breakpoint
> > without reserving it.
> 
> I worked around that restriction for now, in the current version of the
> kgdb patches.  When kgdb registers with the die notifier in its init
> phase, it allocates the perf structures via the perf API and
> subsequently disables the breakpoints with the low level API.



It disables it but then the breakpoint still has a reserved slot,
that looks too much for an opt-in config that may or
may not be used. One slot among four would be irremediably
unavailable from userspace once we set CONFIG_KGDB, if I understand well...
Is it doing so in the beginning of a debugging session or
at boot time?


 
> >  But the problem remains: you'll need to take
> > locks when you eventually reserve it and when you activate it.
> >
> > The fact that it can happen from nmi is really a problem.
> >
> >   
> 
> I talked with Jan a bit with respect to this problem.  He recommended to
> possibly allow kgdb to obtain hw breakpoints locklessly and to break
> reservations that exist with the low level API.  The current patch in
> the kgdb series does not break reservations, it only uses a slot that is
> not already in use.  Let us call the scenarios A and B.
> 
> A) allow kgdb to break existing reservations
> B) kgdb can use what is not reserved, without locks
> 
> What is missing right now is a notification mechanism and a separate
> count for the debugger as to what is in use.   I tend to think that B is
> the right default approach, but Jan was leaning towards scenario A.



A looks dangerous, in that an overflow of the possible number of
breakpoints would make them fighting for the debug registers.
Only 4 of them will make it :) (in x86)
I guess that in overflow case, the plan is to kick out one of the
running breakpoints.
I see several problems in this preempt scheme:

- which breakpoint should we preempt?
- that will bring some complexities in the current code. You'll need
  to keep track of the preempted breakpoint, deactivate, reactivate it
  etc... Moreover the activation things require to take some locks.

I don't think A is good idea.

B looks feasible, but only at the cost of using a best effort
try (in case of NMI).
You'll need to check if the current lock that protects the reservation
datas is already taken. If so you have to give up.
That said this should be fine as the breakpoint reservation is a rare
path, and I doubt one would try to set up a breakpoint in kgdb in the same
time perf does, or any other users.

That said, either A or B, you'll need to take locks to activate/deactivate
the breakpoints.



> > Is there any possibility that we know the user has started a
> > kgdb session, and then reserve as much hardware breakpoints
> > as we can in kgdb at this time?
> >
> >   
> 
> That is the way I implemented it the first time.  Reserve all the slots,
> and then nothing else could use them.  That didn't work out too well
> because then the user space could not make use of hw breakpoints,
> granted this never worked before with user space + kernel space sharing
> between ptrace and kgdb.



Say one opens a kgdb session. A very cool thing would be to reserve
as much breakpoints as we can (without prempting existing ones)
and release them once the session is closed. This is not a problem that
userspace can't reserve new ones during this session, we are debugging
the kernel at this time. I doubt we need userspace breakpoints at the same
time. Do we?

That said I really lack some kgdb background. In which context the
user is connecting to kgdb? The above would only work in a non-NMI
context.

