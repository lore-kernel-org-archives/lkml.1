Return-Path: <linux-kernel-owner+w=401wt.eu-S1763824AbZDJJBc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763824AbZDJJBc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 05:01:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754449AbZDJJBW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 05:01:22 -0400
Received: from mail-qy0-f118.google.com ([209.85.221.118]:62011 "EHLO
	mail-qy0-f118.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753583AbZDJJBV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 05:01:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:x-x-sender:to:subject:message-id:user-agent:mime-version
         :content-type;
        b=Wzo77Es1hmHK/3yJJpRY5eLUgijwdNVDPvw1e9XwtCG5KGpxQ+jCjQrXfqShGxD73A
         sTiEK6ENl9k8aO6m4Q2P3zgJRMXpI1VTUQy10dl3qM10AGRde5EYsj8vDyc8S8VUa8jH
         utUW/d7mhmScK0A5wfssCBvBZ7rw+FHnoqOrg=
Date: Fri, 10 Apr 2009 12:00:31 +0300 (EAT)
From: Dan Carpenter <error27@gmail.com>
X-X-Sender: dcarpenter@bicker
To: linux-kernel@vger.kernel.org
Subject: [patch] dereferencing freed in saa5249.c
Message-ID: <alpine.DEB.2.00.0904101148580.6129@bicker>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I moved the kfree() down a couple lines.  t->vdev is going to be in freed 
memory so there is no point setting it to NULL.  I added a kfree(t) on a 
different error path.

regards,
dan carpenter

Signed-off-by: Dan Carpenter <error27@gmail.com>

--- orig/drivers/media/video/saa5249.c	2009-04-09 23:54:15.000000000 +0300
+++ devel/drivers/media/video/saa5249.c	2009-04-09 23:59:16.000000000 +0300
@@ -598,6 +598,7 @@
 	/* Now create a video4linux device */
 	t->vdev = video_device_alloc();
 	if (t->vdev == NULL) {
+		kfree(t);
 		kfree(client);
 		return -ENOMEM;
 	}
@@ -617,9 +618,8 @@
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
