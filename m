Return-Path: <linux-kernel-owner+w=401wt.eu-S1765067AbYD1G1e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765067AbYD1G1e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 02:27:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753858AbYD1G1Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 02:27:24 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:34574 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752418AbYD1G1X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 02:27:23 -0400
X-Sasl-enc: U7k+sZOEulxMB9ymVuShrROt+EK80SxGzGoLY0zliQk5 1209364041
Date: Mon, 28 Apr 2008 14:26:34 +0800 (WST)
From: Ian Kent <raven@themaw.net>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Kernel Mailing List <linux-kernel@vger.kernel.org>,
       autofs mailing list <autofs@linux.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: [PATCH 1/2] autofs4 - fix execution order race in mount request code
Message-ID: <Pine.LNX.4.64.0804281422060.10684@raven.themaw.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Andrew,

Jeff Moyer has identified a race in due to an execution order dependency
in the autofs4 function root.c:try_to_fill_dentry().

Jeffs description of this race is:

"P1 does a lookup of /mount/submount/foo.  Since the VFS can't find
an entry for "foo" under /mount/submount, it calls into the autofs4
kernel module to allocate a new dentry, D1. The kernel creates a new
waitq for this lookup and calls the daemon to perform the mount.

The daemon performs a mkdir of the "foo" directory under /mount/submount,
which ends up creating a *new* dentry, D2.

Then, P2 does a lookup of /mount/submount/foo.  The VFS path walking
logic finds a dentry in the dcache, D2, and calls the revalidate
function with this.  In the autofs4 revalidate code, we then trigger
a mount, since the dentry is an empty directory that isn't a mountpoint,
and so set DCACHE_AUTOFS_PENDING and call into the wait code to trigger
the mount.

The wait code finds our existing waitq entry (since it is keyed off
of the directory name) and adds itself to the list of waiters.

After the daemon finishes the mount, it calls back into the kernel
to release the waiters. When this happens, P1 is woken up and goes
about clearing the DCACHE_AUTOFS_PENDING flag, but it does this in
D1!  So, given that P1 in our case is a program that will immediately
try to access a file under /mount/submount/foo, we end up finding the
dentry D2 which still has the pending flag set, and we set out to
wait for a mount *again*!

So, one way to address this is to re-do the lookup at the end
of try_to_fill_dentry, and to clear the pending flag on the hashed
dentry.  This seems a sane approach to me."

And Jeffs patch does this.

Signed-off-by: Jeff Moyer <jmoyer@redhat.com>
Acked-by: Ian Kent <raven@themaw.net>

Ian

---
diff -up linux-2.6.25-mm1/fs/autofs4/root.c.redo-lookup-in-ttfd linux-2.6.25-mm1/fs/autofs4/root.c
--- linux-2.6.25-mm1/fs/autofs4/root.c.redo-lookup-in-ttfd	2008-04-28 11:43:30.000000000 +0800
+++ linux-2.6.25-mm1/fs/autofs4/root.c	2008-04-28 11:45:29.000000000 +0800
@@ -244,6 +244,7 @@ static int try_to_fill_dentry(struct den
 {
 	struct autofs_sb_info *sbi = autofs4_sbi(dentry->d_sb);
 	struct autofs_info *ino = autofs4_dentry_ino(dentry);
+	struct dentry *new;
 	int status = 0;
 
 	/* Block on any pending expiry here; invalidate the dentry
@@ -320,6 +321,27 @@ static int try_to_fill_dentry(struct den
 	spin_lock(&dentry->d_lock);
 	dentry->d_flags &= ~DCACHE_AUTOFS_PENDING;
 	spin_unlock(&dentry->d_lock);
+
+	/*
+	 * The dentry that is passed in from lookup may not be the one
+	 * we end up using, as mkdir can create a new one.  If this
+	 * happens, and another process tries the lookup at the same time,
+	 * it will set the PENDING flag on this new dentry, but add itself
+	 * to our waitq.  Then, if after the lookup succeeds, the first
+	 * process that requested the mount performs another lookup of the
+	 * same directory, it will show up as still pending!  So, we need
+	 * to redo the lookup here and clear pending on that dentry.
+	 */
+	if (d_unhashed(dentry)) {
+		new = d_lookup(dentry->d_parent, &dentry->d_name);
+		if (new) {
+			spin_lock(&new->d_lock);
+			new->d_flags &= ~DCACHE_AUTOFS_PENDING;
+			spin_unlock(&new->d_lock);
+			dput(new);
+		}
+	}
+
 	return status;
 }
 
