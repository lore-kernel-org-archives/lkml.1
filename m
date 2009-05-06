Return-Path: <linux-kernel-owner+w=401wt.eu-S1752610AbZEFWvk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752610AbZEFWvk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 18:51:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752811AbZEFWuy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 18:50:54 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:60874 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751915AbZEFWux (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 18:50:53 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: pm list <linux-pm@lists.linux-foundation.org>
Subject: [RFC][PATCH 2/5] PM/Suspend: Do not shrink memory before suspend
Date: Thu, 7 May 2009 00:42:01 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc4-rjw; KDE/4.2.2; x86_64; ; )
Cc: Wu Fengguang <fengguang.wu@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>,
       Nigel Cunningham <nigel@tuxonice.net>
References: <200905070040.08561.rjw@sisk.pl>
In-Reply-To: <200905070040.08561.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905070042.01880.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Remove the shrinking of memory from the suspend-to-RAM code, where
it is not really necessary.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 kernel/power/main.c |   20 +-------------------
 1 file changed, 1 insertion(+), 19 deletions(-)

Index: linux-2.6/kernel/power/main.c
===================================================================
--- linux-2.6.orig/kernel/power/main.c
+++ linux-2.6/kernel/power/main.c
@@ -188,9 +188,6 @@ static void suspend_test_finish(const ch
 
 #endif
 
-/* This is just an arbitrary number */
-#define FREE_PAGE_NUMBER (100)
-
 static struct platform_suspend_ops *suspend_ops;
 
 /**
@@ -226,7 +223,6 @@ int suspend_valid_only_mem(suspend_state
 static int suspend_prepare(void)
 {
 	int error;
-	unsigned int free_pages;
 
 	if (!suspend_ops || !suspend_ops->enter)
 		return -EPERM;
@@ -241,24 +237,10 @@ static int suspend_prepare(void)
 	if (error)
 		goto Finish;
 
-	if (suspend_freeze_processes()) {
-		error = -EAGAIN;
-		goto Thaw;
-	}
-
-	free_pages = global_page_state(NR_FREE_PAGES);
-	if (free_pages < FREE_PAGE_NUMBER) {
-		pr_debug("PM: free some memory\n");
-		shrink_all_memory(FREE_PAGE_NUMBER - free_pages);
-		if (nr_free_pages() < FREE_PAGE_NUMBER) {
-			error = -ENOMEM;
-			printk(KERN_ERR "PM: No enough memory\n");
-		}
-	}
+	error = suspend_freeze_processes();
 	if (!error)
 		return 0;
 
- Thaw:
 	suspend_thaw_processes();
 	usermodehelper_enable();
  Finish:
