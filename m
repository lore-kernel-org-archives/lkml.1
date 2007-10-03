Return-Path: <linux-kernel-owner+w=401wt.eu-S1756123AbXJCRVT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756123AbXJCRVT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 13:21:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752003AbXJCRVK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 13:21:10 -0400
Received: from web36604.mail.mud.yahoo.com ([209.191.85.21]:42273 "HELO
	web36604.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751282AbXJCRVJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 13:21:09 -0400
X-YMail-OSG: hUCjLFgVM1kzDCSvTeI.bazx41wuwRQUz2UGZkvHy5suV8Qf2xkX082cuNUwusy5aHEH2TIxNA--
X-RocketYMMF: rancidfat
Date: Wed, 3 Oct 2007 10:21:08 -0700 (PDT)
From: Casey Schaufler <casey@schaufler-ca.com>
Reply-To: casey@schaufler-ca.com
Subject: Re: [PATCH] Version 4 (2.6.23-rc8-mm2) Smack: Simplified Mandatory Access Control Kernel
To: Al Viro <viro@ftp.linux.org.uk>, Casey Schaufler <casey@schaufler-ca.com>
Cc: torvalds@osdl.org, linux-security-module@vger.kernel.org,
       linux-kernel@vger.kernel.org, akpm@osdl.org, paul.moore@hp.com
In-Reply-To: <20071003051254.GH8181@ftp.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <287091.73995.qm@web36604.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--- Al Viro <viro@ftp.linux.org.uk> wrote:

> On Tue, Oct 02, 2007 at 09:45:42PM -0700, Casey Schaufler wrote:
> > 
> > From: Casey Schaufler <casey@schaufler-ca.com>
> > 
> > Smack is the Simplified Mandatory Access Control Kernel.
> > 
> > Smack implements mandatory access control (MAC) using labels
> > attached to tasks and data containers, including files, SVIPC,
> > and other tasks. Smack is a kernel based scheme that requires
> > an absolute minimum of application support and a very small
> > amount of configuration data.
> 
> I _really_ don't like what you are doing with these symlinks.



> For one thing, you have no exclusion between reading the list
> entries and modifying them.

That's easy enough to fix. I'll do it.

> For another...  WTF is filesystem
> making assumptions about the locations where the things are
> mounted?

I assume by this that you're objecting to the initialization of
/smack/tmp to point to /moldy/<label>.

Over the years I've seen a number of cases where failure to
set up /tmp result in unhappy consequences. If /tmp is anything
other than a real directory on the root filesystem it is important
that special care be taken for the case where things don't get
set up right for some reason. By including a specific, if perhaps
arbitrary, default it becomes easier to create a configuration
that survives the unexpected.

> Hell, even if you override your tmp symlink,

Which is something that I expect virtually everyone to do.

> what
> happens if we want it in two chroot jails with different layouts?

As you can only have /smack mounted once, this isn't an issue,
but it does present an interesting use case that brings the one
mount limitation into question. I'll add addressing this to the
short term todo list.

> I really don't get it; why not simply have something like
> /smack/tmp.link resolve to tmp/<label> and have userland bind or mount
> whatever you bloody like on /smack/tmp?

Because you throw "simple" out the window when you require userland
assistance to perform this function.

> No problems with absolute
> paths, can be used in chroot jails with whatever layouts, ditto for
> namespaces, etc. and both symlink and directory get created at
> the same time (by one name).  Hell, if you keep a reference
> to dentry of directory in the data associated with symlink,
> you can simply switch nd->dentry to that, drop the old one
> and grab the reference to page containing label and return
> it via nd_set_link().  No need to play with allocations, strcat,
> yadda, yadda.  readlink() can stuff the ->d_name of the same
> dentry plus / plus label directly into user buffer; again, no
> allocations needed and works fine anywhere.

I'm having some trouble seeing how the 60 lines of code in
smackfs dealing with symlinks would be improved by your suggestions.
I certainly don't see how requiring userland intervention would
do anything but make it bigger and less reliable.


Casey Schaufler
casey@schaufler-ca.com
