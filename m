Return-Path: <linux-kernel-owner+w=401wt.eu-S932424AbXCDBVO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932424AbXCDBVO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Mar 2007 20:21:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932502AbXCDBVO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Mar 2007 20:21:14 -0500
Received: from smtp.osdl.org ([65.172.181.24]:51198 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932424AbXCDBVN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Mar 2007 20:21:13 -0500
Date: Sat, 3 Mar 2007 17:21:09 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Ray Lee <ray-lk@madrabbit.org>
Cc: linux-kernel@vger.kernel.org, Ray Lee <madrabbit@gmail.com>
Subject: Re: userspace pagecache management tool
Message-Id: <20070303172109.feb4c936.akpm@linux-foundation.org>
In-Reply-To: <45EA1AA7.3040902@madrabbit.org>
References: <20070303122935.f1ab0067.akpm@linux-foundation.org>
	<2c0942db0703031458i540c496fib892240619faa9b2@mail.gmail.com>
	<20070303153454.6548e562.akpm@linux-foundation.org>
	<45EA1AA7.3040902@madrabbit.org>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 03 Mar 2007 17:02:31 -0800 Ray Lee <ray-lk@madrabbit.org> wrote:

> Andrew Morton wrote:
> > <wonders about sys_reclaim_dentry(const char *pathname)>
> 
> Would there be any other users of it than updatedb?

updatedb is the notorious one.

Alas, one can envisage sane workloads which really really really really
want to cache millions of dentries and inodes.  Workloads which get run
more often than once-per-day-at-4AM.  So if we "fix" updatedb, those
people with kernel-indistinguishable workloads get real unhappy.  We have
to pass instructions to the kernel to resolve this.

A sys_reclaim_dentry() would also need a sys_is_dentry_there() so updatedb
could restore the previous state.

Probably it'd be better to fix the well-known internal fragmentation problem
we have with the VFS caches.  That's fairly hard.

> I'm not coming up
> with much, but given that I'm not always clever, that doesn't mean much.
> 
> <thinks out loud...> A hypothetical on-demand file virus scanner is
> going to hit already cached or about-to-be-cached entries by definition.
> Perhaps some system audit daemon, such as tripwire. Well, that has the
> same access patterns as updatedb, doesn't it: a directory at a time.
> find, cp -a, the same.
> 
> So instead of sys_reclaim_dentry, how about extending fadvise to work on
> the fd returned via opendir?

That'd be pretty simple, but a) would reclaim the pagecache for the
directory and not the dentry object itself and b) will only be easy to do
for ext2 and minixfs, which maintain a separate pagecache per directory.

Yes we could do a "nuke all the dentries in this directory thing", but
that's equivalent to sys_reclaim_dentry() in a loop.

> And extending POSIX_FADV_NOREUSE on a file
> fd to drop the dentry at close?
> 
> (Call me chicken; I just don't want to be the guy suggesting a new
> syscall for a single or few users.)
> 
>  ~ ~
> 
> Alternately, there have been requests for a way for userspace to get
> notification of all file events for indexing of data and metadata
> (inotify, unfortunately, doesn't scale to a full filesystem). (cf.
> http://lkml.org/lkml/2006/9/30/98 .)

yes, that's a disappointment.

> That'd allow an updatedb daemon to
> keep the index up to date all the time, amortizing the cost. More
> usefully, it'd allow a content indexing daemon to stay up to date all
> the time, though inotify mostly works for those, I suppose.
> 
> (Hmm...
> 	ray@phoenix:~$ find ~ -type d | wc -l
> 	14067
> 
> ...right. So it probably works fine for normal people.)
> 
> Hey, waitaminute. This should be a solved problem? SELinux must have
> some sort of requirement for logging file access attempts. Google, at
> least, implies so. Perhaps whatever it implements could be lifted into
> the core kernel without dragging the rest behind it.

Maybe the syscall auditing code can be persuaded to spit out records which
can be used for this.

> Dunno. Who do we CC?

That's a problem.  Nobody and everybody.
