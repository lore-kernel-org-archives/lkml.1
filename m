Return-Path: <linux-kernel-owner+w=401wt.eu-S1755379AbZJDKvd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755379AbZJDKvd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Oct 2009 06:51:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754584AbZJDKvc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Oct 2009 06:51:32 -0400
Received: from mail.gmx.net ([213.165.64.20]:47862 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754141AbZJDKvb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Oct 2009 06:51:31 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/GLk9x/nPGyhWCEJwv5Q6+FwAYCNOB+nM6s/EIl6
	fMPUaYdwHKZpja
Subject: Re: Do not overload dispatch queue (Was: Re: IO scheduler based IO
 controller V10)
From: Mike Galbraith <efault@gmx.de>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ulrich Lukas <stellplatz-nr.13a@datenparkplatz.de>,
       linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       dm-devel@redhat.com, nauman@google.com, dpshah@google.com,
       lizf@cn.fujitsu.com, mikew@google.com, fchecconi@gmail.com,
       paolo.valente@unimore.it, ryov@valinux.co.jp, fernando@oss.ntt.co.jp,
       jmoyer@redhat.com, dhaval@linux.vnet.ibm.com, balbir@linux.vnet.ibm.com,
       righi.andrea@gmail.com, m-ikeda@ds.jp.nec.com, agk@redhat.com,
       akpm@linux-foundation.org, peterz@infradead.org, jmarchan@redhat.com,
       riel@redhat.com
In-Reply-To: <1254599386.7153.46.camel@marge.simson.net>
References: <20091003124049.GB12925@redhat.com>
	 <20091003132115.GB31616@kernel.dk> <20091003135623.GD12925@redhat.com>
	 <1254578553.7499.5.camel@marge.simson.net>
	 <20091003142840.GE31616@kernel.dk>
	 <1254581496.8293.8.camel@marge.simson.net>
	 <20091003151445.GF31616@kernel.dk>
	 <1254585420.7539.2.camel@marge.simson.net>
	 <20091003173532.GG31616@kernel.dk>
	 <1254596864.7153.9.camel@marge.simson.net>
	 <20091003192321.GA26573@kernel.dk>
	 <1254599386.7153.46.camel@marge.simson.net>
Content-Type: text/plain
Date: Sun, 04 Oct 2009 12:50:34 +0200
Message-Id: <1254653434.7237.18.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-10-03 at 21:49 +0200, Mike Galbraith wrote:

> It's a huge winner for sure, and there's no way to quantify.  I'm just
> afraid the other shoe will drop from what I see/hear.  I should have
> kept my trap shut and waited really, but the impression was strong.

Seems there was one "other shoe" at least.  For concurrent read vs
write, we're losing ~10% throughput that we weren't losing prior to that
last commit.  I got it back, and the concurrent git throughput back as
well with the tweak below, _seemingly_ without significant sacrifice.

cfq-iosched:  adjust async delay.

8e29675: "implement slower async initiate and queue ramp up" introduced a
throughput regression for concurrent reader vs writer.  Adjusting async delay
to use cfq_slice_async, unless someone adjusts async to have more bandwidth
allocation than sync, restored throughput.

Signed-off-by: Mike Galbraith <efault@gmx.de>

---
 block/cfq-iosched.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

Index: linux-2.6/block/cfq-iosched.c
===================================================================
--- linux-2.6.orig/block/cfq-iosched.c
+++ linux-2.6/block/cfq-iosched.c
@@ -1343,17 +1343,19 @@ static int cfq_dispatch_requests(struct
 	 */
 	if (!cfq_cfqq_sync(cfqq) && cfqd->cfq_desktop) {
 		unsigned long last_sync = jiffies - cfqd->last_end_sync_rq;
+		unsigned long slice = max(cfq_slice_sync, cfq_slice_async);
 		unsigned int depth;
 
+		slice = min(slice, cfq_slice_async);
 		/*
 		 * must wait a bit longer
 		 */
-		if (last_sync < cfq_slice_sync) {
-			cfq_schedule_dispatch(cfqd, cfq_slice_sync - last_sync);
+		if (last_sync < slice) {
+			cfq_schedule_dispatch(cfqd, slice - last_sync);
 			return 0;
 		}
 
-		depth = last_sync / cfq_slice_sync;
+		depth = last_sync / slice;
 		if (depth < max_dispatch)
 			max_dispatch = depth;
 	}

--numbers--

dd vs konsole -e exit
 1.70     1.94     1.32     1.89     1.87    1.7     fairness=1 overload_delay=1
 1.55     1.79     1.38     1.53     1.57    1.5     desktop=1 +last_end_sync
 1.09     0.87     1.11     0.96     1.11    1.02    block-for-linus
 1.10     1.13     0.98     1.11     1.13    1.09    block-for-linus + tweak

concurrent git test
                                                 Avg
108.12   106.33    106.34    97.00    106.52   104.8  1.000 virgin
 89.81    88.82     91.56    96.57     89.38    91.2   .870 desktop=1 +last_end_sync
 92.61    94.60     92.35    93.17     94.05    93.3   .890 blk-for-linus
 89.33    88.82     89.99    88.54     89.09    89.1   .850 blk-for-linus + tweak

read vs write test

desktop=0                                Avg
elapsed        98.23    91.97   91.77    93.9  sec   1.000
30s-dd-read     48.5     49.6    49.1    49.0  mb/s  1.000
30s-dd-write    23.1     27.3    31.3    27.2        1.000
dd-read-total   49.4     50.1    49.6    49.7        1.000
dd-write-total  34.5     34.9    34.9    34.7        1.000

desktop=1 pop 8e296755                    Avg
elapsed        93.30    92.77    90.11   92.0         .979
30s-dd-read     50.5     50.4     51.8   50.9        1.038 
30s-dd-write    22.7     26.4     27.7   25.6         .941
dd-read-total   51.2     50.1     51.6   50.9        1.024 
dd-write-total  34.2     34.5     35.6   34.7        1.000

desktop=1 push 8e296755                   Avg
elapsed       104.51   104.52   101.20  103.4        1.101
30s-dd-read     43.0     43.6     44.5   43.7         .891
30s-dd-write    21.4     23.9     28.9   24.7         .908
dd-read-total   42.9     43.0     43.5   43.1         .867
dd-write-total  30.4     30.3     31.5   30.7         .884

desktop=1 push 8e296755 + tweak           Avg
elapsed        92.10    94.34    93.68   93.3         .993
30s-dd-read     49.7     49.3     48.8   49.2        1.004 
30s-dd-write    23.7     27.1     23.1   24.6         .904
dd-read-total   50.2     50.1     48.7   49.6         .997
dd-write-total  34.7     33.9     34.0   34.2         .985

#!/bin/sh

# dd if=/dev/zero of=deleteme bs=1M count=3000

echo 2 > /proc/sys/vm/drop_caches

dd if=/dev/zero of=deleteme2 bs=1M count=3000 &
dd if=deleteme of=/dev/null bs=1M count=3000 &
sleep 30
killall -q -USR1 dd &
wait
rm -f deleteme2
sync



