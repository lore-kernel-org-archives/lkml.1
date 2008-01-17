Return-Path: <linux-kernel-owner+w=401wt.eu-S1758769AbYAQVnU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758769AbYAQVnU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 16:43:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758070AbYAQVl0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 16:41:26 -0500
Received: from saraswathi.solana.com ([198.99.130.12]:44757 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757715AbYAQVlZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 16:41:25 -0500
Date: Thu, 17 Jan 2008 16:40:49 -0500
From: Jeff Dike <jdike@addtoit.com>
To: Andrew Morton <akpm@osdl.org>
Cc: Daniel Walker <dwalker@mvista.com>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 18/20] UML - mconsole mutex conversion
Message-ID: <20080117214049.GA6777@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Daniel Walker <dwalker@mvista.com>

The plug_mem_mutex is already used as a mutex since it's using DECLARE_MUTEX(),
but the underlying construct is still a semaphore .. This patch switches
it over to a struct mutex.

Signed-off-by: Daniel Walker <dwalker@mvista.com>
Signed-off-by: Jeff Dike <jdike@linux.intel.com>
---
 arch/um/drivers/mconsole_kern.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

Index: linux-2.6-git/arch/um/drivers/mconsole_kern.c
===================================================================
--- linux-2.6-git.orig/arch/um/drivers/mconsole_kern.c	2008-01-17 14:35:43.000000000 -0500
+++ linux-2.6-git/arch/um/drivers/mconsole_kern.c	2008-01-17 14:37:29.000000000 -0500
@@ -17,6 +17,7 @@
 #include "linux/syscalls.h"
 #include "linux/utsname.h"
 #include "linux/workqueue.h"
+#include "linux/mutex.h"
 #include "asm/uaccess.h"
 #include "init.h"
 #include "irq_kern.h"
@@ -360,7 +361,7 @@ struct unplugged_pages {
 	void *pages[UNPLUGGED_PER_PAGE];
 };
 
-static DECLARE_MUTEX(plug_mem_mutex);
+static DEFINE_MUTEX(plug_mem_mutex);
 static unsigned long long unplugged_pages_count = 0;
 static LIST_HEAD(unplugged_pages);
 static int unplug_index = UNPLUGGED_PER_PAGE;
@@ -396,7 +397,7 @@ static int mem_config(char *str, char **
 
 	diff /= PAGE_SIZE;
 
-	down(&plug_mem_mutex);
+	mutex_lock(&plug_mem_mutex);
 	for (i = 0; i < diff; i++) {
 		struct unplugged_pages *unplugged;
 		void *addr;
@@ -453,7 +454,7 @@ static int mem_config(char *str, char **
 
 	err = 0;
 out_unlock:
-	up(&plug_mem_mutex);
+	mutex_unlock(&plug_mem_mutex);
 out:
 	return err;
 }
