Return-Path: <linux-kernel-owner+w=401wt.eu-S1754705AbZIASHe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754705AbZIASHe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Sep 2009 14:07:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751395AbZIASHd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Sep 2009 14:07:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9978 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750715AbZIASHd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Sep 2009 14:07:33 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Linux Kernel Mailing <linux-kernel@vger.kernel.org>,
       laurent.riffard@free.fr
Subject: [patch] cfq: choose a new next_req when a request is dispatched
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Tue, 01 Sep 2009 14:07:26 -0400
Message-ID: <x493a76zggx.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patch addresses http://bugzilla.kernel.org/show_bug.cgi?id=13401, a
regression introduced in 2.6.30.

>From the bug report:

---
I'm writing some files (about 200MB) on a DVD-RW with the pktcdvd driver.

The writing starts with good rate and then it drops down to 16 kB/s, and it can
not go back to better rates until the write operation has finished and the
system has synced.

Switching /dev/sr0 to anticipatory scheduler does restore normal rates (up to
2700 kB/s).

How to reproduce :
- format a DVD-RW for packet-writing
- # pktsetup 0 /dev/sr0
- # mount -o noatime,nodiratime,rw /dev/pktcdvd/pktcdvd0 /media/pkt
- # dd if=/dev/zero of=/media/pkt/flexbackup/test bs=1024K count=8
conv=fdatasync
---

Basically, the blktrace data show that one or more requests get skipped
(usually because requests from the pktcdvd layer are made out of order,
which could be a result of the application writing out of order, I'm not
sure), and when they expire and are serviced, we end up switching back
and forth between issuing a request that is more recent (and further
along the disk) and older requests which are further back (from the
fifo, noting that we only ever service one request from the fifo during
each service window).  For pktcdvd, this is pathological behaviour.

This patch chooses a new next_rq in the cfq_dispatch_insert function,
which is not ideal, but gets us much better and more consistent
performance.  Assuming we are servicing a request from the FIFO that is
of a lower sector number than the previously dispatched request, the
patched kernel will choose a new next_req for the cfqq based on the
current request by finding the next lower and higher sectored requests
from the current one in the rb tree.  The two requests will be compared
against the last recorded head position, and a decision on which request
is better will be made, taking a back seek maximum and back seek penalty
into account.

Now, there is a question of whether it's better to determine the next
best request given the last position of the disk head (recorded in the
activate_request function) or the last request inserted into the
dispatch list.  The attached patch leaves things the way they are, and
this works just fine for the pktcdvd case.  Given that this is a minimal
patch and addresses the regression, I thought it safest to go with this.

Testing by the reporter shows the following:

Scheduler Kernel           Average time (s)  Standard Deviation
--------- ---------------- ----------------  -------------------
CFQ       2.6.29                     22.92                5.93
CFQ       2.6.31-rc7 patched         27.76               15.78

Running an unpatched 2.6.31-rc7 kernel, the same test could take up to
10 minutes.

Comments are greatly appreciated.

Cheers,
Jeff

Signed-off-by: Jeff Moyer <jmoyer@redhat.com>

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index fd7080e..8d6a72a 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -1115,6 +1115,7 @@ static void cfq_dispatch_insert(struct request_queue *q, struct request *rq)
 
 	cfq_log_cfqq(cfqd, cfqq, "dispatch_insert");
 
+	cfqq->next_rq = cfq_find_next_rq(cfqd, cfqq, rq);
 	cfq_remove_request(rq);
 	cfqq->dispatched++;
 	elv_dispatch_sort(q, rq);
