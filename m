Return-Path: <linux-kernel-owner+w=401wt.eu-S937001AbXHHVmJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937001AbXHHVmJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 17:42:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936609AbXHHVl4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 17:41:56 -0400
Received: from ns.suse.de ([195.135.220.2]:39335 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936555AbXHHVlz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 17:41:55 -0400
From: Andreas Gruenbacher <agruen@suse.de>
Organization: SUSE Labs, Novell
To: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC 04/10] Temporary struct vfs_lookup in file_permission
Date: Wed, 8 Aug 2007 23:41:06 +0200
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org, John Johansen <jjohansen@suse.de>,
       Jan Blunck <jblunck@suse.de>, Erez Zadok <ezk@cs.sunysb.edu>,
       "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
References: <20070808171622.632749741@suse.de> <20070808171643.922193525@suse.de> <20070808192558.GA28278@infradead.org>
In-Reply-To: <20070808192558.GA28278@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708082341.06329.agruen@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 08 August 2007 21:25, Christoph Hellwig wrote:
> On Wed, Aug 08, 2007 at 07:16:26PM +0200, Andreas Gruenbacher wrote:
> > Create a temporary struct vfs_lookup in file_permission() instead of
> > passing a NULL value.
> 
> NACK.  file_permission is special in that it doesn't happen in the
> context of any kind of lookup operation, and the nd/intent paramater
> to ->permission should be NULL in that case instead of faking up some crap.

Lookup or not doesn't actually matter. Think of fchdir(2): it does a 
permission check, and it should also pass down the LOOKUP_CHDIR flag. (Yes I 
know, it doesn't do that right now. Bug.) I can't think of a better example 
right now, but the intent does not only make sense in lookup context.

It's true that filesystems should never touch vfsmnts -- except for a few rare 
exceptions. Filesystem stacking is one. NFS silly-rename is another: if the 
vfsmnt of the object being silly-renamed were passed down to the file system, 
we would mntget() it. Right now there is a reference counting bug that allows 
to blow up the kernel by unmounting that mount point before the silly-renamed 
file is closed. (It's client-side only of course, but still.) The vfsmnt that 
this patch passes down in file_permission() is not some crap as you chose to 
call it, it's the appropriate vfsmnt.

Last but not least, file_permission() is a vfs function not a filesystem 
operation. It indirectly calls into security_inode_permission(). We need the 
vfsmnt there for path-based LSMs, for operations like fchmod(2). But that's a 
different set of patches, and a different discussion.

Thanks,
Andreas
