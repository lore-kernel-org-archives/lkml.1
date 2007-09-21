Return-Path: <linux-kernel-owner+w=401wt.eu-S1758015AbXIUMh1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758015AbXIUMh1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 08:37:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751969AbXIUMhO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 08:37:14 -0400
Received: from pat.uio.no ([129.240.10.15]:36490 "EHLO pat.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751822AbXIUMhM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 08:37:12 -0400
Subject: Re: Problem: LTP linkat01 test fails on nfs directory (NFS v3)
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Vitaliy Gusev <vgusev@sw.ru>
Cc: linux-kernel@vger.kernel.org, devel@openvz.org
In-Reply-To: <200709211313.01040.vgusev@sw.ru>
References: <46F1541B.2040800@sw.ru>  <200709211313.01040.vgusev@sw.ru>
Content-Type: text/plain
Date: Fri, 21 Sep 2007 08:37:07 -0400
Message-Id: <1190378227.6680.10.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
X-UiO-Resend: resent
X-UiO-ClamAV-Virus: No
X-UiO-Spam-info: not spam, SpamAssassin (score=-0.0, required=12.0, autolearn=disabled, AWL=-0.027)
X-UiO-Scanned: 7E741E8AA0483094DB0D0CD70A003B5A5C976649
X-UiO-Ratelimit-Test: Ratelimit
X-UiO-SPAM-Test: UIO-RATELIMIT remote_host: 129.240.10.9 spam_score: 0 maxlevel 200 minaction 2 bait 0 mail/h: 1228 total 4031683 max/h 8345 blacklist 0 greylist 0 ratelimit 1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-09-21 at 13:13 +0400, Vitaliy Gusev wrote:
> Hello.
> 
> Tested kernels: 2.6.18, 2.6.22, 2.6.23-rc2
> 
> Steps to reproduce: Suppose that we have mounted some directory from nfs v3 
> server with default options. Also we  have the two directories in this 
> mountpoint and each directory has hard linked file. Try to open those files 
> and write to one and read from another. Data will not be equal. (Testcase: 
> attached hardlink_test.c)

Please retry after re-exporting the filesystem using the highly
recommended "no_subtree_check" option. The default subtree_check option
is broken: it changes the filehandle of the file upon a cross-directory
rename() of that file.

> Analysis: Although these hard linked files have same nfs_fattr::fileid but 
> have different nfs_fh fhandle. In this case nfs_find_actor() function 
> (fs/nfs/inode.c) returns false during opening each file:
> 
> nfs_find_actor()
> {
> ...
> 	if (nfs_compare_fh(NFS_FH(inode), fh))
> 		return 0;
> ...
> }
> 
> Therefore for each of hard links new struct inode is allocated. It leads to 
> cache aliasing.
> 
> Please explain why nfs_find_actor() function compares file handles?

'cos this is the only way to know that two files are the same. fileid is
not always supported by servers: it is an optional NFSv4 attribute, and
on NFSv3, most non-posix filesystems will fake it using something like
iunique().

Comparing filehandles allows you to be certain that two files are the
same if the filehandles are equal. If they are not equal, then that does
not guarantee that the files are different, but then how else are you
going to determine it?

Trond

