Return-Path: <linux-kernel-owner+w=401wt.eu-S1755822AbZJAICG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755822AbZJAICG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 04:02:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755739AbZJAICE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 04:02:04 -0400
Received: from mail.gmx.net ([213.165.64.20]:44803 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755838AbZJAICC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 04:02:02 -0400
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX19gv6BpVsJgE0m7U36ocuWSReowqf+WnyYO5koXNC
	2ND4P39BFHFu3i
Date: Thu, 1 Oct 2009 10:02:08 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: linux-kernel@vger.kernel.org
cc: Greg KH <greg@kroah.com>
Subject: [PATCH] drivers-core: nullify private pointer on device-release
Message-ID: <Pine.LNX.4.64.0910010950330.4408@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.57
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Device structures can be reused over multiple device_add / device_release 
cycles. As the private pointer in that struct is checked for NULL, it has 
to be nullified after freeing the private data. Failure to do so causes a 
use after free bug.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
diff --git a/drivers/base/core.c b/drivers/base/core.c
index 6bee6af..3c9f449 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -122,6 +122,7 @@ static void device_release(struct kobject *kobj)
 		WARN(1, KERN_ERR "Device '%s' does not have a release() "
 			"function, it is broken and must be fixed.\n",
 			dev_name(dev));
+	dev->p = NULL;
 	kfree(p);
 }
 
