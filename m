Return-Path: <linux-kernel-owner+w=401wt.eu-S1756389AbZDZUD2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756389AbZDZUD2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Apr 2009 16:03:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755281AbZDZUDT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Apr 2009 16:03:19 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35439 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753585AbZDZUDS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Apr 2009 16:03:18 -0400
Date: Sun, 26 Apr 2009 12:58:41 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: "Theodore Ts'o" <tytso@mit.edu>, Jan Kara <jack@suse.cz>
cc: Al Viro <viro@zeniv.linux.org.uk>
Subject: ext3: avoid unnecessary spinlock in critical POSIX ACL path
Message-ID: <alpine.LFD.2.00.0904261234530.7331@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


If a filesystem supports POSIX ACL's, the VFS layer expects the filesystem 
to do POSIX ACL checks on any files not owned by the caller, and it does 
this for every single pathname component that it looks up.

That obviously can be pretty expensive if the filesystem isn't careful 
about it, especially with locking. That's doubly sad, since the common 
case tends to be that there are no ACL's associated with the files in 
question.

ext3 already caches the ACL data so that it doesn't have to look it up 
over and over again, but it does so by taking the inode->i_lock spinlock 
on every lookup. Which is a noticeable overhead even if it's a private 
lock, especially on CPU's where the serialization is expensive (eg Intel 
Netburst aka 'P4').

For the special case of not actually having any ACL's, all that locking is 
unnecessary. Even if somebody else were to be changing the ACL's on 
another CPU, we simply don't care - if we've seen a NULL ACL, we might as 
well use it.

So just load the ACL speculatively without any locking, and if it was 
NULL, just use it. If it's non-NULL (either because we had a cached 
entry, or because the cache hasn't been filled in at all), it means that 
we'll need to get the lock and re-load it properly.

This is noticeable even on Nehalem, which does locking quite well (much 
better than P4). From lmbench:

	Processor, Processes - times in microseconds - smaller is better
	------------------------------------------------------------------------------
	Host                 OS  Mhz null null      open slct sig  sig  fork exec sh  
	                             call  I/O stat clos TCP  inst hndl proc proc proc
	--------- ------------- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----
 - before:
	nehalem.l Linux 2.6.30- 3193 0.04 0.09 0.95 1.45 2.18 0.12 0.81 69.1 273. 1141
	nehalem.l Linux 2.6.30- 3193 0.04 0.09 0.95 1.48 2.28 0.12 0.86 69.9 253. 1140
	nehalem.l Linux 2.6.30- 3193 0.04 0.10 0.95 1.42 2.19 0.12 0.81 68.6 284. 1141
 - after:
	nehalem.l Linux 2.6.30- 3193 0.04 0.09 0.92 1.44 2.12 0.12 0.81 68.3 282. 1094
	nehalem.l Linux 2.6.30- 3193 0.04 0.09 0.92 1.39 2.20 0.12 0.82 67.0 308. 1123
	nehalem.l Linux 2.6.30- 3193 0.04 0.09 0.92 1.39 2.36 0.12 0.81 67.4 293. 1148

where you can see what appears to be a roughly 3% improvement in stat
and open/close latencies from just the removal of the locking overhead. 

Of course, this only matters for files you don't own (the owner never 
needs to do the ACL checks), but that's the common case for libraries, 
header files, and executables. As well as for the base components of any 
absolute pathname, even if you are the owner of the final file.

[ At some point we probably want to move this ACL caching logic entirely
  into the VFS layer (and only call down to the filesystem when
  uncached), but in the meantime this improves ext3 a bit.

  A similar fix to btrfs makes a much bigger difference (15x improvement
  in lmbench) due to broken caching. ]

Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/ext3/acl.c |   13 ++++++++-----
 1 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/fs/ext3/acl.c b/fs/ext3/acl.c
index d81ef2f..e0c7454 100644
--- a/fs/ext3/acl.c
+++ b/fs/ext3/acl.c
@@ -129,12 +129,15 @@ fail:
 static inline struct posix_acl *
 ext3_iget_acl(struct inode *inode, struct posix_acl **i_acl)
 {
-	struct posix_acl *acl = EXT3_ACL_NOT_CACHED;
+	struct posix_acl *acl = ACCESS_ONCE(*i_acl);
 
-	spin_lock(&inode->i_lock);
-	if (*i_acl != EXT3_ACL_NOT_CACHED)
-		acl = posix_acl_dup(*i_acl);
-	spin_unlock(&inode->i_lock);
+	if (acl) {
+		spin_lock(&inode->i_lock);
+		acl = *i_acl;
+		if (acl != EXT3_ACL_NOT_CACHED)
+			acl = posix_acl_dup(acl);
+		spin_unlock(&inode->i_lock);
+	}
 
 	return acl;
 }

