Return-Path: <linux-kernel-owner+w=401wt.eu-S1767153AbXCIKxF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767153AbXCIKxF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 05:53:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767158AbXCIKxF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 05:53:05 -0500
Received: from wr-out-0506.google.com ([64.233.184.237]:60331 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767153AbXCIKxC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 05:53:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=jwuoEorFZVOzkRtSxb9YxBt81iQekaom0/PPbMLLIyddOfUsAylcXxr0pJqpDs4VELv6x0lQy6W42l4DJ5Y0yibtVOG3G9oUKGZrVg+3lRV5tA1oamKPpvfHrTatjqtnMwoWqXV8ALNVnxzhqkD+Ys12+5kkMxhLmvo0Z2/3D+Q=
Message-ID: <b0943d9e0703090253r690e1f21qf8d7a1edfd08561b@mail.gmail.com>
Date: Fri, 9 Mar 2007 10:53:01 +0000
From: "Catalin Marinas" <catalin.marinas@gmail.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: Possible "struct pid" leak from tty_io.c
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <m13b4f7ggy.fsf@ebiederm.dsl.xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <b0943d9e0703080927hde01f7dt9ae06433e0c87549@mail.gmail.com>
	 <m13b4f7ggy.fsf@ebiederm.dsl.xmission.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/03/07, Eric W. Biederman <ebiederm@xmission.com> wrote:
> "Catalin Marinas" <catalin.marinas@gmail.com> writes:
> > I'm trying to track down a kmemleak report (on an ARM platform) which
> > seems to have appeared with commit
> > ab521dc0f8e117fd808d3e425216864d60390500. As I'm not familiar with the
> > TTY layer at all, is it possible that the above commit missed a
> > put_pid() call on some path?
>
> I won't arbitrarily rule a missing put_pid out.  I have been know to
> goof up upon occasion.

I'm not entirely sure it's this part of the code, I would have to do
some more investigations (I didn't get this leak before). An
"unscientific" test shows that if I define get_pid/put_pid in the
tty_io.c file so that pid->count is not affected, the leak disappears.
This doesn't necessarily prove that the fault is here though.

> I just did a quick look to see what kmemleak is.  A conservative
> tracing leak detector sounds interesting.  Except for all of the list
> heads which lead to container_of calls I don't know of anything in the
> struct pid implementation that would be difficult for it to work with.
> Well that and there is some rcu access protection which can delay the
> free by a bit.

Kmemleak can cope with list heads and rcu delayed freeing as it also
checks for pointer aliases (those accessible via container_of).

> > The /sbin/init application calls sys_clone() a few times but only one
> > leak is reported (see below). Looking at the reported pid object (at
> > 0xc7c14500), count is 2 and nr is 296 but no process with pid 296
> > exists any more.
>
> It could still be a valid session or a process group id.
> If you examine the struct pid you can test for this be examining all
> of the list heads it keeps.  If there is something on any of the
> lists that would account a count of 1.  How we have a count of 2
> I don't have enough information to guess.

I think it's only the pid_chain and rcu member that could be placed in
a list and kmemleak scans the memory for these two offsets as well.
I'll check those lists anyway but I doubt it's a more fundamental
problem with how kmemleak handles struct pid as I should've probably
got more reports.

> In most any other layer we cache pids indefinitely and a situation
> where we have a pointer to a struct pid with a ref count of 1 long
> after the process goes away is expected.

Yes, indeed, but what kmemleak reports is that the pid structure
wasn't freed yet and there is no way to determine its pointer directly
or via container_of on members (by scanning the memory), hence it is
considered a leak.

> I don't understand your situation enough to guess what is going wrong
> yet.  Hopefully I have given you enough information to get started.

Yes, many thanks. I'll dig further and let you know.

-- 
Catalin
