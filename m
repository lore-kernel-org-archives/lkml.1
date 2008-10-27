Return-Path: <linux-kernel-owner+w=401wt.eu-S1753407AbYJ0QGa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753407AbYJ0QGa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 12:06:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751907AbYJ0QGD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 12:06:03 -0400
Received: from mx1.redhat.com ([66.187.233.31]:37932 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751826AbYJ0QGC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 12:06:02 -0400
Date: Mon, 27 Oct 2008 12:05:14 -0400
From: Jason Baron <jbaron@redhat.com>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] fix 'dynamic_debug' cmd line parameter
Message-ID: <20081027160514.GA3161@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,

In testing 2.6.28-rc1, I found that passing 'dynamic_printk' on the command
line didn't activate the debug code. The problem is that dynamic_printk_setup()
(which activates the debugging) is being called before dynamic_printk_init() is
called (which initializes infrastructure). Fix this by setting setting the
state to 'DYNAMIC_ENABLED_ALL' in dynamic_printk_setup(), which will also
cause all subsequent modules to have debugging automatically started, which is
probably the behavior we want.

thanks,

-Jason

Signed-off-by: Jason Baron <jbaron@redhat.com>

diff --git a/lib/dynamic_printk.c b/lib/dynamic_printk.c
index d640f87..d83660f 100644
--- a/lib/dynamic_printk.c
+++ b/lib/dynamic_printk.c
@@ -402,6 +402,8 @@ static int __init dynamic_printk_init(void)
 				iter->logical_modname,
 				iter->flag_names, iter->hash, iter->hash2);
 	}
+	if (dynamic_enabled == DYNAMIC_ENABLED_ALL)
+		set_all(true);
 	return 0;
 }
 module_init(dynamic_printk_init);
@@ -411,7 +413,7 @@ static int __init dynamic_printk_setup(char *str)
 {
 	if (str)
 		return -ENOENT;
-	set_all(true);
+	dynamic_enabled = DYNAMIC_ENABLED_ALL;
 	return 0;
 }
 /* Use early_param(), so we can get debug output as early as possible */
