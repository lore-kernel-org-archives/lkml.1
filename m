Return-Path: <linux-kernel-owner+w=401wt.eu-S1755977AbXEZBkt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755977AbXEZBkt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 21:40:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752787AbXEZBkk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 21:40:40 -0400
Received: from wine.ocn.ne.jp ([220.111.47.146]:56137 "EHLO
	smtp.wine.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752653AbXEZBkj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 21:40:39 -0400
To: casey@schaufler-ca.com, jbms@cmu.edu
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [AppArmor 01/41] Pass struct vfsmount to the inode_create LSM hook
From: Tetsuo Handa <penguin-fsdevel@I-love.SAKURA.ne.jp>
References: <87fy5kpye6.fsf@jbms.ath.cx>
	<770093.5988.qm@web36601.mail.mud.yahoo.com>
In-Reply-To: <770093.5988.qm@web36601.mail.mud.yahoo.com>
Message-Id: <200705261040.ACB55702.FEtVMFOOHFQTWGJ@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.50]
X-Accept-Language: ja,en
Date: Sat, 26 May 2007 10:40:44 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Casey Schaufler wrote:
> Sorry, but I don't understand your objection. If AppArmor is configured
> to allow everyone access to /bin/gzip but only some people access to
> /bin/gunzip and (important detail) the single binary uses argv[0]
> as documented and (another important detail) there aren't other links
> named gunzip to the binary (ok, that's lots of if's) you should be fine.

The argv[0] defines the default behavior of hard linked or symbolic linked programs,
but the behavior can be overridden using commandline options.
If you want to allow access to /bin/gzip but deny access to /bin/gunzip ,
you also need to deny access to "/bin/gzip -d" "/bin/gzip --decompress" "/bin/gzip --uncompress".
It is impossible to do so because options to override the default behavior
depends on program's design and you can't know
what programs and what options are there in the system.
Even if you know all programs and all options in the system,
it is a too tough job to find and reject options
that override the default behavior in the kernel space.

> > Well, my point was exactly that App Armor doesn't (as far as I know) do
> > anything to enforce the argv[0] convention,
> Sounds like an opportunity for improvement then.

There are (I think) three types of program invocation.

(1) Invocation of hard linked programs.

    /bin/gzip and /bin/gunzip and /bin/zcat are hard links.

    There is no problem because you can know which pathname was requested
    using d_namespace_path() with "struct linux_binprm"->file .

(2) Invocation of symbolic linked programs.

    /sbin/pidof is a symbolic link to /sbin/killall .

    There is a problem because you can't know which pathname was requested
    using d_namespace_path() with "struct linux_binprm"->file
    because the symbolic links were already derefernced inside open_exec().
    To know which pathname was requested, you need to lookup
    using "struct linux_binprm"->filename without LOOKUP_FOLLOW
    and then use d_namespace_path().
    Although there is a race condition that the pathname
    the symbolic link "struct linux_binprm"->filename points to
    may change, but it is inevitable because you can't get
    dentry and vfsmount of both "without LOOKUP_FOLLOW flag" and
    "with LOOKUP_FOLLOW flag" at the same time.

(3) Invocation of dynamically created programs with random names.

    /usr/sbin/logrotate creates files patterned /tmp/logrotate.??????
    and executes these dynamically created files.

    To keep execution of these dynamically created files under control,
    you need to aggregate pathnames of these files.
    AppArmor can't define profile if the pathname of programs is random, can it?

Usually the argv[0] and the "struct linux_binprm"->filename are the same,
but if you want to do something with argv[0], you will need to handle the (2) case
to see whether the argv[0] and "struct linux_binprm"->filename are the same.

Thanks.
