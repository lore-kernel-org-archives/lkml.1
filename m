Return-Path: <linux-kernel-owner+w=401wt.eu-S1758218AbXHKImc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758218AbXHKImc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Aug 2007 04:42:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754699AbXHKImV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Aug 2007 04:42:21 -0400
Received: from mx1.redhat.com ([66.187.233.31]:54415 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754181AbXHKImT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Aug 2007 04:42:19 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <635572.72239.qm@web36611.mail.mud.yahoo.com>
References: <635572.72239.qm@web36611.mail.mud.yahoo.com>
To: casey@schaufler-ca.com
Cc: dhowells@redhat.com, torvalds@osdl.org, akpm@osdl.org, steved@redhat.com,
       trond.myklebust@fys.uio.no, linux-fsdevel@vger.kernel.org,
       linux-cachefs@redhat.com, nfsv4@linux-nfs.org,
       linux-kernel@vger.kernel.org, selinux@tycho.nsa.gov,
       LSM List <linux-security-module@vger.kernel.org>
Subject: Re: [PATCH 00/16] Permit filesystem local caching [try #3]
X-Mailer: MH-E 8.0.3; nmh 1.2-20070115cvs; GNU Emacs 22.1.50
Date: Sat, 11 Aug 2007 09:41:22 +0100
Message-ID: <7504.1186821682@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Casey Schaufler <casey@schaufler-ca.com> wrote:

> How would you expect an LSM that is not SELinux to interface with
> CacheFiles?

You have to understand that I didn't know that much about the LSM interface,
so I asked advice of the Red Hat security people, who, naturally, pointed me
at the SELinux mailing list.  I knew my stuff would have to work with SELinux
to be used with RH stuff.

Furthermore, as you pointed out, there aren't any other LSM modules upstream
yet for me to work against.  I would like CacheFiles to work with all LSM
modules in general, but I don't know how to do that yet.

I'm open to suggestion as to how to modify things to support any LSM.


Btw, do you understand the problems that CacheFiles has to deal with?  If I
set this down clearly, this may help you or someone else suggest a better way
to do things.

  (1) Some random process tries to access a file on a network filesystem
      (NFS example).

  (2) NFS goes to the cache to attempt to read the data from there prior to
      going to the network.

  (3) The cache driver wants to access the files in the cache, but it's
      running in the security context of either the aforementioned random
      process, or one of FS-Cache's thread pool.

      This security context, however, doesn't necessarily give it the rights
      to access what's in the cache, so the driver has to be permitted to act
      as a context appropriate to accessing the cache, without changing the
      overall security context of the random process (which would impact
      things trying to act on that process - kill() for example).

  (4) Assuming the data is found in the cache, all well and good, but if it
      isn't, the cache driver will have to create some files in the cache.

      Now, if the cache driver just went ahead and created the files, they
      could end up with their own security contexts being derived from the
      random process's security context, thus potentially making it impossible
      for other processes to access the cache.

      So the file-creation part of the security context must also be
      overridden temporarily, assuming that whatever LSM is in force has such
      a concept.

Part of the problem is that the VFS does not pass around the security context
as which the VFS routines act, but rather gets them from the task_struct.  For
the most part, this is entirely sufficient, but in the cache driver case, it's
a problem.

David
