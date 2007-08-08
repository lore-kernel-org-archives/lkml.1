Return-Path: <linux-kernel-owner+w=401wt.eu-S934626AbXHHXYX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934626AbXHHXYX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 19:24:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761094AbXHHXYN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 19:24:13 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:35238 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760672AbXHHXYL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 19:24:11 -0400
Date: Thu, 9 Aug 2007 00:24:10 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Andreas Gruenbacher <agruen@suse.de>
Cc: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
       John Johansen <jjohansen@suse.de>, Jan Blunck <jblunck@suse.de>,
       Erez Zadok <ezk@cs.sunysb.edu>,
       "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
Subject: Re: [RFC 04/10] Temporary struct vfs_lookup in file_permission
Message-ID: <20070808232409.GA7876@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Andreas Gruenbacher <agruen@suse.de>, linux-kernel@vger.kernel.org,
	John Johansen <jjohansen@suse.de>, Jan Blunck <jblunck@suse.de>,
	Erez Zadok <ezk@cs.sunysb.edu>,
	Josef 'Jeff' Sipek <jsipek@cs.sunysb.edu>
References: <20070808171622.632749741@suse.de> <20070808171643.922193525@suse.de> <20070808192558.GA28278@infradead.org> <200708082341.06329.agruen@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200708082341.06329.agruen@suse.de>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 08, 2007 at 11:41:06PM +0200, Andreas Gruenbacher wrote:
> Lookup or not doesn't actually matter. Think of fchdir(2): it does a 
> permission check, and it should also pass down the LOOKUP_CHDIR flag.

fchdir per defintion doesn't do any lookup, and it should not pretend to be
doing one.

> It's true that filesystems should never touch vfsmnts -- except for a few rare 
> exceptions. Filesystem stacking is one. NFS silly-rename is another: if the 
> vfsmnt of the object being silly-renamed were passed down to the file system, 
> we would mntget() it. Right now there is a reference counting bug that allows 
> to blow up the kernel by unmounting that mount point before the silly-renamed 
> file is closed. (It's client-side only of course, but still.)

Wrong. Remember what we call unmount is two underlying operations:

 - detach the subtree from the namespace, this is the vfsmount-based operation.
   this one couldn't care less about an in-progress silly-rename
 - actually teard down the filesystem.  this is a superblock-related
   operation, and you want your reference counting for the above case
   to be on the superblock level if at all.  A good explanation of
   the bug you're seeing and how you intend to fix it outside of this
   slightly heated thread might help, though..

Remember that passing down the vfsmount to the filesystem for namespace
operations is actually harmful, because all the namespace operations must
operate independent of the actual view (aka vfsmount) it's coming from - 
all vfsmounts shared a single dentry subtree and operation on either of
them must give the same results.

> The vfsmnt that 
> this patch passes down in file_permission() is not some crap as you chose to 
> call it, it's the appropriate vfsmnt.

No, it's wrong.  There is no path except for informal purposes attached to
a struct file.  I created file_permission to document that clearly and
people don't try things like this.  There's lots of chances where fs passing
has happened, were into a lazily detached tree, after a pviot_root, etc where
trying to do anything that remotely looks like pathname based operation just
doesn't make any sense in this case.

