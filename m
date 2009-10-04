Return-Path: <linux-kernel-owner+w=401wt.eu-S1755117AbZJDLed@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755117AbZJDLed (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Oct 2009 07:34:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753613AbZJDLed
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Oct 2009 07:34:33 -0400
Received: from mail.gmx.net ([213.165.64.20]:35805 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753257AbZJDLec (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Oct 2009 07:34:32 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX192qpQ21wB2Pksvr3yhs3TuBt1VrpUpjw62ARxcWN
	cvnWnaRgGNJKjq
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
In-Reply-To: <1254653434.7237.18.camel@marge.simson.net>
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
	 <1254653434.7237.18.camel@marge.simson.net>
Content-Type: text/plain
Date: Sun, 04 Oct 2009 13:33:33 +0200
Message-Id: <1254656013.7098.2.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.5600000000000001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wrong one.  Let's try the post java version instead.

8e29675: "implement slower async initiate and queue ramp up" introduced a
throughput regression for concurrent reader vs writer.  Adjusting async delay
to use cfq_slice_async restored throughput.

Signed-off-by: Mike Galbraith <efault@gmx.de>

---
 block/cfq-iosched.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

Index: linux-2.6/block/cfq-iosched.c
===================================================================
--- linux-2.6.orig/block/cfq-iosched.c
+++ linux-2.6/block/cfq-iosched.c
@@ -1343,17 +1343,18 @@ static int cfq_dispatch_requests(struct
 	 */
 	if (!cfq_cfqq_sync(cfqq) && cfqd->cfq_desktop) {
 		unsigned long last_sync = jiffies - cfqd->last_end_sync_rq;
+		unsigned long slice = cfq_slice_async;
 		unsigned int depth;
 
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


