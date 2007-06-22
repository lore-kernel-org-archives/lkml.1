Return-Path: <linux-kernel-owner+w=401wt.eu-S1754741AbXFVGrU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754741AbXFVGrU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 02:47:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751772AbXFVGrK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 02:47:10 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:47683 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751219AbXFVGrH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 02:47:07 -0400
Subject: Re: Adding subroot information to /proc/mounts, or obtaining that
	through other means
From: Ram Pai <linuxram@us.ibm.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Al Viro <viro@ftp.linux.org.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org, util-linux-ng@vger.kernel.org
In-Reply-To: <467AB5EE.3030909@zytor.com>
References: <467994BD.6000403@zytor.com>
	 <20070620210343.GQ21478@ftp.linux.org.uk>  <46799A31.10301@zytor.com>
	 <1182442837.3342.13.camel@ram.us.ibm.com>  <467AB5EE.3030909@zytor.com>
Content-Type: text/plain
Date: Thu, 21 Jun 2007 23:44:14 -0700
Message-Id: <1182494654.2812.22.camel@ram.us.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-7.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-06-21 at 10:31 -0700, H. Peter Anvin wrote:
> Ram Pai wrote:
> > 
> > Peter, I am not working on it currently. But i am interested in getting
> > it done. I have the seed set of patches which had Al Viro's ideas
> > incorporated. Infact those patches were sent on lkml 2 months back.
> > Shall we start with those patches?
> > 
> 
> Okay, so what I see in your patches are:
> 
> > > path-from-root: mount point of the mount from /
> > > path-from-root-of-its-sb: path from its own root dentry.
> > > propagation-flag: SHARED, SLAVE, UNBINDABLE, PRIVATE
> > > peer-mount-id: the mount-id of its peer mount (if this mount is shared)
> > > master-mount-id: the mount-id of its master mount (if this mount is
> slave)
> 
> Other than cosmetic, I don't see anything terribly wrong with this,
> although getting a flag when the directory is overmounted would be nice.
> 
> I guess I suggest a single comma-separated field with flags and optional
> ":argument":
> 
> 	private
> 	shared:<peer>
> 	slave:<master>
> 	unbindable
> 	overmounted
> 
> So we could end up with something like:
> 
> rootfs / rootfs rw 0 0 0:1 / 1 private,overmounted
> 
> ... where 1 is the mnt_id (sequence number).
> 
> [Please see my other comments in this thread... basically I believe we
> should just add fields to /proc/mounts.]

I had two patches. The first patch added a new interface
called /proc/mounts_new  and had the following format.

FSID  mntpt  root-dentry  fstype fs-options

where FSID is a filesystem unique id
mntpt is the path to the mountpoint
root-dentry is the path to the dentry with respect to the root dentry of
the same filesystem.
fstype  is the filesystem type
fs-options  the mount options used.


the second patch made a /proc/propagation interface which had almost the
same fields, but also added fields to show the propagation type of the
mount as well as pointers to its peers and master depending on the type
of the mount. 

I think the consensus seems to have a new interface /proc/make-a-name
which extends the interface provided by /proc/mounts but provides the
propagation state of the mounts too as well as disambiguate bind mounts.
Which makes sense.

Why not have something like this?

mnt-id FSID backing-dev mntpt root-dentry fstype
comma-separated-fs-options

and one of the fields in the comma-separated-fs-options indicates the
propagation type of the mount.


BTW: what is the need for overmounted flag?  Do you mean two vfsmounts
mounted on the same dentry on the ***same vfsmount*** ?


RP










> 
> 	-hpa

