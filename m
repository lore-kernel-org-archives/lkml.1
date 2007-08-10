Return-Path: <linux-kernel-owner+w=401wt.eu-S933272AbXHJBLT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933272AbXHJBLT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 21:11:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753654AbXHJBLI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 21:11:08 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:58902 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752646AbXHJBLG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 21:11:06 -0400
Date: Thu, 9 Aug 2007 20:11:04 -0500
From: Dean Nelson <dcn@sgi.com>
To: linux-ia64@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, tony.luck@intel.com, jes@sgi.com
Subject: Re: [RFC 1/3] SGI Altix cross partition memory (XPMEM)
Message-ID: <20070810011104.GB25427@sgi.com>
References: <20070810010659.GA25427@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070810010659.GA25427@sgi.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch exports __put_task_struct as it is needed by XPMEM.

Signed-off-by: Dean Nelson <dcn@sgi.com>

---

One struct file_operations registered by XPMEM, xpmem_open(), calls
'get_task_struct(current->group_leader)' and another, xpmem_flush(), calls
'put_task_struct(tg->group_leader)'. The reason for this is given in the
comment block that appears in xpmem_open().

        /*
         * Increment 'usage' and 'mm->mm_users' for the current task's thread
         * group leader. This ensures that both its task_struct and mm_struct
         * will still be around when our thread group exits. (The Linux kernel
         * normally tears down the mm_struct prior to calling a module's
         * 'flush' function.) Since all XPMEM thread groups must go through
         * this path, this extra reference to mm_users also allows us to
         * directly inc/dec mm_users in xpmem_ensure_valid_PFNs() and avoid
         * mmput() which has a scaling issue with the mmlist_lock.
         */

Index: linux-2.6/kernel/fork.c
===================================================================
--- linux-2.6.orig/kernel/fork.c	2007-08-09 07:07:55.426611601 -0500
+++ linux-2.6/kernel/fork.c	2007-08-09 07:15:43.246391700 -0500
@@ -127,6 +127,7 @@
 	if (!profile_handoff_task(tsk))
 		free_task(tsk);
 }
+EXPORT_SYMBOL_GPL(__put_task_struct);
 
 void __init fork_init(unsigned long mempages)
 {
