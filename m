Return-Path: <linux-kernel-owner+w=401wt.eu-S1755173AbZGXXB6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755173AbZGXXB6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jul 2009 19:01:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755156AbZGXXB6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Jul 2009 19:01:58 -0400
Received: from mail2.shareable.org ([80.68.89.115]:50524 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755146AbZGXXB5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jul 2009 19:01:57 -0400
Date: Sat, 25 Jul 2009 00:01:55 +0100
From: Jamie Lokier <jamie@shareable.org>
To: Andreas Dilger <adilger@sun.com>
Cc: Eric Paris <eparis@redhat.com>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, malware-list@dmesg.printk.net,
       Valdis.Kletnieks@vt.edu, greg@kroah.com, jcm@redhat.com,
       douglas.leeder@sophos.com, tytso@mit.edu, arjan@infradead.org,
       david@lang.hm, jengelh@medozas.de, aviro@redhat.com, mrkafk@gmail.com,
       alexl@redhat.com, jack@suse.cz, tvrtko.ursulin@sophos.com,
       a.p.zijlstra@chello.nl, hch@infradead.org, alan@lxorguk.ukuu.org.uk,
       mmorley@hcl.in, pavel@suse.cz
Subject: Re: fanotify - overall design before I start sending patches
Message-ID: <20090724230155.GL27755@shareable.org>
References: <1248466429.3567.82.camel@localhost> <20090724210008.GE4231@webber.adilger.int> <1248470485.3567.106.camel@localhost> <20090724224223.GH4231@webber.adilger.int>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090724224223.GH4231@webber.adilger.int>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andreas Dilger wrote:
> On Jul 24, 2009  17:21 -0400, Eric Paris wrote:
> > On Fri, 2009-07-24 at 15:00 -0600, Andreas Dilger wrote:
> > > On Jul 24, 2009  16:13 -0400, Eric Paris wrote:
> > > It seems like a 32-bit mask might not be enough, it wouldn't be hard
> > > at this stage to add a 64-bit mask.  Lustre has a similar mechanism
> > > (changelog) that allows tracking all different kinds of filesystem
> > > events (create/unlink/symlink/link/rename/mkdir/setxattr/etc), instead
> > > of just open/close, also use by HSM, enhanced rsync, etc.
> > 
> > I had a 64 bit mask, but Al Viro ask me to go back to a 32 bit mask
> > because of i386 register pressure.  The bitmask operations are on VERY
> > hot paths inside the kernel.
> 
> How about adding a spare "__u32 mask_hi" for future use, so that it can
> be changed directly into a __u64 on LE machines?  That preserves the
> extensibility for the future, without hitting performance on 32-bit
> machines before it is needed.

If so, remember to put "__u32 mask_hi" *before* "__u32 mask" on BE
32-bit machines.  Then it can be changed to __u64 on those too, if
needed.

> Well, if new files are created then userspace won't have any idea which
> inodes need to be checked, and it will also need to keep a persistent
> database of all file i_version values.  If you are trying to hook a
> backup tool onto such an interface and files created persistently on
> disk before a crash are not handled, then they may never be backed up.
> 
> Tools like inotify are fine for desktop window refresh and similar uses,
> but for applications which require robust handling they also need to
> work over a crash.

I see two ways to handle that:

   - Simply assert that the monitoring program is running whenever
     there are any changes to a particular filesystem, or the program
     is told that it must reindex as a matter of policy.

     For example you might run the program before mounting and after
     unmounting, so you know there are no changes at other times.

     That's not hard security, but then neither is i_version or any
     other check, as root (which is responsible for the mount/umount
     sequence after all) can also bypass filesystems.

   - Have a well-known extended attribute (xattr) or set of them which
     are _always deleted_ whenever files are modified.  For example
     "system.indexing.*".  An application called Foo Monitor would
     create "system.indexing.foo" xattrs on files prior to indexing
     each one.

     Each time a MODIFY event occurs on a file, whether it's being
     watched or not, the kernel would remove all attributes whose
     names match "system.indexing.*".

     That includes recursively doing the same to parent directories
     via the path used for that access, all the way to the filesystem
     root (even if the root isn't visible due to mounting).  (See my
     other recent mail for why a single path works for hard-linked files).

     Tools can look at those xattrs to determine if their indexing
     information is up to date - persistently across crashes, unmounts
     and reboots.

> The other issue is that you might get quite a large queue of operations
> in memory, and if this can't be saved to the filesystem then it might
> result in OOMing itself.

:-)  What does inotify do in this scenario?

-- Jamie
