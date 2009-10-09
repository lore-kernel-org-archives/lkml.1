Return-Path: <linux-kernel-owner+w=401wt.eu-S1761281AbZJISbl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761281AbZJISbl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 14:31:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761266AbZJISbk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 14:31:40 -0400
Received: from mail-ew0-f208.google.com ([209.85.219.208]:65056 "EHLO
	mail-ew0-f208.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761265AbZJISbj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 14:31:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=WMVPwL/ce1XNR8BGlLstEUIHHb3DoVswWaIyPpOSY80jQAEHFBHHGfso2+Q+zDWV+G
         k4s9h/qGaqWYwWnAUKiaAQGPvJLhjaxj6pVwwI6gPXW0c8YNd5H28WhnJKO9H1ZJsclf
         xnPk8lklNT1YcKPXyYsYl5Gf7gEF63oeWV/G4=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       John Kacur <jkacur@redhat.com>,
       Sven-Thorsten Dietrich <sven@thebigcorporation.com>,
       Jonathan Corbet <corbet@lwn.net>,
       Alessio Igor Bogani <abogani@texware.it>
Subject: [PATCH] mem_class: Drop the bkl from memory_open()
Date: Fri,  9 Oct 2009 20:31:02 +0200
Message-Id: <1255113062-5835-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The generic open callback for the mem class devices is "protected" by
the bkl.

Let's look at the datas manipulated inside memory_open:

- inode and file: safe
- the devlist: safe because it is constant
- the memdev classes inside this array are safe too (constant)

After we find out which memdev file operation we need to use, we call
its open callback. Depending on the targeted memdev, we call either
open_port() that doesn't manipulate any racy data (just a capable()
check), or we call nothing.

So it's safe to remove the big kernel lock there.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: John Kacur <jkacur@redhat.com>
Cc: Sven-Thorsten Dietrich <sven@thebigcorporation.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Alessio Igor Bogani <abogani@texware.it>
---
 drivers/char/mem.c |   16 +++++-----------
 1 files changed, 5 insertions(+), 11 deletions(-)

diff --git a/drivers/char/mem.c b/drivers/char/mem.c
index a074fce..599846a 100644
--- a/drivers/char/mem.c
+++ b/drivers/char/mem.c
@@ -892,29 +892,23 @@ static int memory_open(struct inode *inode, struct file *filp)
 {
 	int minor;
 	const struct memdev *dev;
-	int ret = -ENXIO;
-
-	lock_kernel();
 
 	minor = iminor(inode);
 	if (minor >= ARRAY_SIZE(devlist))
-		goto out;
+		return -ENXIO;
 
 	dev = &devlist[minor];
 	if (!dev->fops)
-		goto out;
+		return -ENXIO;
 
 	filp->f_op = dev->fops;
 	if (dev->dev_info)
 		filp->f_mapping->backing_dev_info = dev->dev_info;
 
 	if (dev->fops->open)
-		ret = dev->fops->open(inode, filp);
-	else
-		ret = 0;
-out:
-	unlock_kernel();
-	return ret;
+		return dev->fops->open(inode, filp);
+
+	return 0;
 }
 
 static const struct file_operations memory_fops = {
-- 
1.6.2.3

