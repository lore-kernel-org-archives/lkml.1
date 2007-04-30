Return-Path: <linux-kernel-owner+w=401wt.eu-S1422889AbXD3D1b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422889AbXD3D1b (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 23:27:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422887AbXD3D1b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 23:27:31 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:53016 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422838AbXD3D13 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 23:27:29 -0400
Date: Sun, 29 Apr 2007 23:26:24 -0400
From: Josef Sipek <jsipek@cs.sunysb.edu>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, hch@infradead.org,
       akpm@linux-foundation.org, viro@ftp.linux.org.uk,
       Trond.Myklebust@netapp.com, mhalcrow@us.ibm.com
Subject: [PATCH 0/1] [RFC] New mode for path_lookup (V1)
Message-ID: <20070430032624.GA32047@filer.fsl.cs.sunysb.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Stackable file systems frequently need to lookup paths or path components
starting from an arbitrary point in the namespace (identified by a dentry
and a vfsmount).  Currently, such file systems use lookup_one_len, which is
frowned upon [1] as it does not pass the lookup intent along; not passing a
lookup intent, for example, can trigger BUG_ON's when stacking on top of
NFSv4.

The following patch introduces a new mode to path_lookup to allow lookup to
start from an arbitrary point in the namespace.  This approach has been
suggested by Christoph Hellwig at the Linux Storage & Filesystem workshop in
February of this year.

One indicates that the lookup should be relative to a dentry-vfsmnt pair by
using the LOOKUP_ONE flag.  For example, the following snippet of code,
looks up "pathcomponent" in a directory pointed to by
parent_{dentry,vfsmnt}:

nd.dentry = parent_dentry;
nd.mnt = parent_vfsmnt;

err = path_lookup("pathcomponent", LOOKUP_ONE, &nd);
if (!err) {
	/* exits */

	...

	/* once done, release the references */
	path_release(&nd);
} else if (err == -ENOENT) {
	/* doesn't exits */
} else {
	/* other error */
}

VFS functions such as lookup_create can be used on the nameidata structure
to pass the create intent to the file system.

Currently, there is no easy way to pass the LOOKUP_OPEN intent.  The proper
way would be to call open_namei.

We'd like to get comments about what's necessary to make stackable file
systems do lookups right - this includes potential changes to open_namei. 

Josef 'Jeff' Sipek.

[1] http://marc.info/?l=linux-kernel&m=117343337823760&w=2
