Return-Path: <linux-kernel-owner+w=401wt.eu-S1755526AbYH0OY0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755526AbYH0OY0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 10:24:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752998AbYH0OYP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 10:24:15 -0400
Received: from mx1.redhat.com ([66.187.233.31]:49754 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753290AbYH0OYO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 10:24:14 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20080827143355.5b8bfcf1@lxorguk.ukuu.org.uk>
References: <20080827143355.5b8bfcf1@lxorguk.ukuu.org.uk> <20080827134541.19980.61042.stgit@warthog.procyon.org.uk>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org
Subject: Re: [PATCH 00/59] Introduce credentials
X-Mailer: MH-E 8.0.3+cvs; nmh 1.3; GNU Emacs 23.0.50
Date: Wed, 27 Aug 2008 15:24:04 +0100
Message-ID: <21723.1219847044@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> > The wrappings are there to make the implementation of copy-on-write
> > credentials easier.
> 
> What do we get from copy-on-write credentials?

By credentials, I mean: UID, GID, EUID, EGID, SUID, SGID, FSUID, FSGID,
supplementary groups, LSM module context, all four capabilities masks, keyring
subscriptions.

We get a number of things:

 (1) Multiple credential changes all happen simultaneously (setresuid() for
     example).  The new set of credentials is committed with a single RCU
     assignment.

 (2) Some simplification of capabilities handling functions.

 (3) Because the credentials are detached, execve() credential recalculation is
     simplified.  We set up a new set of the credentials we want in advance and
     only commit at the last possibly moment.  Not only that, the credentials
     are committed in one go, rather than being committed piecemeal.

 (4) execve() no longer leaves the credential state incompletely restored if it
     returns an error.

 (5) Other tasks observing an exec'ing process won't see a partially changed
     state; nor will they see a state that gets reverted.

 (6) For one task to read another's credentials, it only needs to keep hold of
     the RCU lock and can drop any spinlocks it has sooner.  Furthermore, it
     can get a reference on that other task's cred struct and drop the RCU lock
     too.

 (7) Because the credentials are detached, it makes it much easier to override
     all of them _without_ affecting how another task acts upon this one.  This
     cleans up do_coredump() and sys_faccessat().  It may help NFSD, especially
     when it comes to supporting SELinux labelling over NFS, and it helps me
     with local caching of network filesystems.

> I've never seen credentials of any kind showing in profiles so why do we
> need this ?

I'm not sure what you mean by that.  Are you talking about profiling as in with
gprof or oprofile, or profiles as in user profiles?


Anyway; my primary interest is this: I want to be able to do local caching of
network filesystems.  One method of doing this is to create a file on disk to
cache each AFS/NFS/CIFS/whatever file I'm asked to cache.  However, I may be
attempting to access disk in the context of the process that invoked the netfs,
but this may have an inappropriate set of credentials for accessing the local
cache.

What Al Viro and Christoph Hellwig would like is for the subjective cred
pointer to be handed to vfs_mkdir() and suchlike and to percolate down through
the filesystems.  Currently I have something that approximates a subjective
pointer and an objective pointer in the task_struct in place of the removed
creds.  Ideally, the subjective pointer ought to be dispensed with and the
appropriate set of creds be handed down instead.  XFS, for example, is already
set up to do this.  I have patches to do most of this, but there are ~150 of
them and they stand at ~5.5MB in size.

David
