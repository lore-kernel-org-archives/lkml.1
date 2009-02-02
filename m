Return-Path: <linux-kernel-owner+w=401wt.eu-S1757791AbZBBULO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757791AbZBBULO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 15:11:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753523AbZBBUK4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 15:10:56 -0500
Received: from wa-out-1112.google.com ([209.85.146.177]:54773 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757478AbZBBUKz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 15:10:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=RjjXKUWO6e/t4MB0WcdCSKJzE3yRtZl21maoCYQLyqy1bsuJ9SdAAqusI12umvPzST
         bxNS1lE5P2lV9GKC8eW+Tw27P4rwo1Vj9L8IF0E+Y5mpBT6DYGhyd2qyVWJ8fJXhth/p
         oLmISwQlc1xl39utrkimWVa4WEfhEyBAD9nFQ=
MIME-Version: 1.0
In-Reply-To: <20090202165606.GA13346@redhat.com>
References: <3f43f78b0902011432y354c1b35m8f645640433f7b49@mail.gmail.com>
	 <20090201174159.4a52e15c.akpm@linux-foundation.org>
	 <20090202064509.GA20237@redhat.com>
	 <3f43f78b0902012310p46186417m66873f410b948fd3@mail.gmail.com>
	 <20090202165606.GA13346@redhat.com>
Date: Mon, 2 Feb 2009 12:10:53 -0800
Message-ID: <3f43f78b0902021210h5b3e7b39h89f9d7303a3ab393@mail.gmail.com>
Subject: Re: main thread pthread_exit/sys_exit bug!
From: Kaz Kylheku <kkylheku@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Roland McGrath <roland@redhat.com>, Ulrich Drepper <drepper@redhat.com>,
       Oleg Nesterov <oleg@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 2, 2009 at 8:56 AM, Oleg Nesterov <oleg@redhat.com> wrote:
> Well, perhaps something like your patch makes sense.
>
>        +/*
>        + * A single thread is exiting, and it is the leader of the group.
>        + * This coresponds to the main thread calling pthread_exit.
>        + * In this case, the persists until all the other
>        + * threads call pthread_exit, or someone calls exit or _exit.
>        + * To implement this case, we park the thread leader in
>        + * a loop which waits until the thread list becomes empty,
>        + * or it receives a fatal signal.
>                           ^^^^^^^^^^^^^^
> The comment is not exactly right, we return on every signal, not only fatal.

Yes; that's stale text, referring to some earlier code that had been changed.

> the above is just the open-coded
> wait_event_interruptible(&current->signal->wait_chldexit,
>                                thread_group_empty(current));

Terrific! I will make the change locally.

Btw, it's ``hand coded''.  ``Open coding'' is what both programmers and macros
do. Hand conding is the dumb thing I did instead of using the macro to open
code it. :)

> I am worried this patch can confuse the user-space. Because, when
> the main thread does sys_exit(), the user-space has all rights
> to assume it exits ;)

Only glibc knows about sys_exit. (Or are there run-times for other language
implementations that have their own binding to sys_exit, bypassing pthreads?)

The POSIX interface used by applications is pthread_exit, and there is no
assumption there about it being an exit-like system call. It has a number of
standard-defined user-space chores to do, in fact.

> But with this patch the main thread will
> continue to handle the signals until the while group exits, I'm
> afraid libpthread.so won't be happy.

> And what if the signal handler does siglongjmp() and aborts sys_exit() ?

pthread_exit peforms cleanup unwinding (required by Unix and POSIX) and
destruction of thread-specific storage.

Glibc does this and then performs its own longjmp to a handler in the startup
code above main. At that point it's no longer correct to longjmp to any of
the frames that have been aborted by that action.  It's still executing user
code; sys_exit has not been called yet, and the signal handler can go
off.

Other than that, there is actually nothing wrong with aborting sys_exit. It
hasn't done any cleanup yet through do_exit, so it can be nicely
reentered later.

I'd say that any programs that are broken by this patch are
probably ``fork in the toaster'' category anyway.

Note that programs can also abort the exit function with signals, too,
and there is nothing that can be done in the kernel about it.

>> It's a bad idea to allow the main thread to terminate. It should stick
>> around because it serves as a facade for the process as a whole. If
>> the main thread is allowed to bail all the way through do_exit, who
>> knows what kind of problems may show up because of that.
>>
>> What if one of my developers is working on a server which has called
>> pthread_exit in the main thread, and wants to attach gdb to it? Will
>> that work if the main thread (a.k.a group leader) is a defunct
>> process?
>
> And I think gdb is wrong. It can see this process has other live threads,
> and attach to them.

But if this problem is patched in this very simple way in the kernel, then gdb
installations ``Just Work'' without even being recompiled.

Probably, the only way the gdb maintainers would accept another Linux-specific
hack would be if they didn't know that a kernel patch will fix it. :)
