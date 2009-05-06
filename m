Return-Path: <linux-kernel-owner+w=401wt.eu-S1760820AbZEFPPu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760820AbZEFPPu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 11:15:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760350AbZEFPPR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 11:15:17 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:54962 "EHLO
	t61.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760648AbZEFPPQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 11:15:16 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 2/2] dereferencing freed in saa5249.c
To: torvalds@linux-foundation.org, mchehab@redhat.com,
       linux-kernel@vger.kernel.org
Date: Wed, 06 May 2009 17:13:45 +0100
Message-ID: <20090506161338.24311.81203.stgit@t61.ukuu.org.uk>
In-Reply-To: <20090506161238.24311.27127.stgit@t61.ukuu.org.uk>
References: <20090506161238.24311.27127.stgit@t61.ukuu.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dan Carpenter <error27@gmail.com>

I moved the kfree() down a couple lines.  t->vdev is going to be in freed
memory so there is no point setting it to NULL.  I added a kfree(t) on a
different error path.

regards,
dan carpenter

Signed-off-by: Dan Carpenter <error27@gmail.com>
Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/media/video/saa5249.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)


diff --git a/drivers/media/video/saa5249.c b/drivers/media/video/saa5249.c
index 48b27fe..271d6e9 100644
--- a/drivers/media/video/saa5249.c
+++ b/drivers/media/video/saa5249.c
@@ -598,6 +598,7 @@ static int saa5249_probe(struct i2c_client *client,
 	/* Now create a video4linux device */
 	t->vdev = video_device_alloc();
 	if (t->vdev == NULL) {
+		kfree(t);
 		kfree(client);
 		return -ENOMEM;
 	}
@@ -617,9 +618,8 @@ static int saa5249_probe(struct i2c_client *client,
 	/* Register it */
 	err = video_register_device(t->vdev, VFL_TYPE_VTX, -1);
 	if (err < 0) {
-		kfree(t);
 		video_device_release(t->vdev);
-		t->vdev = NULL;
+		kfree(t);
 		return err;
 	}
 	return 0;

