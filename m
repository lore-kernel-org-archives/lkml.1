Return-Path: <linux-kernel-owner+w=401wt.eu-S1759827AbZBMGl6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759827AbZBMGl6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 01:41:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751063AbZBMGls
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 01:41:48 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:60076 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750928AbZBMGlr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 01:41:47 -0500
Date: Fri, 13 Feb 2009 06:41:35 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: containers@lists.osdl.org, Paul Menage <menage@google.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [cgroup or VFS ?] WARNING: at fs/namespace.c:636
	mntput_no_expire+0xac/0xf2()
Message-ID: <20090213064135.GJ28946@ZenIV.linux.org.uk>
References: <20090209093414.GU28946@ZenIV.linux.org.uk> <499013CC.2060808@cn.fujitsu.com> <4993BD5D.2020707@cn.fujitsu.com> <20090212062442.GE28946@ZenIV.linux.org.uk> <4993C2A0.3050507@cn.fujitsu.com> <4993C7C2.4060100@cn.fujitsu.com> <20090212070729.GF28946@ZenIV.linux.org.uk> <4995007D.7040101@cn.fujitsu.com> <20090213054751.GI28946@ZenIV.linux.org.uk> <49950F3D.3030704@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49950F3D.3030704@cn.fujitsu.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 13, 2009 at 02:12:13PM +0800, Li Zefan wrote:
> Al Viro wrote:
> > On Fri, Feb 13, 2009 at 01:09:17PM +0800, Li Zefan wrote:
> > 
> >> I ran following testcase, and triggered the warning in 1 hour:
> >>
> >> thread 1:
> >> for ((; ;))
> >> {
> >>         mount --bind /cgroup /mnt > /dev/null 2>&1
> >>         umount /mnt > /dev/null 2>&1
> >> }
> >>
> >> tread 2:
> >> for ((; ;))
> >> {
> >>         mount -t cgroup -o cpu xxx /cgroup > /dev/null 2>&1
> >>         mkdir /cgroup/0 > /dev/null 2>&1
> >>         rmdir /cgroup/0 > /dev/null 2>&1
> >>         umount -l /cgroup > /dev/null 2>&1
> >> }
> > 
> > Wow.  You know, at that point these redirects could probably be removed.
> 
> Ah, yes.
> 
> > If anything in there ends up producing an output, we very much want to
> > see that.  Actually, I'd even make that
> > 	mount --bind /cgroup/mnt || (echo mount1: ; date)
> > etc., so we'd see when do they fail and which one fails (if any)...
> >  
> > Which umount has failed in the above, BTW?
> > 
> > 
> 
> the first one sometimes failed, and the second one hasn't failed:

> mount: wrong fs type, bad option, bad superblock on /cgroup,
>        missing codepage or helper program, or other error
>        In some cases useful info is found in syslog - try
>        dmesg | tail  or so
> 
> mount1

Hold on.  In your last example the first one was doing mount --bind;
has _that_ failed?  Oh, wait...  It can fail, all right, if lookup on
/cgroup gives you your filesystem with the second thread managing to
detach it before we get the namespace_sem.  Then we'll fail that way -
and clean up properly.

Oh, well...  The original question still stands: with those two
scripts, which umount produces that WARN_ON?  The trivial way
to check would be to have a copy of /sbin/umount under a different
name and use _that_ in one of the threads instead of umount.
Then reproduce the WARN_ON and look at the process name in dmesg...
