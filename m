Return-Path: <linux-kernel-owner+w=401wt.eu-S1762508AbYCERkE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762508AbYCERkE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 12:40:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762155AbYCERji
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 12:39:38 -0500
Received: from sacred.ru ([62.205.161.221]:35390 "EHLO sacred.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762112AbYCERjh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 12:39:37 -0500
Message-ID: <47CED849.9070602@openvz.org>
Date: Wed, 05 Mar 2008 20:28:41 +0300
From: Pavel Emelyanov <xemul@openvz.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Paul Menage <menage@google.com>,
       Sukadev Bhattiprolu <sukadev@us.ibm.com>,
       Serge Hallyn <serue@us.ibm.com>
Subject: [PATCH 2/9] Cleanup the get_gendisk() a bit
References: <47CED717.60406@openvz.org>
In-Reply-To: <47CED717.60406@openvz.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (sacred.ru [62.205.161.221]); Wed, 05 Mar 2008 20:28:32 +0300 (MSK)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current implementation first converts kobj to device and
then checks for kobj not to be NULL. This is OK, since the
converting macros is a container_of one, but this does not
look very nice. 

Besides, I'll have to add some code _before_ the kobj_lookup()
and thus will have to move the call to kobj_lookup lower.

So do this job here to make the further patching cleaner.

Signed-off-by: Pavel Emelyanov <xemul@openvz.org>

---
 block/genhd.c |   11 ++++++++---
 1 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/block/genhd.c b/block/genhd.c
index e8cf05a..9a7a903 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -212,10 +212,15 @@ void unlink_gendisk(struct gendisk *disk)
  */
 struct gendisk *get_gendisk(dev_t devt, int *part)
 {
-	struct kobject *kobj = kobj_lookup(bdev_map, devt, part);
-	struct device *dev = kobj_to_dev(kobj);
+	struct kobject *kobj;
+	struct device *dev;
+
+	kobj = kobj_lookup(bdev_map, devt, part);
+	if (kobj == NULL)
+		return NULL;
 
-	return  kobj ? dev_to_disk(dev) : NULL;
+	dev = kobj_to_dev(kobj);
+	return dev_to_disk(dev);
 }
 
 /*
-- 
1.5.3.4

