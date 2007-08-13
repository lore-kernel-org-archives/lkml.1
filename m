Return-Path: <linux-kernel-owner+w=401wt.eu-S948306AbXHMQ1N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S948306AbXHMQ1N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 12:27:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S970834AbXHMPWi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 11:22:38 -0400
Received: from mx1.redhat.com ([66.187.233.31]:44540 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755650AbXHMPWd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 11:22:33 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1187017052.26008.51.camel@moss-spartans.epoch.ncsc.mil>
References: <1187017052.26008.51.camel@moss-spartans.epoch.ncsc.mil> <353795.27307.qm@web36612.mail.mud.yahoo.com> <9536.1187016680@redhat.com>
To: Stephen Smalley <sds@tycho.nsa.gov>
Cc: dhowells@redhat.com, casey@schaufler-ca.com, torvalds@osdl.org,
       akpm@osdl.org, steved@redhat.com, trond.myklebust@fys.uio.no,
       linux-fsdevel@vger.kernel.org, linux-cachefs@redhat.com,
       nfsv4@linux-nfs.org, linux-kernel@vger.kernel.org,
       selinux@tycho.nsa.gov, LSM List <linux-security-module@vger.kernel.org>
Subject: Re: [PATCH 00/16] Permit filesystem local caching [try #3]
X-Mailer: MH-E 8.0.3; nmh 1.2-20070115cvs; GNU Emacs 22.1.50
Date: Mon, 13 Aug 2007 16:22:06 +0100
Message-ID: <10228.1187018526@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Smalley <sds@tycho.nsa.gov> wrote:

> Seems like over-design - we don't need to support LSM stacking, and we
> don't need to support pushing/popping more than one level of context.

It will, at some point hopefully, be possible for someone to try, say, NFS
exporting a cached ISO9660 mount (CDROM) - in which case, we'd should allow
for two levels of stack.  If we can pass the displaced context to the caller
to restore later then that allows for more or less unlimited depth.

It occurs to me that the following is almost good enough, but not quite:

  (1) int security_get_context(void **_context);

	This allocates and gives the caller a blob that describes the current
	context of all the LSM module states attached to the current task and
	stores a pointer to it in *_context.

  (2) int security_push(void *context, struct sec **_old_context)

	This causes all the LSM modules on the current task to switch to a new
	acting state, passing back the old state.  It does not change how
	other tasks do things to this one.

  (3) int security_pop(void *context)

	This causes all the LSM modules on the current task to switch to a new
	acting state, deleting the old state.  It does not change how
	other tasks do things to this one.

  (4) int security_delete_context(void *context)

I still need a way to transform the cachefilesd context into the kernel's
context.  See patch:

   Subject: [Linux-cachefs] [PATCH 12/16] CacheFiles: Get the SID under which
	the CacheFiles module should operate [try #3]

However, this seems to add a fairly generic tranformation, so that could be
generalised:

  (5) int security_xfrm_to_kernel_context(void *from, void **_to);

> What was the objection again to the original interface, aside from
> replacing "u32 secids" with "void* security blobs"?

I got the impression that Casey thought much of this was tied to SELinux, but
rereading his/her emails, I'm not so certain.  Maybe that's sufficient.  Casey?

However, I've realised a problem (as outlined above) with what I've got.
Namely its stack isn't necessarily deep enough.  Alternatively, nfsd perhaps
should suppress caching on what it reads.

David
