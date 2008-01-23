Return-Path: <linux-kernel-owner+w=401wt.eu-S1756970AbYAWTLm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756970AbYAWTLm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 14:11:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755819AbYAWTLa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 14:11:30 -0500
Received: from e2.ny.us.ibm.com ([32.97.182.142]:43236 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755495AbYAWTL2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 14:11:28 -0500
Subject: Re: [PATCH 1/4] add task handling notifier: base definitions
From: Matt Helsley <matthltc@us.ibm.com>
To: Jan Beulich <jbeulich@novell.com>
Cc: Paul Jackson <pj@sgi.com>, linux-kernel@vger.kernel.org
In-Reply-To: <4784A601.76E4.0078.0@novell.com>
References: <476A7832.76E4.0078.0@novell.com>
	 <1199852889.17010.243.camel@localhost.localdomain>
	 <4784A601.76E4.0078.0@novell.com>
Content-Type: text/plain
Organization: IBM Linux Technology Center
Date: Wed, 23 Jan 2008 11:11:25 -0800
Message-Id: <1201115485.5443.41.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2008-01-09 at 09:46 +0000, Jan Beulich wrote:
> >> +BLOCKING_NOTIFIER_HEAD(task_notifier_list);
> >> +EXPORT_SYMBOL_GPL(task_notifier_list);
> >> +ATOMIC_NOTIFIER_HEAD(atomic_task_notifier_list);
> >> +EXPORT_SYMBOL_GPL(atomic_task_notifier_list);
> >> +
> >
> >When these global notifier lists were proposed years ago folks at SGI
> >loudly objected with concerns over anticipated cache line bouncing on
> >512+ cpu machines. Is that no longer a concern?
> 
> I can't see an alternative, since the serialization is unavoidable.

There are definitely alternatives. Naturally they are all much more
complex than using a single notifier chain. You could do per-cpu chains
for example (ugly, I know..).

> >> @@ -121,6 +127,9 @@ void __put_task_struct(struct task_struc
> >>  	WARN_ON(atomic_read(&tsk->usage));
> >>  	WARN_ON(tsk == current);
> >> 
> >> +	atomic_notifier_call_chain(&atomic_task_notifier_list,
> >> +				   TASK_DELETE, tsk);
> >> +
> >>  	security_task_free(tsk);
> >>  	free_uid(tsk->user);
> >>  	put_group_info(tsk->group_info);
> >
> >Would the atomic notifier call chain be necessary if you hooked into an
> >earlier section of do_exit() instead?
> 
> I'm afraid it is, as I was told that sleeping in the do_exit() path is not
> generally possible.
> 
> Jan

Odd. Last I checked I thought I saw a bunch of calls in do_exit() that
could sleep. Only in certain sections and at the end did it appear to
prevent sleeping.

Sorry for the late reply.

Cheers,
	-Matt Helsley

