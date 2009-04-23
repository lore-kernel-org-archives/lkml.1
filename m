Return-Path: <linux-kernel-owner+w=401wt.eu-S1759297AbZDWHsA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759297AbZDWHsA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 03:48:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756990AbZDWHce
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 03:32:34 -0400
Received: from sous-sol.org ([216.99.217.87]:50763 "EHLO x200.localdomain"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756945AbZDWHcd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 03:32:33 -0400
Message-Id: <20090423072714.883707340@sous-sol.org>
User-Agent: quilt/0.47-1
Date: Thu, 23 Apr 2009 00:21:19 -0700
From: Chris Wright <chrisw@sous-sol.org>
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
       alan@lxorguk.ukuu.org.uk, Mikulas Patocka <mpatocka@redhat.com>,
       Alasdair G Kergon <agk@redhat.com>
Subject: [patch 059/100] dm kcopyd: prepare for callback race fix
References: <20090423072020.428683652@sous-sol.org>
Content-Disposition: inline; filename=dm-kcopyd-prepare-for-callback-race-fix.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Mikulas Patocka <mpatocka@redhat.com>

upstream commit: 73830857bca6f6c9dbd48e906daea50bea42d676

Use a variable in segment_complete() to point to the dm_kcopyd_client
struct and only release job->pages in run_complete_job() if any are
defined.  These changes are needed by the next patch.

Cc: stable@kernel.org
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 drivers/md/dm-kcopyd.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/md/dm-kcopyd.c
+++ b/drivers/md/dm-kcopyd.c
@@ -297,7 +297,8 @@ static int run_complete_job(struct kcopy
 	dm_kcopyd_notify_fn fn = job->fn;
 	struct dm_kcopyd_client *kc = job->kc;
 
-	kcopyd_put_pages(kc, job->pages);
+	if (job->pages)
+		kcopyd_put_pages(kc, job->pages);
 	mempool_free(job, kc->job_pool);
 	fn(read_err, write_err, context);
 
@@ -461,6 +462,7 @@ static void segment_complete(int read_er
 	sector_t progress = 0;
 	sector_t count = 0;
 	struct kcopyd_job *job = (struct kcopyd_job *) context;
+	struct dm_kcopyd_client *kc = job->kc;
 
 	mutex_lock(&job->lock);
 
@@ -490,7 +492,7 @@ static void segment_complete(int read_er
 
 	if (count) {
 		int i;
-		struct kcopyd_job *sub_job = mempool_alloc(job->kc->job_pool,
+		struct kcopyd_job *sub_job = mempool_alloc(kc->job_pool,
 							   GFP_NOIO);
 
 		*sub_job = *job;

