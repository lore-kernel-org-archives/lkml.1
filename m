Return-Path: <linux-kernel-owner+w=401wt.eu-S1755364AbYHHDdE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755364AbYHHDdE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 23:33:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753378AbYHHDcy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 23:32:54 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:42021 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753141AbYHHDcy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 23:32:54 -0400
Subject: Re: [GIT PULL]: firmware patches for building firmware into kernel
From: Jaswinder Singh <jaswinder@infradead.org>
To: David Dillow <dave@thedillows.org>
Cc: David Woodhouse <dwmw2@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <1218133288.18118.20.camel@lap75545.ornl.gov>
References: <1218128219.14483.7.camel@jaswinder.satnam>
	 <1218130222.18118.7.camel@lap75545.ornl.gov>
	 <1218130475.14483.16.camel@jaswinder.satnam>
	 <1218133288.18118.20.camel@lap75545.ornl.gov>
Content-Type: text/plain
Date: Fri, 08 Aug 2008 09:01:10 +0530
Message-Id: <1218166270.2540.9.camel@jaswinder.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Dave,

On Thu, 2008-08-07 at 14:21 -0400, David Dillow wrote:

> I just looked at the tree; it still has locking issues, and needs
> further review. You must protect the list from modification while you
> iterate it looking for an match on the requested firmware. 

So here is updated patch:

diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
index 6074321..71ec20d 100644
--- a/drivers/base/firmware_class.c
+++ b/drivers/base/firmware_class.c
@@ -419,9 +419,9 @@ _request_firmware(const struct firmware **firmware_p, const char *name,
 		return -EINVAL;
 
 	/* Return firmware pointer from firmware list if already allocated */
+	mutex_lock(&fw_lock);
 	list_for_each_entry(flst, &firmwarelist, list)
 		if (strcmp(name, flst->name) == 0) {
-			mutex_lock(&fw_lock);
 			flst->count++;
 			*firmware_p = flst->fw;
 			mutex_unlock(&fw_lock);
@@ -429,6 +429,7 @@ _request_firmware(const struct firmware **firmware_p, const char *name,
 			       name, flst->count);
 			return 0;
 		}
+	mutex_unlock(&fw_lock);
 
 	*firmware_p = firmware = kzalloc(sizeof(*firmware), GFP_KERNEL);
 	if (!firmware)
@@ -568,19 +569,22 @@ void release_firmware(const struct firmware *fw)
 {
 	struct firmware_list *flst;
 
+	mutex_lock(&fw_lock);
 	if (fw)
 		list_for_each_entry(flst, &firmwarelist, list)
 			if (fw == flst->fw) {
 				printk(KERN_INFO
 				       "firmware: releasing %s count %d\n",
 				       flst->name, flst->count);
-				mutex_lock(&fw_lock);
 				flst->count--;
-				mutex_unlock(&fw_lock);
-				if (flst->count == 0)
-					__release_firmware(fw, flst);
-				return;
+				if (flst->count == 0) {
+					mutex_unlock(&fw_lock);
+					return __release_firmware(fw, flst);
+				}
+				goto out;
 			}
+out:
+	mutex_unlock(&fw_lock);
 }
 
 /*
@@ -598,6 +602,7 @@ void release_firmware_all(const struct firmware *fw)
 {
 	struct firmware_list *flst;
 
+	mutex_lock(&fw_lock);
 	if (fw)
 		list_for_each_entry(flst, &firmwarelist, list)
 			if (fw == flst->fw) {
@@ -605,13 +610,14 @@ void release_firmware_all(const struct firmware *fw)
 				       "firmware: release_all %s count %d\n",
 				       flst->name, flst->count);
 				if (flst->count) {
-					mutex_lock(&fw_lock);
 					flst->count = 0;
 					mutex_unlock(&fw_lock);
-					__release_firmware(fw, flst);
+					return __release_firmware(fw, flst);
 				}
-				return;
+				goto out;
 			}
+out:
+	mutex_unlock(&fw_lock);
 }
 
 /* Async support */


> Also, was it legal to call release_firmware() from an atomic context? It can now
> sleep, which may be an issue...
> 

yes, release_firmware can sleep. 
So now release_firmware also joined the family of request_firmware.

If you can do request_firmware you can also do release_firmware.

Any how release_firmware will be called below request_firmware or during
exit, I do not think this will make any issue.

Thank you,

Jaswinder Singh.


