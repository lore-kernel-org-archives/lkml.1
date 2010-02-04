Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757298Ab0BDIBh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 03:01:37 -0500
Received: from mail-qy0-f201.google.com ([209.85.221.201]:50724 "EHLO
	mail-qy0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754651Ab0BDIBf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 03:01:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=R5w4PLkevQVUXins7eZ2A/njdhQT4xTTtXyLT3qRggK99vDY3V5O2RWpmJRf5aImxv
         ffQSLtFJRMzP/3Ds0457zLpjDsX//X5j6y/ga0FWO05R7Xj0emIk9gBVYWsOWpfXEF+q
         ezqnLyPxmB1sBb0SL8oRO+Os8aUR3EW1+lB9o=
MIME-Version: 1.0
In-Reply-To: <1264625298.4591.700948@ngc224.gerwinski.de>
References: <1264625298.4591.700948@ngc224.gerwinski.de>
Date: Thu, 4 Feb 2010 16:01:34 +0800
Message-ID: <2375c9f91002040001t1064c8c9h8990b40b63290dd5@mail.gmail.com>
Subject: Re: CLONE_VM: parent terminates silently when child segfaults
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: Frank Heckenbach <f.heckenbach@fh-soft.de>
Cc: linux-kernel@vger.kernel.org, oleg@redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 28, 2010 at 4:48 AM, Frank Heckenbach
<f.heckenbach@fh-soft.de> wrote:
> When a process cloned with CLONE_VM is killed by SIGSEGV, the parent
> process is terminated silently. I don't know if this is known or
> intended behaviour, but I didn't find anything about it.
>
> The test program below demonstrates the problem. It forks a process
> which in turn clones another process which kills itself with
> SIGSEGV.
>
> When I remove the CLONE_VM flag, the program runs as expected:
>
>  fork_pid = ...
>  clone_pid = ...
>  (1 second delay)
>  cloned process status = 11
>  forked process status = 0
>
> However, with CLONE_VM I get:
>
>  fork_pid = ...
>  clone_pid = ...
>  (1 second delay)
>  forked process status = 0
>
> i.e., no output from the first forked process after its waitpid(),
> and no error indication in its status as seen by the main process.
>
> Note: The fork() before clone() is not essential to cause this
> behaviour, just to see its effects (in the 2nd waitpid()). You can
> see the same by calling the program without fork from the shell and
> looking at $?. I just put in fork to make sure it's not a shell
> problem or something.
>
> The problem only occurs with signals such as SIGSEGV or SIGILL, not
> with SIGINT, SIGUSR1, etc. Since CLONE_VM and SIGSEGV both have to
> do with the shared memory space, I'd understand if the parent
> process was also killed by SIGSEGV or so. But having it return with
> status 0 seems strange -- how is one supposed to detect a SIGSEGV in
> the child? The parent can't do it when it's terminated, and the
> parent's parent only sees it terminate with 0.

I think this behavior is somewhat expected.

Becase SIGSEGV and SIGILL are coredump signals, when you use CLONE_VM,
child process will share the memory space with its parent, what would
you expect the parent behaves when its child coredumping their shared memory
space?

Also, you may want to check CLONE_THREAD too, it also provides a chance
of leaving the status of child unavailable.

Cc'ing signal experts...
