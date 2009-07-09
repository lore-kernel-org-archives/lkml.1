Return-Path: <linux-kernel-owner+w=401wt.eu-S1759766AbZGIOuv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759766AbZGIOuv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 10:50:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752189AbZGIOun
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 10:50:43 -0400
Received: from msux-gh1-uea01.nsa.gov ([63.239.67.1]:61433 "EHLO
	msux-gh1-uea01.nsa.gov" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751218AbZGIOum (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 10:50:42 -0400
Subject: Re: [PATCH] Security/sysfs: Enable security xattrs to be set on
 sysfs files, directories, and symlinks.
From: "David P. Quigley" <dpquigl@tycho.nsa.gov>
To: Casey Schaufler <casey@schaufler-ca.com>
Cc: jmorris@namei.org, gregkh@suse.de, sds@tycho.nsa.gov,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
In-Reply-To: <4A554B95.6070709@schaufler-ca.com>
References: <1247074106-23405-1-git-send-email-dpquigl@tycho.nsa.gov>
	 <4A554B95.6070709@schaufler-ca.com>
Content-Type: text/plain
Organization: National Security Agency
Date: Thu, 09 Jul 2009 10:05:06 -0400
Message-Id: <1247148306.4398.157.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.2 (2.26.2-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-07-08 at 18:44 -0700, Casey Schaufler wrote:
> David P. Quigley wrote:
> > This patch adds a setxattr handler to the file, directory, and symlink
> > inode_operations structures for sysfs. This handler uses two new LSM hooks. The
> > first hook takes the xattr name and value and turns the context into a secid.
> > This is embedded into the sysfs_dirent structure so it remains persistent even
> > if the inode structures are evicted from the cache. The second hook allows for
> > the secid to be taken from the sysfs_dirent and be pushed into the inode
> > structure as the actual secid for the inode.
> >   
> 
> Nacked-by: Casey Schaufler <casey@schaufler-ca.com>
> 
> I'm all for sysfs supporting xattrs.
> 
> I am completely opposed to secids as file system metadata.
> 
> What do you get when you do an ls -Z?
> 
> An LSM must not be beholden to exposing transient internal
> representations of security data to userspace, which is what
> you're doing here. An LSM gets to decide what the security
> information it maintains looks like by defining a security blob.
> 
> If you want this in, implement xattrs in sysfs for real. Smack
> depends on the existing, published, and supported xattr interfaces
> for dealing with getting and setting the values. Not secids.
> Smack maintains secids because labeled networking and audit require
> them, and they got there first.
> 
> 

So are you proposing that we embed a variable length string in the
sysfs_dirent structure because that sounds completely silly. It seems
completely reasonable here to take the blob coming in and have the LSM
turn it into a handle that is efficiently referenced by the
sysfs_dirent. The problem here is that sysfs entries have no backing
store at all which means everything we do will have to be added to
sysfs_dirent. I'm pretty sure we don't want to be doing lifecycle
management on strings inside this structure considering the only other
string I see is marked const. If you have a better way of doing this I'm
interested in hearing it but it doesn't seem reasonable to be storing
the xattr itself in the sysfs_dirent. I'd like to hear what Greg thinks
about that.

Dave

