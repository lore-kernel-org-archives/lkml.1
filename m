Return-Path: <linux-kernel-owner+w=401wt.eu-S1757462AbXI2PWL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757462AbXI2PWL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Sep 2007 11:22:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753878AbXI2PV6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Sep 2007 11:21:58 -0400
Received: from hawking.rebel.net.au ([203.20.69.83]:34660 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753130AbXI2PV5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Sep 2007 11:21:57 -0400
Message-ID: <46FE6D8F.70808@davidnewall.com>
Date: Sun, 30 Sep 2007 00:51:51 +0930
From: David Newall <david@davidnewall.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.2) Gecko/20070221 SeaMonkey/1.1.1
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Chroot bug take 3
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

/.

I hope I haven't crossed the line between determined and annoying.  I 
thought we were done, but now I find meat still on this bone.

Posit a normal process having some filesystem root, and a current 
working directory (pwd) lying within that root subtree.  When chroot is 
performed, pwd is left unchanged.  This means it can (and often will) 
lie outside of the new root.

How much of the filesystem lying outside of root should a process be 
allowed to access?  Currently it is the complete filesystem.

It is perfectly reasonable for a process to execute chroot multiple 
times, each time pruning off access to further parts of the filesystem.  
What is *not reasonable* is chroot unavoidably returning access which 
previously had been dropped.  Similarly, performing fchdir on a 
directory opened prior to chroot should not grant access to more of the 
filesystem than was accessible when the directory was opened.

Although chroot can result in pwd lying outside of the new root, is must 
still lie within some root.  A new quantity, openfdroot, will be 
recorded by chroot, to be used as the limit when walking dotdot outside 
of the current root.

The initial value for openfdroot is the complete filesystem.  After 
completing each chroot, as well as chdir, fchdir and close, openfdroot 
will be set to root iff all open directories and pwd lie within that 
root; otherwise it remains unchanged.

In an ideal world a separate openfdroot would be recorded for each open 
directory, and another for pwd, however this is extreme.  A single value 
permits chroot to perform its fundamental promise, namely to prune the root

The following might replace the last two paragraphs in chroot(2)'s 
description:

    This call does not change the current working directory.  After the
    call, '.' can be outside of path, thus files, accessible to the
    process before the call, remain accessible (via relative pathnames)
    afterwards.  This access is intrinsicly dropped by changing
    directory to within the new root.

    This call does not close open file descriptors, and such descriptors
    may allow access to files outside the chroot tree.  A successful
    open(2) on a directory outside of path yields a descriptor that can
    subsequently be passed to fchdir(2) to escape the new root.  This
    will only provide access to as much of the filesystem as was
    accessable when the directory was opened.  Closing all such files
    (and changing directory to within path) drops this access.

Would there be any point in working up a patch?
