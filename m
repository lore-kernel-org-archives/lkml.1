Return-Path: <linux-kernel-owner+w=401wt.eu-S1762772AbXIZVJW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762772AbXIZVJW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 17:09:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751145AbXIZVJL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 17:09:11 -0400
Received: from mx1.redhat.com ([66.187.233.31]:48760 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750950AbXIZVJJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 17:09:09 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20070926180858.GP8181@ftp.linux.org.uk>
References: <20070926180858.GP8181@ftp.linux.org.uk> <20070926142059.2656.27100.stgit@warthog.procyon.org.uk> <20070926142104.2656.26389.stgit@warthog.procyon.org.uk>
To: Al Viro <viro@ftp.linux.org.uk>
Cc: dhowells@redhat.com, hch@infradead.org, Trond.Myklebust@netapp.com,
       sds@tycho.nsa.gov, casey@schaufler-ca.com, linux-kernel@vger.kernel.org,
       selinux@tycho.nsa.gov, linux-security-module@vger.kernel.org
Subject: Re: [PATCH 01/24] CRED: Introduce a COW credentials record
X-Mailer: MH-E 8.0.3; nmh 1.2-20070115cvs; GNU Emacs 22.1.50
Date: Wed, 26 Sep 2007 22:08:05 +0100
Message-ID: <29949.1190840885@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Al Viro <viro@ftp.linux.org.uk> wrote:

> Umm...  Perhaps a better primitive would be "make sure that our cred is
> not shared with anybody, creating a copy and redirecting reference to
> it if needed".

I wanted to make the point that once a cred record was made live - i.e. exposed
to the rest of the system - it should not be changed.  I'll think about
rewording that.  Also "making sure that our cred is not shared" does not work
for cachefiles where we actually want to create a new set of creds.

Al Viro <viro@ftp.linux.org.uk> wrote:

> > In addition, the default setting of i_uid and i_gid to fsuid and fsgid has
> > been moved from the callers of new_inode() into new_inode() itself.
> 
> I don't think it's safe; better do something trivial like
> 	own_inode(inode)
> that would set these (and that's a goot splitup candidate, to go in front
> of the series).

I think you're probably right.  I commented on this at the bottom of the cover
note.  One thing I could do is provide a variant on own_inode() that takes a
parent dir inode pointer and does the sticky GID thing - something that several
filesystems do.

> FWIW, the main weakness here is the need of update_current_cred() splattered
> all over the entry points.

Yeah.  I'm not keen on that, but I'm even less keen on sticking something in
everywhere that the cred struct is consulted.  I don't like the idea of making
it implicit in the dereference of current->cred either, and neither is Linus.

> Two problems:
> 	a) it's a bug source (somebody adds a syscall and forgets to
> add that call / somebody modifies syscall guts and doesn't notice that
> it needs to be added).

It's simpler to check for its existence at the beginning of a syscall.

> 	b) it's almost always doing noting, so being lazier would be
> better (event numbers checked in the inlined part, perhaps?)

Linus is against having an inlined part:-/

> The former would be more robust if it had been closer to the places where
> we get to passing current->cred to functions.

You can't do it there because there may be an override in effect.  Or, rather,
if you do do it there, you have to not do it if there's an override set.

> The latter...  When do we actually step into this kind of situation (somebody
> changing keys on us)

There are four cases:

 (1) The request_key() upcall forces us to create a thread keyring.

 (2) The request_key() upcall forces us to create a process keyring.

 (3) A sibling thread instantiates our common process keyring.

 (4) A sibling thread replaces our common session keyring.

The first three could be trivially avoidable by creating the thread and process
keyrings in advance, (1) and (2) at request_key() time, (3) at clone time.  It
eats extra resources, but it's easy.

The fourth is more tricky.  A sibling thread can replace our common session
keyring on us at any time.  I suppose we could decree that you can't replace
your session keyring if you've got multiple threads.  That ought to be simple
enough, and I suspect won't impact particularly.

The alternatives are (b) not to include the keyrings in the cred stuff, though
they are relevant; and (c) to make it possible for sibling threads to change
each other's creds.  I'm really not keen on (c) as that means you can't just
dereference your own creds directly without taking locks and stuff.

> and what's the right semantics here?  E.g. if it happens
> in the middle of long read(), do we want to keep using the original keys?

If you're in the middle of a long read(), you should be using the cred struct
attached to file->f_cred, not current->cred, and so that problem should not
arise.

As for long ops that aren't I/O operations on file descriptors, I think it's
reasonable for you to do the entire op with the creds you started off doing it
with.

Don't forget that there's also the cap_effective stuff, which appears that it
can be changed by someone other than the target process.

David
