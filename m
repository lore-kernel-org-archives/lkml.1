Return-Path: <linux-kernel-owner+w=401wt.eu-S964858AbZJJCXk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964858AbZJJCXk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 22:23:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934743AbZJJCXj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 22:23:39 -0400
Received: from ey-out-2122.google.com ([74.125.78.27]:60990 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934740AbZJJCXi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 22:23:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=E4auwja1Cri5ohEu+VokkFhTz6sFQobzIlqVLwzb1ZqU2q2iKHOiRmQffDy7m0ky8d
         p2wsOkJwBEpSovqmEhLTELxbNUjOD+3eJvBdJwTnlqsJ4RKL+ixT6niiXCZgnXGy+TzJ
         6qkJEDEWUl/zmKGsLeIaVDkyQrodRaC9SvKr8=
MIME-Version: 1.0
In-Reply-To: <20091009171344.3fc5f28b.akpm@linux-foundation.org>
References: <20091009134354.12A7.A69D9226@jp.fujitsu.com> <20091009171344.3fc5f28b.akpm@linux-foundation.org>
From: Bryan Donlan <bdonlan@gmail.com>
Date: Fri, 9 Oct 2009 22:22:10 -0400
Message-ID: <3e8340490910091922g7891b31al649e91f15ffae687@mail.gmail.com>
Subject: Re: [resend][PATCH] Added PR_SET_PROCTITLE_AREA option for prctl()
To: Andrew Morton <akpm@linux-foundation.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org, Ulrich Drepper <drepper@redhat.com>,
       linux-api@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 9, 2009 at 8:13 PM, Andrew Morton <akpm@linux-foundation.org> wrote:

>> +             res = access_process_vm(task, mm->arg_start, buffer, len, 0);
>> +
>> +             if (mm->arg_end != mm->env_start)
>> +                     /* PR_SET_PROCTITLE_AREA used */
>>                       res = strnlen(buffer, res);
>
> Hang on.
>
> If PR_SET_PROCTITLE_AREA installed a bad address then
> access_process_vm() will return -EFAULT and nothing was written to
> `buffer'?
>
> Also, concurrent PR_SET_PROCTITLE_AREA could cause arg_start and
> arg_end to have inconsistent/incoherent values.  This might result in a
> fault but it also might result in a read of garbage userspace memory.
>
> I guess all of these issues could be written off as "userspace bugs",
> but our behaviour here isn't nice.  We should at least return that
> -EFAULT!.

access_process_vm() does not return an error code - just the number of
bytes successfully transferred. If there's a fault, we just get 0 (or
some intermediate value) back (as discussed on lkml).

>> +                             res += access_process_vm(task, mm->env_start,
>> +                                                      buffer+res, len, 0);
>> +                             res = strnlen(buffer, res);
>> +                     }
>
> And if access_process_vm() returns a -ve errno here, the code simply
> flies off into the weeds.

This code was originally there - it's just been lifted into an if :)
and since access_process_vm will never return a negative errno, it's
not a problem.

Now, there might be a case for arguing that we should try harder to
get an error code (-EIO if we don't read the number of bytes we asked
for), but /proc/pid/cmdline never has before, and that would then make
this a visible change for consumers of /proc/pid/cmdline. Can ps
handle reading cmdline returning -EIO?

> seqlocks are nice but I have to wonder if they made this patch
> unnecessarily complex.  Couldn't we just do:
>
>         PR_SET_PROCTITLE_AREA:
>
>                spin_lock(mm->lock);
>                mm->arg_start = addr;
>                mm->arg_end = addr + len;
>                spin_unlock(mm->lock);
>
> and
>
>        proc_pid_cmdline()
>        {
>                unsigned long addr;
>                unsigned long end;
>
>                spin_lock(mm->lock);
>                addr = mm->arg_start;
>                end = mm->arg_end;
>                spin_unlock(mm->lock);
>
>                <use `addr' and `len'>
>        }
>
> ?

As discussed on the lkml thread, this opens up a nasty race:

Process A: calls PR_SET_PROCTITLE_AREA
Process B: read cmdline:
Process B: spin_lock
Process B: read mm->arg_*
Process B: unlock
Process A: mm->arg_* = ...
Process A: free(old_cmdline_area)
Process A: secret_password = malloc(...)
Process A: strcpy(secret_password, stuff);
Process B: access_process_vm

If secret_password == arg_start, then process B just read secret
information from process A's address space. Since process A has no
idea when or even if process B will complete its read, it has no way
of protecting itself from this, save from never reusing any memory
which has ever been assigned to a proctitle area.

The solution is to use the seqlock to detect this, and prevent the
secret information from ever making it back to process B's userspace.
Note that it's not enough to just recheck arg_start, as process A may
reassign the proctitle area back to its original position after having
it somewhere else for a while.
