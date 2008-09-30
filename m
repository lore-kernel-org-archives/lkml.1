Return-Path: <linux-kernel-owner+w=401wt.eu-S1754145AbYI3TkS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754145AbYI3TkS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 15:40:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753441AbYI3TkE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 15:40:04 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:33459 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753119AbYI3TkC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 15:40:02 -0400
Date: Tue, 30 Sep 2008 14:39:41 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, akpm@linux-foundation.org,
       hch@infradead.org, viro@ZenIV.linux.org.uk,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: unprivileged mounts git tree
Message-ID: <20080930193941.GA2013@us.ibm.com>
References: <20080905153134.GA18367@us.ibm.com> <E1Kd3Mh-0001vk-F5@pomaz-ex.szeredi.hu> <m11vzrge86.fsf@frodo.ebiederm.org> <E1KdnOb-00068L-Eq@pomaz-ex.szeredi.hu> <20080911152033.GA29318@us.ibm.com> <m13ak6ecoi.fsf@frodo.ebiederm.org> <20080912220802.GA23230@us.ibm.com> <m1tzck68od.fsf@frodo.ebiederm.org> <20080914015646.GC18604@us.ibm.com> <m1od2r1l4p.fsf@frodo.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1od2r1l4p.fsf@frodo.ebiederm.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Eric W. Biederman (ebiederm@xmission.com):
> "Serge E. Hallyn" <serue@us.ibm.com> writes:
> 
> >> > So in order for me as an unprivileged user to pin a dentry by mounting
> >> > over it, I have to have write permission to the dentry to begin with
> >> > as well as the dentry being under a user=hallyn mount.
> >> 
> >> That second condition is interesting requiring write permission of the
> >> dentry.  I thought we had obviated the need for that when we added
> >> ownership to the mounts themselves.  In this case at least it shouldn't
> >> it be write permission on the directory containing the dentry.
> >
> > Oh no, it seems I'm wrong, that's not a condition.  Just tested it.
> 
> Ok.  I couldn't find Mikolos's code when I looked quickly.
> What are the current rules?  It sounds like my original example could apply.

Rules according to permit_mount:

	if CAP_SYS_ADMIN, allowed
	if fs type is not marked safe for user mounts (and not bind), -EPERM
	if target is a link, -EPERM
	if target is labeled with new nosubmnt flag, -EPERM
	if target is not a user mount owned by current->uid, -EPERM
	if recursive bind mount, -EPERM (?)

> >> This seems to mess up things like revoke.
> >
> > Hey, do we have revoke now?  :)
> 
> Periodically someone works on revoke ;)
> 
> >> At a practical level it is a real annoyance, regardless of the security
> >> implications.
> >> 
> >> As a point of comparison plan9 does not have that restriction.
> >
> > Why doesn't it have that restriction?  
> 
> I haven't heard the reason.
> 
> > Does it always allow you to rm a mounted-over file?
> 
> Yes.
> 
> The implementation of mounts in plan9 is a bit different.  In
> plan9 mounts are looked up by mount namespace and qid (effectively
> the inode number).  So the semantics are slightly different.
> Requiring a new mount namespace if you want to see what a filesystem
> looks like without a mount on top of a given file.
> 
> It also looks like plan9 is likely to have a unmountable and unusable mount
> if you actually delete an file, from another mount namespace.
> 
> Linux actually has a very similar case where we can loose a mount if you rename
> the directory that contains it to be somewhere higher in the mount hierarchy
> than the location the mount was under.

Can you give an example?

> All of that said there is a very good practical justification for it all.
> In a filesystem where not all changes come through our local VFS the
> VFS cannot prevent changes to a filesystem it can only cache and respond
> to changes that do occur.
> 
> So things like sysfs_rename_dir and sysfs_move_dir routinely bypass
> the VFS restriction against changes happening under mount points.  It
> isn't a problem in practice because people don't mount on sysfs but the
> problem is very much there today.
> 
> It looks to me like the right solution is very much to do the lazy
> unmount we do for expired mounts, and purge everything that happens

You mean if we rm something, do the same thing we do for a lazy umount?

That sounds reasonble, if the implementation is doable.  And should
avoid any potential revoke issues for Pekka.

> and then we just don't have to worry about mounts causing a denial
> of service attack and life gets simpler.
> 
> Rename is a bit trickier than unlink and rmdir in that we should allow

The rename issue here being what you mentioned above about losing a
mount if we mv something to the wrong place?

> it on the underlying filesystem and only remove the directory if the
> rename goes out of scope for the overlying mount.
> 
> Eric
