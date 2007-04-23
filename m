Return-Path: <linux-kernel-owner+w=401wt.eu-S1754119AbXDWRrj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754119AbXDWRrj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 13:47:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754116AbXDWRrj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 13:47:39 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:41874 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754118AbXDWRri (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 13:47:38 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Christoph Hellwig <hch@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>, containers@lists.osdl.org,
       linux-kernel@vger.kernel.org, Marcel Holtmann <marcel@holtmann.org>,
       rusty@rustcorp.com.au
Subject: Re: [PATCH] kthread: Spontaneous exit support
References: <m1slawn9eb.fsf@ebiederm.dsl.xmission.com>
	<1176969596686-git-send-email-ebiederm@xmission.com>
	<20070419162459.af7a182c.akpm@linux-foundation.org>
	<20070422194455.GA18561@infradead.org>
	<m1fy6rzsug.fsf_-_@ebiederm.dsl.xmission.com>
	<20070423112537.GA21941@infradead.org>
	<20070423165810.GA188@tv-sign.ru>
Date: Mon, 23 Apr 2007 11:45:51 -0600
In-Reply-To: <20070423165810.GA188@tv-sign.ru> (Oleg Nesterov's message of
	"Mon, 23 Apr 2007 20:58:10 +0400")
Message-ID: <m1mz0zvvao.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov <oleg@tv-sign.ru> writes:

> On 04/23, Christoph Hellwig wrote:
>>
>> On Sun, Apr 22, 2007 at 09:12:55PM -0600, Eric W. Biederman wrote:
>> > 
>> > This patch implements the kthread helper functions kthread_start
>> > and kthread_end which make it simple to support a kernel thread
>> > that may decided to exit on it's own before we request it to.
>> > It is still assumed that eventually we will get around to requesting
>> > that the kernel thread stop.
>> 
>> I don't think having to parallel APIs is a good idea, people will
>> get utterly confused which one to use.  Better always grab a reference
>> in kthread_create and drop it in kthread_stop.  For normal thread
>> no change in behaviour and only slightly more code in the slowpath.
>> 
>> Of course it will need an audit for half-assed kthread conversion
>> first to avoid task_struct reference count leaks.
>
> In that case it is better to grab a reference in kthread(). This also
> close the race when a new thread is woken (freezer) and exits before
> kthread_create() does get_task_struct().
>
>> In addition to that kthrad_end implementation look wrong. When
>> the kthread has exited prematurely no one will call complete
>> on kthread_stop_info.done before it's been setup.
>
> This is not true anymore, see another patch from Eric
>
> 	kthread-enhance-kthread_stop-to-abort-interruptible-sleeps.patch

Ok.  Thinking about it I agree with Christoph that parallel API's can
be a problem.

However we do still need to support kernel threads where kthread_stop will
never be called.  There appear to be a few legitimate cases where
someone wants to fire off a thread and have it do some work but don't
care at all for stopping it before it is done.

So I propose we add a kthread_orphan as a basic primitive to decrement the
count on the task_struct if we want a kthread to simply exit after it
has done some work.

And as a helper function we can have a kthread_run_orphan.

I think having a kthread_orphan will document what we are doing better
and make it easy to find kernel threads that don't use kthread_stop.

The pain is that this requires an audit of all kernel kthread creators
so that we call kthread_orphan on the right ones, or else we will have
a task_struct leak.  At least that isn't a fatal condition.

Eric
