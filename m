Return-Path: <linux-kernel-owner+w=401wt.eu-S1031195AbXDQQ6K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031195AbXDQQ6K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 12:58:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031197AbXDQQ6J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 12:58:09 -0400
Received: from cs.columbia.edu ([128.59.16.20]:47481 "EHLO cs.columbia.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031195AbXDQQ6H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 12:58:07 -0400
Message-ID: <4624FC38.6040503@cs.columbia.edu>
Date: Tue, 17 Apr 2007 12:56:24 -0400
From: Shaya Potter <spotter@cs.columbia.edu>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: bharata@linux.vnet.ibm.com
CC: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Jan Blunck <j.blunck@tu-harburg.de>
Subject: Re: [RFC][PATCH  0/15] VFS based Union Mount
References: <20070417131459.GA4001@in.ibm.com> <4624DB46.6040400@cs.columbia.edu> <20070417163055.GA11318@in.ibm.com>
In-Reply-To: <20070417163055.GA11318@in.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Bharata B Rao wrote:

> No. foo is not visible. While looking for a file in a union mounted
> directory, the lookup starts from the topmost directory and proceeds
> downwards if the file isn't present the top layers. If a whiteout is
> found in any of the top layers, the lookup is abondoned and -ENOENT
> is removed. Thus until a whiteout exists in any upper layer for
> a corresponding file in the lower layer, the lower layer file remains
> hidden until the whiteout is removed.
> 
> However in the case of dir-c containing foo, the foo(from dir-c) will become
> visible after union mounting dir-c on top of dir-b and dir-a.

ok, so the major limitation of this approach is that the top most layer 
has to either be, ext2, ext3 or tmpfs (in patch), and most likely not 
NFS (assumption is that NFS has no conception of the whiteout type of 
file).  One thing the unionfs people are doing w/ their ODF approach, is 
within the ODF fs, they have a special inode that is the "whiteout" 
inode, and when they create a whiteout, they just create a hardlink from 
the dentry they want to whiteout to the "whiteout inode".  could that be 
a worthwhile approach instead of the whiteout file type?  (i.e. many 
file systems support the concept of a hard link).

I ask, because using union in a diskless environment.  Imagine pxe 
booting a kernel/initramfs and then using union to create a real root fs 
  (shared lower layer, private rw upper layer, ala live cds).  Which 
brings up a different point, with unionfs, one can pivot_root into it, 
can one do the same for these "union mounts"?  Don't know enough about 
the VFS to know if this should "just work" or might be a problem.
