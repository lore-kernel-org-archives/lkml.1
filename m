Return-Path: <linux-kernel-owner+w=401wt.eu-S1751046AbYFBLQZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751046AbYFBLQZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 07:16:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751895AbYFBLQQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 07:16:16 -0400
Received: from moutng.kundenserver.de ([212.227.126.188]:59249 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751660AbYFBLQP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 07:16:15 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: hooanon05@yahoo.co.jp
Subject: Re: [RFC 0/7] [RFC] cramfs: fake write support
Date: Mon, 2 Jun 2008 13:15:40 +0200
User-Agent: KMail/1.9.9
Cc: Jamie Lokier <jamie@shareable.org>,
       Phillip Lougher <phillip@lougher.demon.co.uk>,
       David Newall <davidn@davidnewall.com>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, hch@lst.de
References: <200805311737.58991.arnd@arndb.de> <200806020912.49721.arnd@arndb.de> <9159.1212402992@jrobl>
In-Reply-To: <9159.1212402992@jrobl>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200806021315.41211.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+CcG2vEyX+eAL2rK8BnBBsFdmssA6nFKw0Rj5
 WumNl1gQzv4ItYQAPVr4W3Paf2UeG4kNXheaN/HlE04OcnpzJS
 BmqinerDmtf7ejLUbNqtg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 02 June 2008, hooanon05@yahoo.co.jp wrote:
> > * data inconsistency problems when simultaneously accessing the underlying
> >   fs and the union.
> Aufs has three levels of detecting the direct-access to the lower
> (branch) filesystems (ie. bypassing aufs). I guess the most strict level
> is a good answer for your question. It is based on the inotify
> feature. Aufs sets inotify-watch to every accessed directories on lower
> fs. During those inodes are cached, aufs receives the inotify event for
> thier children/files and marks the aufs data for the file is
> obsoleted. When the file is accessed later, aufs retrives the latest
> inode (or dentry) again.
> The inotify-watch will be removed when the aufs dir inode is discarded
> from cache.

This is a very complicated approach, and I'm not sure if it even addresses
the case where you have a shared mmap on both files. With VFS based union
mounts, they share one inode, so you don't need to use idiotify in the first
place, and it automatically works on shared mmaps.

> > * duplication of dentry and inode data structures in the union wastes
> >   memory and cpu cycles.
> 
> Aufs has its own dentry and inode object as normal fs has. And they have
> pointers to the corresponding ones on the lower fs. If you make a union
> from two real filesystems, then aufs inode will have (at most) two
> pointers as its private data.
> Do you mean having pointers is a duplicataion?

I mean having your own dentry and inode object is duplication. The
underlying file system already has them, so if you have your own,
you need to keep them synchronized. I guess that in order to do
a lookup on a file, you need the steps of

1. lookup in aufs dentry cache -> fail
2. lookup in underlying dentry cache -> fail
3. try to read dentry from disk -> fail
4. repeat 2-3 until found, or arrive at lowest level 
5. create an inode in memory for the lower file system
6. create dentry in memory on lower file system, pointing
   to that
7. create an aufs specific inode pointing to the underlying
   inode
8. create an aufs specific dentry object to point to that
9. create a struct inode representing the aufs inode
10. create another VFS dentry to point to that

when you really should just return the dentry found by the
lower file system.

> > * whiteouts are in the same namespace as regular files, so conflicts are
> >   possible.
> 
> Yes, that's right.
> Aufs reserves ".wh." as a whiteout prefix, and prohibits users to handle
> such filename inside aufs. It might be a problem as you wrote, but users
> can create/remove them directly on the lower fs and I have never
> received request about this reserved prefix.

It's not so much a practical limitation as an exploitable feature.
E.g. an unpriviledged user may use this to get an application into
an error condition by asking for an invalid file name.

Posix reserves a well-defined set of invalid file names, and
deviation from this means that you are not compliant, and that
in a potentially unexpected way.

> > * mounting a large number of aufs on top of each other eventually
> >   overflows the kernel stack, e.g. in readdir.
> 
> Aufs readdir operation consumes memory, but it is not stack. If it was
> implemented as a recursive function, it might cause the stack
> overflow. But actually it is a loop.
> The memory is used for stroing entry names and eliminating whiteout-ed
> ones, and the result will be cached for a specified time. So the memory
> (other than stack) will be consumed.

How does aufs know that one of its branches is an aufs itself?
If you detect this, do you fold it into a single aufs instance with
more branches?
In case you don't do it, I don't see how you get around the stack
overflow, but if you do it, you have again added a whole lot of
complexity for something that should be trivial when done right.

> > * allowing multiple writable branches (instead of just stacking
> >   one rw copy on a number of ro file systems) is confusing to the user
> >   and complicates the implementation a lot.
> 
> Probably you are right. Initially aufs had only one policy to select the
> writable branch. But several users requested another policy such as
> round-robin or most-free-spece, and aufs has implemented them.
> I don't guess uers will be confused by these policies. While I tried it
> should be simple, I guess some people will say it is complex.

I personally think that a policy other than writing to the top is crazy
enough, but randomly writing to multiple places is much worse, as it
becomes unpredictable what the file system does, not just unexpected.

	Arnd <><
