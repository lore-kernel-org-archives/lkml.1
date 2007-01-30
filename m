Return-Path: <linux-kernel-owner+w=401wt.eu-S1751761AbXA3Thf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751761AbXA3Thf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 14:37:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751760AbXA3The
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 14:37:34 -0500
Received: from mta11.adelphia.net ([68.168.78.205]:63549 "EHLO
	mta11.adelphia.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751761AbXA3The (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 14:37:34 -0500
Date: Tue, 30 Jan 2007 13:37:31 -0600
From: Corey Minyard <minyard@acm.org>
To: Andrew Morton <akpm@osdl.org>, Linux Kernel <linux-kernel@vger.kernel.org>
Cc: David Barksdale <amatus@ocgnet.org>
Subject: [PATCH] IPMI: fix timeout list handling
Message-ID: <20070130193731.GA12130@localdomain>
Reply-To: minyard@acm.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Barksdale <amatus@ocgnet.org>

This patch against the 2.6.20-rc6 kernel fixes a dangling pointer bug in
ipmi_timeout_handler. A list of timedout messages is not re-initialized
before reuse, causing the head of the list to point to freed memory.

Signed-off-by: David Barksdale <amatus@ocgnet.org>
Signed-off-by: Corey Minyard <minyard@acm.org>
---
diff -ruNp linux-2.6.git.orig/drivers/char/ipmi/ipmi_msghandler.c linux-2.6.git/drivers/char/ipmi/ipmi_msghandler.c
--- linux-2.6.git.orig/drivers/char/ipmi/ipmi_msghandler.c	2007-01-30 10:32:14.000000000 -0600
+++ linux-2.6.git/drivers/char/ipmi/ipmi_msghandler.c	2007-01-30 10:33:50.000000000 -0600
@@ -3649,8 +3649,6 @@ static void ipmi_timeout_handler(long ti
 	unsigned long        flags;
 	int                  i;
 
-	INIT_LIST_HEAD(&timeouts);
-
 	rcu_read_lock();
 	list_for_each_entry_rcu(intf, &ipmi_interfaces, link) {
 		/* See if any waiting messages need to be processed. */
@@ -3671,6 +3669,7 @@ static void ipmi_timeout_handler(long ti
 		/* Go through the seq table and find any messages that
 		   have timed out, putting them in the timeouts
 		   list. */
+		INIT_LIST_HEAD(&timeouts);
 		spin_lock_irqsave(&intf->seq_lock, flags);
 		for (i = 0; i < IPMI_IPMB_NUM_SEQ; i++)
 			check_msg_timeout(intf, &(intf->seq_table[i]),

