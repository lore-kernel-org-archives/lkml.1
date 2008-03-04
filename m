Return-Path: <linux-kernel-owner+w=401wt.eu-S1764316AbYCDMVz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764316AbYCDMVz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 07:21:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754743AbYCDMVn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 07:21:43 -0500
Received: from ozlabs.org ([203.10.76.45]:35690 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753843AbYCDMVm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 07:21:42 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Jan Glauber <jang@linux.vnet.ibm.com>
Subject: [PATCH 1/2] modules: Fix module waiting for dependent modules' init.
Date: Tue, 4 Mar 2008 23:21:01 +1100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Miles Lane <miles.lane@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
       linux-usb@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803042321.01683.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit c9a3ba55 (module: wait for dependent modules doing init.)
didn't quite work because the waiter holds the module lock, meaning
that the state of the module it's waiting for cannot change.

Fortunately, it's fairly simple to update the state outside the lock
and do the wakeup.

Thanks to Jan Glauber <jang@linux.vnet.ibm.com> for tracking this down
and testing (qdio and qeth).

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 kernel/module.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff -r 1198dd206438 kernel/module.c
--- a/kernel/module.c	Tue Mar 04 11:18:59 2008 +1100
+++ b/kernel/module.c	Tue Mar 04 13:23:22 2008 +1100
@@ -2172,9 +2172,11 @@ sys_init_module(void __user *umod,
 		return ret;
 	}
 
-	/* Now it's a first class citizen! */
+	/* Now it's a first class citizen!  Wake up anyone waiting for it. */
+	mod->state = MODULE_STATE_LIVE;
+	wake_up(&module_wq);
+
 	mutex_lock(&module_mutex);
-	mod->state = MODULE_STATE_LIVE;
 	/* Drop initial reference. */
 	module_put(mod);
 	unwind_remove_table(mod->unwind_info, 1);
@@ -2183,7 +2185,6 @@ sys_init_module(void __user *umod,
 	mod->init_size = 0;
 	mod->init_text_size = 0;
 	mutex_unlock(&module_mutex);
-	wake_up(&module_wq);
 
 	return 0;
 }
