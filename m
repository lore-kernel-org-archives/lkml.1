Return-Path: <linux-kernel-owner+w=401wt.eu-S935756AbXGRS4n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935756AbXGRS4n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 14:56:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762628AbXGRS4c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 14:56:32 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:23483 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761134AbXGRS4b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 14:56:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=sDZDKzlHQW5WKLoaEHKwwtu/nVM8ZvefV1fZ8XYEPqPUBfkex9ExZbUCQqHzwZBu3wJfFhF0jq8i5XHMfASHq9xCwV7bYaHHNARw04K+OQhTtw8OtgBZZZ0kzz3YN5X7peyzJ8X7tCB5IDnX/Ulz3NJvrAV1jQnaOdO4Sg3kHD4=
Date: Wed, 18 Jul 2007 22:56:24 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       Mauro Carvalho Chehab <v4l-dvb-maintainer@linuxtv.org>
Subject: [PATCH] Conexant 2388x: check for kthread_run
Message-ID: <20070718185624.GA13996@cvg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds checking of kthread_run return code.

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
---
Probably we could just ignore a such situation (we do
check for core->kthread value before trying to stop the
thread) but we have to leave a footmark in kernel
messages anyway I guess. Comments?

 drivers/media/video/cx88/cx88-video.c |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/cx88/cx88-video.c b/drivers/media/video/cx88/cx88-video.c
index 98fa354..2e05450 100644
--- a/drivers/media/video/cx88/cx88-video.c
+++ b/drivers/media/video/cx88/cx88-video.c
@@ -1881,8 +1881,15 @@ static int __devinit cx8800_initdev(struct pci_dev *pci_dev,
 	mutex_unlock(&core->lock);
 
 	/* start tvaudio thread */
-	if (core->tuner_type != TUNER_ABSENT)
+	if (core->tuner_type != TUNER_ABSENT) {
 		core->kthread = kthread_run(cx88_audio_thread, core, "cx88 tvaudio");
+		if (IS_ERR(core->kthread)) {
+			err = PTR_ERR(core->kthread);
+			printk(KERN_ERR "Failed to create cx88 audio thread, err=%d\n",
+			       err);
+			goto fail_unreg;
+		}
+	}
 	return 0;
 
 fail_unreg:
