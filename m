Return-Path: <linux-kernel-owner+w=401wt.eu-S1753322AbYCLSh1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753322AbYCLSh1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 14:37:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751653AbYCLShR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 14:37:17 -0400
Received: from cantor2.suse.de ([195.135.220.15]:37135 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751579AbYCLShQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 14:37:16 -0400
From: Andi Kleen <ak@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Save some bytes in mm_struct by filling holes on 64bit
Date: Wed, 12 Mar 2008 19:38:05 +0100
User-Agent: KMail/1.9.1
Cc: linux-kernel@vger.kernel.org
References: <20080312142807.GA2290@bingen.suse.de> <20080312110537.3f812130.akpm@linux-foundation.org>
In-Reply-To: <20080312110537.3f812130.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803121938.05497.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> The current ioctx_list_lock position is better from a cache layout POV?

Hmm ok you're right perhaps it's better to move core_waiters up
instead. Updated  patch
Save some bytes in mm_struct by filling holes v2

Putting int values together for better packing on 64bit 
shrinks sizeof(struct mm_struct) from 776 bytes to 760 bytes.

Signed-off-by: Andi Kleen <ak@suse.de>

Index: linux-2.6.25-rc5/include/linux/mm_types.h
===================================================================
--- linux-2.6.25-rc5.orig/include/linux/mm_types.h
+++ linux-2.6.25-rc5/include/linux/mm_types.h
@@ -172,6 +172,7 @@ struct mm_struct {
 	atomic_t mm_users;			/* How many users with user space? */
 	atomic_t mm_count;			/* How many references to "struct mm_struct" (users 
count as 1) */
 	int map_count;				/* number of VMAs */
+	int core_waiters;
 	struct rw_semaphore mmap_sem;
 	spinlock_t page_table_lock;		/* Protects page tables and some counters */
 
@@ -216,11 +217,10 @@ struct mm_struct {
 	unsigned long flags; /* Must use atomic bitops to access the bits */
 
 	/* coredumping support */
-	int core_waiters;
 	struct completion *core_startup_done, core_done;
 
 	/* aio bits */
-	rwlock_t		ioctx_list_lock;
+	rwlock_t		ioctx_list_lock;	/* aio lock */
 	struct kioctx		*ioctx_list;
 #ifdef CONFIG_CGROUP_MEM_RES_CTLR
 	struct mem_cgroup *mem_cgroup;
