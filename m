Return-Path: <linux-kernel-owner+w=401wt.eu-S1761147AbYAKOFZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761147AbYAKOFZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 09:05:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758413AbYAKOFP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 09:05:15 -0500
Received: from wine.ocn.ne.jp ([122.1.235.145]:51494 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756831AbYAKOFN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 09:05:13 -0500
To: indan@nul.nu
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, w@1wt.eu,
       serue@us.ibm.com
Subject: Re: [PATCH][RFC] Simple tamper-proof device filesystem.
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <47176.81.207.0.53.1199887192.squirrel@secure.samage.net>
	<200801100457.m0A4vcoi024209@www262.sakura.ne.jp>
	<36843.81.207.0.53.1200006346.squirrel@secure.samage.net>
	<200801110846.m0B8kIf7088823@www262.sakura.ne.jp>
	<38047.81.207.0.53.1200054134.squirrel@secure.samage.net>
In-Reply-To: <38047.81.207.0.53.1200054134.squirrel@secure.samage.net>
Message-Id: <200801112305.BII64642.tHOJSMLVQFFOOF@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.50 PL2]
X-Accept-Language: ja,en
Date: Fri, 11 Jan 2008 23:05:07 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.



Indan Zupancic wrote:
> That "only the tiny daemon can modify /dev/" is done with MAC rules,
> the ones that should be the default for all applications except udev by
> default already. For teh kernel nothing changes.

OK. You assume use of MAC with enough fine grained access control.



> Wrong. All nodes are created and thus there's never a need to create
> new nodes. So /dev/ can't be modified by anyone. This works because
> all nodes that anyone might want to create already exist.

Already exist is not enough.
These nodes have to be deletable if requested by appropriate process.
These nodes have to be protected by MAC from directly calling
mknod()/rename()/unlink()/link()/mount() etc.



> This is true on a theoretical level. But practically I think you can either
> run multiple daemons, one for each namespace where you want to control /dev/,

If the daemon does not exist in that namespace?

> or if you really want one daemon you can pass the
> directory fd to it where the node should be created and use mknodat().
> I believe that crosses namespaces correctly.

The "fd" passed to mknodat() is used for starting from
specified directory instead for current directory.
The object obtained by resolving the rest "pathname" depends on
the "/" of the calling process.

If /var/jail/dev/dyndev/link is a symlink to /dev ,
a process in chroot("/var/jail/") + chdir("/") will get "/var/jail/dev/node"
and a process not in chroot("/var/jail/") + chdir("/")  will get "/dev/node"
by resolving mknodat(fd_for_"/var/jail/", "dev/dyndev/link/node") .
If the process is in the chroot() but the daemon is not in the chroot() ,
the daemon will create nodes in a wrong location.

So, you let the LD_PRELOAD library to solve all directory components
before passing the "fd" to the daemon using UNIX domain socket
so that the daemon won't create nodes in a wrong location.

OK. It looks like working, although I'm not taking racy condition into account.



> But I think that the chance that any process needs to create device nodes
> in a chroot is at the level of fairy existance.

Not only mknod() but also rename()/unlink()/link()/mount(bind) etc. that may
cause filename/attribute mismatching.

How can the daemon know whether the request is trying to manipulate nodes
in /dev directory or not?
If "mount --bind /dev/ /var/dir/" is used, the daemon must check
filename/attribute pair when mknod("/var/dir/null") is requested
because permitting the request will modify /dev state.
If "mount --bind /dev/ /var/dir/" is not used, the daemon must not check
filename/attribute pair when mknod("/var/dir/null") is requested
because permitting the request will not modify /dev state.



What does the daemon do? It receives requests from the LD_PRELOAD library
using UNIX domain socket and checks filename/attribute pair and issue
mknodat()/renameat()/unlinkat()/linkat() etc. when the combination is appropriate?

What does the LD_PRELOAD library do? It intercepts all pathname related syscalls
(except open()) and solve directory component and determine whether the request is
trying to manipulate nodes in /dev direcrtory and forward request to the daemon
using UNIX domain socket?

"Make the daemon and the LD_PRELOAD library bug-and-race free and
develop the MAC policy for the daemon and the LD_PRELOAD library"
and "Make this filesystem bug-and-race free". Which one is easier?



Regards.
