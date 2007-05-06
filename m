Return-Path: <linux-kernel-owner+w=401wt.eu-S1753686AbXEFRnY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753686AbXEFRnY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2007 13:43:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754830AbXEFRnX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 May 2007 13:43:23 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:60186 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753686AbXEFRmu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2007 13:42:50 -0400
From: "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, hch@infradead.org,
       akpm@linux-foundation.org, viro@ftp.linux.org.uk,
       Trond.Myklebust@netapp.com, neilb@suse.de, mhalcrow@us.ibm.com
Subject: [PATCH 0/5] [RFC] New path lookup function (V3)
Date: Sun,  6 May 2007 13:41:24 -0400
Message-Id: <1178473289617-git-send-email-jsipek@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.rc1.20.g86b9
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

(For list of changes since V2, see end of this email.)

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

Currently, there is no easy way to pass the LOOKUP_OPEN intent.  The proper
way would be to call open_namei.

We'd like to get comments about what's necessary to make stackable file
systems do lookups right: this includes potential changes to open_namei.

Josef 'Jeff' Sipek.

[1] http://lkml.org/lkml/2007/3/9/95
[2] http://lkml.org/lkml/2007/5/4/51


Changes since V2:

- renamed path_component_lookup to vfs_path_lookup as it allows lookup of
  any path relative to a dentry/vfsmnt (hch)
- kernel doc comment for vfs_path_lookup (hch)
- cleaned up the audit_inode condition (hch)
- rpc_mount should not be dereferenced directly (trond)
- make path_walk static (hch)
- make link_path_walk static (hch)

