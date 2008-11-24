Return-Path: <linux-kernel-owner+w=401wt.eu-S1753037AbYKXMrT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753037AbYKXMrT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 07:47:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751334AbYKXMrJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 07:47:09 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:37264 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751191AbYKXMrI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 07:47:08 -0500
Message-ID: <492AA241.6050004@openvz.org>
Date: Mon, 24 Nov 2008 15:46:57 +0300
From: Pavel Emelyanov <xemul@openvz.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Michael Kerrisk <mtk.manpages@googlemail.com>
CC: Kir Kolyshkin <kir@openvz.org>, linux-man@vger.kernel.org,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: Documentation for CLONE_NEWPID
References: <4923810B.7010201@gmail.com>
In-Reply-To: <4923810B.7010201@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Kerrisk wrote:
> Pavel, Kir,
> 
> Drawing fairly heavily on your LWN.net article (http://lwn.net/Articles/259217/), plus the kernel 
> source and some experimentation, I created the patch below to document CLONE_NEWPID for the clone(2) 
> manual page.  Could you please review and let me know of any improvements or inaccuracies.

Michael, sorry for the late response - I've been on vacation last week and didn't
have chance to connect to check my mail. Some comments are inline.

> Thanks,
> 
> Michael
> 
> --- a/man2/clone.2
> +++ b/man2/clone.2
> @@ -266,6 +268,78 @@ in the same
>  .BR clone ()
>  call.
>  .TP
> +.BR CLONE_NEWPID " (since Linux 2.6.24)"
> +.\" This explanation draws a lot of details from
> +.\" http://lwn.net/Articles/259217/
> +.\" Authors: Pavel Emelyanov <xemul@openvz.org>
> +.\" and Kir Kolyshkin <kir@openvz.org>
> +.\"
> +.\" The primary kernel commit is 30e49c263e36341b60b735cbef5ca37912549264
> +.\" Author: Pavel Emelyanov <xemul@openvz.org>
> +If
> +.B CLONE_PID
> +is set, then create the process in a new PID namespace.
> +If this flag is not set, then (as with
> +.BR fork (2)),
> +the process is created in the same PID namespace as
> +the calling process.
> +This flag is intended for the implementation of control groups.

Well, actually this has nothing to do with control groups. This
flag is intended to be used to facilitate the creation of containers
along with many other clone flags. Control groups is yet another
way to create a container.

> +A PID namespace provides an isolated environment for PIDs:
> +PIDs in a new namespace start at 1,
> +somewhat like a standalone system, and calls to
> +.BR fork (2),
> +.BR vfork (2),
> +or
> +.BR clone (2)
> +will produce processes whose PIDs within the namespace
> +are only guaranteed to be unique within that namespace.

Well, I'm not sure I understood correctly what was meant here, but after 
we have a namespace each task has two pids. And _all_ of them are unique 
in corresponding namespaces.

> +The first process created in a new namespace
> +(i.e., the process created using the
> +.BR CLONE_NEWPID
> +flag) has the PID 1, and is the "init" process for the namespace.
> +Children that are orphaned within the namespace will be reparented
> +to this process rather than
> +.BR init (8).
> +Unlike the traditional
> +.B init
> +process, the "init" process of a PID namespace can terminate,
> +and if it does, all of the processes in the namespace are terminated.
> +
> +PID namespaces form a hierarchy.
> +When a PID new namespace is created,
> +the PIDs of the processes in that namespace are visible
> +in the PID namespace of the process that created the new namespace;
> +analogously, if the parent PID namespace is itself
> +the child of another PID namespace,
> +then PIDs of the child and parent PID namespaces will both be
> +visible in the grandparent PID namespace.
> +Conversely, the processes in the "child" PID namespace do not see
> +the PIDs of the processes in the parent namespace.
> +The existence of a namespace hierarchy means that each process
> +may now have multiple PIDs:
> +one for each namespace in which it is visible.
> +(A call to
> +.BR getpid (2)
> +always returns the PID associated with the namespace in which
> +the process was created.)

I don't thinks it's a good example - the getpid cannot be called
for other process other than current :)

> +
> +After creating the new namespace,
> +it is useful for the child to change its root directory
> +and mount a new procfs instance at
> +.I /proc
> +so that tools such as
> +.BR ps (1)
> +work correctly.
> +
> +Use of this flag requires: a kernel configured with the
> +.B CONFIG_PID_NS
> +configuration option and requires that the process be privileged
> +.RB (CAP_SYS_ADMIN ).
> +This flag can't be specified in conjunction with
> +.BR CLONE_THREAD .
> +.TP
>  .BR CLONE_PARENT " (since Linux 2.3.12)"
>  If
>  .B CLONE_PARENT
> @@ -627,6 +701,14 @@ were specified in
>  .IR flags .
>  .TP
>  .B EINVAL
> +Both
> +.BR CLONE_NEWPID
> +and
> +.BR CLONE_THREAD
> +were specified in
> +.IR flags .
> +.TP
> +.B EINVAL
>  Returned by
>  .BR clone ()
>  when a zero value is specified for
> @@ -639,6 +721,8 @@ copied.
>  .TP
>  .B EPERM
>  .B CLONE_NEWNS
> +or
> +.B CLONE_NEWPID
>  was specified by a non-root process (process without \fBCAP_SYS_ADMIN\fP).
>  .TP
>  .B EPERM
> 

