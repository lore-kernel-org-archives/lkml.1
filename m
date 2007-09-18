Return-Path: <linux-kernel-owner+w=401wt.eu-S1756811AbXIRKfb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756811AbXIRKfb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 06:35:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755011AbXIRKfX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 06:35:23 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51821 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755048AbXIRKfX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 06:35:23 -0400
Date: Tue, 18 Sep 2007 03:34:00 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Nadia Derbey <Nadia.Derbey@bull.net>
Cc: Alexey Dobriyan <adobriyan@sw.ru>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.23-rc6-mm1: IPC: sleeping function called ...
Message-Id: <20070918033400.495b02dd.akpm@linux-foundation.org>
In-Reply-To: <46EFA8DC.2020909@bull.net>
References: <20070918091728.GA6766@localhost.sw.ru>
	<20070918031723.05689e92.akpm@linux-foundation.org>
	<46EFA8DC.2020909@bull.net>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Sep 2007 12:30:52 +0200 Nadia Derbey <Nadia.Derbey@bull.net> wrote:

> Andrew Morton wrote:
> > On Tue, 18 Sep 2007 13:17:28 +0400 Alexey Dobriyan <adobriyan@sw.ru> wrote:
> > 
> > 
> >>I'm getting tons of this, and X fails to start
> >>
> >>CONFIG_SYSVIPC=y
> >>CONFIG_SYSVIPC_SYSCTL=y
> >># CONFIG_PREEMPT_NONE is not set
> >># CONFIG_PREEMPT_VOLUNTARY is not set
> >>CONFIG_PREEMPT=y
> >>CONFIG_PREEMPT_BKL=y
> >>CONFIG_DEBUG_PREEMPT=y
> >>
> >>BUG: sleeping function called from invalid context at kernel/rwsem.c:47
> >>in_atomic():1, irqs_disabled():0
> >>no locks held by X/5879.
> >> [<c012bcb1>] down_write+0x15/0x50
> >> [<c01b53af>] do_shmat+0x235/0x3a0
> >> [<c0106be2>] sys_ipc+0x146/0x263
> >> [<c0102892>] sysenter_past_esp+0xa7/0xb5
> >> [<c0102856>] sysenter_past_esp+0x6b/0xb5
> >> =======================
> > 
> > 
> > Here's a bug:
> > 
> > --- a/ipc/util.c~ipc-integrate-ipc_checkid-into-ipc_lock-fix-2
> > +++ a/ipc/util.c
> > @@ -691,7 +691,7 @@ struct kern_ipc_perm *ipc_lock(struct ip
> >  		rcu_read_unlock();
> >  		return ERR_PTR(-EINVAL);
> >  	}
> > -
> > +	rcu_read_unlock();
> >  	return out;
> >  }
> >  
> 
> Andrew,
> 
> Actually the rcu_read_lock is released in ipc_unlock().

I agree it should be, but it isn't.

> So I think we 
> shouldn't add an rcu_read_unlock() before leaving ipc_lock().
> This is a part that has not changed since the ref code.
> 

Well, it was an optimisation.  spin_lock() implies rcu_read_lock().  That's
a bit dirty and we might choose to not do that.

Would be interested in knowing the locking rules in there.  For example,
this:

/**
 *	ipc_findkey	-	find a key in an ipc identifier set	
 *	@ids: Identifier set
 *	@key: The key to find
 *	
 *	Requires ipc_ids.mutex locked.
 *	Returns the LOCKED pointer to the ipc structure if found or NULL
 *	if not.
 *	If key is found ipc contains its ipc structure
 */

appears to be hopelessly out of date?

