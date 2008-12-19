Return-Path: <linux-kernel-owner+w=401wt.eu-S1752814AbYLSC1y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752814AbYLSC1y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2008 21:27:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751541AbYLSC1n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 21:27:43 -0500
Received: from mx2.redhat.com ([66.187.237.31]:38900 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751436AbYLSC1m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 21:27:42 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20081218123601.11810b7f.akpm@linux-foundation.org>
References: <20081218123601.11810b7f.akpm@linux-foundation.org> <8930.1229560221@redhat.com> <20081218224418.804f10bc.sfr@canb.auug.org.au> <20081218142420.GA16728@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: dhowells@redhat.com, Christoph Hellwig <hch@infradead.org>,
       sfr@canb.auug.org.au, trond.myklebust@fys.uio.no, steved@redhat.com,
       rwheeler@redhat.com, bfields@fieldses.org, nfsv4@linux-nfs.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: Pull request for FS-Cache, including NFS patches
Date: Fri, 19 Dec 2008 02:27:24 +0000
Message-ID: <7633.1229653644@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> wrote:

> I don't believe that it has yet been convincingly demonstrated that we
> want to merge it at all.
> 
> It's a huuuuuuuuge lump of new code, so it really needs to provide
> decent value.  Can we revisit this?  Yet again?  What do we get from
> all this?

I should tell you to go and reread LKML at this point.

But...  What can FS-Cache do for you?  Well, in your specific case, probably
nothing.  If all your computers are local to your normal desktop box and are
connected by sufficiently fast network and you have sufficiently few of them,
or you don't use any of NFS, AFS, CIFS, Lustre, CRFS, CD-ROMs then it is
likely that won't gain you anything.

Even if you do use some of those "netfs's", it won't get you anything yet
because I haven't included patches to support anything other than NFS and the
in-kernel AFS client yet.

However, if you do use NFS (or my AFS client), and you are accessing computers
via slow networks, or you have lots of machines spamming your NFS server, then
it might avail you.

It's a compromise: a trade-off between the loading and latencies of your
network vs the loading and latencies of your disk; you sacrifice disk space to
make up for the deficiencies of your network.  The worst bit is that the
latencies are additive under some circumstances (when doing a page read you
may have to check disk and then go to the network).


So, FS-Cache can do the following for you:

 (1) Allow you to reduce network loading by diverting repeat reads to local
     storage.

 (2) Allow you to reduce the latency of slow network links by diverting repeat
     reads to local storage.

 (3) Allow you to reduce the effect of uncontactable servers by serving data
     out of local storage.

 (4) Allows you to reduce the latency of slow rotating media (such as CDROM
     and CD-changers).

 (5) Allow you to implement disconnected operation, partly by (3), but also by
     caching changes for later syncing.

Now, (1) and (2) are readily demonstrable.  I have posted benchmarks to do
this.  (3) to (5) are not yet implemented; these have to be mostly implemented
in the filesystems that use FS-Cache rather than FS-Cache itself.  FS-Cache
currently has sufficient functionality to do (3) and (4), but needs some extra
bits to do (5).

I've tried to implement just the minimal useful functionality for persistent
caching.  There is more to be added, but it's not immediately necessary.


FS-Cache tries to make its facilities as simple and as general as possible so
that _any_ filesystem or blockdev can use it.  I have patches here to make NFS
and AFS use it.  I know someone is working on getting Lustre to use it, and
other filesystem maintainers have expressed interest, subject to the code
getting upstream.

Furthermore, FS-Cache hides the implementation of the cache from the netfs.
Not only that, it hides I/O errors in the cache from the netfs.  Why should
the netfs have to deal with such things?


Another way to look at things is to look at other cases of cached netfs's.
OpenAFS for example.  It has a local cache of its own.  Solaris has local NFS
caching.  Windows has local caching for NFS and CIFS, I think.  Even web
browsers have local caching.

>  303 files changed, 21049 insertions(+), 3726 deletions(-)

A big chunk of that, particularly the deletions, is the creds patches.
Excluding the stuff pulled from the security and NFS trees, the combined
FS-Cache, CacheFiles and AFS+ and NFS+FS-Cache patches are, in fact:

	86 files changed, 15385 insertions(+), 413 deletions(-)

and over 19% of the insertions is documentation.  Most of the deletions (373)
are in AFS.

> Are any distros pushing for this?  Or shipping it?  If so, are they
> able to weigh in and help us with this quite difficult decision?

We (Red Hat) have shipped it in RHEL-5 and some Fedora releases.  Doing so is
quite an effort, though, precisely because the code is not yet upstream.  We
have customers using it and are gaining more customers who want it.  There
even appear to be CentOS users using it (or at least complaining when it
breaks).


I don't know what will convince you.  I've given you theoretical reasons why
caching ought to be useful; I've backed up the ones I've implemented with
benchmarks; I've given you examples of what our customers are doing with it or
want to do with it.  Please help me understand what else you want.

Do you perhaps want the netfs maintainers (such as Trond) to say that it's
necessary?

David
