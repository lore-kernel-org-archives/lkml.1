Return-Path: <linux-kernel-owner+w=401wt.eu-S1760207AbZBDVSh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760207AbZBDVSh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 16:18:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755150AbZBDVS2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 16:18:28 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:51169 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754712AbZBDVS1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 16:18:27 -0500
Date: Wed, 4 Feb 2009 22:17:59 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, Greg KH <greg@kroah.com>,
       ltt-dev@lists.casi.polymtl.ca, linux-kernel@vger.kernel.org
Subject: Re: [BUG] Linux 2.6.28.3 freezing on a 32-bits x86 Thinkpad T43p
Message-ID: <20090204211759.GK22608@elte.hu>
References: <20090204211106.GA30824@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090204211106.GA30824@Krystal>
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


* Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:

> Hi,
> 
> I've started experiencing freezes on my uniprocessor laptop with a
> 2.6.28.2/2.6.28.3 kernel with the LTTng patchset applied
> (http://git.kernel.org/?p=linux/kernel/git/compudj/linux-2.6-lttng.git;a=shortlog;h=2.6.28.3-lttng-0.88).
> Instrumentation is dynamically disabled when this happens, so it's
> unlikely that the LTTng patches would be causing this problem.
> 
> It happens when I work in X. The keyboard and mouse stop responding, and
> the machine stops answering to the network. It may take a few days to
> reproduce, and happens randomly when I actively use the computer (e.g
> surfing with firefox).
> 
> I managed to install a 50' serial cable through my appartment to capture
> the following OOPS. It points to a NULL pointer dereference in
> kernel/timer.c:cascade(). My config has hrtimers and no_hz activated.
> I suspect a race with with timer base lock or interrupt disabling
> protecting the timer base.
> 
> Any idea what is going on with the timers here ? In the meantime, I'll
> try to enable more debugging options to get more information when the
> problem reappears.

hm, it would be nice to know which timer got corrupted. It could possibly 
have gotten kfreed, reallocated, overwritten - and crashes things like this.

There's two ways to debug such things more directly:

1) enable CONFIG_PAGEALLOC=y. These days its plenty fast and its overhead 
   cannot be noticed.

2) enable DEBUGOBJECTS - you also need 'debugobjects' on the boot line for 
   this to be activated. This will report such corruptions sooner and in a 
   more specific way.

3) any particular reason why you have:

    # CONFIG_DEBUG_KERNEL is not set

   There's a number of goodies in that menu. CONFIG_LIST_DEBUG=y for 
   example.

It is highly unlikely that the timer list code is the culprit here - it has 
not changed in ages and it is very intensively used by all subsystems so 
breakages in it get found and reported very, very quickly.

btw., your stacktrace also has this:

>  [<c1010000>] kvm_mmu_pte_write+0xb0/0xa60

So in theory there could be some kvm induced memory corruption as well.

Hope this helps,

	Ingo
