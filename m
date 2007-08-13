Return-Path: <linux-kernel-owner+w=401wt.eu-S932848AbXHMTyL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932848AbXHMTyL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 15:54:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760749AbXHMTxH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 15:53:07 -0400
Received: from mx1.redhat.com ([66.187.233.31]:58286 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759598AbXHMTxD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 15:53:03 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <959629.46851.qm@web36606.mail.mud.yahoo.com>
References: <959629.46851.qm@web36606.mail.mud.yahoo.com>
To: casey@schaufler-ca.com
Cc: dhowells@redhat.com, Stephen Smalley <sds@tycho.nsa.gov>,
       torvalds@osdl.org, akpm@osdl.org, steved@redhat.com,
       trond.myklebust@fys.uio.no, linux-fsdevel@vger.kernel.org,
       linux-cachefs@redhat.com, nfsv4@linux-nfs.org,
       linux-kernel@vger.kernel.org, selinux@tycho.nsa.gov,
       LSM List <linux-security-module@vger.kernel.org>
Subject: Re: [PATCH 00/16] Permit filesystem local caching [try #3]
X-Mailer: MH-E 8.0.3; nmh 1.2-20070115cvs; GNU Emacs 22.1.50
Date: Mon, 13 Aug 2007 20:52:36 +0100
Message-ID: <16119.1187034756@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Casey Schaufler <casey@schaufler-ca.com> wrote:

> The specification of your push interface that the push operation
> not affect how others access the process is OK for SELinux, but
> not for any other MAC scheme that I've dealt with, and I think
> that's most of them. Nuts. Smack, for example, uses exactly one
> label on the process for all purposes.

It's a fairly important concept.  The victimisation security context on a
process must not change, even if the kernel overrides the security context
that that process acts as so that it can transparently do work on its behalf.

IMO, the right way to do this is to pass the security context directly to
vfs_mkdir() and co.

> Are you concerned about accesses other than signals? Signals
> could be staitforward to deal with in a pushed situation, but
> I'd hesitate to say that the solution would generalize without
> additional thought.

There's also /proc and ptrace() for example.  ps -z must not show the
overridden state.

> > > >   (5) int security_xfrm_to_kernel_context(void *from, void **_to);
> > > 
> > > Woof. What are you transforming from? 
> > 
> > In CacheFiles case, the cachefilesd daemon's security label into the label
> > the cache driver acts as on behalf of other processes.
> 
> I'm not sure I understand what this is doing.

CacheFiles consists of two parts: the kernel module which creates things in
the cache and does accesses into the cache on behalf of processes that access
cached filesystems, and the userspace daemon that builds cull tables and
deletes things.

The reason there are two security labels is that the daemon's label gives it
just enough rights to be able to do its job.  More or less all it can do is
lookup, opendir, readdir, stat, rmdir, unlink and open the chardev for talking
to the kernel module.  This means that the daemon can't, for example, be made
to read or modify cache storage objects.

Thus means, however, that the daemon's label isn't sufficient for the kernel
module to do its job.  But since there's no way for the kernel module to
directly get a label (and indeed it doesn't know the label it needs), a
transformation has to be applied that turns the process label used by the
daemon into a process label that the kernel, and only the kernel, can use.

The kernel's label gives it, amongst other things, the additional rights to do
mkdir, creat, open, read, write, setxattr, getxattr, rename - things the
daemon isn't allowed to do.

David
