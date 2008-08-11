Return-Path: <linux-kernel-owner+w=401wt.eu-S1755401AbYHKSRS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755401AbYHKSRS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 14:17:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752804AbYHKSRJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 14:17:09 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:48395 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751878AbYHKSRI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 14:17:08 -0400
Date: Mon, 11 Aug 2008 20:16:42 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Max.Krasnyansky@qualcomm.com
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Max Krasnyansky <maxk@qualcomm.com>, lizf@cn.fujitsu.com,
       jeff.chua.linux@gmail.com, Glauber Costa <gcosta@redhat.com>
Subject: Re: [PATCH] Resurect proper handling of maxcpus= kernel option
Message-ID: <20080811181642.GS4524@elte.hu>
References: <1218052854-5020-1-git-send-email-Krasnyansky@qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1218052854-5020-1-git-send-email-Krasnyansky@qualcomm.com>
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


* Max.Krasnyansky@qualcomm.com <Max.Krasnyansky@qualcomm.com> wrote:

> From: Max Krasnyansky <maxk@qualcomm.com>
> 
> For some reason we had redundant parsers registered for maxcpus=. One 
> in init/main.c and another in arch/x86/smpboot.c So I nuked the one in 
> arch/x86.
> 
> Also 64-bit kernels used to handle maxcpus= as documented in 
> Documentation/cpu-hotplug.txt. CPUs with 'id > maxcpus' are 
> initialized but not booted. 32-bit version for some reason ignored 
> them even though all the infrastructure for booting them later is 
> there.
> 
> In the current mainline both 64 and 32 bit versions are broken. I'm 
> too lazy to look through git history but I'm guessing it happened as 
> part of the i386 and x86_64 unification.

yes in essence. 32-bit always had maxcpus as a hard restriction in the 
number of CPUs. This got extended to 64-bit as well, via commit 
89b08200ad:

    x86: make x86_64 accept the max_cpus parameter

in v2.6.25. Two major kernel releases and nobody noticed - it's a rarely 
used option.

> This patch restores the correct behaviour. I've tested x86_64 version 
> on 4- and 8- way Core2 and 2-way Opteron based machines. Various 
> config combinations SMP, !SMP, CPU_HOTPLUG, !CPU_HOTPLUG. Booted with 
> maxcpus=1 and maxcpus=4, etc. Everything is working as expected.
> 
> I cannot test 32-bit version (no 32-bit machines here).

This will need some test time on 32-bit as that is where this represents 
a material change. ( albeit what matters most is the maxcpus=1 
distinction - and for that nosmp can be used as well to turn off 
multi-cpu support altogether. So we could do this in v2.6.27 as well. )

Also, a quick grep shows that your patch will very likely break the 
visws build:

 arch/x86/kernel/visws_quirks.c:extern unsigned int __cpuinitdata maxcpus;
 arch/x86/kernel/visws_quirks.c:        if (ncpus > maxcpus)
 arch/x86/kernel/visws_quirks.c:                ncpus = maxcpus;

could you please fix that?

	Ingo
