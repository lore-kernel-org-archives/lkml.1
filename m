Return-Path: <linux-kernel-owner+w=401wt.eu-S964952AbXHHRTo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964952AbXHHRTo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 13:19:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935188AbXHHRTE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 13:19:04 -0400
Received: from ns2.suse.de ([195.135.220.15]:37151 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763318AbXHHRTA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 13:19:00 -0400
Message-Id: <20070808171622.632749741@suse.de>
User-Agent: quilt/0.46-1
Date: Wed, 08 Aug 2007 19:16:22 +0200
From: Andreas Gruenbacher <agruen@suse.de>
To: linux-kernel@vger.kernel.org
Cc: John Johansen <jjohansen@suse.de>, Jan Blunck <jblunck@suse.de>,
       Erez Zadok <ezk@cs.sunysb.edu>,
       "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
Subject: [RFC 00/10] Split up struct nameidata (take 3)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

In several places where no nameidata object is available, we are
currently passing NULL instead of constructing a temporary nameidata
object.  This is because struct nameidata is big, and constructing
temporary nameidata objects is not efficient.  Here is another shot at
splitting up struct nameidata: struct vfs_lookup is similar to struct
nameidata but leaves out the fields required only while walking an
actual pathname.  It fits in 24 bytes as opposed to 80 on x86.

This allows to construct temporary vfs_lookup objects where needed
instead of the NULL passing, which gets rid of the associated NULL
checking, and ensures that struct vfsmnt and the lookup intent are
passed down consistently.

In addition, the dentry and vfsmnt in struct vfs_lookup (before: struct
nameidata) are put inside a struct path. This allows to use
path{get,put} instead of mnt{get,put} plus d{get,put}, resulting in more
consistent code. The path{get,put} functions seemingly were suggested by
Erez Zadok / Josef 'Jeff' Sipek; Jan Blunck has been working on this
recently as well.


This proposal consists of the following patches:

nameidata-split.diff

	Introduce struct vfs_lookup and change struct nameidata to
	embed a struct vfs_lookup.  (Requires the next patch to build.)

nameidata-split-2.diff

	Update all nameidata users.

permission-args.diff

	Switch from struct nameidata to struct vfs_lookup in the
	permission inode operation and related functions.

file_permission.diff

	Create a temporary vfs_lookup object in file_permission().

sys_fchdir.diff
do_path_lookup.diff

	Use vfs_permission() instead of file_permission().

create-args.diff

	Switch from struct nameidata to struct vfs_lookup in the
	create inode operation and related functions.

vfs_create-nameidata.diff

	Fix all users of vfs_create() to never pass it a NULL
	vfs_lookup.  Get rid of the NULL checks.

d_revalidate-args.diff

	Switch from struct nameidata to struct vfs_lookup in the
	d_revalidate dentry operation and related functions.

lookup-args.diff

	Switch from struct nameidata to struct vfs_lookup in the
	lookup inode operation and related functions.


Ultimately, it would be nice to get rid of all the NULL nameidata /
vfs_lookup passing, particularly to the permission inode operation. At
that point, permission() could be replaced entirely by vfs_permission().
Other vfs functions like vfs_create() can be cleaned up in a similar
way.


Andreas

