Return-Path: <linux-kernel-owner+w=401wt.eu-S1759086AbZA2PH2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759086AbZA2PH2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 10:07:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754695AbZA2PHR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 10:07:17 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:55653 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753854AbZA2PHP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 10:07:15 -0500
Date: Thu, 29 Jan 2009 16:07:01 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Linux 2.6.29-rc2] BUG: using smp_processor_id() in preemptible
Message-ID: <20090129150701.GE6512@elte.hu>
References: <8db1092f0901170058k325dc6ddtddb42deea1ddd098@mail.gmail.com> <200901271628.54037.rjw@sisk.pl> <20090127154946.GA28209@elte.hu> <200901272218.39608.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200901272218.39608.rjw@sisk.pl>
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


* Rafael J. Wysocki <rjw@sisk.pl> wrote:

> On Tuesday 27 January 2009, Ingo Molnar wrote:
> > 
> > * Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > 
> > > > In fact whatever check you put in it's _always_ going to be 
> > > > fundamentally more fragile than direct instrumentation: you cannot 
> > > > possibly check all possible places that enable interrupts. (they could 
> > > > be disabling interrupts as a _restore_irqs() sequence for example)
> > > 
> > > In this particular case, I'm not really interested in that.  What I'm 
> > > interested in is which driver's ->suspend_late() or ->resume_early() (or 
> > > the equivalents for sysdevs) has enabled interrupts, which is quite easy 
> > > to check directly.
> > 
> > But this is exactly what it does - without any need for debug checks 
> > spread around!
> > 
> > You'll get a _full stack dump_ from the very driver that is enabling 
> > interrupts! You dont get a trace - you get a stack dump of the very place 
> > that is buggy. It does not get any better than that.
> 
> I'm not going to argue.
> 
> Nevertheless, IMO something like the patch below should be sufficient to catch
> these bugs.
> 
> Thanks,
> Rafael
> 
> 
> ---
>  drivers/base/power/main.c |   12 ++++++++++++
>  drivers/base/sys.c        |   21 ++++++++++++++++-----
>  include/linux/pm.h        |   18 ++++++++++++++++++
>  3 files changed, 46 insertions(+), 5 deletions(-)

hm, so now you sprinkle debug checks all around the code, instead of 
putting in a single pair of:

    force_irqs_off_start();
    ...
    force_irqs_off_end();

which would catch everything that your checks would catch - and it would 
catch more. In what way is your approach better?

	Ingo
