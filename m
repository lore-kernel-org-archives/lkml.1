Return-Path: <linux-kernel-owner+w=401wt.eu-S1756739AbZBLGde@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756739AbZBLGde (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 01:33:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751127AbZBLGdZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 01:33:25 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:64848 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750785AbZBLGdY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 01:33:24 -0500
Message-ID: <4993C2A0.3050507@cn.fujitsu.com>
Date: Thu, 12 Feb 2009 14:33:04 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: containers@lists.osdl.org, Paul Menage <menage@google.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [cgroup or VFS ?] WARNING: at fs/namespace.c:636	mntput_no_expire+0xac/0xf2()
References: <49617D35.4040805@cn.fujitsu.com> <20090209004046.3ce1dde0.akpm@linux-foundation.org> <20090209093414.GU28946@ZenIV.linux.org.uk> <499013CC.2060808@cn.fujitsu.com> <4993BD5D.2020707@cn.fujitsu.com> <20090212062442.GE28946@ZenIV.linux.org.uk>
In-Reply-To: <20090212062442.GE28946@ZenIV.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>> How cute...  Same mountpoint in both, so these mount(2) will sometimes
>>>> fail (cgroup picks the same sb on the same options, AFAICS) and fail
>>>> silently due to these redirects...
>>>>
>>>> That's a lovely way to stress-test a large part of ro-bind stuff *and*
>>>> umount()-related code.  Could you do C equivalent of the above (just
>>>> the same syscalls in loop, nothing fancier) and do time-stamped strace?
>>>>
>>> Sure, I'll write a C version and try to reproduce the warning.
>>>
>> Unfortunately, the C equivalent can't reproduce the warning, I've run the
>> test for the whole night. :( While using the script, often I can trigger
>> the warning in several mins.
> 
> Ho-hum...  I wonder if we are hitting cgroup_clone() in all that fun...

I don't think so, I think cgroup_clone() will be called only if namespace is
used, like clone(CLONE_NEWNS). Even if cgroup_clone() gets called, it will
return before doing any vfs work unless the ns_cgroup subsystem is mounted.

int cgroup_clone(struct task_struct *tsk, struct cgroup_subsys *subsys,
							char *nodename)
{
	...
	mutex_lock(&cgroup_mutex);
 again:
	root = subsys->root;
	if (root == &rootnode) {	<--- here
		mutex_unlock(&cgroup_mutex);
		return 0;
	}

> Could you
> 	a) add a printk to that sucker
> 	b) independently from (a), see if wrapping these syscalls into
> 	pid = fork();
> 	if (!pid) {
> 		[make a syscall, print something]
> 		exit(0);
> 	} else if (pid > 0) {
> 		waitpid(pid, NULL, 0);
> 	}
> and see what happens...
> 
> 
