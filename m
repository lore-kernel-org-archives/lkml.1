Return-Path: <linux-kernel-owner+w=401wt.eu-S1759292AbYJ2XFc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759292AbYJ2XFc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 19:05:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755934AbYJ2XDL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 19:03:11 -0400
Received: from kroah.org ([198.145.64.141]:35903 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757271AbYJ2XDH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 19:03:07 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Jason Baron <jbaron@redhat.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 6/6] Driver core: fix 'dynamic_debug' cmd line parameter
Date: Wed, 29 Oct 2008 15:58:12 -0700
Message-Id: <1225321092-21933-6-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <20081029223824.GB21657@kroah.com>
References: <20081029223824.GB21657@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jason Baron <jbaron@redhat.com>

In testing 2.6.28-rc1, I found that passing 'dynamic_printk' on the command
line didn't activate the debug code. The problem is that dynamic_printk_setup()
(which activates the debugging) is being called before dynamic_printk_init() is
called (which initializes infrastructure). Fix this by setting setting the
state to 'DYNAMIC_ENABLED_ALL' in dynamic_printk_setup(), which will also
cause all subsequent modules to have debugging automatically started, which is
probably the behavior we want.

Signed-off-by: Jason Baron <jbaron@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 lib/dynamic_printk.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

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
-- 
1.6.0.2

