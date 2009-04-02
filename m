Return-Path: <linux-kernel-owner+w=401wt.eu-S1759494AbZDBQD2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759494AbZDBQD2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 12:03:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754686AbZDBQDD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 12:03:03 -0400
Received: from mx2.redhat.com ([66.187.237.31]:37574 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763691AbZDBQDA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 12:03:00 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <200904030232.59355.nickpiggin@yahoo.com.au>
References: <200904030232.59355.nickpiggin@yahoo.com.au> <200904030100.05741.nickpiggin@yahoo.com.au> <20090401230515.28177.73948.stgit@warthog.procyon.org.uk> <5564.1238684153@redhat.com>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: dhowells@redhat.com, hch@infradead.org, viro@zeniv.linux.org.uk,
       nfsv4@linux-nfs.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 22/43] CacheFiles: Add a hook to write a single page of data to an inode [ver #46]
Date: Thu, 02 Apr 2009 17:02:33 +0100
Message-ID: <6488.1238688153@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin <nickpiggin@yahoo.com.au> wrote:

> Hmm, I guess not all filesystems define write_begin/write_end. But if you
> only need to use ones that do define them?

That would be a reasonable restriction.  As would excluding NFS, AFS, CIFS,
etc..

> Yes, you framed the changelog as introducing this new callback because it
> allows a highly optimised code that takes advantage of page aligned write.
> So I went on a tangent thinking you were going to use it later to avoid
> the data copy or something.

I would love to avoid the data copies and do asynchronous direct I/O.  However
the DIO interface appears very highly userspace centric, and is very hard to
use from within the kernel.

> You are knowingly squashing together fscache and the backing filesystem if
> you do something like introduce a flag like PG_owner_priv_2 and disallow the
> backing filesystem from reusing it.

The backing filesystem isn't disallowed from reusing it; the *netfs* is.

Understand that there are two filesystems involved:  The netfs, which makes
requests of FS-Cache, and the backing filesystem which cachefiles uses to
store data.  

FS-Cache places restrictions such as having to yield up FS_private_2 and
FS_owner_priv_2 on the netfs.

Cachefiles places restrictions such as must have bmap(), setxattr(),
write_one_page() on the backing fs.

> So at which point you don't have to keep up illusions about being totally
> filesystem agnostic.

I'm trying to keep things as filesystem agnostic as I can, at both ends.

> Many filesystems don't need the file argument to write_begin/write_end.

That probably includes all those I care about for supporting the backing fs.
The problem is how does cachefiles tell?  Perhaps a file_system_type flag?

	#define FS_SUPPORTS_CACHEFILES 65536

or 

	#define FS_NULL_FILEPTR_OKAY 65536

perhaps.

David
