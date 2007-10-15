Return-Path: <linux-kernel-owner+w=401wt.eu-S1763770AbXJOXlX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763770AbXJOXlX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 19:41:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755796AbXJOXlO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 19:41:14 -0400
Received: from sullivan.realtime.net ([205.238.132.226]:3909 "EHLO
	sullivan.realtime.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754909AbXJOXlN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 19:41:13 -0400
Date: Mon, 15 Oct 2007 18:40:43 -0500 (CDT)
From: Milton Miller <miltonm@bga.com>
Subject: [PATCH] sched domain sysctl: free kstrdup allocations
Message-Id: <mm-sched-2b@bga.com>
In-Reply-To: <20071015074700.GC32064@elte.hu>
References: <mm-sched-0@bga.com>, <mm-sched-2@bga.com>,
	<20071015074700.GC32064@elte.hu>
To: Ingo Molnar <mingo@elte.hu>
Cc: <linux-kernel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The procnames for the cpu and domain were allocated via kstrdup and so
should also be freed.   The names for the files are static, but we
can differentiate them by the presence of the proc_handler.  If a
kstrdup (of < 32 characters) fails the sysctl code will not see the
procname or remaining table entries, but any child tables and names
will be reclaimed upon free.

Signed-off-by: Milton Miller <miltonm@bga.com>
--- 

Hi Ingo.

It occurred to me this morning that the procname field was dynamically
allocated and needed to be freed.  I started to put in break statements
when allocation failed but it was approaching 50% error handling code.

I came up with this alternative of looping while entry->mode is set and
checking proc_handler instead of ->table.  Alternatively, the string
version of the domain name and cpu number could be stored the structs.

I verified by compiling CONFIG_DEBUG_SLAB and checking the allocation
counts after taking a cpuset exclusive and back.

milton

Index: kernel/kernel/sched.c
===================================================================
--- kernel.orig/kernel/sched.c	2007-10-15 12:21:38.000000000 -0500
+++ kernel/kernel/sched.c	2007-10-15 12:22:12.000000000 -0500
@@ -5290,11 +5290,20 @@ static struct ctl_table *sd_alloc_ctl_en
 
 static void sd_free_ctl_entry(struct ctl_table **tablep)
 {
-	struct ctl_table *entry = *tablep;
+	struct ctl_table *entry;
 
-	for (entry = *tablep; entry->procname; entry++)
+	/*
+	 * In the intermediate directories, both the child directory and
+	 * procname are dynamically allocated and could fail but the mode
+	 * will always be set.  In the lowest directory the names are
+	 * static strings and all have proc handlers.
+	 */
+	for (entry = *tablep; entry->mode; entry++) {
 		if (entry->child)
 			sd_free_ctl_entry(&entry->child);
+		if (entry->proc_handler == NULL)
+			kfree(entry->procname);
+	}
 
 	kfree(*tablep);
 	*tablep = NULL;
