Return-Path: <linux-kernel-owner+w=401wt.eu-S936644AbYBVA6a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936644AbYBVA6a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 19:58:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933470AbYBVA6G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 19:58:06 -0500
Received: from phunq.net ([64.81.85.152]:50682 "EHLO moonbase.phunq.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S934859AbYBVA6D convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 19:58:03 -0500
From: Daniel Phillips <phillips@phunq.net>
To: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 00/37] Permit filesystem local caching
Date: Thu, 21 Feb 2008 16:57:00 -0800
User-Agent: KMail/1.9.5
Cc: Trond.Myklebust@netapp.com, chuck.lever@oracle.com, casey@schaufler-ca.com,
       nfsv4@linux-nfs.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, selinux@tycho.nsa.gov,
       linux-security-module@vger.kernel.org
References: <200802211444.04986.phillips@phunq.net> <28196.1203605703@redhat.com> <18063.1203638861@redhat.com>
In-Reply-To: <18063.1203638861@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Content-Disposition: inline
Message-Id: <200802211657.01704.phillips@phunq.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 21 February 2008 16:07, David Howells wrote:
> The way the client works is like this:

Thanks for the excellent ascii art, that cleared up the confusion right
away.

> What are you trying to do exactly?  Are you actually playing with it, or just
> looking at the numbers I've produced?

Trying to see if you are offering enough of a win to justify testing it,
and if that works out, then going shopping for a bin of rotten vegetables
to throw at your design, which I hope you will perceive as useful.

In short I am looking for a reason to throw engineering effort at it.
>From the numbers you have posted I think you are missing some basic
efficiencies that could take this design from the sorta-ok zone to wow!

I think you may already be in the wow zone for taking load off a server
and I know of applications where an NFS server gets hammered so badly
that having the client suck a little in the unloaded case is a price
worth paying.  But the whole idea would be much more attractive if the
regressions were smaller.

> > Who is supposed to win big?  Is this mainly about reducing the load on 
> > the server, or is the client supposed to win even with a lightly loaded 
> > server?
> 
> These are difficult questions to answer.  The obvious answer to both is "it
> depends", and the real answer to both is "it's a compromise".
> 
> Inserting a cache adds overhead: you have to look in the cache to see if your
> objects are mirrored there, and then you have to look in the cache to see if
> the data you want is stored there; and then you might have to go to the server
> anyway and then schedule a copy to be stored in the cache.

But looking up the object in the cache should be nearly free - much less
than a microsecond per block.  If not then there are design issues.  I
suspect that you are doing yourself a disservice by going all the way
through the vfs to do this cache lookup, but this needs to be proved.

> The characteristics of this type of cache depend on a number of things: the
> filesystem backing it being the most obvious variable, but also how fragmented
> it is and the properties of the disk drive or drives it is on.

Double caching and vm unawareness of that has to hurt.

> The metadata problem is quite a tricky one since it increases with the number
> of files you're dealing with.  As things stand in my patches, when NFS, for
> example, wants to access a new inode, it first has to go to the server to
> lookup the NFS file handle, and only then can it go to the cache to find out if
> there's a matching object in the case.

So without the persistent cache it can omit the LOOKUP and just send the
filehandle as part of the READ?

> Worse, the cache must then perform 
> several synchronous disk bound metadata operations before it can be possible to
> read from the cache.  Worse still, this means that a read on the network file
> cannot proceed until (a) we've been to the server *plus* (b) we've been to the
> disk.
> 
> The reason my client going to my server is so quick is that the server has the 
> dcache and the pagecache preloaded, so that across-network lookup operations
> are really, really quick, as compared to the synchronous slogging of the local
> disk to find the cache object.

Doesn't that just mean you have to preload the lookup table for the
persistent cache so you can determine whether you are caching the data
for a filehandle without going to disk?

> I can probably improve this a little by pre-loading the subindex directories
> (hash tables) that I use to reduce the directory size in the cache, but I don't
> know by how much.

Ah I should have read ahead.  I think the correct answer is "a lot".
Your big can-t-get-there-from-here is the round trip to the server to
determine whether you should read from the local cache.  Got any ideas?

And where is the Trond-meister in all of this?

Regards,

Daniel
