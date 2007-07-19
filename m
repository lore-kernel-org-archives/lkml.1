Return-Path: <linux-kernel-owner+w=401wt.eu-S938148AbXGSNxv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938148AbXGSNxv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 09:53:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936634AbXGSNsm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 09:48:42 -0400
Received: from ns1.suse.de ([195.135.220.2]:54524 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935021AbXGSNsl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 09:48:41 -0400
From: Andi Kleen <ak@suse.de>
References: <20070719348.540885000@suse.de>
In-Reply-To: <20070719348.540885000@suse.de>
To: will_schmidt@vnet.ibm.com, ak@suse.de, linux-kernel@vger.kernel.org
Subject: [PATCH for review] [11/48] x86_64: During VM oom condition, kill all threads in process group
Message-Id: <20070719134840.47B5114E6E@wotan.suse.de>
Date: Thu, 19 Jul 2007 15:48:40 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Will Schmidt <will_schmidt@vnet.ibm.com>

During a VM oom condition, kill all threads in the process group.

We have had complaints where a threaded application is left in a bad state
after one of it's threads is killed when we hit a VM: out_of_memory condition.

Killing just one of the process threads can leave the application in a bad
state, whereas killing the entire process group would allow for the
application to restart, or otherwise handled, and makes it very obvious that
something has gone wrong.

This change allows the entire process group to be taken down, rather than just
the one thread.

Signed-off-by: Will <will_schmidt@vnet.ibm.com>
Signed-off-by: Andi Kleen <ak@suse.de>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86_64/mm/fault.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux/arch/x86_64/mm/fault.c
===================================================================
--- linux.orig/arch/x86_64/mm/fault.c
+++ linux/arch/x86_64/mm/fault.c
@@ -569,7 +569,7 @@ out_of_memory:
 	}
 	printk("VM: killing process %s\n", tsk->comm);
 	if (error_code & 4)
-		do_exit(SIGKILL);
+		do_group_exit(SIGKILL);
 	goto no_context;
 
 do_sigbus:
