Return-Path: <linux-kernel-owner+w=401wt.eu-S1755479AbXD0Imr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755479AbXD0Imr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 04:42:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755487AbXD0Imr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 04:42:47 -0400
Received: from static-141-230-6-89.ipcom.comunitel.net ([89.6.230.141]:46360
	"EHLO traven.no-ip.org" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755479AbXD0Imq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 04:42:46 -0400
Date: Fri, 27 Apr 2007 10:45:37 +0200
From: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
To: gregkh@suse.de, axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [PATCH 2/5] Kcopyd: use mutex instead of semaphore
Message-ID: <20070427084537.GD4213@traven>
Mail-Followup-To: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>,
	gregkh@suse.de, axboe@kernel.dk, linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org
References: <20070427083857.GB4213@traven>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070427083857.GB4213@traven>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Kcopyd uses a semaphore as mutex. use the mutex API instead of the
(binary) semaphore

Signed-off-by: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>

--
diff --git a/drivers/md/kcopyd.c b/drivers/md/kcopyd.c
index b46f6c5..340272a 100644
--- a/drivers/md/kcopyd.c
+++ b/drivers/md/kcopyd.c
@@ -195,7 +195,7 @@ struct kcopyd_job {
 	 * These fields are only used if the job has been split
 	 * into more manageable parts.
 	 */
-	struct semaphore lock;
+	struct mutex lock;
 	atomic_t sub_jobs;
 	sector_t progress;
 };
@@ -452,7 +452,7 @@ static void segment_complete(int read_err,
 	sector_t count = 0;
 	struct kcopyd_job *job = (struct kcopyd_job *) context;
 
-	down(&job->lock);
+	mutex_lock(&job->lock);
 
 	/* update the error */
 	if (read_err)
@@ -476,7 +476,7 @@ static void segment_complete(int read_err,
 			job->progress += count;
 		}
 	}
-	up(&job->lock);
+	mutex_unlock(&job->lock);
 
 	if (count) {
 		int i;
@@ -558,7 +558,7 @@ int kcopyd_copy(struct kcopyd_client *kc, struct io_region *from,
 		dispatch_job(job);
 
 	else {
-		init_MUTEX(&job->lock);
+		mutex_init(&job->lock);
 		job->progress = 0;
 		split_job(job);
 	}

-- 
Matthias Kaehlcke
Linux Application Developer
Barcelona

      El trabajo es el refugio de los que no tienen nada que hacer
                            (Oscar Wilde)
                                                                 .''`.
    using free software / Debian GNU/Linux | http://debian.org  : :'  :
                                                                `. `'`
gpg --keyserver pgp.mit.edu --recv-keys 47D8E5D4                  `-
