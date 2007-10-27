Return-Path: <linux-kernel-owner+w=401wt.eu-S1753432AbXJ0XCQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753432AbXJ0XCQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2007 19:02:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751390AbXJ0XB6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Oct 2007 19:01:58 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:36519 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751388AbXJ0XB4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2007 19:01:56 -0400
Date: Sat, 27 Oct 2007 19:01:20 -0400
Message-Id: <200710272301.l9RN1K40022960@agora.fsl.cs.sunysb.edu>
From: Erez Zadok <ezk@cs.sunysb.edu>
To: Christoph Hellwig <hch@infradead.org>
Cc: Erez Zadok <ezk@cs.sunysb.edu>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       viro@ftp.linux.org.uk, "Serge E. Hallyn" <serue@us.ibm.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Chris Wright <chrisw@sous-sol.org>, James Morris <jmorris@namei.org>,
       Stephen Smalley <sds@tycho.nsa.gov>,
       "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
Subject: Re: [PATCH 1/9] Unionfs: security convert lsm into a static interface fix 
In-reply-to: Your message of "Tue, 23 Oct 2007 10:07:39 BST."
             <20071023090739.GA19758@infradead.org> 
X-MailKey: Erez_Zadok
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

In message <20071023090739.GA19758@infradead.org>, Christoph Hellwig writes:
> On Mon, Oct 22, 2007 at 08:48:04PM -0400, Erez Zadok wrote:
> > Why?  Are you concerned that the security policy may change after a module
> > is loaded?
> 
> No, it's a matter of proper layering.  We generally don't want modules
> like stackabke filesystems to call directly into methods but rather use
> proper highlevel VFS helpers to isolate them from details and possible
> changes.  The move to out of line security_ helpers just put this on the
> radard.

OK, I'll be shortly posting a couple of patches to fs/ioctl.c.

> > I can probably get rid of having unionfs call security_inode_permission,
> > by calling permission() myself and carefully post-process its return
> > code (unionfs needs to "ignore" EROFS initially, to allow copyup to take
> > place).
> 
> Sounds fine.

I was able to test this idea and it works fine.  Now unionfs calls
permission(), post-processes the return value, and I don't need my own
modified version of permission() in unionfs.  This saved me ~50 LoC and
reduced stack pressure a little.

> > But security_file_ioctl doesn't have any existing helper I can call.  I
> > can introduce a trivial vfs_security_file_ioctl wrapper to
> > security_file_ioctl, but what about the already existing *19* exported
> > security_* functions in security/security.c?  Do you want to see simple
> > wrappers for all of them?  It seems redundant to add a one-line wrapper
> > around an already one-line function around security_ops->XXX.  Plus,
> > some of the existing exported security_* functions are file-system
> > related, others are networking, etc.  So we'll need wrappers whose names
> > are prefixed appropriately: vfs_*, net_*, etc.
> 
> The fix for security_file_ioctl is probably to either not do it at all
> or move it the call to security_file_ioctl into vfs_ioctl and get it by
> using that helper.  I suspect most other security_ exports should be
> avoided similarly.

Christoph, I looked more closely at that and the selinux code.  Only
sys_ioctl calls security_file_ioctl.  And security_file_ioctl performs all
sorts of checks that mostly have to do with the currently running task or
the open file.  The running task is still the same, whether filesystem
stacking is involved or not.  Also, the unionfs-level struct file is
logically the same file at the lower level: they refer to the same object,
just at two layers.  I can't see any reason why unionfs_ioctl should have to
call security_file_ioctl(lower_file) the way sys_ioctl does: that check is
already done well before the file system's ->ioctl is invoked.  I also don't
see how it would ever be possible that sys_ioctl will succeed in its call to
security_file_ioctl(upper_file), but unionfs will fail the same security
check on the lower file.

So I commented out unionfs's call to security_file_ioctl(lower_file) and
tested it on a bunch of things, including an selinux-enabled livecd.
Everything seemed to work just fine, so I'll be sending some patches to that
effect, and we can drop the -mm patch which exports security_file_ioctl().
BTW, ecryptfs doesn't call security_file_ioctl().

Cheers,
Erez.
