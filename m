Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1752673AbYLRELZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752673AbYLRELZ (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 23:11:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751077AbYLRELP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 23:11:15 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:55922 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750797AbYLRELO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 23:11:14 -0500
Date: Thu, 18 Dec 2008 13:10:15 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, gregkh@suse.de
Subject: Re: mmotm 2008-12-17-16-41 uploaded
Message-Id: <20081218131015.735da05e.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <200812180057.mBI0vpPt013574@imap1.linux-foundation.org>
References: <200812180057.mBI0vpPt013574@imap1.linux-foundation.org>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Dec 2008 16:41:54 -0800
akpm@linux-foundation.org wrote:

> The mm-of-the-moment snapshot 2008-12-17-16-41 has been uploaded to
> 
>    http://userweb.kernel.org/~akpm/mmotm/
> 
> and will soon be available at
> 
>    git://git.zen-sources.org/zen/mmotm.git
> 

This was necessary. I'm not sure my patch description is corrcect...
but this helps me ;)
This change kfree(dev->p) comes from linux-next.

==
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

dev->release() may free struct dev itself. To free dev->p
in safe way, remember dev->p.

Signed-off-by:KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 drivers/base/core.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

Index: mmotm-2.6.28-Dec17/drivers/base/core.c
===================================================================
--- mmotm-2.6.28-Dec17.orig/drivers/base/core.c
+++ mmotm-2.6.28-Dec17/drivers/base/core.c
@@ -109,6 +109,7 @@ static struct sysfs_ops dev_sysfs_ops = 
 static void device_release(struct kobject *kobj)
 {
 	struct device *dev = to_dev(kobj);
+	struct device_private *p = dev->p;
 
 	if (dev->release)
 		dev->release(dev);
@@ -116,11 +117,13 @@ static void device_release(struct kobjec
 		dev->type->release(dev);
 	else if (dev->class && dev->class->dev_release)
 		dev->class->dev_release(dev);
-	else
+	else {
 		WARN(1, KERN_ERR "Device '%s' does not have a release() "
 			"function, it is broken and must be fixed.\n",
 			dev_name(dev));
-	kfree(dev->p);
+		return;
+	}
+	kfree(p);
 }
 
 static struct kobj_type device_ktype = {


