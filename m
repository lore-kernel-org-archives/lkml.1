Return-Path: <linux-kernel-owner+w=401wt.eu-S1753848AbZIQUaM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753848AbZIQUaM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 16:30:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753348AbZIQUaK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 16:30:10 -0400
Received: from smtp-out.google.com ([216.239.33.17]:18250 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753336AbZIQUaJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 16:30:09 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=hXttcQ6YKsi2hLkTtXPNtoHxrbqMQPu8R4fi5m9ZL0u9d2wDrZCBR/nozsnsQa7TU
	/38W6WXAfhAe+YN6ITiag==
Date: Thu, 17 Sep 2009 13:29:59 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Eric Paris <eparis@redhat.com>
cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org
Subject: Re: kernel panic - not syncing: out of memory and no killable
 processes
In-Reply-To: <1253191435.5213.209.camel@dhcp231-106.rdu.redhat.com>
Message-ID: <alpine.DEB.1.00.0909171326340.31112@chino.kir.corp.google.com>
References: <1253158603.5213.204.camel@dhcp231-106.rdu.redhat.com> <1253191435.5213.209.camel@dhcp231-106.rdu.redhat.com>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Sep 2009, Eric Paris wrote:

> the next-20090916 tree still panic's the same way.  As does Linus'
> latest git tree ab86e5765
> 
> I'll try bisecting between v2.6.31 and master if it would give better
> data than trying to bisect between two -next trees, but I'm sorta stuck
> with a machine that won't boot and doesn't tell me much about why.
> 

It's panicking because the oom killer is getting called during boot and 
there are no user tasks to kill, i.e. there are only kthreads running, 
which it can't kill.  It sounds like something is trying to allocate 
higher order pages that cannot be found on your 512M machine because of 
fragmentation.

Try merging the following patch to get more information such as the 
allocation order and gfp_mask.  It will also show the VM size of all 
kthreads and the state of your system memory to deterine whether there's a 
page allocator issue, lowmem_reserve_ratio is too high, etc.
---
diff --git a/mm/oom_kill.c b/mm/oom_kill.c
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -540,6 +540,15 @@ retry:
 	/* Found nothing?!?! Either we hang forever, or we panic. */
 	if (!p) {
 		read_unlock(&tasklist_lock);
+		printk(KERN_WARNING "%s invoked oom-killer: "
+			"gfp_mask=0x%x, order=%d, oomkilladj=%d\n",
+			current->comm, gfp_mask, order, current->oomkilladj);
+		task_lock(current);
+		cpuset_print_task_mems_allowed(current);
+		task_unlock(current);
+		dump_stack();
+		show_mem();
+		dump_tasks(NULL);
 		panic("Out of memory and no killable processes...\n");
 	}
 
