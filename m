Return-Path: <linux-kernel-owner+w=401wt.eu-S1761308AbZGIPFe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761308AbZGIPFe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 11:05:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760705AbZGIPFT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 11:05:19 -0400
Received: from msux-gh1-uea02.nsa.gov ([63.239.67.2]:55794 "EHLO
	msux-gh1-uea02.nsa.gov" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760261AbZGIPFS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 11:05:18 -0400
Subject: Re: [PATCH] Security/sysfs: Enable security xattrs to be set on
 sysfs files, directories, and symlinks.
From: "David P. Quigley" <dpquigl@tycho.nsa.gov>
To: Casey Schaufler <casey@schaufler-ca.com>
Cc: jmorris@namei.org, gregkh@suse.de, sds@tycho.nsa.gov,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
In-Reply-To: <4A560363.6050304@schaufler-ca.com>
References: <1247074106-23405-1-git-send-email-dpquigl@tycho.nsa.gov>
	 <4A554B95.6070709@schaufler-ca.com> <1247148306.4398.157.camel@localhost>
	 <4A560363.6050304@schaufler-ca.com>
Content-Type: text/plain
Organization: National Security Agency
Date: Thu, 09 Jul 2009 10:56:06 -0400
Message-Id: <1247151366.4398.171.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.2 (2.26.2-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-07-09 at 07:49 -0700, Casey Schaufler wrote:
> David P. Quigley wrote:
> > On Wed, 2009-07-08 at 18:44 -0700, Casey Schaufler wrote:
> >   
> >> David P. Quigley wrote:
> >>     
> >>> This patch adds a setxattr handler to the file, directory, and symlink
> >>> inode_operations structures for sysfs. This handler uses two new LSM hooks. The
> >>> first hook takes the xattr name and value and turns the context into a secid.
> >>> This is embedded into the sysfs_dirent structure so it remains persistent even
> >>> if the inode structures are evicted from the cache. The second hook allows for
> >>> the secid to be taken from the sysfs_dirent and be pushed into the inode
> >>> structure as the actual secid for the inode.
> >>>   
> >>>       
> >> Nacked-by: Casey Schaufler <casey@schaufler-ca.com>
> >>
> >> I'm all for sysfs supporting xattrs.
> >>
> >> I am completely opposed to secids as file system metadata.
> >>
> >> What do you get when you do an ls -Z?
> >>
> >> An LSM must not be beholden to exposing transient internal
> >> representations of security data to userspace, which is what
> >> you're doing here. An LSM gets to decide what the security
> >> information it maintains looks like by defining a security blob.
> >>
> >> If you want this in, implement xattrs in sysfs for real. Smack
> >> depends on the existing, published, and supported xattr interfaces
> >> for dealing with getting and setting the values. Not secids.
> >> Smack maintains secids because labeled networking and audit require
> >> them, and they got there first.
> >>
> >>
> >>     
> >
> > So are you proposing that we embed a variable length string in the
> > sysfs_dirent structure because that sounds completely silly. 
> 
> No, I'm not proposing that because it sounds silly, I'm proposing it
> because that's the way xattrs work on Linux.
> 
> > It seems
> > completely reasonable here to take the blob coming in and have the LSM
> > turn it into a handle that is efficiently referenced by the
> > sysfs_dirent. The problem here is that sysfs entries have no backing
> > store at all which means everything we do will have to be added to
> > sysfs_dirent. I'm pretty sure we don't want to be doing lifecycle
> > management on strings inside this structure considering the only other
> > string I see is marked const. If you have a better way of doing this I'm
> > interested in hearing it but it doesn't seem reasonable to be storing
> > the xattr itself in the sysfs_dirent.
> 
> Smack depends on the xattr interfaces to inspect and manipulate labels
> on file system objects. Now you have a file system that "supports"
> xattrs, but not the xattr interfaces. What if I want to change the
> label on a sysfs entry? Or even read it? I can't with your scheme.
> 
> You are proposing a one-off hack to solve a particular problem. It
> introduces issues of its own. I don't care that it is clever and
> compact. It's not right.
> 

Why can't you use that? I used the set and get xattr interfaces to test
the code and it worked just fine. I agree with you that generic xattr
support for all pseudo file systems would be great but we don't see a
usecase for xattr support on sysfs other than in the security namespace.
Now we have a file system here that is not persistent across reboots and
we may only have one LSM active at a given time. You can try to have an
xattr table embedded into the sysfs_dirent structure but it is counter
the problem that is trying to be solved. The reason why we can't just
use the inode for the entry to begin with is that under memory pressure
those inodes can and will be evicted. Given that adding a method that
with the potential to add lots of memory pressure to the system seems
counterproductive. Remember those sysfs_dirent entries have to exist for
the lifetime of the sysfs filesystem. This means that you have the
potential for full page size attributes to be in each and every
sysfs_dirent structure.

The solution we have here says you specify and retrieve the security
blob using the normal xattr format but internally for memory reasons the
LSM is expected to map that blob to a unique identifier which is stored
in the sysfs_dirent. In the case of Smack this is practically a null
translation since your secid is the pointer to your actual label. In
SELinux the initial translation (luckily only done once) is a little
heavy weight but refreshing the inode after that is not. This mapping
can be transient because these xattrs are not persistent and neither is
the file system they are on.

Dave

