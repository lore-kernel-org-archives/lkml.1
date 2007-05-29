Return-Path: <linux-kernel-owner+w=401wt.eu-S1764776AbXE2L1Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764776AbXE2L1Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 07:27:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756172AbXE2L1S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 07:27:18 -0400
Received: from wine.ocn.ne.jp ([220.111.47.146]:57121 "EHLO
	smtp.wine.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752119AbXE2L1S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 07:27:18 -0400
X-Greylist: delayed 2473 seconds by postgrey-1.27 at vger.kernel.org; Tue, 29 May 2007 07:27:17 EDT
To: crispin@novell.com, cliffe@iinet.net.au
Cc: casey@schaufler-ca.com, mrmacman_g4@mac.com,
       linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [AppArmor 01/41] Pass struct vfsmount to the inode_create LSMhook
From: Tetsuo Handa <from-lsm@I-love.SAKURA.ne.jp>
References: <653438.15244.qm@web36612.mail.mud.yahoo.com>
	<465AE46B.4090109@iinet.net.au>
	<465B57D7.2040101@novell.com>
In-Reply-To: <465B57D7.2040101@novell.com>
Message-Id: <200705291946.FDB72328.NtTGSNMP@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.50]
X-Accept-Language: ja,en
Date: Tue, 29 May 2007 19:46:04 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Crispin Cowan wrote:
> AppArmor actually does something similar to this, by mediating all of
> the ways that you can make an alias to a file. These are:
> 
>     * Symbolic links: these actually don't work for making aliases with
>       respect to LSM-based security systems such as AppArmor, SELinux,
>       and TOMOYO Linux, because the symbolic link is resolved before the
>       access request is presented to the LSM hooks. So if you create the
>       symbolic link /tmp/harmless -> /etc/shadow and then the confined
>       victim tries to access /tmp/harmless, what the LSM sees is an
>       attempt to access /etc/shadow.
Yes, TOMOYO does so too.

Although TOMOYO is not using LSM, TOMOYO checks it by manually inserted hooks
that are called after resolving the symbolic links.

>     * Hard links: AppArmor explicitly mediates permission to make a hard
>       link to a file. To be able to make a hard link /tmp/harmless ->
>       /etc/shadow you have to have explicit permission to do so, or the
>       attempt to make the link is blocked. This mediation is kept
>       relatively simple by the fact that you can only hard link to
>       files, and not to directories.
Yes, TOMOYO does so too.

Conventional UNIX's access control can't restrict
which path_to_file can link with which another_path_to_file
because UNIX's access control is a label-based access control.
Therefore "ln /etc/shadow /tmp/harmless" becomes a problem
when introducing pathname-based access control.

TOMOYO checks the combination of both link source and destination,
using "allow_link path_to_link_source path_to_link_destination" syntax.
Therefore "ln /etc/shadow /tmp/harmless" is impossible as long as
"allow_link /etc/shadow /tmp/harmless" (or something like "allow_link /etc/\* /tmp/\*")
is not given. TOMOYO checks rename operation as well using
"allow_rename path_to_oldname path_to_newname" syntax.

>     * Multiple mounts: Linux lets you mount the same file system
>       multiple times at multiple mount points, so the same file could
>       appear at two different places. AppArmor has very coarse mediation
>       here, and simply prohibits all calls to mount() without special
>       permission. So only highly privileged processes can create such an
>       alias.
Yes, TOMOYO does so too.

But TOMOYO checks not only the capability to call mount() system call
but also the combination of "path_to_device" "path_to_mountpoint" and "filesystem_type"
using "allow_mount path_to_device path_to_mountpoint filesystem_type"
("allow_mount --bind path_to_bind_source path_to_bind_destionation" for bind mounts) syntax.

And, this is why this very long long thread began.
One of the reasons that TOMOYO doesn't use LSM is that
it is impossible to obtain "struct vfsmount" parameter inside some of LSM hook functions.
 From the label-based access control's point of view,
bind mount interferes nothing with label based access control
and passing "struct vfsmount" parameter looks redundant.
But, from the pathname-based access control's point of view,
bind mount interferes severely with pathname-based access control
because it is impossible to determine which pathname was requested.
Although both pathnames point to the same object,
TOMOYO focuses on the PROCEDURE FOR REACHING AN OBJECT
and being able to know the procedure is very important.
(In contrast, SELinux focuses on the ATTRIBUTE OF THE REQUESTED OBJECT, doesn't it?)

> So it could be done, but AFAICT, with small benefit and large cost. More
> security may be more secure, but it isn't necessarily better.
I don't think so.
I think the pathname-based access control and the label-based access control are
complementarity relation. TOMOYO can coexist with SELinux and AppArmor.
What is sad, it becomes impossible to coexist with SELinux and AppArmor if TOMOYO uses LSM.

Thanks.
