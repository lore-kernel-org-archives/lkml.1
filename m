Return-Path: <linux-kernel-owner+w=401wt.eu-S1753628AbZCZHuj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753628AbZCZHuj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 03:50:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751294AbZCZHua
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 03:50:30 -0400
Received: from ms1.nttdata.co.jp ([163.135.193.232]:35041 "EHLO
	ms1.nttdata.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750911AbZCZHu3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 03:50:29 -0400
X-Greylist: delayed 2132 seconds by postgrey-1.27 at vger.kernel.org; Thu, 26 Mar 2009 03:50:29 EDT
Message-ID: <49CB2B69.7010102@nttdata.co.jp>
Date: Thu, 26 Mar 2009 16:14:49 +0900
From: Kentaro Takeda <takedakn@nttdata.co.jp>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.8.1.21) Gecko/20090302 Thunderbird/2.0.0.21 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: dhowells@redhat.com
CC: penguin-kernel@I-love.SAKURA.ne.jp, haradats@nttdata.co.jp,
       viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org
Subject: Re: Are path-based LSM hooks called from the wrong places?
References: <13750.1237997653@redhat.com>
In-Reply-To: <13750.1237997653@redhat.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 26 Mar 2009 07:14:52.0534 (UTC) FILETIME=[8EB6F960:01C9ADE2]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David,
thanks for your attention. :)

David Howells wrote:
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
Well, my understanding is that your question is related to two aspects of
the new LSM hooks: location and coverage.

(about location)
This patch introduced new LSM hooks outside vfs helper functions because
Al had adviced us that vfs helper functions should remain vfsmount-unaware.

(about coverage)
This patch is not intended to implement the equivalent of security_inode_*
hooks. This patch is for pathname-based MAC, especially for TOMOYO 
in kernel 2.6.30.

> Using sys_mkdir() and suchlike directly from within the kernel would add a lot
> of overhead as I'd have to generate a full pathname for each call, whereas
> vfs_mkdir() or notify_change() allows me to start from an inode I already
> have.
Callers of sys_mkdir() and suchlike directly from within the kernel don't need
to generate a full pathname. Name based LSM will generate a full pathname from
dentry and vfsmount. There is no getname() nor path_walk() call.

Regards,

