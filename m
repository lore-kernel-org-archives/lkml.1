Return-Path: <linux-kernel-owner+w=401wt.eu-S1752075AbZDMRTq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752075AbZDMRTq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 13:19:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751483AbZDMRTg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 13:19:36 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:42694 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751200AbZDMRTf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 13:19:35 -0400
Date: Mon, 13 Apr 2009 19:18:53 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Valdis.Kletnieks@vt.edu, Mike Travis <travis@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       mm-commits@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
       Dave Jones <davej@redhat.com>
Subject: Re: mmotm 2009-04-10-02-21 uploaded - forkbombed by work_for_cpu
Message-ID: <20090413171853.GA4601@elte.hu>
References: <200904100922.n3A9MOIV013828@imap1.linux-foundation.org> <4609.1239456126@turing-police.cc.vt.edu> <alpine.LFD.2.00.0904130847500.4583@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0904130847500.4583@localhost.localdomain>
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


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> So I do think Andrew's commit is broken and we should think about 
> it a bit more, but I also think that Valdis' problem comes from 
> acpi-cpufreq just being damn stupid. Doing a 
> smp_call_function_single() to read two MSR's is going to be a 
> _lot_ more efficient than doing that crazy work_on_cpu() for that.
> 
> So the _real_ problem came through the commits like
> 
>     cpufreq: use work_on_cpu in acpi-cpufreq.c for drv_read and drv_write
>     cpumask: use work_on_cpu in acpi-cpufreq.c for read_measured_perf_ctrs
> 
> that were meant to reduce stack usage with big cpu masks. And 
> sure, the _old_ way of doing it was also stupid (it rescheduled 
> the process to the other CPU by using cpus_allowed()).
> 
> Mike, Ingo?

I think Andrew has a stack of fixes queued up, one of which should 
solve this problem too - which Mike tested - as the commit from 
Andrew has caused another regression as well.

There's no sha1 - the patch is in this thread on lkml:

  sysbench(oltp)+mysql 10% regression with 2.6.30-rc1

| From: Andrew Morton <akpm@linux-foundation.org>
|
| Atttempting to rid us of the problematic work_on_cpu().  Just use
| smp_call_fuction_single() here.
|
| This repairs a 10% sysbench(oltp)+mysql regression which Mike 
| reported,

	Ingo
