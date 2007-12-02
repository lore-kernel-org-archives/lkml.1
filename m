Return-Path: <linux-kernel-owner+w=401wt.eu-S1756203AbXLBVK5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756203AbXLBVK5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2007 16:10:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752621AbXLBVKt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Dec 2007 16:10:49 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:51268 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753846AbXLBVKs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2007 16:10:48 -0500
Date: Sun, 2 Dec 2007 22:10:27 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <andi@firstfloor.org>
Cc: Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [feature] automatically detect hung TASK_UNINTERRUPTIBLE tasks
Message-ID: <20071202211027.GA32282@elte.hu>
References: <20071201092037.GA32544@elte.hu> <p737ijwylet.fsf@bingen.suse.de> <20071202185945.GA25990@elte.hu> <20071202114152.3bf4332d@laptopd505.fenrus.org> <20071202200953.GA23994@one.firstfloor.org> <20071202202602.GA16480@elte.hu> <20071202204725.GA25891@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071202204725.GA25891@one.firstfloor.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Andi Kleen <andi@firstfloor.org> wrote:

> > Out of direct experience, 95% of the "too long delay" cases are plain 
> > old bugs. The rest we can (and must!) convert to TASK_KILLABLE or could 
> 
> I already pointed out a few cases (nfs, cifs, smbfs, ncpfs, afs).  It 
> would be pretty bad to merge this patch without converting them to 
> TASK_KILLABLE first

which we want to do in 2.6.25 anyway, so i dont see any big problems 
here. Also, it costs nothing to just stick it in and see the results, 
worst case we'd have to flip around the default. I think this is much 
ado about nothing - so far i dont really see any objective basis for 
your negative attitude.

> There's also the additional issue that even block devices are often 
> network or SAN backed these days. Having 120 second delays in there is 
> quite possible.
>
> So most likely adding this patch and still keeping a robust kernel 
> would require converting most of these delays to TASK_KILLABLE first. 
> That would not be a bad thing -- i would often like to kill a process 
> stuck on a bad block device -- but is likely a lot of work.

what if you considered - just for a minute - the possibility of this 
debug tool being the thing that actually animates developers to fix such 
long delay bugs that have bothered users for almost a decade meanwhile?

Until now users had little direct recourse to get such problems fixed. 
(we had sysrq-t, but that included no real metric of how long a task was 
blocked, so there was no direct link in the typical case and users had 
no real reliable tool to express their frustration about unreasonable 
delays.)

Now this changes: they get a "smoking gun" backtrace reported by the 
kernel, and blamed on exactly the place that caused that unreasonable 
delay. And it's not like the kernel breaks - at most 10 such messages 
are reported per bootup.

We increase the delay timeout to say 300 seconds, and if the system is 
under extremely high IO load then 120+ might be a reasonable delay, so 
it's all tunable and runtime disable-able anyway. So if you _know_ that 
you will see and tolerate such long delays, you can tweak it - but i can 
tell you with 100% certainty that 99.9% of the typical Linux users do 
not characterize such long delays as "correct behavior".

> > There are no softlockup false positive bugs open at the moment. If 
> > you know about any, then please do not hesitate and report them, 
> > i'll be eager to fix them. The softlockup detector is turned on by 
> > default in Fedora (alongside lockdep in rawhide), and it helped us 
> > find countless
> 
> That just means nobody runs stress tests on those. [...]

that is an all-encompassing blanket assertion that sadly drips of ill 
will (which permeates your mails lately). I for example run tons of 
stress tests on "those" and of course many others do too. So i dont 
really know what to think of your statement :-(

> [...] e.g. lockdep tends to explode even on simple stress tests on 
> larger systems because it tracks all locks in all dynamic objects in 
> memory and towards 6k-10k entries the graph walks tend to take 
> multiple seconds on some NUMA systems.

a bug was fixed in this area - can you still see this with 2.6.24-rc3?

[ But i'd be the first one to point out that lockdep is certainly not
  from the cheap tools department, that's why i said above that lockdep
  is enabled in Fedora rawhide (i.e. development) kernels. Softlockup
  detector is much cheaper and it's default enabled all the time. ]

	Ingo
