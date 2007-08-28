Return-Path: <linux-kernel-owner+w=401wt.eu-S1756951AbXH1JH3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756951AbXH1JH3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 05:07:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752777AbXH1JHT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 05:07:19 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:56885 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751620AbXH1JHS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 05:07:18 -0400
Date: Tue, 28 Aug 2007 11:07:09 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Hugh Dickins <hugh@veritas.com>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: fix bogus hotplug cpu warning
Message-ID: <20070828090709.GA24578@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


this commit:

 commit d243769d3f83b318813a04a9592bb7cfedc6c280
 Author: Hugh Dickins <hugh@veritas.com>
 Date:   Mon Aug 27 16:06:19 2007 +0100

    fix bogus hotplug cpu warning

    Fix bogus DEBUG_PREEMPT warning on x86_64, when cpu brought online 
    after bootup: current_is_keventd is right to note its use of 
    smp_processor_id is preempt-safe, but should use 
    raw_smp_processor_id to avoid the warning.

-       int cpu = smp_processor_id();   /* preempt-safe: keventd is per-cpu */
+       int cpu = raw_smp_processor_id(); /* preempt-safe: keventd is per-cpu */

is incorrect. smp_processor_id() will _not_ warn about true per-cpu 
tasks:

        /*
         * Kernel threads bound to a single CPU can safely use
         * smp_processor_id():
         */
        this_mask = cpumask_of_cpu(this_cpu);

        if (cpus_equal(current->cpus_allowed, this_mask))
                goto out;

so if this check triggered for the cpu-offline code it's because keventd 
was _not_ per-cpu (perhaps because the cpu offline code broke its 
affinity?). So your patch hides a real bug.

	Ingo
