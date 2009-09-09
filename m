Return-Path: <linux-kernel-owner+w=401wt.eu-S1752356AbZIIMsj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752356AbZIIMsj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 08:48:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751510AbZIIMsi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 08:48:38 -0400
Received: from mail.gmx.net ([213.165.64.20]:56637 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751213AbZIIMsh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 08:48:37 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+lpo0MvR6lsmqxRuAN7SBlDzlhII5S5g+DjO7kZN
	86MUeD3LqBFS5o
Subject: Re: BFS vs. mainline scheduler benchmarks and measurements
From: Mike Galbraith <efault@gmx.de>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Con Kolivas <kernel@kolivas.org>, linux-kernel@vger.kernel.org
In-Reply-To: <20090909115429.GY18599@kernel.dk>
References: <20090907115750.GW18599@kernel.dk>
	 <20090907141458.GD24507@elte.hu> <20090907173846.GB18599@kernel.dk>
	 <20090907204458.GJ18599@kernel.dk> <20090908091304.GQ18599@kernel.dk>
	 <1252423398.7746.97.camel@twins> <20090908203409.GJ18599@kernel.dk>
	 <20090909061308.GA28109@elte.hu>
	 <1252486344.28645.18.camel@marge.simson.net>
	 <20090909091009.GR18599@kernel.dk>  <20090909115429.GY18599@kernel.dk>
Content-Type: text/plain
Date: Wed, 09 Sep 2009 14:48:36 +0200
Message-Id: <1252500516.6170.20.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.53
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-09-09 at 13:54 +0200, Jens Axboe wrote:

> Things are much better with this patch on the notebook! I cannot compare
> with BFS as that still doesn't run anywhere I want it to run, but it's
> way better than -rc9-git stock. latt numbers on the notebook have 1/3
> the max latency, average is lower, and stddev is much smaller too.

That patch has a bit of bustage in it.

We definitely want to turn down sched_latency though, and LAST_BUDDY
also wants some examination it seems.

taskset -c 3 ./xx 1 (100% cpu 1 sec interval perturbation measurement proggy.  overhead is what it is not getting)
xx says
2392.52 MHZ CPU
perturbation threshold 0.057 usecs.
...
'nuther terminal
taskset -c 3 make -j2 vmlinux

xx output

current (fixed breakage) patched tip tree
pert/s:      153 >18842.18us:       11 min:  0.50 max:36010.37 avg:4354.06 sum/s:666171us overhead:66.62%
pert/s:      160 >18767.18us:       12 min:  0.13 max:32011.66 avg:4172.69 sum/s:667631us overhead:66.66%
pert/s:      156 >18499.43us:        9 min:  0.13 max:27883.24 avg:4296.08 sum/s:670189us overhead:66.49%
pert/s:      146 >18480.71us:       10 min:  0.50 max:32009.38 avg:4615.19 sum/s:673818us overhead:67.26%
pert/s:      154 >18433.20us:       17 min:  0.14 max:31537.12 avg:4474.14 sum/s:689018us overhead:67.68%
pert/s:      158 >18520.11us:        9 min:  0.50 max:34328.86 avg:4275.66 sum/s:675554us overhead:66.76%
pert/s:      154 >18683.74us:       12 min:  0.51 max:35949.23 avg:4363.67 sum/s:672005us overhead:67.04%
pert/s:      154 >18745.53us:        8 min:  0.51 max:34203.43 avg:4399.72 sum/s:677556us overhead:67.03%

bfs209
pert/s:      124 >18681.88us:       17 min:  0.15 max:27274.74 avg:4627.36 sum/s:573793us overhead:56.70%
pert/s:      106 >18702.52us:       20 min:  0.55 max:32022.07 avg:5754.48 sum/s:609975us overhead:59.80%
pert/s:      116 >19082.42us:       17 min:  0.15 max:39835.34 avg:5167.69 sum/s:599452us overhead:59.95%
pert/s:      109 >19289.41us:       22 min:  0.14 max:36818.95 avg:5485.79 sum/s:597951us overhead:59.64%
pert/s:      108 >19238.97us:       19 min:  0.14 max:32026.74 avg:5543.17 sum/s:598662us overhead:59.87%
pert/s:      106 >19415.76us:       20 min:  0.54 max:36011.78 avg:6001.89 sum/s:636201us overhead:62.95%
pert/s:      115 >19341.89us:       16 min:  0.08 max:32040.83 avg:5313.45 sum/s:611047us overhead:59.98%
pert/s:      101 >19527.53us:       24 min:  0.14 max:36018.37 avg:6378.06 sum/s:644184us overhead:64.42%

stock tip (ouch ouch ouch)
pert/s:      153 >48453.23us:        5 min:  0.12 max:144009.85 avg:4688.90 sum/s:717401us overhead:70.89%
pert/s:      172 >47209.49us:        3 min:  0.48 max:68009.05 avg:4022.55 sum/s:691879us overhead:67.05%
pert/s:      148 >51139.18us:        5 min:  0.53 max:168094.76 avg:4918.14 sum/s:727885us overhead:71.65%
pert/s:      171 >51350.64us:        6 min:  0.12 max:102202.79 avg:4304.77 sum/s:736115us overhead:69.24%
pert/s:      153 >57686.54us:        5 min:  0.12 max:224019.85 avg:5399.31 sum/s:826094us overhead:74.50%
pert/s:      172 >55886.47us:        2 min:  0.11 max:75378.18 avg:3993.52 sum/s:686885us overhead:67.67%
pert/s:      157 >58819.31us:        3 min:  0.12 max:165976.63 avg:4453.16 sum/s:699146us overhead:69.91%
pert/s:      149 >58410.21us:        5 min:  0.12 max:104663.89 avg:4792.73 sum/s:714116us overhead:71.41%

sched_latency=20ms min_granularity=4ms
pert/s:      162 >30152.07us:        2 min:  0.49 max:60011.85 avg:4272.97 sum/s:692221us overhead:68.13%
pert/s:      147 >29705.33us:        8 min:  0.14 max:46577.27 avg:4792.03 sum/s:704428us overhead:70.44%
pert/s:      162 >29344.16us:        2 min:  0.49 max:48010.50 avg:4176.75 sum/s:676633us overhead:67.40%
pert/s:      155 >29109.69us:        2 min:  0.49 max:49575.08 avg:4423.87 sum/s:685700us overhead:68.30%
pert/s:      153 >30627.66us:        3 min:  0.13 max:84005.71 avg:4573.07 sum/s:699680us overhead:69.42%
pert/s:      142 >30652.47us:        5 min:  0.49 max:56760.06 avg:4991.61 sum/s:708808us overhead:70.88%
pert/s:      152 >30101.12us:        2 min:  0.49 max:45757.88 avg:4519.92 sum/s:687028us overhead:67.89%
pert/s:      161 >29303.50us:        3 min:  0.12 max:40011.73 avg:4238.15 sum/s:682342us overhead:67.43%

NO_LAST_BUDDY
pert/s:      154 >15257.87us:       28 min:  0.13 max:42004.05 avg:4590.99 sum/s:707013us overhead:70.41%
pert/s:      162 >15392.05us:       34 min:  0.12 max:29021.79 avg:4177.47 sum/s:676750us overhead:66.81%
pert/s:      162 >15665.11us:       33 min:  0.13 max:32008.34 avg:4237.10 sum/s:686410us overhead:67.90%
pert/s:      159 >15914.89us:       31 min:  0.56 max:32056.86 avg:4268.87 sum/s:678751us overhead:67.47%
pert/s:      166 >15858.94us:       26 min:  0.13 max:26655.84 avg:4055.02 sum/s:673134us overhead:66.65%
pert/s:      165 >15878.96us:       32 min:  0.13 max:28010.44 avg:4107.86 sum/s:677798us overhead:66.68%
pert/s:      164 >16213.55us:       29 min:  0.14 max:34263.04 avg:4186.64 sum/s:686610us overhead:68.04%
pert/s:      149 >16764.54us:       20 min:  0.13 max:38688.64 avg:4758.26 sum/s:708981us overhead:70.23%

