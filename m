Return-Path: <linux-kernel-owner+w=401wt.eu-S1759077AbZCZPyS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759077AbZCZPyS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 11:54:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756414AbZCZPyH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 11:54:07 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:56864 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752532AbZCZPyG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 11:54:06 -0400
Date: Thu, 26 Mar 2009 15:53:57 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: David Howells <dhowells@redhat.com>
Cc: Kentaro Takeda <takedakn@nttdata.co.jp>,
       Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
       Toshiharu Harada <haradats@nttdata.co.jp>, linux-kernel@vger.kernel.org
Subject: Re: Are path-based LSM hooks called from the wrong places?
Message-ID: <20090326155357.GS28946@ZenIV.linux.org.uk>
References: <13750.1237997653@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <13750.1237997653@redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 25, 2009 at 04:14:13PM +0000, David Howells wrote:
> 
> Hi Kentaro,
> 
> I've just been looking at some of the VFS syscall routines, such as
> notify_change(), with an eye to calling it from FS-Cache to grow a file.  I
> see that whilst notify_change() calls the inode-based LSM hooks (as drive
> SELinux), it doesn't call the path-based LSM hooks (as drive other security
> modules).  It leaves that to the callers, such as do_sys_ftruncate().
> 
> I see that vfs_mkdir(), for example, is similar, in that vfs_mkdir() - which
> I'm calling from FS-Cache - invokes the inode-based LSM hooks, but it bypasses
> the path-based LSM hooks as those are called from sys_mkdir().
> 
> It would appear that path-based LSM hooks may well be being called from the
> wrong places.  They were added in:
> 
> 	commit be6d3e56a6b9b3a4ee44a0685e39e595073c6f0d
> 	Author: Kentaro Takeda <takedakn@nttdata.co.jp>
> 	Date:   Wed Dec 17 13:24:15 2008 +0900
> 
> 	    introduce new LSM hooks where vfsmount is available.
> 
> 	    Add new LSM hooks for path-based checks.  Call them on directory-modifying
> 	    operations at the points where we still know the vfsmount involved.
> 
> 	    Signed-off-by: Kentaro Takeda <takedakn@nttdata.co.jp>
> 	    Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> 	    Signed-off-by: Toshiharu Harada <haradats@nttdata.co.jp>
> 	    Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
> 
> Using sys_mkdir() and suchlike directly from within the kernel would add a lot
> of overhead as I'd have to generate a full pathname for each call, whereas
> vfs_mkdir() or notify_change() allows me to start from an inode I already
> have.

If you start from inode (or dentry, for that matter), you don't *have*
a pathname at all.  The real question is, do you want these checks to
apply and if you do - which path do you want to use (esp. if you have
multiple namespaces)?
