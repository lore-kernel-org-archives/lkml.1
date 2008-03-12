Return-Path: <linux-kernel-owner+w=401wt.eu-S1752115AbYCLO2T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752115AbYCLO2T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 10:28:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751261AbYCLO2K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 10:28:10 -0400
Received: from ns1.suse.de ([195.135.220.2]:53903 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751230AbYCLO2J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 10:28:09 -0400
Date: Wed, 12 Mar 2008 15:28:07 +0100
From: Andi Kleen <ak@suse.de>
To: akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] Save some bytes in mm_struct by filling holes on 64bit
Message-ID: <20080312142807.GA2290@bingen.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Save some bytes in mm_struct by filling holes

Putting int values together for better packing on 64bit 
shrinks sizeof(struct mm_struct) from 776 bytes to 760 bytes.

Signed-off-by: Andi Kleen <ak@suse.de>

Index: linux-2.6.25-rc5/include/linux/mm_types.h
===================================================================
--- linux-2.6.25-rc5.orig/include/linux/mm_types.h
+++ linux-2.6.25-rc5/include/linux/mm_types.h
@@ -172,6 +172,7 @@ struct mm_struct {
 	atomic_t mm_users;			/* How many users with user space? */
 	atomic_t mm_count;			/* How many references to "struct mm_struct" (users count as 1) */
 	int map_count;				/* number of VMAs */
+	rwlock_t		ioctx_list_lock;	/* aio lock */
 	struct rw_semaphore mmap_sem;
 	spinlock_t page_table_lock;		/* Protects page tables and some counters */
 
@@ -213,14 +214,13 @@ struct mm_struct {
 	unsigned int token_priority;
 	unsigned int last_interval;
 
+	int core_waiters;
 	unsigned long flags; /* Must use atomic bitops to access the bits */
 
 	/* coredumping support */
-	int core_waiters;
 	struct completion *core_startup_done, core_done;
 
 	/* aio bits */
-	rwlock_t		ioctx_list_lock;
 	struct kioctx		*ioctx_list;
 #ifdef CONFIG_CGROUP_MEM_RES_CTLR
 	struct mem_cgroup *mem_cgroup;
