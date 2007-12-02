Return-Path: <linux-kernel-owner+w=401wt.eu-S1753626AbXLCAf5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753626AbXLCAf5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2007 19:35:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750960AbXLCAfs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Dec 2007 19:35:48 -0500
Received: from cantor2.suse.de ([195.135.220.15]:53533 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750838AbXLCAfr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2007 19:35:47 -0500
Date: Sun, 2 Dec 2007 14:53:20 -0800
From: Greg KH <gregkh@suse.de>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: rae l <crquan@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: Since sysfs_mount is static and used only in sysfs_init
	function, it could be just an automatic variable.
Message-ID: <20071202225320.GA23359@suse.de>
References: <91b13c310712011231k3604214bx3559387c568cce09@mail.gmail.com> <20071202044825.GA7004@suse.de> <91b13c310712012252k5307735x782582fd2d7abd94@mail.gmail.com> <20071202075437.GA19897@suse.de> <m14pf03fex.fsf@ebiederm.dsl.xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m14pf03fex.fsf@ebiederm.dsl.xmission.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 02, 2007 at 03:22:46PM -0700, Eric W. Biederman wrote:
> Greg KH <gregkh@suse.de> writes:
> 
> > On Sun, Dec 02, 2007 at 02:52:17PM +0800, rae l wrote:
> >> On Dec 2, 2007 12:48 PM, Greg KH <gregkh@suse.de> wrote:
> >> ...
> >> > > and where is a detailed explaination on kern_mount? could someone give
> >> > > some comments or documentation pointers on this?
> >> >
> >> > See the patches that Eric Biederman just posted to lkml for why this
> >> > structure is a static pointer this way right now, it's in preparation
> >> > for future patches.
> >> I have checked commit 7d0c7d676cc066413e1583b5af9fba8011972d41 by Eric
> >> W. Biederman,
> >>
> > http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=7d0c7d676cc066413e1583b5af9fba8011972d41
> >> 
> >> which just make sysfs_mount from externally visible to static that
> >> could be only used in one c file,
> >> 
> >> but I mean that the static variable is still on kernel bss section,
> >> this consumes a pointer (4 or 8 bytes) memory,
> >> 
> >> through a grep from fs/sysfs/, it appears that the variable
> >> sysfs_mount is only used in the sysfs_init function,
> >> 
> >> $ grep -RsInw sysfs_mount fs/sysfs/
> >> fs/sysfs/mount.c:25:static struct vfsmount *sysfs_mount;
> >> fs/sysfs/mount.c:101:           sysfs_mount = kern_mount(&sysfs_fs_type);
> >> fs/sysfs/mount.c:102:           if (IS_ERR(sysfs_mount)) {
> >> fs/sysfs/mount.c:104:                   err = PTR_ERR(sysfs_mount);
> >> fs/sysfs/mount.c:105:                   sysfs_mount = NULL;
> >> 
> >> we could mark this variable an automatic one, which scope is just in
> >> this function, thus created and destroyed with the stack,
> >> this approach does not consume a pointer on kernel bss section,
> >> 
> >> Why not do this?
> >
> > Again, see the patches he _just_ posted to lkml, the specific message
> > you are looking for is:
> > 	Message-ID: <m11wa693t0.fsf@ebiederm.dsl.xmission.com>
> > 	Subject: [PATCH 01/10] sysfs: Make sysfs_mount static again.
> >
> > Also see the whole long thread for more details.
> 
> As long as you aren't talking about the subthread that spun off
> about GPL exports, and just the rest of my patches and showing
> where I am going that sounds reasonable.

Yes, that subthread really had nothing to do with your patch series :)

> > If you have further questions about this, please ask Eric.
> 
> Honestly I think there is a reasonable chance we could kill
> sysfs_mount and the kern_mount entirely.  We used to need  the
> internal kernel mount because of the coupling between sysfs_dirent
> and the directory dentries but that is gone now.

Hm, this does take into account the fact that we internally mount sysfs
as part of the boot process to determine the boot disk major:minor,
right?  As long as we don't break that, I'm happy.

thanks,

greg k-h
