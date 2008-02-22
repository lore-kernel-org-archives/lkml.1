Return-Path: <linux-kernel-owner+w=401wt.eu-S934975AbYBVMuy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934975AbYBVMuy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 07:50:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752671AbYBVMum
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 07:50:42 -0500
Received: from mx1.redhat.com ([66.187.233.31]:45756 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751022AbYBVMuk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 07:50:40 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <200802211657.01704.phillips@phunq.net>
References: <200802211657.01704.phillips@phunq.net> <200802211444.04986.phillips@phunq.net> <28196.1203605703@redhat.com> <18063.1203638861@redhat.com>
To: Daniel Phillips <phillips@phunq.net>
Cc: dhowells@redhat.com, Trond.Myklebust@netapp.com, chuck.lever@oracle.com,
       casey@schaufler-ca.com, nfsv4@linux-nfs.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       selinux@tycho.nsa.gov, linux-security-module@vger.kernel.org
Subject: Re: [PATCH 00/37] Permit filesystem local caching
X-Mailer: MH-E 8.0.3+cvs; nmh 1.2-20070115cvs; GNU Emacs 23.0.50
Date: Fri, 22 Feb 2008 12:48:51 +0000
Message-ID: <20089.1203684531@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel Phillips <phillips@phunq.net> wrote:

> > The way the client works is like this:
> 
> Thanks for the excellent ascii art, that cleared up the confusion right
> away.

You know what they say about pictures... :-)

> > What are you trying to do exactly?  Are you actually playing with it, or
> > just looking at the numbers I've produced?
> 
> Trying to see if you are offering enough of a win to justify testing it,
> and if that works out, then going shopping for a bin of rotten vegetables
> to throw at your design, which I hope you will perceive as useful.

One thing that you have to remember: my test setup is pretty much the
worst-case for being appropriate for showing the need for caching to improve
performance.  There's a single client and a single server, they've got GigE
networking between them that has very little other load, and the server has
sufficient memory to hold the entire test data set.

> From the numbers you have posted I think you are missing some basic
> efficiencies that could take this design from the sorta-ok zone to wow!

Not really, it's just that this lashup could be considered designed to show
local caching in the worst light.

> But looking up the object in the cache should be nearly free - much less
> than a microsecond per block.

The problem is that you have to do a database lookup of some sort, possibly
involving several synchronous disk operations.

CacheFiles does a disk lookup by taking the key given to it by NFS, turning it
into a set of file or directory names, and doing a short pathwalk to the target
cache file.  Throwing in extra indices won't necessarily help.  What matters is
how quick the backing filesystem is at doing lookups.  As it turns out, Ext3 is
a fair bit better then BTRFS when the disk cache is cold.

> > The metadata problem is quite a tricky one since it increases with the
> > number of files you're dealing with.  As things stand in my patches, when
> > NFS, for example, wants to access a new inode, it first has to go to the
> > server to lookup the NFS file handle, and only then can it go to the cache
> > to find out if there's a matching object in the case.
> 
> So without the persistent cache it can omit the LOOKUP and just send the
> filehandle as part of the READ?

What 'it'?  Note that the get the filehandle, you have to do a LOOKUP op.  With
the cache, we could actually cache the results of lookups that we've done,
however, we don't know that the results are still valid without going to the
server:-/

AFS has a way around that - it versions its vnode (inode) IDs.

> > The reason my client going to my server is so quick is that the server has
> > the dcache and the pagecache preloaded, so that across-network lookup
> > operations are really, really quick, as compared to the synchronous
> > slogging of the local disk to find the cache object.
> 
> Doesn't that just mean you have to preload the lookup table for the
> persistent cache so you can determine whether you are caching the data
> for a filehandle without going to disk?

Where "lookup table" == "dcache".  That would be good yes.  cachefilesd
prescans all the files in the cache, which ought to do just that, but it
doesn't seem to be very effective.  I'm not sure why.

> > I can probably improve this a little by pre-loading the subindex
> > directories (hash tables) that I use to reduce the directory size in the
> > cache, but I don't know by how much.
> 
> Ah I should have read ahead.  I think the correct answer is "a lot".

Quite possibly.  It'll allow me to dispense with at least one fs lookup call
per cache object request call.

> Your big can-t-get-there-from-here is the round trip to the server to
> determine whether you should read from the local cache.  Got any ideas?

I'm not sure what you mean.  Your statement should probably read "... to
determine _what_ you should read from the local cache".

> And where is the Trond-meister in all of this?

Keeping quiet as far as I can tell.

David
