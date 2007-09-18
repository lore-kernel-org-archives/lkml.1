Return-Path: <linux-kernel-owner+w=401wt.eu-S1756046AbXIRKdh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756046AbXIRKdh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 06:33:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754702AbXIRKdb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 06:33:31 -0400
Received: from mailhub.sw.ru ([195.214.233.200]:37390 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753206AbXIRKdb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 06:33:31 -0400
Date: Tue, 18 Sep 2007 14:32:47 +0400
From: Alexey Dobriyan <adobriyan@sw.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: nadia.derbey@bull.net, linux-kernel@vger.kernel.org
Subject: Re: 2.6.23-rc6-mm1: IPC: sleeping function called ...
Message-ID: <20070918103247.GA6787@localhost.sw.ru>
References: <20070918091728.GA6766@localhost.sw.ru> <20070918032727.c07aa521.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070918032727.c07aa521.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 18, 2007 at 03:27:27AM -0700, Andrew Morton wrote:
> On Tue, 18 Sep 2007 13:17:28 +0400 Alexey Dobriyan <adobriyan@sw.ru> wrote:
> 
> > I'm getting tons of this, and X fails to start
> > 
> > CONFIG_SYSVIPC=y
> > CONFIG_SYSVIPC_SYSCTL=y
> > # CONFIG_PREEMPT_NONE is not set
> > # CONFIG_PREEMPT_VOLUNTARY is not set
> > CONFIG_PREEMPT=y
> > CONFIG_PREEMPT_BKL=y
> > CONFIG_DEBUG_PREEMPT=y
> > 
> > BUG: sleeping function called from invalid context at kernel/rwsem.c:47
> > in_atomic():1, irqs_disabled():0
> 
> OK, this fixes the locking here:

Ditto. Thanks!
[puts mental note to read IPC patches]

> --- a/ipc/util.c~ipc-integrate-ipc_checkid-into-ipc_lock-fix-2
> +++ a/ipc/util.c
> @@ -295,7 +295,6 @@ int ipc_addid(struct ipc_ids* ids, struc
>  
>  	spin_lock_init(&new->lock);
>  	new->deleted = 0;
> -	rcu_read_lock();
>  	spin_lock(&new->lock);
>  	return id;
>  }
> @@ -691,7 +690,7 @@ struct kern_ipc_perm *ipc_lock(struct ip
>  		rcu_read_unlock();
>  		return ERR_PTR(-EINVAL);
>  	}
> -
> +	rcu_read_unlock();
>  	return out;
>  }

