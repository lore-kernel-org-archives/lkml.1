Return-Path: <linux-kernel-owner+w=401wt.eu-S1754187Ab0AUMW4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754187Ab0AUMW4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 07:22:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753800Ab0AUMW4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 07:22:56 -0500
Received: from mx1.redhat.com ([209.132.183.28]:38511 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753756Ab0AUMWz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 07:22:55 -0500
Date: Thu, 21 Jan 2010 10:22:25 -0200
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: perf top: losing events?
Message-ID: <20100121122224.GA21083@ghostprotocols.net>
References: <1264052528.26323.13.camel@marge.simson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1264052528.26323.13.camel@marge.simson.net>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Jan 21, 2010 at 06:42:08AM +0100, Mike Galbraith escreveu:
> Greetings Arnaldo,
> 
> ------------------------------------------------------------------------------------------------------------------------------
>    PerfTop:     670 irqs/sec  kernel:14.6% [1000Hz cycles],  (all, cpu: 3)
> ------------------------------------------------------------------------------------------------------------------------------
> 
>              samples  pcnt function            DSO
>              _______ _____ ___________________ ________________________________________________________________
> 
>             12535.00 82.1% main                /root/bin/pert
>               302.00  2.0% clear_page_c        [kernel.kallsyms]
>               169.00  1.1% _int_malloc         /lib64/libc-2.9.so
>               168.00  1.1% page_fault          [kernel.kallsyms]
>               138.00  0.9% yylex               /usr/local/src/kernel/linux-2.6.33.git/scripts/genksyms/genksyms
>               121.00  0.8% __GI_memset         /lib64/libc-2.9.so
>               117.00  0.8% copy_page_c         [kernel.kallsyms]
>                96.00  0.6% _raw_spin_lock      [kernel.kallsyms]
>                79.00  0.5% use_config          /usr/local/src/kernel/linux-2.6.33.git/scripts/basic/fixdep
> 
> If only 100% userland hog (pert) is running, I see the expected 1KHz
> irqs/sec.  As soon as I start a kbuild with it, irqs/sec drops, though
> NMIs are indeed happening at 1KHz.
> 
> Bisection points to 5b2bb75 perf top: Support userspace symbols too.

Can you check if this one helps? 

- Arnaldo

diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 7a8a77e..8b04988 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -934,8 +934,11 @@ static void event__process_sample(const event_t *self,
 	struct addr_location al;
 	u8 origin = self->header.misc & PERF_RECORD_MISC_CPUMODE_MASK;
 
+	++samples;
+
 	switch (origin) {
 	case PERF_RECORD_MISC_USER:
+		++userspace_samples;
 		if (hide_user_symbols)
 			return;
 		break;
@@ -960,9 +963,6 @@ static void event__process_sample(const event_t *self,
 		if (list_empty(&syme->node) || !syme->node.next)
 			__list_insert_active_sym(syme);
 		pthread_mutex_unlock(&active_symbols_lock);
-		if (origin == PERF_RECORD_MISC_USER)
-			++userspace_samples;
-		++samples;
 	}
 }
 
