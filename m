Return-Path: <linux-kernel-owner+w=401wt.eu-S936996AbYBVW1c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936996AbYBVW1c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 17:27:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936939AbYBVW0p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 17:26:45 -0500
Received: from phunq.net ([64.81.85.152]:39637 "EHLO moonbase.phunq.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S936744AbYBVW0j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 17:26:39 -0500
From: Daniel Phillips <phillips@phunq.net>
To: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 00/37] Permit filesystem local caching
Date: Fri, 22 Feb 2008 14:25:47 -0800
User-Agent: KMail/1.9.5
Cc: Trond.Myklebust@netapp.com, chuck.lever@oracle.com, casey@schaufler-ca.com,
       nfsv4@linux-nfs.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, selinux@tycho.nsa.gov,
       linux-security-module@vger.kernel.org, Trond.Myklebust@netapp.com
References: <200802211657.01704.phillips@phunq.net> <18063.1203638861@redhat.com> <20089.1203684531@redhat.com>
In-Reply-To: <20089.1203684531@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802221425.48535.phillips@phunq.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 22 February 2008 04:48, David Howells wrote:
> > But looking up the object in the cache should be nearly free - much less
> > than a microsecond per block.
> 
> The problem is that you have to do a database lookup of some sort, possibly
> involving several synchronous disk operations.

Right, so the obvious optimization strategy for this corner of it is to
decimate the synchronous disk ops for the average case, for which there
are a variety of options, one of which you already suggested.

> CacheFiles does a disk lookup by taking the key given to it by NFS, turning it
> into a set of file or directory names, and doing a short pathwalk to the target
> cache file.  Throwing in extra indices won't necessarily help.  What matters is
> how quick the backing filesystem is at doing lookups.  As it turns out, Ext3 is
> a fair bit better then BTRFS when the disk cache is cold.

All understood.  I am eventually going to suggest cutting the backing
filesystem entirely out of the picture, with a view to improving both
efficiency and transparency, hopefully with a code size reduction as
well.  But you are up and running with the filesystem approach, enough
to tackle the basic algorithm questions, which is worth a lot.

I really do not like idea of force fitting this cache into a generic
vfs model.  Sun was collectively smoking some serious crack when they
cooked that one up.  But there is also the ageless principle "isness is
more important than niceness".

> > > The metadata problem is quite a tricky one since it increases with the
> > > number of files you're dealing with.  As things stand in my patches, when
> > > NFS, for example, wants to access a new inode, it first has to go to the
> > > server to lookup the NFS file handle, and only then can it go to the cache
> > > to find out if there's a matching object in the case.
> > 
> > So without the persistent cache it can omit the LOOKUP and just send the
> > filehandle as part of the READ?
> 
> What 'it'?  Note that the get the filehandle, you have to do a LOOKUP op.  With
> the cache, we could actually cache the results of lookups that we've done,
> however, we don't know that the results are still valid without going to the
> server:-/

What I was trying to say.  It => the cache logic.

> AFS has a way around that - it versions its vnode (inode) IDs.

Which would require a change to NFS, not an option because you hope to
work with standard servers?  Of course with years to think about this,
the required protocol changes were put into v4.  Not.

/me hopes for an NFS hack to show up and explain the thinking there

Actually, there are many situations where changing both the client (you
must do that anyway) and the server is logistically practical.  In fact
that is true for all actual use cases I know of for this cache model.
So elaborating the protocol is not an option to reject out of hand.  A
hack along those lines could (should?) be provided as an opportunistic
option.

Have you completely exhausted optimization ideas for the file handle
lookup?

> > > The reason my client going to my server is so quick is that the server has
> > > the dcache and the pagecache preloaded, so that across-network lookup
> > > operations are really, really quick, as compared to the synchronous
> > > slogging of the local disk to find the cache object.
> > 
> > Doesn't that just mean you have to preload the lookup table for the
> > persistent cache so you can determine whether you are caching the data
> > for a filehandle without going to disk?
> 
> Where "lookup table" == "dcache".  That would be good yes.  cachefilesd
> prescans all the files in the cache, which ought to do just that, but it
> doesn't seem to be very effective.  I'm not sure why.

RCU?  Anyway, it is something to be tracked down and put right.

> > Your big can-t-get-there-from-here is the round trip to the server to
> > determine whether you should read from the local cache.  Got any ideas?
> 
> I'm not sure what you mean.  Your statement should probably read "... to
> determine _what_ you should read from the local cache".

What I tried to say.  So still... got any ideas?  That extra synchronous
network round trip is a killer.  Can it be made streaming/async to keep
throughput healthy?

> > And where is the Trond-meister in all of this?
> 
> Keeping quiet as far as I can tell.

/me does the Trond summoning dance

Daniel
