Return-Path: <linux-kernel-owner+w=401wt.eu-S1755435AbZBOVy5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755435AbZBOVy5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Feb 2009 16:54:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751670AbZBOVyt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Feb 2009 16:54:49 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:53246 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752625AbZBOVys (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Feb 2009 16:54:48 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sun, 15 Feb 2009 22:49:24 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH] ieee1394: raw1394: add sparse annotations to
 raw1394_compat_write
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org
Message-ID: <tkrat.99eef21990faacfb@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eliminate the following warnings in raw1394_compat_write()'s error
return path, seen on x86-64 with CONFIG_COMPAT=y:

drivers/ieee1394/raw1394.c:381:17: warning: incorrect type in return expression (different address spaces)
drivers/ieee1394/raw1394.c:381:17:    expected char const [noderef] <asn:1>*
drivers/ieee1394/raw1394.c:381:17:    got void *
drivers/ieee1394/raw1394.c:2252:14: warning: incorrect type in argument 1 (different address spaces)
drivers/ieee1394/raw1394.c:2252:14:    expected void const *ptr
drivers/ieee1394/raw1394.c:2252:14:    got char const [noderef] <asn:1>*[assigned] buffer
drivers/ieee1394/raw1394.c:2253:19: warning: incorrect type in argument 1 (different address spaces)
drivers/ieee1394/raw1394.c:2253:19:    expected void const *ptr
drivers/ieee1394/raw1394.c:2253:19:    got char const [noderef] <asn:1>*[assigned] buffer

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/ieee1394/raw1394.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

Index: linux/drivers/ieee1394/raw1394.c
===================================================================
--- linux.orig/drivers/ieee1394/raw1394.c
+++ linux/drivers/ieee1394/raw1394.c
@@ -369,6 +369,7 @@ static const char __user *raw1394_compat
 {
 	struct compat_raw1394_req __user *cr = (typeof(cr)) buf;
 	struct raw1394_request __user *r;
+
 	r = compat_alloc_user_space(sizeof(struct raw1394_request));
 
 #define C(x) __copy_in_user(&r->x, &cr->x, sizeof(r->x))
@@ -378,7 +379,8 @@ static const char __user *raw1394_compat
 	    C(tag) ||
 	    C(sendb) ||
 	    C(recvb))
-		return ERR_PTR(-EFAULT);
+		return (__force const char __user *)ERR_PTR(-EFAULT);
+
 	return (const char __user *)r;
 }
 #undef C
@@ -389,6 +391,7 @@ static int
 raw1394_compat_read(const char __user *buf, struct raw1394_request *r)
 {
 	struct compat_raw1394_req __user *cr = (typeof(cr)) buf;
+
 	if (!access_ok(VERIFY_WRITE, cr, sizeof(struct compat_raw1394_req)) ||
 	    P(type) ||
 	    P(error) ||
@@ -400,6 +403,7 @@ raw1394_compat_read(const char __user *b
 	    P(sendb) ||
 	    P(recvb))
 		return -EFAULT;
+
 	return sizeof(struct compat_raw1394_req);
 }
 #undef P
@@ -2249,8 +2253,8 @@ static ssize_t raw1394_write(struct file
    	    sizeof(struct compat_raw1394_req) !=
 			sizeof(struct raw1394_request)) {
 		buffer = raw1394_compat_write(buffer);
-		if (IS_ERR(buffer))
-			return PTR_ERR(buffer);
+		if (IS_ERR((__force void *)buffer))
+			return PTR_ERR((__force void *)buffer);
 	} else
 #endif
 	if (count != sizeof(struct raw1394_request)) {

-- 
Stefan Richter
-=====-==--= --=- -====
http://arcgraph.de/sr/

