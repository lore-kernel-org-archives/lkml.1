Return-Path: <linux-kernel-owner+w=401wt.eu-S932596AbZLHQhN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932596AbZLHQhN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 11:37:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932407AbZLHQhM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 11:37:12 -0500
Received: from mx1.redhat.com ([209.132.183.28]:32911 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932532AbZLHQhL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 11:37:11 -0500
Date: Tue, 8 Dec 2009 17:31:31 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Alexey Dobriyan <adobriyan@gmail.com>,
       Ananth Mavinakayanahalli <ananth@in.ibm.com>,
       Christoph Hellwig <hch@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org,
       utrace-devel@redhat.com
Subject: Re: [RFC,PATCH 14/14] utrace core
Message-ID: <20091208163131.GA14815@redhat.com>
References: <20091124200220.GA5828@redhat.com> <1259697242.1697.1075.camel@laptop> <20091201220847.GA25400@redhat.com> <1260210877.3935.594.camel@laptop> <20091208150417.GA11883@redhat.com> <1260286163.3935.1497.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1260286163.3935.1497.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/08, Peter Zijlstra wrote:
>
> On Tue, 2009-12-08 at 16:04 +0100, Oleg Nesterov wrote:
> >
> > Well, this is subjective, but I don't agree that
> >
> >         get_task_struct(task);
> >         task->utrace_flags = flags;
> >         spin_unlock(&utrace->lock);
> >         put_task_struct(task);
> >
> > looks better.
>
> No, what I mean by assymetric locking is that utrace_reset() and
> utrace_reap() drop the utrace->lock where their caller acquired it,
> resulting in non-obvious like:
>
> utrace_control()
> {
>
>   ...
>   spin_lock(&utrace->lock);
>
>   ...
>
>   if (reset)
>     utrace_reset(utrace);
>   else
>     spin_unlock(&utrace->lock);
> }

Agreed, the code like this never looks good.

> If you take a task ref you can write the much saner:
>
> utrace_control()
> {
>   ...
>   spin_lock(&utrace->lock);
>   ...
>   if (reset)
>     utrace_reset(utrace);
>
>   spin_unlock(&utrace->lock);
> }

No, get_task_struct() in utrace_reset() can't help, we should move
it into utrace_control() then. And in this case it becomes even more
subtle: it is needed because ->utrace_flags may be cleared inside
utrace_reset() and after that utrace_control()->spin_unlock() becomes
unsafe.

Also. utrace_reset() drops utrace->lock to call put_detached_list()
lockless. If we want to avoid the assymetric locking, every caller
should pass "struct list_head *detached" to utrace_reset(), drop
utrace->lock, and call put_detached_list().

Oleg.

