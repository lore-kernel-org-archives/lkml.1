Return-Path: <linux-kernel-owner+w=401wt.eu-S1755980AbYF0KzO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755980AbYF0KzO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 06:55:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755692AbYF0Ky4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 06:54:56 -0400
Received: from saeurebad.de ([85.214.36.134]:38214 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755650AbYF0Kyy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 06:54:54 -0400
From: Johannes Weiner <hannes@saeurebad.de>
To: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
Cc: Andrew Morton <akpm@linux-foundation.org>, tzanussi@gmail.com,
       penberg@cs.helsinki.fi, torvalds@linux-foundation.org,
       compudj@krystal.dyndns.org, vegard.nossum@gmail.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] Full conversion to early_initcall() interface, remove old interface.
References: <20080623153056.1862c14e@linux360.ro>
	<20080623172742.be332a53.akpm@linux-foundation.org>
	<20080625120151.56180b47@linux360.ro>
Date: Fri, 27 Jun 2008 12:54:21 +0200
In-Reply-To: <20080625120151.56180b47@linux360.ro> (Eduard's message of "Wed,
	25 Jun 2008 12:01:51 +0300")
Message-ID: <87d4m3ywpu.fsf@skyscraper.fehenstaub.lan>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Eduard,

Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro> writes:

> A previous patch added the early_initcall(), to allow a cleaner hooking of
> pre-SMP initcalls. Now we remove the older interface, converting all
> existing users to the new one.
>
> Signed-off-by: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
> ---
>  include/linux/sched.h |   12 ------------
>  include/linux/smp.h   |    8 --------
>  init/main.c           |   23 +----------------------
>  kernel/sched.c        |    6 +++++-
>  kernel/smp.c          |    6 +++++-
>  kernel/softirq.c      |    4 +++-
>  kernel/softlockup.c   |   27 ++++++++++++++++++++++++---
>  7 files changed, 38 insertions(+), 48 deletions(-)
...
> diff --git a/kernel/softirq.c b/kernel/softirq.c
> index 0592568..efab66a 100644
> --- a/kernel/softirq.c
> +++ b/kernel/softirq.c
> @@ -658,7 +658,7 @@ static struct notifier_block __cpuinitdata cpu_nfb = {
>  	.notifier_call = cpu_callback
>  };
>  
> -__init int spawn_ksoftirqd(void)
> +static int __init spawn_ksoftirqd(void)
>  {
>  	void *cpu = (void *)(long)smp_processor_id();
>  	int err = cpu_callback(&cpu_nfb, CPU_UP_PREPARE, cpu);
> @@ -669,6 +669,8 @@ __init int spawn_ksoftirqd(void)
>  	return 0;
>  }

You forgot to remove the declaration from linux/interrupt.h.

Andrew, the following fix is needed for -mmotm:

From: Johannes Weiner <hannes@saeurebad.de>
Subject: full-conversion-to-early_initcall-interface-remove-old-interface-fix

Original patch made spawn_softirqd() static but failed to remove the
global definition.  Do so now.

Signed-off-by: Johannes Weiner <hannes@saeurebad.de>
---

diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h
index 30da779..62aa4f8 100644
--- a/include/linux/interrupt.h
+++ b/include/linux/interrupt.h
@@ -299,7 +299,6 @@ extern void softirq_init(void);
 #define __raise_softirq_irqoff(nr) do { or_softirq_pending(1UL << (nr)); } while (0)
 extern void raise_softirq_irqoff(unsigned int nr);
 extern void raise_softirq(unsigned int nr);
-extern int spawn_ksoftirqd(void);
 
 
 /* Tasklets --- multithreaded analogue of BHs.
