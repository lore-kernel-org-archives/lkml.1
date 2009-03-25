Return-Path: <linux-kernel-owner+w=401wt.eu-S1753094AbZCYQOf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753094AbZCYQOf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 12:14:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755043AbZCYQOX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 12:14:23 -0400
Received: from mx2.redhat.com ([66.187.237.31]:49656 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751014AbZCYQOW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 12:14:22 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
To: Kentaro Takeda <takedakn@nttdata.co.jp>,
       Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
       Toshiharu Harada <haradats@nttdata.co.jp>,
       Al Viro <viro@zeniv.linux.org.uk>
cc: dhowells@redhat.com, linux-kernel@vger.kernel.org
Subject: Are path-based LSM hooks called from the wrong places?
Date: Wed, 25 Mar 2009 16:14:13 +0000
Message-ID: <13750.1237997653@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Kentaro,

I've just been looking at some of the VFS syscall routines, such as
notify_change(), with an eye to calling it from FS-Cache to grow a file.  I
see that whilst notify_change() calls the inode-based LSM hooks (as drive
SELinux), it doesn't call the path-based LSM hooks (as drive other security
modules).  It leaves that to the callers, such as do_sys_ftruncate().

I see that vfs_mkdir(), for example, is similar, in that vfs_mkdir() - which
I'm calling from FS-Cache - invokes the inode-based LSM hooks, but it bypasses
the path-based LSM hooks as those are called from sys_mkdir().

It would appear that path-based LSM hooks may well be being called from the
wrong places.  They were added in:

	commit be6d3e56a6b9b3a4ee44a0685e39e595073c6f0d
	Author: Kentaro Takeda <takedakn@nttdata.co.jp>
	Date:   Wed Dec 17 13:24:15 2008 +0900

	    introduce new LSM hooks where vfsmount is available.

	    Add new LSM hooks for path-based checks.  Call them on directory-modifying
	    operations at the points where we still know the vfsmount involved.

	    Signed-off-by: Kentaro Takeda <takedakn@nttdata.co.jp>
	    Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
	    Signed-off-by: Toshiharu Harada <haradats@nttdata.co.jp>
	    Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

Using sys_mkdir() and suchlike directly from within the kernel would add a lot
of overhead as I'd have to generate a full pathname for each call, whereas
vfs_mkdir() or notify_change() allows me to start from an inode I already
have.

David
