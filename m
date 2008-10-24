Return-Path: <linux-kernel-owner+w=401wt.eu-S1755454AbYJXEml@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755454AbYJXEml (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 00:42:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752457AbYJXEjQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 00:39:16 -0400
Received: from kroah.org ([198.145.64.141]:51711 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751249AbYJXEjM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 00:39:12 -0400
Date: Thu, 23 Oct 2008 21:34:09 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, jejb@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Jan Blunck <jblunck@suse.de>,
       Kazuo Ito <ito.kazuo@oss.ntt.co.jp>, Alasdair G Kergon <agk@redhat.com>
Subject: [patch 09/27] dm kcopyd: avoid queue shuffle
Message-ID: <20081024043409.GJ30828@kroah.com>
References: <20081024042023.054190751@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="dm-kcopyd-avoid-queue-shuffle.patch"
In-Reply-To: <20081024043303.GA30828@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us 
know.

------------------
From: Kazuo Ito <ito.kazuo@oss.ntt.co.jp>

commit b673c3a8192e28f13e2050a4b82c1986be92cc15 upstream

Write throughput to LVM snapshot origin volume is an order
of magnitude slower than those to LV without snapshots or
snapshot target volumes, especially in the case of sequential
writes with O_SYNC on.

The following patch originally written by Kevin Jamieson and
Jan Blunck and slightly modified for the current RCs by myself
tries to improve the performance by modifying the behaviour
of kcopyd, so that it pushes back an I/O job to the head of
the job queue instead of the tail as process_jobs() currently
does when it has to wait for free pages. This way, write
requests aren't shuffled to cause extra seeks.

I tested the patch against 2.6.27-rc5 and got the following results.
The test is a dd command writing to snapshot origin followed by fsync
to the file just created/updated.  A couple of filesystem benchmarks
gave me similar results in case of sequential writes, while random
writes didn't suffer much.

dd if=/dev/zero of=<somewhere on snapshot origin> bs=4096 count=...
   [conv=notrunc when updating]

1) linux 2.6.27-rc5 without the patch, write to snapshot origin,
average throughput (MB/s)
                     10M     100M    1000M
create,dd         511.46   610.72    11.81
create,dd+fsync     7.10     6.77     8.13
update,dd         431.63   917.41    12.75
update,dd+fsync     7.79     7.43     8.12

compared with write throughput to LV without any snapshots,
all dd+fsync and 1000 MiB writes perform very poorly.

                     10M     100M    1000M
create,dd         555.03   608.98   123.29
create,dd+fsync   114.27    72.78    76.65
update,dd         152.34  1267.27   124.04
update,dd+fsync   130.56    77.81    77.84

2) linux 2.6.27-rc5 with the patch, write to snapshot origin,
average throughput (MB/s)

                     10M     100M    1000M
create,dd         537.06   589.44    46.21
create,dd+fsync    31.63    29.19    29.23
update,dd         487.59   897.65    37.76
update,dd+fsync    34.12    30.07    26.85

Although still not on par with plain LV performance -
cannot be avoided because it's copy on write anyway -
this simple patch successfully improves throughtput
of dd+fsync while not affecting the rest.

Signed-off-by: Jan Blunck <jblunck@suse.de>
Signed-off-by: Kazuo Ito <ito.kazuo@oss.ntt.co.jp>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/md/dm-kcopyd.c |   13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

--- a/drivers/md/dm-kcopyd.c
+++ b/drivers/md/dm-kcopyd.c
@@ -268,6 +268,17 @@ static void push(struct list_head *jobs,
 	spin_unlock_irqrestore(&kc->job_lock, flags);
 }
 
+
+static void push_head(struct list_head *jobs, struct kcopyd_job *job)
+{
+	unsigned long flags;
+	struct dm_kcopyd_client *kc = job->kc;
+
+	spin_lock_irqsave(&kc->job_lock, flags);
+	list_add(&job->list, jobs);
+	spin_unlock_irqrestore(&kc->job_lock, flags);
+}
+
 /*
  * These three functions process 1 item from the corresponding
  * job list.
@@ -398,7 +409,7 @@ static int process_jobs(struct list_head
 			 * We couldn't service this job ATM, so
 			 * push this job back onto the list.
 			 */
-			push(jobs, job);
+			push_head(jobs, job);
 			break;
 		}
 

-- 
