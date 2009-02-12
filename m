Return-Path: <linux-kernel-owner+w=401wt.eu-S1756678AbZBLGZA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756678AbZBLGZA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 01:25:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750848AbZBLGYv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 01:24:51 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:53550 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750742AbZBLGYu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 01:24:50 -0500
Date: Thu, 12 Feb 2009 06:24:42 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: containers@lists.osdl.org, Paul Menage <menage@google.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [cgroup or VFS ?] WARNING: at fs/namespace.c:636
	mntput_no_expire+0xac/0xf2()
Message-ID: <20090212062442.GE28946@ZenIV.linux.org.uk>
References: <49617D35.4040805@cn.fujitsu.com> <20090209004046.3ce1dde0.akpm@linux-foundation.org> <20090209093414.GU28946@ZenIV.linux.org.uk> <499013CC.2060808@cn.fujitsu.com> <4993BD5D.2020707@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4993BD5D.2020707@cn.fujitsu.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 12, 2009 at 02:10:37PM +0800, Li Zefan wrote:
> Li Zefan wrote:
> > Al Viro wrote:
> >> On Mon, Feb 09, 2009 at 12:40:46AM -0800, Andrew Morton wrote:
> >>>> Thread 1:
> >>>>   for ((; ;))
> >>>>   {
> >>>>       mount -t cgroup -o cpuset xxx /mnt > /dev/null 2>&1
> >>>>       mkdir /mnt/0 > /dev/null 2>&1
> >>>>       rmdir /mnt/0 > /dev/null 2>&1
> >>>>       umount /mnt > /dev/null 2>&1
> >>>>   }
> >>>>
> >>>> Thread 2:
> >>>>   {
> >>>>       mount -t cpuset xxx /mnt > /dev/null 2>&1
> >>>>       umount /mnt > /dev/null 2>&1
> >>>>   }
> >> How cute...  Same mountpoint in both, so these mount(2) will sometimes
> >> fail (cgroup picks the same sb on the same options, AFAICS) and fail
> >> silently due to these redirects...
> >>
> >> That's a lovely way to stress-test a large part of ro-bind stuff *and*
> >> umount()-related code.  Could you do C equivalent of the above (just
> >> the same syscalls in loop, nothing fancier) and do time-stamped strace?
> >>
> > 
> > Sure, I'll write a C version and try to reproduce the warning.
> > 
> 
> Unfortunately, the C equivalent can't reproduce the warning, I've run the
> test for the whole night. :( While using the script, often I can trigger
> the warning in several mins.

Ho-hum...  I wonder if we are hitting cgroup_clone() in all that fun...
Could you
	a) add a printk to that sucker
	b) independently from (a), see if wrapping these syscalls into
	pid = fork();
	if (!pid) {
		[make a syscall, print something]
		exit(0);
	} else if (pid > 0) {
		waitpid(pid, NULL, 0);
	}
and see what happens...
