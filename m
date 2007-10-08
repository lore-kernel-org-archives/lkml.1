Return-Path: <linux-kernel-owner+w=401wt.eu-S1754603AbXJHGue@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754603AbXJHGue (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2007 02:50:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752789AbXJHGu1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Oct 2007 02:50:27 -0400
Received: from hu-out-0506.google.com ([72.14.214.226]:9028 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752667AbXJHGu0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2007 02:50:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=oPIo4IzGdde/U5PX0UnQlZFtrdbcJvSnHpwX9YUHghxZyB/mPnKEZrWxru39O9ahQp6ooVRD5SU6Br2nZ86KX8esXt+UatAU7iRjxfxVn8yjl+4Iq/vZc8ql90IO1q8xldBdEeXOB3lPyKlBLt7EL87g2AMNJ2GGkMxzhYKD6qA=
Date: Mon, 8 Oct 2007 14:50:10 +0800
From: Dave Young <hidave.darkstar@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, gregkh@suse.de
Subject: [PATCH] param_sysfs_builtin memchr argument fix
Message-ID: <20071008065009.GA2862@darkstar.te-china.tietoenator.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

If memchr argument is longer than strlen(kp->name), there will be some
weird result. 

Signed-off-by: Dave Young <hidave.darkstar@gmail.com> 

---
params.c |   10 ++++++++--
1 file changed, 8 insertions(+), 2 deletions(-)

diff -upr linux/kernel/params.c linux.new/kernel/params.c
--- linux/kernel/params.c	2007-10-08 14:30:06.000000000 +0800
+++ linux.new/kernel/params.c	2007-10-08 14:31:22.000000000 +0800
@@ -592,15 +592,21 @@ static void __init param_sysfs_builtin(v
 
 	for (i=0; i < __stop___param - __start___param; i++) {
 		char *dot;
+		int kplen;
 
 		kp = &__start___param[i];
+		kplen = strlen(kp->name);
 
 		/* We do not handle args without periods. */
-		dot = memchr(kp->name, '.', MAX_KBUILD_MODNAME);
+		if (kplen > MAX_KBUILD_MODNAME) {
+			DEBUGP("kernel parameter %s is too long\n", kp->name);
+			continue;
+		}
+		dot = memchr(kp->name, '.', kplen);
 		if (!dot) {
 			DEBUGP("couldn't find period in %s\n", kp->name);
 			continue;
-		}
+		} 
 		name_len = dot - kp->name;
 
  		/* new kbuild_modname? */
