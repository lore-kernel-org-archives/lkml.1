Return-Path: <linux-kernel-owner+w=401wt.eu-S1754335AbYIEI6N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754335AbYIEI6N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 04:58:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751243AbYIEI56
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 04:57:58 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:39105 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751179AbYIEI55 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 04:57:57 -0400
Date: Fri, 5 Sep 2008 10:57:36 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Don Zickus <dzickus@redhat.com>,
       "Mingarelli, Thomas" <Thomas.Mingarelli@hp.com>,
       Andi Kleen <andi@firstfloor.org>, Prarit Bhargava <prarit@redhat.com>,
       Peter Zijlstra <peterz@infradead.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "arozansk@redhat.com" <arozansk@redhat.com>,
       "ak@linux.intel.com" <ak@linux.intel.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       "Maciej W. Rozycki" <macro@linux-mips.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH RFC] NMI Re-introduce un[set]_nmi_callback
Message-ID: <20080905085736.GD18485@elte.hu>
References: <20080904175231.GH18288@one.firstfloor.org> <20080904182637.GP3400@redhat.com> <20080904190816.GB4349@redhat.com> <20080904200032.GM18288@one.firstfloor.org> <183C1D5A376DE343AA8F94FC2A1EC14938D3E74841@GVW1091EXB.americas.hpqcorp.net> <20080904205725.GC4349@redhat.com> <183C1D5A376DE343AA8F94FC2A1EC14938D3E748D1@GVW1091EXB.americas.hpqcorp.net> <20080904212134.GD4349@redhat.com> <20080904212453.GR3400@redhat.com> <20080904214628.GE4349@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080904214628.GE4349@redhat.com>
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


* Vivek Goyal <vgoyal@redhat.com> wrote:

> > Prarit's patch disabled the timer upon registering a callback to 
> > prevent this case.  The thought was if you have your own handler you 
> > could provide your own watchdog.
> 
> In theory, you could do the same while registering the handler on die 
> chain?
> 
> I don't get the whole point. So we are looking for a system where no 
> body else uses an NMI for any purpose and the moment NMI happens, this 
> driver will go and panic() the system. I don't get, what do we achive 
> by that?
> 
> Looks like you got some device in platform which raises an NMI and 
> which indicates that something is wrong and log the message and do a 
> panic(). But you don't have a way to find out if that device has 
> raised the interrupt or something else has raised the NMI, hence you 
> want to stop the watchdog timer and assume any NMI henceforth is from 
> device?
> 
> So any functionality which is dependent on NMI, will not work as long 
> as this driver is loaded.

exactly. The proposed patch brings the NMI notifier arms race to its 
next level: it is in essence a "super high priority" notifier that wants 
exclusivity. That is unnecessary: we already have sufficient 
infrastructure in place to recognize the priority of notifiers, and die 
notifiers make active use of it. (see the list below)

If the goal is to log relevant NMI events to NVRAM for later inspection 
then the solution is to register a low-priority notifier which will 
execute if no other notifier shows interest in an NMI event.

If the goal is to reboot the system if there's a "bad" NMI, then the 
solution is to register a low-priority notifier which will execute and 
panic the system if no other notifier shows interest in that NMI event.

This means all the 'good' NMI sources need to register at higher 
priority and all the standard platform fallback notifiers need to 
register at lowest priority. Debuggers go last. If any of the existing 
notifiers in the kernel dont follow the rules and cause problems then we 
can fix up those.

Here's a list of all current die notifiers we use in the kernel:

                                                                  prio
                                                                  ----
  # core kernel:

  kernel/kprobes.c                   # instruction probing        +INT_MAX
  kernel/trace/trace.c               # dump trace                 150

  # arch/x86:

  arch/x86/mm/kmmio.c                # mmiotrace, debug feature   0 
  arch/x86/kernel/kgdb.c             # kgdb, kernel debugger      -INT_MAX
  arch/x86/kernel/crash.c            # kdump                      0
  arch/x86/oprofile/nmi_int.c        # oprofile                   0
  arch/x86/oprofile/nmi_timer_int.c  # oprofile timer fallback    0

  # drivers:

  drivers/watchdog/hpwdt.c           # HP watchdog driver         +INT_MAX
  drivers/char/ipmi/ipmi_watchdog.c  # IPMI watchdog              150
  drivers/misc/sgi-xp/xpc_main.c     # SGI SN2                    0

  # upcoming:
  arch/x86/mm/kmemcheck/smp.c        # in tip/master              0
                                     [ this should change to +INT_MAX ]

One change we could do is to move arch/x86/kernel/crash.c's priority to 
-100. That would achieve the following effect: it would execute after 
all known sources of NMIs, but before the lowest prio interactive 
notifiers such as kgdb.

That way a platform driver could insert at priority -50 and execute 
after the known self-generated NMI sources, but before any of the debug 
and crash-tool notifiers. And the constants should be made symbolic as 
well, so that we encode the purpose of a notifier, not the 
implementation - and can map the purpose to priority and shape the 
ordering flexibly.

furthermore, as i indicated it in my first reply, if the port 61H read 
is causing problems on this platform (and i'd not be surprised if it did 
so) we can turn it into a lowest-prio fallback notifier which only 
executes if no known sources of NMIs show interest in an event.

	Ingo
