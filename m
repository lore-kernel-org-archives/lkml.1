Return-Path: <linux-kernel-owner+w=401wt.eu-S1762427AbXJLQoy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762427AbXJLQoy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 12:44:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760355AbXJLQnP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 12:43:15 -0400
Received: from vms048pub.verizon.net ([206.46.252.48]:53573 "EHLO
	vms048pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760332AbXJLQnM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 12:43:12 -0400
Date: Fri, 12 Oct 2007 11:42:41 -0500
From: Corey Minyard <minyard@acm.org>
Subject: [PATCH 6/7] IPMI: fix hotmod remove lock
To: Andrew Morton <akpm@osdl.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Reply-to: minyard@acm.org
Message-id: <20071012164241.GF22142@minyard.local>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Corey Minyard <cminyard@mvista.com>

The removal of proc entries was done holding a lock, which is
no longer allowed.  There is no need for the lock, only a mutex
is required, so switch over to a mutex.

Not needed for the stable kernel.

Signed-off-by: Corey Minyard <cminyard@mvista.com>

Index: linux-2.6.21/drivers/char/ipmi/ipmi_msghandler.c
===================================================================
--- linux-2.6.21.orig/drivers/char/ipmi/ipmi_msghandler.c
+++ linux-2.6.21/drivers/char/ipmi/ipmi_msghandler.c
@@ -221,10 +221,8 @@ struct ipmi_smi
 	void                     *send_info;
 
 #ifdef CONFIG_PROC_FS
-	/* A list of proc entries for this interface.  This does not
-	   need a lock, only one thread creates it and only one thread
-	   destroys it. */
-	spinlock_t             proc_entry_lock;
+	/* A list of proc entries for this interface. */
+	struct mutex           proc_entry_lock;
 	struct ipmi_proc_entry *proc_entries;
 #endif
 
@@ -1891,11 +1889,11 @@ int ipmi_smi_add_proc_entry(ipmi_smi_t s
 		file->write_proc = write_proc;
 		file->owner = owner;
 
-		spin_lock(&smi->proc_entry_lock);
+		mutex_lock(&smi->proc_entry_lock);
 		/* Stick it on the list. */
 		entry->next = smi->proc_entries;
 		smi->proc_entries = entry;
-		spin_unlock(&smi->proc_entry_lock);
+		mutex_unlock(&smi->proc_entry_lock);
 	}
 #endif /* CONFIG_PROC_FS */
 
@@ -1939,7 +1937,7 @@ static void remove_proc_entries(ipmi_smi
 #ifdef CONFIG_PROC_FS
 	struct ipmi_proc_entry *entry;
 
-	spin_lock(&smi->proc_entry_lock);
+	mutex_lock(&smi->proc_entry_lock);
 	while (smi->proc_entries) {
 		entry = smi->proc_entries;
 		smi->proc_entries = entry->next;
@@ -1948,7 +1946,7 @@ static void remove_proc_entries(ipmi_smi
 		kfree(entry->name);
 		kfree(entry);
 	}
-	spin_unlock(&smi->proc_entry_lock);
+	mutex_unlock(&smi->proc_entry_lock);
 	remove_proc_entry(smi->proc_dir_name, proc_ipmi_root);
 #endif /* CONFIG_PROC_FS */
 }
@@ -2690,7 +2688,7 @@ int ipmi_register_smi(struct ipmi_smi_ha
 	}
 	intf->curr_seq = 0;
 #ifdef CONFIG_PROC_FS
-	spin_lock_init(&intf->proc_entry_lock);
+	mutex_init(&intf->proc_entry_lock);
 #endif
 	spin_lock_init(&intf->waiting_msgs_lock);
 	INIT_LIST_HEAD(&intf->waiting_msgs);
