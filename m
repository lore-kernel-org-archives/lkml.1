Return-Path: <linux-kernel-owner+w=401wt.eu-S1754738AbYH1CY7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754738AbYH1CY7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 22:24:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752964AbYH1CYu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 22:24:50 -0400
Received: from mu-out-0910.google.com ([209.85.134.190]:5648 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753157AbYH1CYt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 22:24:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=OkB0PRSrx48YopFTPHYF/TLYStUuXFK+CYSPPtPE5PIrX5rLMrgptmp+hkTUj5616o
         CrPxKdH4YxbwHCJjgkD83MLH+4hkmVV9N5yfZkUadDNM1rt4YcsFr535tAVCrbkg722X
         kZ2EHblQkdcjrIqpUPPUNBEe3btAARF2B9y6c=
Date: Thu, 28 Aug 2008 06:26:23 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@osdl.org, viro@zeniv.linux.org.uk
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] anondev: switch to IDA
Message-ID: <20080828022623.GB18499@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 fs/super.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/fs/super.c
+++ b/fs/super.c
@@ -682,7 +682,7 @@ void emergency_remount(void)
  * filesystems which don't use real block-devices.  -- jrs
  */
 
-static DEFINE_IDR(unnamed_dev_idr);
+static DEFINE_IDA(unnamed_dev_ida);
 static DEFINE_SPINLOCK(unnamed_dev_lock);/* protects the above */
 
 int set_anon_super(struct super_block *s, void *data)
@@ -691,10 +691,10 @@ int set_anon_super(struct super_block *s, void *data)
 	int error;
 
  retry:
-	if (idr_pre_get(&unnamed_dev_idr, GFP_ATOMIC) == 0)
+	if (ida_pre_get(&unnamed_dev_ida, GFP_ATOMIC) == 0)
 		return -ENOMEM;
 	spin_lock(&unnamed_dev_lock);
-	error = idr_get_new(&unnamed_dev_idr, NULL, &dev);
+	error = ida_get_new(&unnamed_dev_ida, &dev);
 	spin_unlock(&unnamed_dev_lock);
 	if (error == -EAGAIN)
 		/* We raced and lost with another CPU. */
@@ -704,7 +704,7 @@ int set_anon_super(struct super_block *s, void *data)
 
 	if ((dev & MAX_ID_MASK) == (1 << MINORBITS)) {
 		spin_lock(&unnamed_dev_lock);
-		idr_remove(&unnamed_dev_idr, dev);
+		ida_remove(&unnamed_dev_ida, dev);
 		spin_unlock(&unnamed_dev_lock);
 		return -EMFILE;
 	}
@@ -720,7 +720,7 @@ void kill_anon_super(struct super_block *sb)
 
 	generic_shutdown_super(sb);
 	spin_lock(&unnamed_dev_lock);
-	idr_remove(&unnamed_dev_idr, slot);
+	ida_remove(&unnamed_dev_ida, slot);
 	spin_unlock(&unnamed_dev_lock);
 }
 

