Return-Path: <linux-kernel-owner+w=401wt.eu-S1756365AbXIRK2q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756365AbXIRK2q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 06:28:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754956AbXIRK2j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 06:28:39 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55056 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754949AbXIRK2j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 06:28:39 -0400
Date: Tue, 18 Sep 2007 03:27:27 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Alexey Dobriyan <adobriyan@sw.ru>
Cc: nadia.derbey@bull.net, linux-kernel@vger.kernel.org
Subject: Re: 2.6.23-rc6-mm1: IPC: sleeping function called ...
Message-Id: <20070918032727.c07aa521.akpm@linux-foundation.org>
In-Reply-To: <20070918091728.GA6766@localhost.sw.ru>
References: <20070918091728.GA6766@localhost.sw.ru>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Sep 2007 13:17:28 +0400 Alexey Dobriyan <adobriyan@sw.ru> wrote:

> I'm getting tons of this, and X fails to start
> 
> CONFIG_SYSVIPC=y
> CONFIG_SYSVIPC_SYSCTL=y
> # CONFIG_PREEMPT_NONE is not set
> # CONFIG_PREEMPT_VOLUNTARY is not set
> CONFIG_PREEMPT=y
> CONFIG_PREEMPT_BKL=y
> CONFIG_DEBUG_PREEMPT=y
> 
> BUG: sleeping function called from invalid context at kernel/rwsem.c:47
> in_atomic():1, irqs_disabled():0

OK, this fixes the locking here:

--- a/ipc/util.c~ipc-integrate-ipc_checkid-into-ipc_lock-fix-2
+++ a/ipc/util.c
@@ -295,7 +295,6 @@ int ipc_addid(struct ipc_ids* ids, struc
 
 	spin_lock_init(&new->lock);
 	new->deleted = 0;
-	rcu_read_lock();
 	spin_lock(&new->lock);
 	return id;
 }
@@ -691,7 +690,7 @@ struct kern_ipc_perm *ipc_lock(struct ip
 		rcu_read_unlock();
 		return ERR_PTR(-EINVAL);
 	}
-
+	rcu_read_unlock();
 	return out;
 }
 
_

But I'm not very confident in what's happening in there.  The patches take
away a _lot_ of the RCU locking, and it's unlear what's protecting the idr
tree.  Is it rcu, or is it the mutex?  The code seems confused and the
comments are all wrong.
