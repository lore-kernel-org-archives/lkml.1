Return-Path: <linux-kernel-owner+w=401wt.eu-S1755556AbZHULsA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755556AbZHULsA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 07:48:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755473AbZHULr7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 07:47:59 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:54386 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755129AbZHULr7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 07:47:59 -0400
Date: Fri, 21 Aug 2009 13:46:45 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jes Sorensen <jes@sgi.com>, Jens Axboe <jens.axboe@oracle.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Yinghai Lu <yinghai@kernel.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Latest Linus tree oopses on Nehalem box
Message-ID: <20090821114645.GD24647@elte.hu>
References: <4A8E7CBE.3020209@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A8E7CBE.3020209@sgi.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jes Sorensen <jes@sgi.com> wrote:

> Hi,
>
> I am seeing this one with the latest Linus' git tree as of this 
> morning on a Nehalem box. Using the defconfig + megaraid driver.
>
> Not sure if this is already fixed, or if someone already knows 
> whats wrong? Smells like a yet another BIOS bug - yes the BIOS on 
> this thing is rubbish.

my Nehalem (16 logical cpus) boots fine:

 aldebaran:~> uname -a
 Linux aldebaran 2.6.31-rc6-tip-01272-g9919e28-dirty #1518 SMP Fri 
 Aug 21 11:13:12 CEST 2009 x86_64 x86_64 x86_64 GNU/Linux

> [    6.664800] RIP: 0010:[<ffffffff810391e7>]  [<ffffffff810391e7>]  
> find_busiest_group+0x620/0x6fd 

Nothing similar is open at the moment.

There's only one open .31 scheduler regression bug at the moment: a 
rare division by zero bug that sometimes crashes boxes - the bigger 
the box the likelier the crash.

Your crash looks to be one of:

 1) a genuine scheduler bug tickled on your new hardware. Needs to 
    be bisected/debugged/fixed.

 2) a BIOS bug passing crappy ACPI tables which cause us to create a
    buggy sched-domains tree or so. We do treat ACPI data as 
    external untrusted data and try to use it in sane ways only, but 
    such bugs have happened in the past and could happen again.

The scheduler has sanity check for the sched-domains arch setup: if 
you enable CONFIG_SCHED_DEBUG=y then sched_domain_debug() will 
become noisy in your syslog if there's something wrong (but wont 
stop the bootup so you have to actively check your syslog).

Might be useful to see your full crashlog, if you are allowed to 
post that, plus your kernel .config would be useful to know too. 
Plus would be useful to know whether this is a regression relative 
to .30 or a yet unfixed bug triggering on your class of hardware.

Thanks,

	Ingo
