Return-Path: <linux-kernel-owner+w=401wt.eu-S1757444AbZFCNN5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757444AbZFCNN5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 09:13:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754301AbZFCNNu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 09:13:50 -0400
Received: from mx2.redhat.com ([66.187.237.31]:55873 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753054AbZFCNNt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 09:13:49 -0400
Date: Wed, 3 Jun 2009 15:06:57 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Oleg Nesterov <oleg@redhat.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Paul Mackerras <paulus@samba.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [PATCH resend5 4/4] cputime: optimize jiffies_to_cputime(1)
Message-ID: <20090603150657.0a60a474@dhcp-lab-109.englab.brq.redhat.com>
In-Reply-To: <alpine.LFD.2.00.0905291406370.3397@localhost.localdomain>
References: <20090529131948.36174118@dhcp-lab-109.englab.brq.redhat.com>
	<alpine.LFD.2.00.0905291406370.3397@localhost.localdomain>
Organization: RedHat
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

> > This patch (with 3 previous) was compiled on x86, x86_64, ppc with
> > CONFIG_VIRT_CPU_ACCOUNTNG=n, ppc64 with CONFIG_VIRT_CPU_ACCOUNTING=y.
> > Run time testing was done only on x86.

I tested patches on ppc64 with CONFIG_VIRT_CPU_ACCOUNTING=y . Additionally I
measure impact of iffies_to_cputime(1) to cputime_one_jiffiy conversion on
check_cpu_itimer() calls with below code:

+       xstart = get_cycles();
+       barrier();
        check_cpu_itimer(tsk, &sig->it[CPUCLOCK_PROF], &prof_expires, ptime,
                         SIGPROF);
        check_cpu_itimer(tsk, &sig->it[CPUCLOCK_VIRT], &virt_expires, utime,
                         SIGVTALRM);
+       barrier();
+       xend = get_cycles();
+       check_cpu_itimer_cycles += xend - xstart;
+       check_cpu_itimer_n++;

Using cputime_one_jiffy was about 4% faster.

Cheers
Stanislaw
