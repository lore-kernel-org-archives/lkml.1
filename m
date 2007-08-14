Return-Path: <linux-kernel-owner+w=401wt.eu-S932310AbXHNRz2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932310AbXHNRz2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 13:55:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755459AbXHNRzJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 13:55:09 -0400
Received: from mummy.ncsc.mil ([144.51.88.129]:47339 "EHLO jazzhorn.ncsc.mil"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758026AbXHNRzF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 13:55:05 -0400
Subject: Re: [PATCH 00/16] Permit filesystem local caching [try #3]
From: Stephen Smalley <sds@tycho.nsa.gov>
To: casey@schaufler-ca.com
Cc: David Howells <dhowells@redhat.com>, torvalds@osdl.org, akpm@osdl.org,
       steved@redhat.com, trond.myklebust@fys.uio.no,
       linux-fsdevel@vger.kernel.org, linux-cachefs@redhat.com,
       nfsv4@linux-nfs.org, linux-kernel@vger.kernel.org,
       selinux@tycho.nsa.gov, LSM List <linux-security-module@vger.kernel.org>
In-Reply-To: <462850.65153.qm@web36605.mail.mud.yahoo.com>
References: <462850.65153.qm@web36605.mail.mud.yahoo.com>
Content-Type: text/plain
Organization: National Security Agency
Date: Tue, 14 Aug 2007 13:50:47 -0400
Message-Id: <1187113847.26008.234.camel@moss-spartans.epoch.ncsc.mil>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-2.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-08-13 at 14:44 -0700, Casey Schaufler wrote:
> --- David Howells <dhowells@redhat.com> wrote:
> 
> > Casey Schaufler <casey@schaufler-ca.com> wrote:
> > 
> > > The specification of your push interface that the push operation
> > > not affect how others access the process is OK for SELinux, but
> > > not for any other MAC scheme that I've dealt with, and I think
> > > that's most of them. Nuts. Smack, for example, uses exactly one
> > > label on the process for all purposes.
> > 
> > It's a fairly important concept.  The victimisation security context on a
> > process must not change, even if the kernel overrides the security context
> > that that process acts as so that it can transparently do work on its behalf.
> > 
> > IMO, the right way to do this is to pass the security context directly to
> > vfs_mkdir() and co.
> > 
> > > Are you concerned about accesses other than signals? Signals
> > > could be staitforward to deal with in a pushed situation, but
> > > I'd hesitate to say that the solution would generalize without
> > > additional thought.
> > 
> > There's also /proc and ptrace() for example.  ps -z must not show the
> > overridden state.
> > 
> > > > > >   (5) int security_xfrm_to_kernel_context(void *from, void **_to);
> > > > > 
> > > > > Woof. What are you transforming from? 
> > > > 
> > > > In CacheFiles case, the cachefilesd daemon's security label into the
> > label
> > > > the cache driver acts as on behalf of other processes.
> > > 
> > > I'm not sure I understand what this is doing.
> > 
> > CacheFiles consists of two parts: the kernel module which creates things in
> > the cache and does accesses into the cache on behalf of processes that access
> > cached filesystems, and the userspace daemon that builds cull tables and
> > deletes things.
> > 
> > The reason there are two security labels is that the daemon's label gives it
> > just enough rights to be able to do its job.  More or less all it can do is
> > lookup, opendir, readdir, stat, rmdir, unlink and open the chardev for
> > talking
> > to the kernel module.  This means that the daemon can't, for example, be made
> > to read or modify cache storage objects.
> > 
> > Thus means, however, that the daemon's label isn't sufficient for the kernel
> > module to do its job.  But since there's no way for the kernel module to
> > directly get a label (and indeed it doesn't know the label it needs), a
> > transformation has to be applied that turns the process label used by the
> > daemon into a process label that the kernel, and only the kernel, can use.
> > 
> > The kernel's label gives it, amongst other things, the additional rights to
> > do
> > mkdir, creat, open, read, write, setxattr, getxattr, rename - things the
> > daemon isn't allowed to do.
> 
> With Smack you can leave the label alone, raise CAP_MAC_OVERRIDE,
> do your business of setting the label correctly, and then drop
> the capability. No new hooks required.

Except that CAP_MAC_OVERRIDE doesn't exist upstream, and if it did, it
would represent Smack-specific logic in the core kernel (when you're
complaining about SELinux-specific logic there).  So even that would
have to be encapsulated within a hook.

-- 
Stephen Smalley
National Security Agency

