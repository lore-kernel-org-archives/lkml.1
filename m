Return-Path: <linux-kernel-owner+w=401wt.eu-S1761147AbZFQUZH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761147AbZFQUZH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 16:25:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755768AbZFQUY6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 16:24:58 -0400
Received: from isrv.corpit.ru ([81.13.33.159]:40092 "EHLO isrv.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755352AbZFQUY5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 16:24:57 -0400
Message-ID: <4A395119.5060108@msgid.tls.msk.ru>
Date: Thu, 18 Jun 2009 00:24:57 +0400
From: Michael Tokarev <mjt@tls.msk.ru>
Organization: Telecom Service, JSC
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: "J. Bruce Fields" <bfields@fieldses.org>
CC: Justin Piszcz <jpiszcz@lucidpixels.com>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.29.1: nfsd: page allocation failure - nfsd or kernel problem?
References: <alpine.DEB.2.00.0906161203160.27742@p34.internal.lan> <alpine.DEB.2.00.0906161205260.27742@p34.internal.lan> <4A37FE48.6070306@msgid.tls.msk.ru> <4A38ACC0.3060501@msgid.tls.msk.ru> <alpine.DEB.2.00.0906170542170.3600@p34.internal.lan> <4A38C7CA.7040005@msgid.tls.msk.ru> <20090617185139.GF24040@fieldses.org>
In-Reply-To: <20090617185139.GF24040@fieldses.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

J. Bruce Fields wrote:
> On Wed, Jun 17, 2009 at 02:39:06PM +0400, Michael Tokarev wrote:
>> Justin Piszcz wrote:
>>>
>>> On Wed, 17 Jun 2009, Michael Tokarev wrote:
>>>
>>>> Michael Tokarev wrote:
>>>>> Justin Piszcz wrote:
>>>> ...
>>>>
>>>> Justin, by the way, what's the underlying filesystem on the server?
>>>>
>>>> I've seen this error on 2 machines already (both running 2.6.29.x  
>>>> x86-64),
>>>> and in both cases the filesystem on the server was xfs.  May this be
>>>> related somehow to http://bugzilla.kernel.org/show_bug.cgi?id=13375 ?
>>>> That one is different, but also about xfs and nfs.  I'm trying to
>>>> reproduce the problem on different filesystem...
>>> Hello, I am also running XFS on 2.6.29.x x86-64.
>>>
>>> For me, the error happened when I was running an XFSDUMP from a client  
>>> (and dumping) the stream over NFS to the XFS server/filesystem.  This 
>>> is typically when the error occurs or during heavy I/O.
>> Very similar load was here -- not xfsdump but tar and dump of an ext3
>> filesystems.
>>
>> And no, it's NOT xfs-related: I can trigger the same issue easily on

Note the NOT, in upper case ;)

>> ext4 as well.  About 20 minutes of running 'dump' of another fs
>> to the nfs mount and voila, nfs server reports the same page allocation
>> failure.  Note that all file operations are still working, i.e. it
>> produces good (not corrupted) files on the server.
> 
> There's a possibly related report for 2.6.30 here:
> 
> 	http://bugzilla.kernel.org/show_bug.cgi?id=13518

Does not look similar.

I repeated the issue here.  The slab which is growing here is buffer_head.
It's growing slowly -- right now, after ~5 minutes of constant writes over
nfs, its size is 428423 objects, growing at about 5000 objects/minute rate.
When stopping writing, the cache shrinks slowly back to an acceptable
size, probably when the data gets actually written to disk.

It looks like we need a bug entry for this :)

I'll re-try 2.6.30 hopefully tomorrow.

/mjt
