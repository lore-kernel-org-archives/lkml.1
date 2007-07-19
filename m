Return-Path: <linux-kernel-owner+w=401wt.eu-S938049AbXGSOdU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938049AbXGSOdU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 10:33:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764756AbXGSOce
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 10:32:34 -0400
Received: from ug-out-1314.google.com ([66.249.92.168]:11511 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S937872AbXGSOcb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 10:32:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=D8ugqDRA/hSnTdU3UMFpVJzISSF3InxGaT6UmbgzeAx4DhKwrG7dX6gyYR01+IchagZjA742f3NzGycbHA6vResf6mWMTbUsTP07RvJfiQSXAMjJDCh4jDDjV2ZxkIs3vFZQA/2NXLUfAPWeaJ5lbzOQHSg8+eFYSEhFlvVmlDs=
Date: Thu, 19 Jul 2007 18:32:25 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Conexant 2388x: check for kthread_run
Message-ID: <20070719143225.GA7246@cvg>
References: <20070718185624.GA13996@cvg> <1184786738.4049.38.camel@gaivota>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1184786738.4049.38.camel@gaivota>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[Mauro Carvalho Chehab - Wed, Jul 18, 2007 at 04:25:38PM -0300]
| Hi Cyrill,
| 
| Em Qua, 2007-07-18 ??s 22:56 +0400, Cyrill Gorcunov escreveu:
| > This patch adds checking of kthread_run return code.
| > 
| > Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
| > ---
| > Probably we could just ignore a such situation (we do
| > check for core->kthread value before trying to stop the
| > thread) but we have to leave a footmark in kernel
| > messages anyway I guess. Comments?
| 
| > +		if (IS_ERR(core->kthread)) {
| > +			err = PTR_ERR(core->kthread);
| > +			printk(KERN_ERR "Failed to create cx88 audio thread, err=%d\n",
| > +			       err);
| > +			goto fail_unreg;
| 
| I would just remove the goto from your patch. 
| 
| It is safe not starting the kernel thread, but keeping the driver
| initializing.
| 
| The drawback of not having the thread is not changing to stereo on some
| situations and not detecting audio standard changes (some countries may
| have more than one audio standard when you changing from VHF to UHF or
| on Cable TV).
| 
| -- 
| Cheers,
| Mauro
| 

Hi Mauro,
thanks for the answer. Well, here is updated version.

---
From: Cyrill Gorcunov <gorcunov@gmail.com>
Subject: [PATCH] Conexant 2388x: check for kthread_run

The patch adds checking of kthread_run return code
and issues a message if it fails.

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
---

 drivers/media/video/cx88/cx88-video.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/cx88/cx88-video.c b/drivers/media/video/cx88/cx88-video.c
index 98fa354..06b233a 100644
--- a/drivers/media/video/cx88/cx88-video.c
+++ b/drivers/media/video/cx88/cx88-video.c
@@ -1881,8 +1881,14 @@ static int __devinit cx8800_initdev(struct pci_dev *pci_dev,
 	mutex_unlock(&core->lock);
 
 	/* start tvaudio thread */
-	if (core->tuner_type != TUNER_ABSENT)
+	if (core->tuner_type != TUNER_ABSENT) {
 		core->kthread = kthread_run(cx88_audio_thread, core, "cx88 tvaudio");
+		if (IS_ERR(core->kthread)) {
+			err = PTR_ERR(core->kthread);
+			printk(KERN_ERR "Failed to create cx88 audio thread, err=%d\n",
+			       err);
+		}
+	}
 	return 0;
 
 fail_unreg:
