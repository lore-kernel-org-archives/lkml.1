Return-Path: <linux-kernel-owner+w=401wt.eu-S1762790AbXGPVX0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762790AbXGPVX0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 17:23:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756906AbXGPVXS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 17:23:18 -0400
Received: from mail4.iitk.ac.in ([203.197.196.4]:59936 "EHLO mail4.iitk.ac.in"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755240AbXGPVXR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 17:23:17 -0400
X-Virus-Scanner: This message was checked by NOD32 Antivirus system
	for Linux Server. For more information on NOD32 Antivirus System,
	please, visit our website: http://www.nod32.com/.
Date: Tue, 17 Jul 2007 03:16:29 +0530 (IST)
From: Satyam Sharma <ssatyam@cse.iitk.ac.in>
To: Al Viro <viro@ftp.linux.org.uk>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ulrich Drepper <drepper@redhat.com>
Subject: Re: [PATCH] utime(s): Honour CAP_FOWNER when times==NULL
In-Reply-To: <20070716204523.GJ21668@ftp.linux.org.uk>
Message-ID: <Pine.LNX.4.64.0707170306200.2005@cselinux1.cse.iitk.ac.in>
References: <20070716185423.1607.78787.sendpatchset@cselinux1.cse.iitk.ac.in>
 <alpine.LFD.0.999.0707161142210.20061@woody.linux-foundation.org>
 <Pine.LNX.4.64.0707170054100.2005@cselinux1.cse.iitk.ac.in>
 <20070716204523.GJ21668@ftp.linux.org.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Jul 2007, Al Viro wrote:
> On Tue, Jul 17, 2007 at 01:00:42AM +0530, Satyam Sharma wrote:
> > > 	if ((current->fsuid != inode->i_uid) && !capable(CAP_FOWNER))
> > > 
> > > test is a rather common test, and in fact, arguably, every time you see 
> > > one part of it, you should probably see the other. Would it make sense to 
> > > make a helper inline function to do this, and replace all users? Doing a
> > > 
> > > 	git grep 'fsuid.*\<i_uid\>'
> > > 
> > > seems to show quite a few cases of this pattern..
> > 
> > Yes, I thought of writing a helper function for this myself. The semantics
> > of CAP_FOWNER sort of justify that, but probably better to get Al's views
> > on this first.
> 
> Helper makes sense (and most of these places will become its call), but...
> E.g. IIRC the change of UID requires CAP_CHOWN; CAP_FOWNER is not enough.
> Ditto for change of GID.  setlease() is using CAP_LEASE and that appears
> to be intentional (no idea what relevant standards say here)...
> 
> I'd suggest converting the obvious cases with new helper and taking the
> rest one-by-one after that.  Some of those might want CAP_FOWNER added,
> some not...

There aren't too many negative results, here's a little audit:

fs/attr.c:32:
fs/attr.c:38:

-> Both are from inode_change_ok(). [ for chown(2) and chgrp(2) ]
-> CAP_FOWNER is not checked for either case, I think it should be.
-> CAP_CHOWN is anyway checked for explicitly later in that condition.

fs/namei.c:186: if (current->fsuid == inode->i_uid)

-> generic_permission().
-> I wonder if CAP_FOWNER processes should ever even be calling into
   this function in the first place (?)
-> So best to keep CAP_FOWNER out of this condition (?)

fs/namei.c:438: if (current->fsuid == inode->i_uid)

-> exec_permission_lite().
-> This is a clone function of the previous one, so again CAP_FOWNER
   out of this (?)

fs/reiserfs/ioctl.c:54:
fs/xattr.c:63:
-> False positives, CAP_FOWNER checked on line below.
-> Helper would help for both cases.

Anwyay, so I'm thinking of adding:

struct inode;

int is_not_owner(struct inode *)
{
	return ((current->fsuid != inode->i_uid) && !capable(CAP_FOWNER));
}

to linux/capability.h inside the __KERNEL__ #ifdef, asm/current.h is
included in there already.

And then do the necessary conversions. Sounds OK?

Satyam
