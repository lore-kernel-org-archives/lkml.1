Return-Path: <linux-kernel-owner+w=401wt.eu-S1757293AbYKVBL2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757293AbYKVBL2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 20:11:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753855AbYKVBLT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 20:11:19 -0500
Received: from mx2.redhat.com ([66.187.237.31]:59156 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752250AbYKVBLS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 20:11:18 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20081121002847.c8fe7aef.akpm@linux-foundation.org>
References: <20081121002847.c8fe7aef.akpm@linux-foundation.org> <20081120144139.10667.75519.stgit@warthog.procyon.org.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: dhowells@redhat.com, trond.myklebust@fys.uio.no, viro@ZenIV.linux.org.uk,
       nfsv4@linux-nfs.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 00/45] Permit filesystem local caching [ver #41]
Date: Sat, 22 Nov 2008 01:11:09 +0000
Message-ID: <19708.1227316269@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> wrote:

> > These patches add local caching for network filesystems such as NFS and AFS.
> 
> For performance reasons, one assumes.  Are there any other reasons?
> Disconnected operation, anything like that?

There are a number of reasons.  It *can* improve performance, of the client,
the network and the server; and it can form the basis of disconnected
operation.

If the link is very slow, the disk may be fast enough that locally cached files
are faster pulled from disk on the client.  If the link is very fast, then
pulling from RAM on the server may be much faster than the cache.

However, even if the link is very fast, if there are lots of clients, using a
cache may reduce the loading on the network because the clients are able to
satisfy read requests from their own disk rather than sucking the data over the
network.  Furthermore, this will reduce the loading on the server as that also
has to do less work as it doesn't have to receive, process and respond to the
read requests.

FS-Cache does _not_ guarantee there will be a performance improvement on the
client.  There _is_ a penalty associated with using a cache.  The various
penalties imposed by a particular cache and the various enhancements supplied
by that cache are a compromise.  Generally you cannot get an improvement in one
parameter without a further penalty elsewhere.

FS-Cache tries to be very simple: It allows the netfs to store pages, to key
those pages in such a way that it can retrieve them later, and to allow
coherency data to be stored about those pages - all without the netfs knowing
anything about how the cache actually works, or if there's even a cache at all.
That means, however, that the netfs must decide how and when it wants to use
the facility.

> We would want to know the performance benefits in some detail before even 
> looking at the code, no?  Maybe they're in here somewhere but I missed it..

Now that I've applied the comments I got, I'll get you some benchmarks.  I'll
have to see about setting up some realistic test scenarios.

My current testing rig involves a single client connected by GigE to a single
server with little other traffic on the network.  In this situation uncached
NFS (22s[*]) creams cached NFS (18m) because the working set fits entirely into
RAM on the server, but doesn't on the client, so the client has to read the
whole lot from disk each time (lots of synchronous seek penalties), but the
server doesn't.

[*] Eight parallel tars over three 350MB kernel trees pulled by NFS.  Three
    tars on each of two trees, two tars on the third.  The client machine has
    1GB of RAM.

This is not a situation in which I'd normally use a cache, except if I was
expecting the server to disappear randomly and wanted to be able to go on
working.

So I need to slow down the network.  Pulling from my AFS server, which is at
the far end of a ~50MB/s ethernet-over-mains network, the cache makes much more
of a difference.

David
