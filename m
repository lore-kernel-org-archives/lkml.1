Return-Path: <linux-kernel-owner+w=401wt.eu-S1759006AbXEXB7p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759006AbXEXB7p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 21:59:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757595AbXEXB71
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 21:59:27 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:42575 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757490AbXEXB70 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 21:59:26 -0400
From: "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, hch@infradead.org,
       akpm@linux-foundation.org, viro@ftp.linux.org.uk,
       Trond.Myklebust@netapp.com, neilb@suse.de, mhalcrow@us.ibm.com
Subject: [PATCH 0/5] New path lookup function (V4)
Date: Wed, 23 May 2007 21:54:33 -0400
Message-Id: <11799716781687-git-send-email-jsipek@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.rc1.165.gaf9b
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The only change since V3, is the fix for a vfsmount reference leak in the
nfsctl patch (pointed out by hch).

Stackable file systems, among others, frequently need to lookup paths or
path components starting from an arbitrary point in the namespace
(identified by a dentry and a vfsmount).  Currently, such file systems use
lookup_one_len, which is frowned upon [1] as it does not pass the lookup
intent along; not passing a lookup intent, for example, can trigger BUG_ON's
when stacking on top of NFSv4.

The first patch introduces a new lookup function to allow lookup starting
from an arbitrary point in the namespace.  This approach has been suggested
by Christoph Hellwig [2].

The second patch changes sunrpc to use vfs_path_lookup.

The third patch changes nfsctl.c to use vfs_path_lookup.

The fourth patch marks link_path_walk static.

The fifth, and last patch, unexports path_walk because it is no longer
unnecessary to call it directly, and using the new vfs_path_lookup is
cleaner.

For example, the following snippet of code, looks up "some/path/component"
in a directory pointed to by parent_{dentry,vfsmnt}:

err = vfs_path_lookup(parent_dentry, parent_vfsmnt,
		      "some/path/component", 0, &nd);
if (!err) {
	/* exits */

	...

	/* once done, release the references */
	path_release(&nd);
} else if (err == -ENOENT) {
	/* doesn't exist */
} else {
	/* other error */
}

VFS functions such as lookup_create can be used on the nameidata structure
to pass the create intent to the file system.

Josef 'Jeff' Sipek.

[1] http://lkml.org/lkml/2007/3/9/95
[2] http://lkml.org/lkml/2007/5/4/51

