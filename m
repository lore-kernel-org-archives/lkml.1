Return-Path: <linux-kernel-owner+w=401wt.eu-S1758569AbZB0SUf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758569AbZB0SUf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 13:20:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752956AbZB0SUX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 13:20:23 -0500
Received: from mummy.ncsc.mil ([144.51.88.129]:50604 "EHLO mummy.ncsc.mil"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752870AbZB0SUW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 13:20:22 -0500
Subject: Re: [RFC 0/8] Aufs2 documents
From: "David P. Quigley" <dpquigl@tycho.nsa.gov>
To: hooanon05@yahoo.co.jp
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <16503.1235744837@jrobl>
References: <7558.1235374266@jrobl>
	 <1235584254.15148.86.camel@moss-terrapins.epoch.ncsc.mil>
	 <7390.1235624062@jrobl>
	 <1235668827.15148.422.camel@moss-terrapins.epoch.ncsc.mil>
	 <16503.1235744837@jrobl>
Content-Type: text/plain
Organization: National Security Agency
Date: Fri, 27 Feb 2009 13:17:13 -0500
Message-Id: <1235758633.15148.448.camel@moss-terrapins.epoch.ncsc.mil>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.4 (2.24.4-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-02-27 at 23:27 +0900, hooanon05@yahoo.co.jp wrote:
> "David P. Quigley":
> > an EOPNOTSUPP back. Considering things such as ACLs and SELinux labels
> > are stored in xattrs it seems that failing a copyup on EOPNOTSUPP is a
> > very reasonable thing to do.
> 
> Do you mean ... ?
> - if aufs and its lower branch fs support xattr but its upper branch
>   doesn't, then some of copyup will fail.
> - that is user's choice.

I mean that in the event that an xattr can't be copied up to the next
read-write branch the copyup should fail. Otherwise you get the
situation where you can drop very important security information just by
touching a file on a read-only branch. If someone wants to guarantee
that they will always be able to copyup a given xattr it should be their
responsibility to ensure that every file system can handle it.

> 
> 
> > > Finally I am considering to make some levels to support xattr.
> > > - support minimum common set of key only (if such set exists)
> > >   Here "minimum common set" means a group of key which are surely
> > >   supported by all filesystems. Aufs will filter-out other keys.
> > > - create a new internal status flag
> > >   This flag is set when the type of all branches are same. When the flag
> > >   is set, aufs will handle xattr by simply redirecting.
> > > - create a new aufs mount option
> > >   the option will select two behaviours (above).
> > 
> > So I don't think this is a good way of going about it. The idea of
> > having some flag which indicates just relay to the lower filesystems if
> > they are all the same completely ignores that you may have several file
> > systems which all support the required namespaces. One example I can
> 
> When all branch filesystems support the required xattr even if thier
> filesystem-type differ, user can specify the mount option (the thrid
> level above) and all xattr will be handled. When any of xattr are not
> supported by the upper branch fs, then copyup will fail.
> Do I make my clear, or do I misunderstand you?

I can see an "I know better" mount option being useful for this. I
understand what you're trying to do now.

> 
> 
> > If you have more questions about this feel free to ask. I don't have
> > time to actually do work in this space but I can answer whatever
> > questions you have.
> 
> I am afraid I don't fully understand what you wrote.
> According to linux/Documentation/Smack.txt, "xattr support is not
> strictly required". But for selinux (or other security mechanism), xattr
> is neccessary as you wrote.
> Please tell me the url where I should know about security label or
> type. Particulary "iso9660_t" type, I don't know what it is.
> And do you believe the lack of supporting xattr is critical for aufs to
> be merged?

I don't know how many people are interested in using SELinux and Unionfs
so I can't say if it's critical for merging however I think it is
reasonable to expect any new file system to work with the security
mechanisms already in the kernel. Without at least basic xattr support
SELinux will have to fall back on assigning mount wide labels to any
aufs mount even if all the underlying file systems have security labels.

For information on SELinux there are the official papers on nsa.gov but
I also found this reference in a LWN article a while back [1]. It
contains a series of notes that the person took while learning SELinux
and they are well formatted. I haven't ready them all thoroughly but a
quick glance over the initial concepts document seems to be accurate and
what you are looking for.

The point I was trying to make with iso9660_t is that since the xattr
interface is what is used for security labels regardless of whether the
underlying file system actually supports xattrs there are other places
that the security label may come from. Since an iso9660 file system does
not support extended attributes SELinux has a fixed type for all content
on that file system. When someone asks for security.selinux on an
iso9660 file system it goes to the inode, takes the security context in
there, and converts it into the string you see even though there is no
real xattr support.


[1]http://equivocation.org/selinux

Dave

