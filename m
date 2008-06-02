Return-Path: <linux-kernel-owner+w=401wt.eu-S1760676AbYFBM6r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760676AbYFBM6r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 08:58:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754783AbYFBM6g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 08:58:36 -0400
Received: from vsmtp04.dti.ne.jp ([202.216.231.139]:49813 "EHLO
	vsmtp04.dti.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754216AbYFBM6f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 08:58:35 -0400
From: hooanon05@yahoo.co.jp
Subject: Re: [RFC 0/7] [RFC] cramfs: fake write support 
To: Arnd Bergmann <arnd@arndb.de>
Cc: Jamie Lokier <jamie@shareable.org>,
       Phillip Lougher <phillip@lougher.demon.co.uk>,
       David Newall <davidn@davidnewall.com>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, hch@lst.de
In-Reply-To: <200806021315.41211.arnd@arndb.de>
References: <200805311737.58991.arnd@arndb.de> <200806020912.49721.arnd@arndb.de> <9159.1212402992@jrobl> <200806021315.41211.arnd@arndb.de>
Date: Mon, 02 Jun 2008 21:56:40 +0900
Message-ID: <6880.1212411400@jrobl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Arnd Bergmann:
> This is a very complicated approach, and I'm not sure if it even addresses
> the case where you have a shared mmap on both files. With VFS based union
> mounts, they share one inode, so you don't need to use idiotify in the first
> place, and it automatically works on shared mmaps.

As you might know, aufs doesn't have its own file mapped pages. Aufs
overrides vm_operations and redirects the page fault to the lower file's
vm_operation. So the shared mmap has no problem.
I am afraid that I should write "marks the attributes in aufs is
obsoleted" instead of "marks the aufs data for the file is obsoleted" in
my previous mail.


> I mean having your own dentry and inode object is duplication. The

I see.
Then the solution must be union-mount.
Your 10 steps seem to be rather verbose. Generally, 'lookup' means to
create (or get) inode and dentry, and the fs inode and VFS inode are
allocated in the same time.
Aufs does 'lookup' for the lower dentry (yes, it must be repeated if
necessary), and sets it to the aufs dentry/inode private data.


> It's not so much a practical limitation as an exploitable feature.
> E.g. an unpriviledged user may use this to get an application into
> an error condition by asking for an invalid file name.

If a user specifies the prohibitted filename, the he will get an error.


> Posix reserves a well-defined set of invalid file names, and
> deviation from this means that you are not compliant, and that
> in a potentially unexpected way.

Yes, the whiteout prefix is a limitation (or a feature).


> How does aufs know that one of its branches is an aufs itself?
> If you detect this, do you fold it into a single aufs instance with
> more branches?
> In case you don't do it, I don't see how you get around the stack
> overflow, but if you do it, you have again added a whole lot of
> complexity for something that should be trivial when done right.

- To detect the filesystem type is easy. Aufs can know whether the
  branch is aufs or not by checking s_magic or s_type->name.
- aufs doesn't fold? expand? the nested aufs branch.

You might be pointng out a general matter of stacking filesystem.
When one of branches is a stacking fs, and it is nested deeper and
deeper,
- /aufs1 = /rw1 + /aufs2
- /aufs2 = /rw2 + /aufs3
- /aufs3 = /rw3 + /aufs4
	:::
then the stack-overflow may happen. It is not limited to readdir, it can
happen in every operation. Basically aufs rejects 'aufs/unionfs branch',
in other word "aufs branch of another aufs mount."
But aufs has a configuration to enable this. When a user enables it and
sets deeply nested aufs branch, it could happen. But this is same thing
even if you use union-mount (and if UnionMount supports such branch).


> I personally think that a policy other than writing to the top is crazy
> enough, but randomly writing to multiple places is much worse, as it
> becomes unpredictable what the file system does, not just unexpected.

I don't want you to call aufs users crazy who are using such policies.
By the way, how do you think link(2) or rename(2)? When the source file
exists on the lower writable branch, do you think copy-up is the best
way? Or do you think all lower branches should be readonly?
There is an exception in aufs's branch-select policy. That is
link/rename case. When the source file exists on a writable branch, aufs
tries link/rename it on that branch in every policy. Do you think it
best to do it on the top branch only?


Junjiro Okajima
