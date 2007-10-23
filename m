Return-Path: <linux-kernel-owner+w=401wt.eu-S1752502AbXJWAsw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752502AbXJWAsw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 20:48:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751146AbXJWAsn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 20:48:43 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:47623 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750715AbXJWAsm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 20:48:42 -0400
Date: Mon, 22 Oct 2007 20:48:04 -0400
Message-Id: <200710230048.l9N0m4di009035@agora.fsl.cs.sunysb.edu>
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
In-reply-to: Your message of "Mon, 22 Oct 2007 09:22:31 BST."
             <20071022082231.GA15132@infradead.org> 
X-MailKey: Erez_Zadok
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

In message <20071022082231.GA15132@infradead.org>, Christoph Hellwig writes:
> On Sun, Oct 21, 2007 at 07:51:14PM -0400, Erez Zadok wrote:
> > From: Andrew Morton <akpm@linux-foundation.org>
> > 
> > ERROR: "security_inode_permission" [fs/unionfs/unionfs.ko] undefined!
> > ERROR: "security_file_ioctl" [fs/unionfs/unionfs.ko] undefined!
> > 
> > Need these back.
> 
> These should never used by modules.

Why?  Are you concerned that the security policy may change after a module
is loaded?  My understanding of the security code is that it should handle
this, even if people call security_*() functions directly.  When I look at
the security_* functions in security.c, to me they very much smell like
global wrappers that others can call, b/c they refer to private/global ops
vectors that one should not be referencing directly.  For example:

int security_file_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
{
	return security_ops->file_ioctl(file, cmd, arg);
}

> You'll need to use and/or introduce
> vfs_ helpers that do proper security checks before calling the methods.

I can probably get rid of having unionfs call security_inode_permission, by
calling permission() myself and carefully post-process its return code
(unionfs needs to "ignore" EROFS initially, to allow copyup to take place).

But security_file_ioctl doesn't have any existing helper I can call.  I can
introduce a trivial vfs_security_file_ioctl wrapper to security_file_ioctl,
but what about the already existing *19* exported security_* functions in
security/security.c?  Do you want to see simple wrappers for all of them?
It seems redundant to add a one-line wrapper around an already one-line
function around security_ops->XXX.  Plus, some of the existing exported
security_* functions are file-system related, others are networking, etc.  So
we'll need wrappers whose names are prefixed appropriately: vfs_*, net_*,
etc.

Thanks,
Erez.
