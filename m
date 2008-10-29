Return-Path: <linux-kernel-owner+w=401wt.eu-S1753237AbYJ2G3h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753237AbYJ2G3h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 02:29:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752018AbYJ2G32
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 02:29:28 -0400
Received: from wf-out-1314.google.com ([209.85.200.174]:21375 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751357AbYJ2G31 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 02:29:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=Hq1GhcOe5bh+iQm8jq4il2I/1cf60C+KU9RUKABR+DrqlJv9w4SThNBtLaqpB4ZMeM
         WJ13qYByhsrNa2ckT++33RP45rqco2xW+CdujlwElAB0Z774CJ4L07cQ/y8ELwkCnfqJ
         gt26/H+ZFgJ8BU3O5bNQJiDcp2doVMrW6JaXc=
Subject: Re: [PATCH 1/2] headers: move release_kernel_lock(),
 reacquire_kernel_lock() to sched.c
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Alexey Dobriyan <adobriyan@gmail.com>, torvalds@osdl.org,
       viro@zeniv.linux.org.uk, acme@ghostprotocols.net,
       linux-kernel@vger.kernel.org
In-Reply-To: <20081029061827.GA7936@elte.hu>
References: <20081029044351.GA2304@x200.localdomain>
	 <20081029044447.GB2304@x200.localdomain>  <20081029061827.GA7936@elte.hu>
Content-Type: text/plain
Date: Tue, 28 Oct 2008 23:29:24 -0700
Message-Id: <1225261764.20276.7.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-10-29 at 07:18 +0100, Ingo Molnar wrote:
> * Alexey Dobriyan <adobriyan@gmail.com> wrote:
> > +#ifdef CONFIG_LOCK_KERNEL
> > +/*
> > + * Release/re-acquire global kernel lock for the scheduler
> > + */
> > +#define release_kernel_lock(tsk) do { 		\
> > +	if (unlikely((tsk)->lock_depth >= 0))	\
> > +		__release_kernel_lock();	\
> > +} while (0)
> > +
> > +static inline int reacquire_kernel_lock(struct task_struct *task)
> > +{
> > +	if (unlikely(task->lock_depth >= 0))
> > +		return __reacquire_kernel_lock();
> > +	return 0;
> > +}
> > +#else
> > +#define release_kernel_lock(task)		do { } while(0)
> > +#define reacquire_kernel_lock(task)		0
> > +#endif
> 

Also is it possible to keep them as inlines in both the CONFIG_LOCK_KERNEL
and !CONFIG_LOCK_KERNEL

Something like (without checking if release_kernel_lock _can_ be an inline:

static inline void release_kernel_lock(struct task_struct *task)
{
#ifdef CONFIG_LOCK_KERNEL
	if (unlikely(task->lock_depth >= 0))
		__release_kernel_lock();
#endif
	return;
}

static inline int reacquire_kernel_lock(struct task_struct *task)
{
#ifdef CONFIG_LOCK_KERNEL
	if (unlikely(task->lock_depth >= 0))
		return __reacquire_kernel_lock();
#endif
	return 0;
}

Then the typechecking is kept in both CONFIG_LOCK_KERNEL/!CONFIG_LOCK_KERNEL

Cheers,

Harvey

