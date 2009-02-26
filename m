Return-Path: <linux-kernel-owner+w=401wt.eu-S1755728AbZBZRXb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755728AbZBZRXb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 12:23:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751817AbZBZRXV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 12:23:21 -0500
Received: from mummy.ncsc.mil ([144.51.88.129]:54028 "EHLO mummy.ncsc.mil"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750900AbZBZRXT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 12:23:19 -0500
Subject: Re: [RFC 0/8] Aufs2 documents
From: "David P. Quigley" <dpquigl@tycho.nsa.gov>
To: hooanon05@yahoo.co.jp
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <7390.1235624062@jrobl>
References: <7558.1235374266@jrobl>
	 <1235584254.15148.86.camel@moss-terrapins.epoch.ncsc.mil>
	 <7390.1235624062@jrobl>
Content-Type: text/plain
Organization: National Security Agency
Date: Thu, 26 Feb 2009 12:20:27 -0500
Message-Id: <1235668827.15148.422.camel@moss-terrapins.epoch.ncsc.mil>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.4 (2.24.4-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-02-26 at 13:54 +0900, hooanon05@yahoo.co.jp wrote:
> "David P. Quigley":
> > I think it would be useful to see the source code for AUFS2 posted to
> > LKML. One of the questions I have not which doesn't seem to be addressed
> > in these documents is how robust is your xattr support and are you
> > making the appropriate LSM calls to make this usable with SELinux and
> > Smack. Also from a labeling perspective you have a very interesting
> > question of which label do you select when unifying directories. If you
> > have a/foo and b/foo each with different labels which do you choose.
> > Based on the history of Union type file systems I would suspect the
> > answer is whichever branch is listed first. 
> 
> Aufs doesn't support xattr curretnly because I don't decide how to
> support it yet.
> As far as I know, the implementation of xattr and its key/name pairs are
> filesystem dependent. For instance,
> - there are two branches (rw and ro) in aufs and their filesystem type
>   differs from each other.
> - an application issues getxattr() or listxattr() and makes sure
>   "key.brabra" exists (or set).
> - and then it issues setxattr() for "key.brabra".
> - aufs will copies-up the file and tries setxattr() for the upper one.
> - I am afraid there may happen "key.brabra" is not supported by the
>   upper filesystem and aufs returns an error.
> - from the users' point of view, this behaviour must be very strange.

This is correct. Seeing the xattr then not being able to set it is not
necessarily wrong behavior but if the error returned is along the lines
of key doesn't exist then that can be confusing. For example with
SELinux it is possible to see security.selinux but then to get an
EOPNOTSUPP on trying to set that key on certain file systems. Doing a
quick test on ext3 with setfattr on an xattr that doesn't exist you get
an EOPNOTSUPP back. Considering things such as ACLs and SELinux labels
are stored in xattrs it seems that failing a copyup on EOPNOTSUPP is a
very reasonable thing to do.


> 
> Finally I am considering to make some levels to support xattr.
> - support minimum common set of key only (if such set exists)
>   Here "minimum common set" means a group of key which are surely
>   supported by all filesystems. Aufs will filter-out other keys.
> - create a new internal status flag
>   This flag is set when the type of all branches are same. When the flag
>   is set, aufs will handle xattr by simply redirecting.
> - create a new aufs mount option
>   the option will select two behaviours (above).

So I don't think this is a good way of going about it. The idea of
having some flag which indicates just relay to the lower filesystems if
they are all the same completely ignores that you may have several file
systems which all support the required namespaces. One example I can
think of is a thin client where you get the main image from an NFSv4
server hopefully with the labeled nfs support built in (shameless plug)
so that the security.selinux and security.smack xattrs work properly.
You can then union that with either a persistent file system
(ext{2,3,4}) or a non-persistent one like tmpfs. Both of these support
the security namespace where ext* will store it on disk tmpfs will only
update the incore inode security state. Regardless you have a situation
where it is acceptable to use setxattr on the nfs4, ext*, and tmpfs
branches.

So I think it might be reasonable to say that if you can't copyup the
xattr fail with EOPNOTSUPP and leave it upto the administrator to
configure his system in a way that allows him to copyup files properly.
If he knows he has a store with a lot of user.* xattrs on a read only
branch he should make sure his read write branch supports user xattrs. 

>From a security perspective though there is the question of what label
do you give the file that you just created in the copyup process. If you
have the union of an iso(iso9660_t) and an ext3 file system (possibly
any type) what type do you give the new file. iso9660_t doesn't really
belong on an ext3 file system. You might need to create a new LSM hook
to ask the security module what to label files that are copied up.  

> 
> Unfortunately I could not understand what label means.
> Is it a volume label at mounting like UUID?

Unfortunately label seems to be an overloaded term. I should have used
the term security label. So as of 2.6.30 there will be 3 LSMs in
mainline. Two of which SELinux and Smack are label based MAC
implementations. This means that objects in the system (files, pipes,
symlinks, directories) are assigned a security label. In SELinux this is
a multi-field string which contains a user, role, type, and potentially
a Multi-Level Security component (think Secret, Top Secret). I'm not as
familiar with Smack labels and where they are stored but it also assigns
a security label to objects. SELinux stores these labels in an xattr
which is keyed with security.selinux. Like I mentioned above it is
possible that security.selinux can be persistent like in the case of
ext* or just goes away on unmount like in the case of tmpfs.

If you have more questions about this feel free to ask. I don't have
time to actually do work in this space but I can answer whatever
questions you have.

Dave

