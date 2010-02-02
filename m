Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756865Ab0BBStL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 13:49:11 -0500
Received: from mx1.redhat.com ([209.132.183.28]:5154 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756845Ab0BBStG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 13:49:06 -0500
Date: Tue, 2 Feb 2010 13:48:34 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>
Cc: Shaohua Li <shaohua.li@intel.com>, Corrado Zoccolo <czoccolo@gmail.com>,
       Moyer Jeff Moyer <jmoyer@redhat.com>
Subject: [PATCH] cfq-iosched: Do not idle on async queues
Message-ID: <20100202184834.GC3922@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jens,

Few weeks back, Shaohua Li had posted similar patch. I am reposting it
with more test results.

This patch does two things.

- Do not idle on async queues.

- It also changes the write queue depth CFQ drives (cfq_may_dispatch()).
  Currently, we seem to driving queue depth of 1 always for WRITES. This is
  true even if there is only one write queue in the system and all the logic
  of infinite queue depth in case of single busy queue as well as slowly
  increasing queue depth based on last delayed sync request does not seem to
  be kicking in at all.

This patch will allow deeper WRITE queue depths (subjected to the other
WRITE queue depth contstraints like cfq_quantum and last delayed sync
request).

Shaohua Li had reported getting more out of his SSD. For me, I have got
one Lun exported from an HP EVA and when pure buffered writes are on, I
can get more out of the system. Following are test results of pure
buffered writes (with end_fsync=1) with vanilla and patched kernel. These
results are average of 3 sets of run with increasing number of threads.

AVERAGE[bufwfs][vanilla]
-------
job       Set NR  ReadBW(KB/s)   MaxClat(us)    WriteBW(KB/s)  MaxClat(us)
---       --- --  ------------   -----------    -------------  -----------
bufwfs    3   1   0              0              95349          474141
bufwfs    3   2   0              0              100282         806926
bufwfs    3   4   0              0              109989         2.7301e+06
bufwfs    3   8   0              0              116642         3762231
bufwfs    3   16  0              0              118230         6902970

AVERAGE[bufwfs] [patched kernel]
-------
bufwfs    3   1   0              0              270722         404352
bufwfs    3   2   0              0              206770         1.06552e+06
bufwfs    3   4   0              0              195277         1.62283e+06
bufwfs    3   8   0              0              260960         2.62979e+06
bufwfs    3   16  0              0              299260         1.70731e+06

I also ran buffered writes along with some sequential reads and some
buffered reads going on in the system on a SATA disk because the potential
risk could be that we should not be driving queue depth higher in presence
of sync IO going to keep the max clat low.

With some random and sequential reads going on in the system on one SATA
disk I did not see any significant increase in max clat. So it looks like
other WRITE queue depth control logic is doing its job. Here are the
results.

AVERAGE[brr, bsr, bufw together] [vanilla]
-------
job       Set NR  ReadBW(KB/s)   MaxClat(us)    WriteBW(KB/s)  MaxClat(us)
---       --- --  ------------   -----------    -------------  -----------
brr       3   1   850            546345         0              0
bsr       3   1   14650          729543         0              0
bufw      3   1   0              0              23908          8274517

brr       3   2   981.333        579395         0              0
bsr       3   2   14149.7        1175689        0              0
bufw      3   2   0              0              21921          1.28108e+07

brr       3   4   898.333        1.75527e+06    0              0
bsr       3   4   12230.7        1.40072e+06    0              0
bufw      3   4   0              0              19722.3        2.4901e+07

brr       3   8   900            3160594        0              0
bsr       3   8   9282.33        1.91314e+06    0              0
bufw      3   8   0              0              18789.3        23890622

AVERAGE[brr, bsr, bufw mixed] [patched kernel]
-------
job       Set NR  ReadBW(KB/s)   MaxClat(us)    WriteBW(KB/s)  MaxClat(us)
---       --- --  ------------   -----------    -------------  -----------
brr       3   1   837            417973         0              0
bsr       3   1   14357.7        591275         0              0
bufw      3   1   0              0              24869.7        8910662

brr       3   2   1038.33        543434         0              0
bsr       3   2   13351.3        1205858        0              0
bufw      3   2   0              0              18626.3        13280370

brr       3   4   913            1.86861e+06    0              0
bsr       3   4   12652.3        1430974        0              0
bufw      3   4   0              0              15343.3        2.81305e+07

brr       3   8   890            2.92695e+06    0              0
bsr       3   8   9635.33        1.90244e+06    0              0
bufw      3   8   0              0              17200.3        24424392

So looks like it might make sense to include this patch.

Thanks
Vivek

Signed-off-by: Vivek Goyal <vgoyal@redhat.com> 
---
 block/cfq-iosched.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index ee130f1..fc87750 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -1803,7 +1803,7 @@ static bool cfq_should_idle(struct cfq_data *cfqd, struct cfq_queue *cfqq)
 	 * Otherwise, we do only if they are the last ones
 	 * in their service tree.
 	 */
-	return service_tree->count == 1;
+	return service_tree->count == 1 && cfq_cfqq_sync(cfqq);
 }
 
 static void cfq_arm_slice_timer(struct cfq_data *cfqd)
-- 
1.6.2.5

