Return-Path: <linux-kernel-owner+w=401wt.eu-S1764281AbYCDMXU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764281AbYCDMXU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 07:23:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753943AbYCDMXL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 07:23:11 -0500
Received: from ozlabs.org ([203.10.76.45]:37760 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753778AbYCDMXK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 07:23:10 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/2] modules: Whine about suspicious return values from module's ->init() hook
Date: Tue, 4 Mar 2008 23:22:26 +1100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Alexey Dobriyan <adobriyan@gmail.com>
References: <200803042321.01683.rusty@rustcorp.com.au>
In-Reply-To: <200803042321.01683.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803042322.26693.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: Whine about suspicious return values from module's ->init() hook
Date: Mon, 11 Feb 2008 01:09:06 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>

Return value convention of module's init functions is 0/-E. Sometimes, e.g.
during forward-porting mistakes happen and buggy module created, where result
of comparison "workqueue != NULL" is propagated all the way up to
sys_init_module. What happens is that some other module created workqueue in
question, our module created it again and module was successfully loaded.

Or it could be some other bug.

Let's make such mistakes much more visible. In retrospective, such messages
would noticeably shorten some of my head-scratching sessions.

Note, that dump_stack() is just a way to get attention from user.
Sample message:

sys_init_module: 'foo'->init suspiciously returned 1, it should follow 0/-E convention
sys_init_module: loading module anyway...
Pid: 4223, comm: modprobe Not tainted 2.6.24-25f666300625d894ebe04bac2b4b3aadb907c861 #5

Call Trace:
 [<ffffffff80254b05>] sys_init_module+0xe5/0x1d0
 [<ffffffff8020b39b>] system_call_after_swapgs+0x7b/0x80

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 kernel/module.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff -u
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -2174,6 +2174,14 @@ sys_init_module(void __user *umod,
 		wake_up(&module_wq);
 		return ret;
 	}
+	if (ret > 0) {
+		printk(KERN_WARNING "%s: '%s'->init suspiciously returned %d, "
+				    "it should follow 0/-E convention\n"
+		       KERN_WARNING "%s: loading module anyway...\n",
+		       __func__, mod->name, ret,
+		       __func__);
+		dump_stack();
+	}
 
 	/* Now it's a first class citizen! */
 	mutex_lock(&module_mutex);

