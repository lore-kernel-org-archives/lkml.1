Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757028Ab0BCJyO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 04:54:14 -0500
Received: from tango.0pointer.de ([85.214.72.216]:42930 "EHLO
	tango.0pointer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755930Ab0BCJyN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 04:54:13 -0500
Date: Wed, 3 Feb 2010 10:53:41 +0100
From: Lennart Poettering <mzxreary@0pointer.de>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] exit: PR_SET_ANCHOR for marking processes as reapers
 for child processes
Message-ID: <20100203095339.GA10050@tango.0pointer.de>
References: <20100202120457.GA19605@omega>
 <20100203172006.D3B2.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100203172006.D3B2.A69D9226@jp.fujitsu.com>
Organization: Red Hat, Inc.
X-Campaign-1: ()  ASCII Ribbon Campaign
X-Campaign-2: /  Against HTML Email & vCards - Against Microsoft Attachments
User-Agent: Leviathan/19.8.0 [zh] (Cray 3; I; Solaris 4.711; Console)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 03.02.10 17:24, KOSAKI Motohiro (kosaki.motohiro@jp.fujitsu.com) wrote:

> 
> > [ I already sent this patch half a year ago or so, as an RFC. I didn't
> > really get any comments back then, however I am still interested in
> > seeing this patch in the kernel tree. So here I go again: please
> > comment! I have updated the patch to apply to the current upstream git
> > master. ]
> > 
> > Right now, if a process dies all its children are reparented to init.
> > This logic has good uses, i.e. for double forking when daemonizing.
> > However it also allows child processes to "escape" their parents, which
> > is a problem for software like session managers (such as gnome-session)
> > or other process supervisors.
> 
> I think you need to explain why this patch improve gnome-session.
> 
>  - What's happen on current gnome-session. and When?

If a child of a supervisor daemon such as g-s does a double fork (and
unfortunately most existing user daemons do), then that supervisor
deaemon will be unable to monitor that child anymore, i.e. do
something when it dies, such as restarting it, or tearing the session
down, or doing something when it segfaults and so on.

Also, if g-s itself dies, clients that escaped it via double-forking
will stay around even if PR_DEATHSIG is used. With this patch applied
PR_DEATHSIG will work for them too because child processes cannot
escape their parents anymore if the parent wants that. And
getrusage(RUSAGE_CHILDREN) will start to return useful results in g-s
too.

Also, as a minor side-effect the output of "ps xawf" or similar tools
becomes much more useful since processes belonging to a session will
actually show up as children of g-s in the tree instead of as
unattached processes.

Right now, only init itself can do process supervising properly, since
it will be getting the SIGCHLD for those processes that escaped their
parents by double forking. With this patch I want to extend this
power to non-init supervisor daemons, such as g-s.

Also, this makes it easier to write and test init daemon because you
can run them as PID != 1 and still get very similar functionality
regarding SIGCHLD.

>  - After the patch, Which behavior will be changed?

For normal processes, nothing. And for those which use this new
PR_SETACNHOR call the children won't be able to escape them anymore
via a double fork. Or as I already tried to explain:

> > This patch adds a simple flag for each process that marks it as an
> > "anchor" process for all its children and grandchildren. If a child of
> > such an anchor dies all its children will not be reparented to init, but
> > instead to this anchor, escaping this anchor process is not possible. A
> > task with this flag set hence acts as little "sub-init".

>  - Why do you think gnome-session can ignore old kernel?

Did I say that?

On new kernels supervisor daemons can make use of this and children
won't be able to escape them. On old kernels they cannot and children
will continue to escape them. But uh, that should be fine. So on newer
kernels g-s can supervise all user daemons nicely, and on old kernels
we continue with the status quo. That should be fine.

Lennart

-- 
Lennart Poettering                        Red Hat, Inc.
lennart [at] poettering [dot] net
http://0pointer.net/lennart/           GnuPG 0x1A015CC4
