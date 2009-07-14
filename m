Return-Path: <linux-kernel-owner+w=401wt.eu-S1754456AbZGNOGO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754456AbZGNOGO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 10:06:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753811AbZGNOGN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 10:06:13 -0400
Received: from msux-gh1-uea01.nsa.gov ([63.239.67.1]:64791 "EHLO
	msux-gh1-uea01.nsa.gov" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753259AbZGNOGM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 10:06:12 -0400
Subject: Re: [PATCH] Security/sysfs: Enable security xattrs to be set on
 sysfs files, directories, and symlinks.
From: "David P. Quigley" <dpquigl@tycho.nsa.gov>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: jmorris@namei.org, gregkh@suse.de, sds@tycho.nsa.gov,
       Casey Schaufler <casey@schaufler-ca.com>, linux-kernel@vger.kernel.org
In-Reply-To: <m1skh0yunm.fsf@fess.ebiederm.org>
References: <1247074106-23405-1-git-send-email-dpquigl@tycho.nsa.gov>
	 <m1r5wmnee0.fsf@fess.ebiederm.org> <1247498399.4398.259.camel@localhost>
	 <m1zlb8a5n5.fsf@fess.ebiederm.org> <1247512705.4398.292.camel@localhost>
	 <m1skh0yunm.fsf@fess.ebiederm.org>
Content-Type: text/plain
Organization: National Security Agency
Date: Tue, 14 Jul 2009 09:55:36 -0400
Message-Id: <1247579736.4398.356.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.2 (2.26.2-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-07-13 at 17:29 -0700, Eric W. Biederman wrote:
> "David P. Quigley" <dpquigl@tycho.nsa.gov> writes:
> 
> > [ Inline Comments...]
> >
> > On Mon, 2009-07-13 at 09:50 -0700, Eric W. Biederman wrote:
> >> Taking the conversation back on the list.
> >> 
> >> "David P. Quigley" <dpquigl@tycho.nsa.gov> writes:
> >> 
> >> > On Sun, 2009-07-12 at 07:51 -0700, Eric W. Biederman wrote:
> >> >> "David P. Quigley" <dpquigl@tycho.nsa.gov> writes:
> >> >> 
[Snip....]
> >
> > Looking at the sysfs code I can see where the inode gets its default
> > values for everything but uid and gid. Are those set somewhere higher up
> > in the vfs on the init_inode path? The approach does seem reasonable but
> > do we want to have to allocate an entire iattr structure inside the
> > sysfs_inode_attr structure you propose just to store the secid? 
> 
> For a non-default secid.   I think so.  I assume we want to track
> when the label was set  and that requires timestamps.
> 
> If wind up allocating a lot of these things perhaps it will make
> sense to do something different.  But I expect the common case will be
> few nodes in sysfs having non-default attributes.

This sounds reasonable to me so I'll rework the patch to do this.

> 
> >> >> > diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
> >> >> > index 2081055..395c36d 100644
> >> >> > --- a/security/selinux/hooks.c
> >> >> > +++ b/security/selinux/hooks.c
> >> >> > @@ -448,6 +448,10 @@ static int sb_finish_set_opts(struct super_block *sb)
> >> >> >  	    sbsec->behavior > ARRAY_SIZE(labeling_behaviors))
> >> >> >  		sbsec->flags &= ~SE_SBLABELSUPP;
> >> >> >  
> >> >> > +	/* Special handling for sysfs. Is genfs but also has setxattr handler*/
> >> >> > +	if (strncmp(sb->s_type->name, "sysfs", sizeof("sysfs")) == 0)
> >> >> > +		sbsec->flags |= SE_SBLABELSUPP;
> >> >> 
> >> >> What is this about?  My impression is that if we have generic xattr
> >> >> handling sysfs is not special so why do we have a special case?
> >> >> 
> >> >> Is this interface appropriate for dealing with xattrs to all
> >> >> linux virtual filesystmes similar to sysfs that do not currently
> >> >> implement xattrs. aka debugfs, proc, etc?
> >> >
> >> > Even though sysfs has a setxattr handler the labeling behavior with
> >> > respect to SELinux needs special handling. The idea here is that by
> >> > default sysfs will be labeled across the board with the same label. The
> >> > reason we can't use a normal style xattr handler here is because there
> >> > is no original backing store to pull the label from. Only after a label
> >> > has been changed is there a semi-persistent value that can be used for
> >> > reinstantiating the inode in the case that it is pruned from the cache.
> >> > Otherwise it falls back to the base genfs labeling of sysfs entries as
> >> > sysfs_t.
> >> 
> >> Sounds like we want a mount option or the like here.  Something explicit
> >> in sysfs not something explicit in the security module.
> >> 
> >> I am also a bit dubious about 
> >
> > I don't think a mount option is the best thing here. Labeling behavior
> > is something that is LSM dependent and even file system dependent within
> > certain LSMs. Since I don't speak for Casey that the way SELinux handles
> > sysfs is the way he want's Smack handling sysfs, and we can't tell what
> > future label based LSMs will do I think leaving it to the module to
> > decide is best.
> 
> Sure the source needs to be the lsm and not user space.  The concept
> however of setting a default at the beginning of time and having no
> special cases beyond that seems reasonable.
> 
> After that beginning of time default you would not need special cases.

So part of the issue here is that the labeling semantics for all file
systems aren't the same. For most in memory file systems we don't have
the need to be able to set the label after creation. For example proc
has all of its entries generated by the kernel and the kernel knows best
for how to label them. There isn't a need for a userspace interface to
change the labels on proc entries. Similarly something like devpts has
its labels set based on the creating process and also the inode can't be
evicted from under it. sysfs does actually seem to be a special case
since we have a mixture of two behaviors. We have the coarse genfs
labeling by default and then we have a situation where virtd needs to
set the label of the resource depending on the context of the qemu
process that will be accessing it.

> 
> >> > Proc also has some special case handling in the SELinux module but I
> >> > haven't had a chance to look at it and try to understand why. I don't
> >> > think that this would be a general purpose solution for all pseudo file
> >> > systems like you mentioned above but it may work for some of them. I'll
> >> > look into them a bit more and then respond about them.
> >> 
> >> Sounds good.  If we are going to expand the LSM it would be good to design
> >> something decent instead of adding a nasty add-hoc case.
> >
> > A quick look over proc and debugfs leads me to believe that a generic
> > mechanism for all of them short of adding generic xattr support to all
> > pseudo file systems would be tricky at best and even more add-hoc than
> > what we already do. There isn't any uniformity in the data structures
> > that are used in these file systems so even if we came up with a lazy
> > update mechanism for these attributes it looks like the implementation
> > would vary greatly depending on the file system. Even then it doesn't
> > change the add-hoc nature of the functionality as we are only trying to
> > handle security attributes. 
> 
> So why should the lsm hooks care.  That is what I am really after.  A
> common set of lsm hooks, and the lsm hooks shouldn't need to see all of
> the data structures for those filesystems.

Well the hooks in this situation don't care. As long as the file system
has a backing data structure to store the secid if/when the inode gets
evicted then it can use the hooks just like sysfs does.

> 
> > The real solution which is a lot of work and I don't exactly know how I
> > would go about putting it together is to try to provide a generic xattr
> > mechanism for pseudo file systems. However I don't have any use cases
> > for the majority of the xattr name spaces. The only thing we have at the
> > moment that needs attention and only on sysfs is the security.* name
> > space. So trying to implement full-blown xattrs on sysfs seems like a
> > bunch of effort with no clear user for it.
> 
> Sort of.  What we are taking about with this patch is generic xattr
> support facing user space and the security modules.  With an optimized
> storage backend, that will only store well know attributes.
> 
> I think it makes sense to talk about a way to keep from growing lsm
> special cases for each new virtual filesystem.  Which means sysfs
> and debugfs at least should share the same lsm hooks.  Ideally 
> sysctl and proc would as well but they have special cases that
> likely would break userspace if we changed things at the moment.

The main issue here is that the reason we have all these tiny file
systems instead of some one creating a generic one a long time ago is
that they all have different semantics. This means there is potential
for the labeling behavior of each one to have different semantics which
means in certain cases there will be special cases. sysfs is one of
these special cases. Looking at it again I think the mechanism is
generalizable to any file system with some sort of backing store but the
fine details will have to be investigated on a per file system basis.

> 
> Eric

