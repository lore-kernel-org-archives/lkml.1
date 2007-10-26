Return-Path: <linux-kernel-owner+w=401wt.eu-S1764332AbXJZU5T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764332AbXJZU5T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 16:57:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754940AbXJZU5G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 16:57:06 -0400
Received: from styx.suse.cz ([82.119.242.94]:42298 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754901AbXJZU5E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 16:57:04 -0400
Subject: Re: [AppArmor 32/45] Enable LSM hooks to distinguish operations on
	file descriptors from operations on pathnames
From: Miklos Szeredi <mszeredi@suse.cz>
To: Andreas Gruenbacher <agruen@suse.de>
Cc: jjohansen@suse.de, akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org
In-Reply-To: <200710262224.45773.agruen@suse.de>
References: <20071026064024.243943043@suse.de>
	 <20071026064051.393728475@suse.de> <1193398252.4721.7.camel@localhost>
	 <200710262224.45773.agruen@suse.de>
Content-Type: text/plain
Date: Fri, 26 Oct 2007 22:58:11 +0200
Message-Id: <1193432291.4721.27.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-10-26 at 22:24 +0200, Andreas Gruenbacher wrote:
> On Friday 26 October 2007 13:30, Miklos Szeredi wrote:
> > There's a slight problem (other than HCH not liking it) with this
> > approach of passing the open file in iattr:  for special files, the
> > struct file pointer makes no sense to the filesystem, since it is always
> > opened by the generic functions.
> 
> So what do you think where the inodes come from for syscalls like fchmod? Out 
> of struct file, of course. But your f_op->getattr and f_op->setattr patches 
> are meant for passing struct file down to filesystems anyway, so that 
> completely contradicts what you are saying above.

For special files, f_op->fsetattr will be NULL, since
init_special_inode() will set up i_fop that way.

So the filesystem's fsetattr() will only be called for regular files
and/or directories, depending on how it sets up i_fop.

With the ia_file thing, the filesystem would receive the struct file
pointer in all cases.  So the posted patch would break AFS and FUSE,
because they unconditionally use ia_file if available and don't check
the file type.  They could check the file type, but still the interface
would be ugly.

> > So I think the correct solution (which was suggested by Trond and
> > others) is to define an f_op->fsetattr() method, which interested
> > filesystems can define.
> 
> That's nothing but a replacement for ATTR_FILE and iattr->ia_file. Except by 
> removing the ATTR_FILE flag, LSMs will no longer get that information for 
> distinguishing file descriptor operations from other operations.
> 
> AppArmor needs to know when notify_change is called on a file descriptor, but 
> it doesn't care about the file descriptor itself. So any way of passing along 
> that information will be fine.

Ah, so if we kept ATTR_FILE and got rid of iattr_file, would that be OK
for AppArmor? 

Thanks,
Miklos

