Return-Path: <linux-kernel-owner+w=401wt.eu-S1752615AbXCHSL5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752615AbXCHSL5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 13:11:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752616AbXCHSL5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 13:11:57 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:47393 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752615AbXCHSL4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 13:11:56 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Catalin Marinas" <catalin.marinas@gmail.com>
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: Re: Possible "struct pid" leak from tty_io.c
References: <b0943d9e0703080927hde01f7dt9ae06433e0c87549@mail.gmail.com>
Date: Thu, 08 Mar 2007 11:11:41 -0700
In-Reply-To: <b0943d9e0703080927hde01f7dt9ae06433e0c87549@mail.gmail.com>
	(Catalin Marinas's message of "Thu, 8 Mar 2007 17:27:37 +0000")
Message-ID: <m13b4f7ggy.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"Catalin Marinas" <catalin.marinas@gmail.com> writes:

> Hi Eric,
>
> I'm trying to track down a kmemleak report (on an ARM platform) which
> seems to have appeared with commit
> ab521dc0f8e117fd808d3e425216864d60390500. As I'm not familiar with the
> TTY layer at all, is it possible that the above commit missed a
> put_pid() call on some path?

I won't arbitrarily rule a missing put_pid out.  I have been know to
goof up upon occasion.

I just did a quick look to see what kmemleak is.  A conservative
tracing leak detector sounds interesting.  Except for all of the list
heads which lead to container_of calls I don't know of anything in the
struct pid implementation that would be difficult for it to work with.
Well that and there is some rcu access protection which can delay the
free by a bit.

> The /sbin/init application calls sys_clone() a few times but only one
> leak is reported (see below). Looking at the reported pid object (at
> 0xc7c14500), count is 2 and nr is 296 but no process with pid 296
> exists any more.

It could still be a valid session or a process group id.
If you examine the struct pid you can test for this be examining all
of the list heads it keeps.  If there is something on any of the
lists that would account a count of 1.  How we have a count of 2
I don't have enough information to guess.

Core tty layer handling stops having an remembering pids when the
session or process group exits so it is relatively safe from pid wrap
around issues without my changes and should make the kind of thing you
are reporting very unlikely in a correctly functioning system.

In most any other layer we cache pids indefinitely and a situation
where we have a pointer to a struct pid with a ref count of 1 long
after the process goes away is expected.  In this case it is better
to hold a reference to a struct pid so we don't do the wrong thing
when pid wrap around occurs then to hold a reference to an entire
task_struct and lock that in place.

I don't understand your situation enough to guess what is going wrong
yet.  Hopefully I have given you enough information to get started.


> unreferenced object 0xc7c14500 (size 36):
>  comm "init", pid 245, jiffies 4294939289
>  backtrace:
>    [<c0070c18>] kmem_cache_alloc
>    [<c003a528>] alloc_pid
>    [<c0026468>] do_fork
>    [<c00153b0>] sys_clone
>    [<c0010f80>] ret_fast_syscall

I think this is the path that all pid structures come from so
unfortunately that doesn't help tracing this problem down.

Eric
