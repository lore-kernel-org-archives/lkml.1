Return-Path: <linux-kernel-owner+w=401wt.eu-S1753512AbZHMIf4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753512AbZHMIf4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 04:35:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753244AbZHMIf4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 04:35:56 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:48413 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753051AbZHMIfz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 04:35:55 -0400
Date: Thu, 13 Aug 2009 10:35:24 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
       Andrew Morton <akpm@linux-foundation.org>,
       "lizf@cn.fujitsu.com" <lizf@cn.fujitsu.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       "menage@google.com" <menage@google.com>, xemul@openvz.org,
       prarit@redhat.com, andi.kleen@intel.com,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [UPDATED][PATCH][mmotm] Help Root Memory Cgroup Resource
	Counters Scale Better (v5)
Message-ID: <20090813083524.GC21389@elte.hu>
References: <20090813065504.GG5087@balbir.in.ibm.com> <20090813162640.fe2349e9.nishimura@mxp.nes.nec.co.jp> <20090813080206.GH5087@balbir.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090813080206.GH5087@balbir.in.ibm.com>
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


* Balbir Singh <balbir@linux.vnet.ibm.com> wrote:

> Without Patch
> 
>  Performance counter stats for '/home/balbir/parallel_pagefault':
> 
>   5826093739340  cycles                   #    809.989 M/sec
>    408883496292  instructions             #      0.070 IPC
>      7057079452  cache-references         #      0.981 M/sec
>      3036086243  cache-misses             #      0.422 M/sec

> With this patch applied
> 
>  Performance counter stats for '/home/balbir/parallel_pagefault':
> 
>   5957054385619  cycles                   #    828.333 M/sec
>   1058117350365  instructions             #      0.178 IPC
>      9161776218  cache-references         #      1.274 M/sec
>      1920494280  cache-misses             #      0.267 M/sec

Nice how the instruction count and the IPC value incraesed, and the 
cache-miss count decreased.

Btw., a 'perf stat' suggestion: you can also make use of built-in 
error bars via repeating parallel_pagefault N times:

  aldebaran:~> perf stat --repeat 3 /bin/ls

 Performance counter stats for '/bin/ls' (3 runs):

       1.108886  task-clock-msecs         #      0.875 CPUs    ( +-   4.316% )
              0  context-switches         #      0.000 M/sec   ( +-   0.000% )
              0  CPU-migrations           #      0.000 M/sec   ( +-   0.000% )
            254  page-faults              #      0.229 M/sec   ( +-   0.000% )
        3461896  cycles                   #   3121.958 M/sec   ( +-   3.508% )
        3044445  instructions             #      0.879 IPC     ( +-   0.134% )
          21213  cache-references         #     19.130 M/sec   ( +-   1.612% )
           2610  cache-misses             #      2.354 M/sec   ( +-  39.640% )

    0.001267355  seconds time elapsed   ( +-   4.762% )

that way even small changes in metrics can be identified as positive 
effects of a patch, if the improvement is beyond the error 
percentage that perf reports.

For example in the /bin/ls numbers i cited above, the 'instructions' 
value can be trusted up to 99.8% (with a ~0.13% noise), while say 
the cache-misses value can not really be trusted, as it has 40% of 
noise. (Increasing the repeat count will drive down the noise level 
- at the cost of longer measurement time.)

For your patch the improvement is so drastic that this isnt needed - 
but the error estimations can be quite useful for more borderline 
improvements. (and they are also useful in finding and proving small 
performance regressions)

	Ingo
