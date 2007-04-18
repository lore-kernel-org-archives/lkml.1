Return-Path: <linux-kernel-owner+w=401wt.eu-S932764AbXDRHMd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932764AbXDRHMd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 03:12:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932771AbXDRHMc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 03:12:32 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:44115 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932750AbXDRHMb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 03:12:31 -0400
Date: Wed, 18 Apr 2007 12:49:47 +0530
From: Bharata B Rao <bharata@linux.vnet.ibm.com>
To: Shaya Potter <spotter@cs.columbia.edu>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Jan Blunck <j.blunck@tu-harburg.de>
Subject: Re: [RFC][PATCH  0/15] VFS based Union Mount
Message-ID: <20070418071947.GC5870@in.ibm.com>
Reply-To: bharata@linux.vnet.ibm.com
References: <20070417131459.GA4001@in.ibm.com> <4624DB46.6040400@cs.columbia.edu> <20070417163055.GA11318@in.ibm.com> <4624FC38.6040503@cs.columbia.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4624FC38.6040503@cs.columbia.edu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 17, 2007 at 12:56:24PM -0400, Shaya Potter wrote:
> Bharata B Rao wrote:
> 
> >No. foo is not visible. While looking for a file in a union mounted
> >directory, the lookup starts from the topmost directory and proceeds
> >downwards if the file isn't present the top layers. If a whiteout is
> >found in any of the top layers, the lookup is abondoned and -ENOENT
> >is removed. Thus until a whiteout exists in any upper layer for
> >a corresponding file in the lower layer, the lower layer file remains
> >hidden until the whiteout is removed.
> >
> >However in the case of dir-c containing foo, the foo(from dir-c) will 
> >become
> >visible after union mounting dir-c on top of dir-b and dir-a.
> 
> ok, so the major limitation of this approach is that the top most layer 
> has to either be, ext2, ext3 or tmpfs (in patch), and most likely not 
> NFS (assumption is that NFS has no conception of the whiteout type of 
> file).

I haven't played with union mounts with NFS. Hence would let Jan answer
this. However note that union mount provides a writable union only
if the filesystem supports the notion of whiteouts.

> One thing the unionfs people are doing w/ their ODF approach, is 
> within the ODF fs, they have a special inode that is the "whiteout" 
> inode, and when they create a whiteout, they just create a hardlink from 
> the dentry they want to whiteout to the "whiteout inode".  could that be 
> a worthwhile approach instead of the whiteout file type?  (i.e. many 
> file systems support the concept of a hard link).

We we thinking something on similar lines as noted in our documentation.
Right now we maintain one inode for every whiteout. We were planning to
have a single whiteout inode and have all whiteout dentries point to this.
But here again we were thinking of having every filesystem support
this whiteout inode type.

Anyway I will have a look at ODF from unionfs to see how this is done.

>
> I ask, because using union in a diskless environment.  Imagine pxe 
> booting a kernel/initramfs and then using union to create a real root fs 
>  (shared lower layer, private rw upper layer, ala live cds).  Which 
> brings up a different point, with unionfs, one can pivot_root into it, 
> can one do the same for these "union mounts"?  Don't know enough about 
> the VFS to know if this should "just work" or might be a problem.

I would assume that it should 'just work'. But right now it is not working.
Our code is not yet ready to correctly work with move mounts. Since pivot_root
has semantics similar to move mounts, pivot_root is also not working. Also
chroot to a union mount point is also not working atm. We will be working
to get all these right.

Regards,
Bharata.
