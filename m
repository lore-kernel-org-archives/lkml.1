Return-Path: <linux-kernel-owner+w=401wt.eu-S1756006AbXIRKSu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756006AbXIRKSu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 06:18:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754430AbXIRKSn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 06:18:43 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59980 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755257AbXIRKSl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 06:18:41 -0400
Date: Tue, 18 Sep 2007 03:17:23 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Alexey Dobriyan <adobriyan@sw.ru>
Cc: nadia.derbey@bull.net, linux-kernel@vger.kernel.org
Subject: Re: 2.6.23-rc6-mm1: IPC: sleeping function called ...
Message-Id: <20070918031723.05689e92.akpm@linux-foundation.org>
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
> no locks held by X/5879.
>  [<c012bcb1>] down_write+0x15/0x50
>  [<c01b53af>] do_shmat+0x235/0x3a0
>  [<c0106be2>] sys_ipc+0x146/0x263
>  [<c0102892>] sysenter_past_esp+0xa7/0xb5
>  [<c0102856>] sysenter_past_esp+0x6b/0xb5
>  =======================

Here's a bug:

--- a/ipc/util.c~ipc-integrate-ipc_checkid-into-ipc_lock-fix-2
+++ a/ipc/util.c
@@ -691,7 +691,7 @@ struct kern_ipc_perm *ipc_lock(struct ip
 		rcu_read_unlock();
 		return ERR_PTR(-EINVAL);
 	}
-
+	rcu_read_unlock();
 	return out;
 }
 
_

but it still doesn't fix it.

Nadia, please review Documentation/SubmitChecklist.  It contains stuff
which would have prevented this.

