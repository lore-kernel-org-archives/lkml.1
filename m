Return-Path: <linux-kernel-owner+w=401wt.eu-S1757842AbXLGSBT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757842AbXLGSBT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2007 13:01:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754548AbXLGSBB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Dec 2007 13:01:01 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:62149 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754315AbXLGSBA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2007 13:01:00 -0500
In-Reply-To: <21053.1196971251@redhat.com>
References: <26C82FDD-C778-4034-A3CF-CB1C83A0C90C@oracle.com> <A0BB0F8C-9628-4B6C-A2F7-F3870B487D4E@oracle.com> <6306.1196874660@redhat.com> <25619.1196904168@redhat.com> <21053.1196971251@redhat.com>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <DD7C0279-50CF-443B-B61B-D3DD78EE22C5@oracle.com>
Cc: Peter Staubach <staubach@redhat.com>,
       Trond Myklebust <trond.myklebust@fys.uio.no>, nfsv4@linux-nfs.org,
       linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 7bit
From: Chuck Lever <chuck.lever@oracle.com>
Subject: Re: How to manage shared persistent local caching (FS-Cache) with NFS?
Date: Fri, 7 Dec 2007 12:59:48 -0500
To: David Howells <dhowells@redhat.com>
X-Mailer: Apple Mail (2.752.2)
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David-

[ Some history snipped... ]

On Dec 6, 2007, at 3:00 PM, David Howells wrote:
> Chuck Lever <chuck.lever@oracle.com> wrote:
>> Is it a problem because, if there are multiple copies of the same  
>> remote file
>> in its cache, then FS-cache doesn't know, upon  reconnection,  
>> which item to
>> match against a particular remote file?
>
> There are multiple copies of the same remote file that are  
> described by the
> same remote parameters.  Same IP address, same port, same NFS  
> version, same
> FSID, same FH.  The difference may be a local connection parameter.

Why not encode the local mounted-on directory in the key?  A  
cryptographic hash of the directory's absolute pathname would be  
bounded in size.  And the mounted-on directory is usually persistent  
across client reboots.

That way you can use the directory name hash to distinguish the  
different views of the same remote object.

>> An adequate first pass at FS-cache can be done without guaranteeing
>> persistence.
>
> True.  But it's not particularly interesting to me in such a case.
>
>> There are a host of other issues that need exposure -- steady-state
>> performance;
>
> Meaning what?

Meaning your cache is at quota all the time, and to continue  
operation it must eject items constantly.

This is a scenario where it pays to cache the read-mostly items on  
disk, and leave the frequently changing items in memory.

The economics of disk caches is different than memory caches.  Disk  
caches are much larger and cheaper, but their performance tanks when  
they have to track frequently changing files.  Memory caches are  
smaller, but tracking frequently changing data is only a little more  
expensive than tracking data that doesn't change often.

> I have been measuring the performance improvement and degradation  
> numbers, and
> I can say that if you've one client and one server, the server has  
> all the
> files in memory, and there's gigabit ethernet between them, an on- 
> disk cache
> really doesn't help.
>
> Basically, the consideration of whether to use a cache is a  
> compromise between
> a host of factors.
>
>> cache garbage collection
>
> Done.
>
>> and reclamation;
>
> Done.
>
>> cache item aliasing;
>
> Partly done.
>
>> whether all files on a mount point should be cached on disk, or  
>> some in
>> memory and some on disk;
>
> I've thought about that, but no-one seems particularly interested in
> discussing it.

I think it's key to preventing FS-cache from making performance worse  
in many common scenarios.

>> And what would it harm if FS-cache decides that certain items in  
>> its cache
>> have become ambiguous or otherwise unusable after a  reconnection  
>> event, thus
>> it reclaims them instead of re-using them?
>
> It depends.
>
> At some point I'd like to make disconnected operation possible, and  
> that means
> storing data to be written back in the cache.  You can't  
> necessarily just
> chuck that away.

Disconnected operation for NFS is fraught with challenges.  Access to  
data on servers is traditionally gated by the client's IP address,  
for example.  The client may disconnect from the network, then  
reconnect using a different address where suddenly all of its  
accesses are rebuffed.

NFS servers, not clients, traditionally determine the file's mtime  
and ctime, and its file handle.  So file updates and file creation  
become problematic.  The client has to reconcile the server's file  
handle, for files created offline, with its own when reconnecting.

And, for disconnected operation, the cache is required to contain  
every item from the remote.  You can't just drop items from the cache  
because they are inconvenient.

>>> I can't just say: "Well, it'll oops if you configure your NFS  
>>> shares like
>>> that,
>>> so don't.  It's not worth me implementing round it.".
>>
>> What causes that instability?  Why can't you insulate against the  
>> instability
>> but allow cache incoherence and aliased cache items?
>
> Insulate how?  The only way to do that is to add something to the  
> cache key
> that says that these two otherwise identical items are actually  
> diffent
> things.

That something might be the pathname of the mounted-on directory or  
of the file itself.

>> I'm arguing that cache coherence isn't supported by the NFS  
>> protocol, so how
>> can FS-cache *require* a facility to support persistent local   
>> caching that
>> the protocol doesn't have in the first place?
>
> NFS has just enough to just about support a persistent local cache for
> unmodified files.  It has unique file keys per server, and it has a  
> (limited)
> amount of coherency data per file.  That's not really the problem.
>
> The problem is that the client can create loads of different views  
> of a remote
> export and the kernel treats them as if they're views of different  
> remote
> exports.  These views do not necessarily have *anything* to  
> distinguish them
> at all (nosharecache option).

Yes, they do.  The combination of mount options and mounted-on  
directory (or local pathname to the file) gives you a unique identity  
for that view.

> Now, for the case of cached clients, we can enforce a reduction of  
> incoherency
> by requiring one remote inode maps to a single client inode if that  
> inode is
> going to be placed in the persistent cache.

That seems reasonable.  Just don't cache the second and greater  
instances of the same remote file if FS-cache can't handle local  
aliases.

>> Invalidating is cheap for in-memory caches.  Frequent invalidation  
>> is going
>> to be expensive for FS-cache, since it requires some disk I/O (and  
>> perhaps
>> even file truncation).
>
> So what?  That's one of the compromises you have to make if you  
> want an
> on-disk cache.  The invalidation is asynchronous anyway.

So an item is cached in memory until space becomes available in the  
disk cache?
>

--
Chuck Lever
chuck[dot]lever[at]oracle[dot]com
