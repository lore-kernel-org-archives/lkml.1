Return-Path: <linux-kernel-owner+w=401wt.eu-S1753949AbZKWRlk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753949AbZKWRlk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 12:41:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753860AbZKWRlj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 12:41:39 -0500
Received: from mx1.redhat.com ([209.132.183.28]:9416 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753783AbZKWRli (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 12:41:38 -0500
From: Jeff Layton <jlayton@redhat.com>
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: ebiederm@xmission.com, pavel@ucw.cz, miklos@szeredi.hu,
       viro@ZenIV.linux.org.uk
Subject: [PATCH 0/3] vfs: plug some holes involving LAST_BIND symlinks and file bind mounts (try #5)
Date: Mon, 23 Nov 2009 12:41:21 -0500
Message-Id: <1258998084-26797-1-git-send-email-jlayton@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are a few situations where a lookup can end up returning a dentry
without revalidating it, and without checking whether the calling
process has permissions to access it. Two situations identified so far
are:

1) LAST_BIND symlinks (such as those under /proc/<pid>)

2) file bind mounts

This patchset is intended to fix this by forcing revalidation of the
returned dentries at appropriate locations.

In the case of LAST_BIND symlinks it also adds a check to verify that
the target of the symlink is accessible by the current process by
walking mounts and dentries back up to the root and checking permission
on each inode.

This set fixes the reproducers I have (including the reproducer that
Pavel provided for the permissions bypass). It's still pretty rough
though and I expect that it'll need revision. At this point, I'm mainly
looking to get these questions answered:

1) what should we do if these dentries are found to be invalid? Is it ok
to d_invalidate them? Or is that likely to break something (particularly
in the case of file bind mounts)?

2) I'm using FS_REVAL_DOT as an indicator of whether to force a
d_revalidate. I think that it's appropriate to key off of that flag, but
we may want to rename it (maybe FS_FORCE_D_REVAL ?).

3) is check_path_accessible racy? It seems to work, but something
doesn't seem quite right with this approach. Is this defeatable somehow?
Could a rename of one of the intermediate path components cause
problems?

4) do we need to hold the dcache_lock across the check_path_accessible
call?

This isn't my usual area of expertise, so I'm definitely open to
suggestions on this.

Jeff Layton (3):
  vfs: force reval of target when following LAST_BIND symlinks
  vfs: force reval on dentry of bind mounted files on FS_REVAL_DOT
    filesystems
  vfs: check path permissions on target of LAST_BIND symlinks

 fs/namei.c |  104 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 102 insertions(+), 2 deletions(-)

