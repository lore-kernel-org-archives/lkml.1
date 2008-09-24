Return-Path: <linux-kernel-owner+w=401wt.eu-S1753106AbYIXI7T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753106AbYIXI7T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 04:59:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751510AbYIXI7J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 04:59:09 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:38691 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751234AbYIXI7I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 04:59:08 -0400
Date: Wed, 24 Sep 2008 10:58:48 +0200
From: Ingo Molnar <mingo@elte.hu>
To: =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
Cc: linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
       Steven Noonan <steven@uplinklabs.net>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [Patch -tip 0/4] Creation of the initcall tracer
Message-ID: <20080924085848.GA22251@elte.hu>
References: <48D8C516.4090706@gmail.com> <20080923100034.GA23118@elte.hu> <20080923193106.GA21422@elte.hu> <48DA0A09.5080709@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <48DA0A09.5080709@gmail.com>
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


* Frédéric Weisbecker <fweisbec@gmail.com> wrote:

> Ingo Molnar a écrit :
> > * Ingo Molnar <mingo@elte.hu> wrote:
> > 
> >> i've integrated tip/tracing/fastboot into tip/master and have started 
> >> testing it. It passed the basic tests already so i've just pushed out 
> >> the new tip/master. Please double-check that i have not messed up the 
> >> rename or the integration somewhere.
> > 
> > FYI, -tip testing found a boot hang with CONFIG_BOOT_TRACER=y, on a 
> > 32-bit T60 laptop. I've attached the config that provokes the hang. (you 
> > need initcall_debug on the boot commandline)
> > 
> > The hang always happens after a specific initcall, shortly after tracing 
> > is enabled. It just hangs indefinitely there, the last line displayed 
> > was:
> > 
> >  [   0.004017] initcall ehci_hcd_init+0x0/0x80 returned 0 after 228 msecs
> > 
> > it should have printed this next:
> > 
> > [    0.808024] calling  ohci_hcd_mod_init+0x0/0x80 @ 10
> > 
> > but that line is never printed.
> > 
> > i've bisected the hang down to this specific commit:
> > 
> >  | 35df98dfe2b2503436a8cfda301657810df50a3a is first bad commit
> >  | commit 35df98dfe2b2503436a8cfda301657810df50a3a
> >  | Author: Frédéric Weisbecker <fweisbec@gmail.com>
> >  | Date:   Tue Sep 23 11:38:18 2008 +0100
> >  |
> >  |     tracing/ftrace: launch boot tracing after pre-smp initcalls
> > 
> > An idea: maybe the boot tracer is interacting with the ftrace self-tests 
> > somehow? CONFIG_FTRACE_SELFTEST=y is enabled.
> > 
> > another thing i noticed is that the sysprof tracer was initialized and 
> > self-tested shortly before the hang occured. Might be unrelated.
> > 
> > the bisection log is:
> > 
> >  # bad:  [6522eab5] Merge branch 'x86/uv'
> >  # good: [699b81f5] Merge branch 'x86/iommu'
> >  # bad:  [8007aae9] timers: fix build error in !oneshot case
> >  # good: [7f29b23d] Merge branch 'core/rcu'
> >  # bad:  [a54f17e3] manual merge of tracing/fastboot
> >  # good: [bcbbe946] tracing/ftrace: make tracing suitable to run the b
> >  # good: [d7095e5a] Merge branch 'fastboot'
> >  # bad:  [35df98df] tracing/ftrace: launch boot tracing after pre-smp
> >  # good: [42aaa6be] tracing/ftrace: give an entry on the config for bo
> > 
> > 	Ingo
> > 
> Ingo Molnar a écrit :
> > * Ingo Molnar <mingo@elte.hu> wrote:
> > 
> >> i've integrated tip/tracing/fastboot into tip/master and have started 
> >> testing it. It passed the basic tests already so i've just pushed out 
> >> the new tip/master. Please double-check that i have not messed up the 
> >> rename or the integration somewhere.
> > 
> > FYI, -tip testing found a boot hang with CONFIG_BOOT_TRACER=y, on a 
> > 32-bit T60 laptop. I've attached the config that provokes the hang. (you 
> > need initcall_debug on the boot commandline)
> > 
> > The hang always happens after a specific initcall, shortly after tracing 
> > is enabled. It just hangs indefinitely there, the last line displayed 
> > was:
> > 
> >  [   0.004017] initcall ehci_hcd_init+0x0/0x80 returned 0 after 228 msecs
> > 
> > it should have printed this next:
> > 
> > [    0.808024] calling  ohci_hcd_mod_init+0x0/0x80 @ 10
> > 
> > but that line is never printed.
> > 
> > i've bisected the hang down to this specific commit:
> > 
> >  | 35df98dfe2b2503436a8cfda301657810df50a3a is first bad commit
> >  | commit 35df98dfe2b2503436a8cfda301657810df50a3a
> >  | Author: Frédéric Weisbecker <fweisbec@gmail.com>
> >  | Date:   Tue Sep 23 11:38:18 2008 +0100
> >  |
> >  |     tracing/ftrace: launch boot tracing after pre-smp initcalls
> > 
> > An idea: maybe the boot tracer is interacting with the ftrace self-tests 
> > somehow? CONFIG_FTRACE_SELFTEST=y is enabled.
> > 
> > another thing i noticed is that the sysprof tracer was initialized and 
> > self-tested shortly before the hang occured. Might be unrelated.
> > 
> > the bisection log is:
> > 
> >  # bad:  [6522eab5] Merge branch 'x86/uv'
> >  # good: [699b81f5] Merge branch 'x86/iommu'
> >  # bad:  [8007aae9] timers: fix build error in !oneshot case
> >  # good: [7f29b23d] Merge branch 'core/rcu'
> >  # bad:  [a54f17e3] manual merge of tracing/fastboot
> >  # good: [bcbbe946] tracing/ftrace: make tracing suitable to run the b
> >  # good: [d7095e5a] Merge branch 'fastboot'
> >  # bad:  [35df98df] tracing/ftrace: launch boot tracing after pre-smp
> >  # good: [42aaa6be] tracing/ftrace: give an entry on the config for bo
> > 
> > 	Ingo
> > 
> 
> Hehe! I was preparing a patch because I saw last night that the self-tests were reseting and touching the ring-buffer during the initcall tracing.
> And now I can see the results of this problem....
> 
> Following is a patch that should fix it.

applied to tip/tracing/fastboot, thanks Frédéric!

	Ingo
