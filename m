Return-Path: <linux-kernel-owner+w=401wt.eu-S1753520AbZIIRLd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753520AbZIIRLd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 13:11:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753460AbZIIRLc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 13:11:32 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36714 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753421AbZIIRLb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 13:11:31 -0400
Date: Wed, 9 Sep 2009 10:09:47 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Christoph Hellwig <hch@infradead.org>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Al Viro <viro@zeniv.linux.org.uk>,
       Linux Filesystem Mailing List <linux-fsdevel@vger.kernel.org>,
       Eric Paris <eparis@redhat.com>, Mimi Zohar <zohar@us.ibm.com>,
       James Morris <jmorris@namei.org>
Subject: Re: [PATCH 8/8] jffs2/jfs/xfs: switch over to 'check_acl' rather
 than 'permission()'
In-Reply-To: <20090908183431.GA22314@infradead.org>
Message-ID: <alpine.LFD.2.01.0909090945580.7458@localhost.localdomain>
References: <alpine.LFD.2.01.0909071337510.3419@localhost.localdomain> <alpine.LFD.2.01.0909071401210.3419@localhost.localdomain> <alpine.LFD.2.01.0909071402220.3419@localhost.localdomain> <alpine.LFD.2.01.0909071402510.3419@localhost.localdomain>
 <alpine.LFD.2.01.0909071403110.3419@localhost.localdomain> <alpine.LFD.2.01.0909071403390.3419@localhost.localdomain> <alpine.LFD.2.01.0909071404090.3419@localhost.localdomain> <alpine.LFD.2.01.0909071404370.3419@localhost.localdomain>
 <alpine.LFD.2.01.0909071405070.3419@localhost.localdomain> <20090908183431.GA22314@infradead.org>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 8 Sep 2009, Christoph Hellwig wrote:
>
> The split of these patches is a bit odd, either do all in one patch or
> one patch per filesystem instead of those groups.

Hmm. I actually did that somewhat on purpose. 

The reason? If there is something wrong, I want bisection to specify it 
fairly well, and I was thinking that maybe there would be some filesystem
specific issue. I know, it's unlikely, but hey, if I knew when bugs 
happened, I'd just make sure they never did..

So I wanted to keep the shmfs one separate, because people use that 
filesystem independently of - and generally differently from - the other 
on-disk ones, and maybe you could have a shmfs-specific bug but not a 
filesystem-specific one (or vice versa). So if some application suddenly 
breaks, anybody doing bisection would see which one it is.

Now, I could then have bundled up the rest of the filesystems as one 
commit, or done them all as individual ones, and there I don't really have 
any huge preferences. There were six filesystems that had "obviously just 
the wrapper function" (done by just doing a

	git grep -2 generic_permission

in case anybody cares), and quite frankly, if you do that grep, then the 
ext* group stands out very clearly (next to each other, same indentation 
due to filenames etc etc). So I just did them next.

And the third group was just "the rest". Not standing out in any 
particular way, but also not worth doing individually in any particular 
way. Bisectability in those groups doesn't much matter, because I don't 
think it's all that likely that a machine that shows problems would run a 
mix of filesystems, the way you'd mix shmfs with other filesystems and 
other patterns.

> That beeing said if we go down this way I would prefer if we go
> down all the way, that is convert the remaining few filesystems that
> pass a check_acl argument to generic_permission (btrfs, gfs2, ocfs2)
> and just kill off that argument.

And I do agree, eventually. But the series was really meant to be a 
standalone thing where I didn't force filesystems to change. I also hope 
that some filesystems, like btrfs, that don't use the "trivial wrapper", 
would look at _why_ they don't just use the trivial wrapper.

For some of them, they seem to have real major reasons not to just use 
'generic_permission()' (eg fuse), while others - btrfs - seem to be just 
odd, and eg have its own special case of btrfs-specific read-only crap. 
Which is a real downer, since that MAY_WRITE case isn't even relevant for 
pathname lookup, but even for other inodes I really don't see why btrfs 
doesn't just use the generic VFS-layer "S_IMMUTABLE" bit.

Now, for your particular suggestion it doesn't matter (we'd just drop the 
last argument, and have "generic_permission()" pick it up from the inode 
ops), but the larger point was that I really didn't want to change 
filesystem code unnecessarily. And I'd actually hope that eventually _no_ 
filesystem would use "generic_permission()" at all, and we'd just always 
do that whole check_acl thing at a VFS level if the filesystem provides 
acls.

Part of that is that I would also move the whole "get_cached_acl()" to 
the VFS layer entirely - and I think Al has patches to this. So then we'd 
only need to call some filesystem-specific "check_acl" in the cases where 
we do _not_ already have cached ACL's - and then we can finally do all the 
ACL checks without ever calling into the filesystem at all, which is 
pretty much required if we want to do lockless lookups.

> After that there is another step we can easily go:  as we now cache the
> ACLs in the generic inode instead of the per-fs one we can move the
> get_cached_acl call to your acl_permission_check helper (for gfs2/ocfs2
> that don't cache ACLs it will always fail), and not call out to the fs
> for the fast path at all.

Yes, see above. Al and I talked about this a couple of months ago, and 
that's why he already moved the ACL lists to the generic inode in 
preparation of this. The reason for that was that absolutely _all_ 
filesystems got the locking wrong (too much unnecessary locking for the 
common case of a cached "no acl" case), and some of them got the caching 
wrong (no caching at all).

The take-away message from this all is generally: "don't make individual 
filesystems do even simple things - they'll do it wrong". It's not just 
that the VFS layer will do it better, it's that if it's done in the VFS 
layer we can be clever about locking in a way that we can _not_ be when we 
have to rely on the filesystem writers being aware of subtle issues.

			Linus
