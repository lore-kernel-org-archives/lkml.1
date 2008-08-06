Return-Path: <linux-kernel-owner+w=401wt.eu-S1759600AbYHFUEN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759600AbYHFUEN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 16:04:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756395AbYHFUAW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 16:00:22 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:59377 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756135AbYHFUAU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 16:00:20 -0400
Date: Wed, 6 Aug 2008 16:00:18 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Greg KH <greg@kroah.com>, Dave Hansen <haveblue@us.ibm.com>
cc: Kernel development list <linux-kernel@vger.kernel.org>
Subject: [PATCH] fix verify_dynamic_kobject_allocation()
Message-ID: <Pine.LNX.4.44L0.0808061558320.2138-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The warn-when-statically-allocated-kobjects-are-used patch crashes my
machine during boot when it calls kzalloc(), presumably because the
call occurs too early.  This patch (as1126) fixes it by using a static
string instead of a dynamically-allocated string.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>

---

Index: usb-2.6/lib/kobject.c
===================================================================
--- usb-2.6.orig/lib/kobject.c
+++ usb-2.6/lib/kobject.c
@@ -38,10 +38,9 @@ static int ptr_in_range(void *ptr, void 
 
 static void verify_dynamic_kobject_allocation(struct kobject *kobj)
 {
-	char *namebuf;
+	static char namebuf[KSYM_NAME_LEN];
 	const char *ret;
 
-	namebuf = kzalloc(KSYM_NAME_LEN, GFP_KERNEL);
 	ret = kallsyms_lookup((unsigned long)kobj, NULL, NULL, NULL,
 			namebuf);
 	/*
@@ -52,9 +51,9 @@ static void verify_dynamic_kobject_alloc
 	 */
 	if (!initmem_now_dynamic &&
 	    ptr_in_range(kobj, __init_begin, __init_end))
-		goto out;
+		return;
 	if (!ret || !strlen(ret))
-		goto out;
+		return;
 	pr_debug("---- begin silly warning ----\n");
 	pr_debug("This is a janitorial warning, not a kernel bug.\n");
 	pr_debug("The kobject '%s', at, or inside '%s'@(0x%p) is not "
@@ -62,8 +61,6 @@ static void verify_dynamic_kobject_alloc
 	pr_debug("kobjects must be dynamically allocated, not static\n");
 	/* dump_stack(); */
 	pr_debug("---- end silly warning ----\n");
-out:
-	kfree(namebuf);
 }
 #else
 static void verify_dynamic_kobject_allocation(struct kobject *kobj) { }

