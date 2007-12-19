Return-Path: <linux-kernel-owner+w=401wt.eu-S1757463AbXLSXjs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757463AbXLSXjs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 18:39:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753932AbXLSXjj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 18:39:39 -0500
Received: from mx1.redhat.com ([66.187.233.31]:37571 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751373AbXLSXji (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 18:39:38 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <47688FD9.6080705@crispincowan.com>
References: <47688FD9.6080705@crispincowan.com> <1197401823.28006.74.camel@moss-spartans.epoch.ncsc.mil> <1197322068.18120.176.camel@moss-spartans.epoch.ncsc.mil> <1197307397.18120.72.camel@moss-spartans.epoch.ncsc.mil> <1197305173.18120.60.camel@moss-spartans.epoch.ncsc.mil> <20071205193818.24617.79771.stgit@warthog.procyon.org.uk> <20071205193859.24617.36392.stgit@warthog.procyon.org.uk> <25037.1197306473@redhat.com> <25572.1197320887@redhat.com> <25965.1197329769@redhat.com> <9789.1197405725@redhat.com> 
To: Crispin Cowan <crispin@crispincowan.com>
Cc: dhowells@redhat.com, Stephen Smalley <sds@tycho.nsa.gov>,
       Karl MacMillan <kmacmill@redhat.com>, viro@ftp.linux.org.uk,
       hch@infradead.org, Trond.Myklebust@netapp.com, casey@schaufler-ca.com,
       linux-kernel@vger.kernel.org, selinux@tycho.nsa.gov,
       linux-security-module@vger.kernel.org,
       apparmor-dev <apparmor-dev@forge.novell.com>
Subject: Re: [PATCH 08/28] SECURITY: Allow kernel services to override LSM settings for task actions [try #2]
X-Mailer: MH-E 8.0.3+cvs; nmh 1.2-20070115cvs; GNU Emacs 23.0.50
Date: Wed, 19 Dec 2007 23:38:27 +0000
Message-ID: <2618.1198107507@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Crispin Cowan <crispin@crispincowan.com> wrote:

> > This is used, for example, by CacheFiles which has to transparently access
> > the cache on behalf of a process that thinks it is doing, say, NFS
> > accesses with a potentially inappropriate (with respect to accessing the
> > cache) set of security data.
> I'm not sure, but I think that you could do this *much* easier in
> AppArmor using change_profile to switch the NFS Daemon to the profile of
> the requesting process. That still leaves some problems:

NFS Daemon?  NFS quite often runs in the context of whichever process issued,
say, a read syscall.  It's at this point the cachefiles needs to run, and
using change_profile is I suspect not an option there.  Remember: you can't
change the objective profile of the aforementioned process, hence the act_as
pointer.

That said, I don't know what change_profile does.

> However, it seems to me that you have the same problem with SELinux:
> what do you do if the domain/type of the requesting process does not
> exist on the NFS server? How do you ensure a uniform name space of types?

I'm not sure what you're getting at.  The security NFS uses to access the
server is separate from the security that cachefiles uses to access the cache.

> > How about I just stick the context in /etc/cachefilesd.conf as a textual
> > configuration item and have the daemon pass that as a string to the
> > cachefiles kernel module, which can then ask LSM if it's valid to set this
> > context as an override, given the daemon's own security context?  That
> > seems entirely reasonable to me.
> >   
> That semantically maps well to the AppArmor change_profile() API, so
> conceptually it should work.

Okay.

> It would be easier if you did that in user space instead of in the kernel,

Do what in userspace?  Parse the context?  Validate the context?  Or change
the context?

> I don't know if it causes a problem to attempt to kind-of call
> change_profile() from within the kernel.  Notably, change_profile can fail,
> so what does your kernel module do when the attempt to change security
> context fails?

The cache aborts and all subsequent operations on that cache bounce and go to
the server instead.

The change of context cannot be done in userspace because to get to a
userspace capable of attempting this operation would itself require a change
of context.  Besides, it'd also be inefficient, probably horribly so, to do
all caching ops in userspace.

What I need is an LSM operation to change a task_security struct to have a
specified context.  I can then use the task_security struct in all future
cache ops on a cache by pointing task->act_as at it.

David
