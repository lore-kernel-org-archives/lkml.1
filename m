Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932601Ab0BDTdM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 14:33:12 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37153 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758431Ab0BDTdE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 14:33:04 -0500
Date: Thu, 4 Feb 2010 11:31:45 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, stable@kernel.org
Subject: Re: [PATCH] procfs: Fix refcnt leak on proc_self_follow_link()
 error path
Message-Id: <20100204113145.a635005c.akpm@linux-foundation.org>
In-Reply-To: <20100114015557.GF19799@ZenIV.linux.org.uk>
References: <87aawkjxlf.fsf@devron.myhome.or.jp>
	<20100113194300.GA4673@ZenIV.linux.org.uk>
	<20100113162504.1c06c5e6.akpm@linux-foundation.org>
	<20100114015557.GF19799@ZenIV.linux.org.uk>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Jan 2010 01:55:57 +0000
Al Viro <viro@ZenIV.linux.org.uk> wrote:

> On Wed, Jan 13, 2010 at 04:25:04PM -0800, Andrew Morton wrote:
> > On Wed, 13 Jan 2010 19:43:01 +0000
> > Al Viro <viro@ZenIV.linux.org.uk> wrote:
> > 
> > > On Tue, Jan 12, 2010 at 03:38:36AM +0900, OGAWA Hirofumi wrote:
> > > > 
> > > > If ->follow_link handler return the error, it should decrement
> > > > nd->path refcnt.
> > > > 
> > > > This patch fix it.
> > > 
> > > It's OK for -stable, but for the next tree... not really.  I'd rather
> > > kill vfs_follow_link() uses here and in gfs2; see #untested in vfs-2.6.git
> > > for details.
> > 
> > Confused.  Is #untested planned for 2.6.33?  If not, how do we fix this
> > bug in .33?
> 
> My preference would be a backport of corresponding bits - they _are_ safe.
> I can live with procfs/gfs2 stuff getting into the tree as-is to be
> converted later (and note that at least procfs one is fairly old - it goes
> back to commit 488e5bc4560d0b510c1ddc451c51a6cc14e3a930
> Author: Eric W. Biederman <ebiederm@xmission.com>
> Date:   Fri Feb 8 04:18:34 2008 -0800
>     proc: proper pidns handling for /proc/self
> so it's prime -stable fodder, whatever form of fix we prefer for that).
> 
> For post-2.6.33 we definitely have good reasons to fix that stuff by
> providing ->put_link() and switching to nd_set_link() for those.  It
> allows to kill fsckloads of symlink body copying when doing open() on
> pathname that resolves to a symlink, which is worth a lot.

I see this in linux-next:

commit 1427acc5655198f0196178846599a62656e92df0
Author:     Al Viro <viro@zeniv.linux.org.uk>
AuthorDate: Thu Jan 14 01:03:28 2010 -0500
Commit:     Al Viro <viro@zeniv.linux.org.uk>
CommitDate: Sat Jan 30 00:03:55 2010 -0500

    Switch proc/self to nd_set_link()
    
    Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

diff --git a/fs/proc/base.c b/fs/proc/base.c
index e42bbd8..58324c2 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -2369,16 +2369,30 @@ static void *proc_self_follow_link(struct dentry *dentry, struct nameidata *nd)
 {
 	struct pid_namespace *ns = dentry->d_sb->s_fs_info;
 	pid_t tgid = task_tgid_nr_ns(current, ns);
-	char tmp[PROC_NUMBUF];
-	if (!tgid)
-		return ERR_PTR(-ENOENT);
-	sprintf(tmp, "%d", task_tgid_nr_ns(current, ns));
-	return ERR_PTR(vfs_follow_link(nd,tmp));
+	char *name = ERR_PTR(-ENOENT);
+	if (tgid) {
+		name = __getname();
+		if (!name)
+			name = ERR_PTR(-ENOMEM);
+		else
+			sprintf(name, "%d", tgid);
+	}
+	nd_set_link(nd, name);
+	return NULL;
+}
+
+static void proc_self_put_link(struct dentry *dentry, struct nameidata *nd,
+				void *cookie)
+{
+	char *s = nd_get_link(nd);
+	if (!IS_ERR(s))
+		__putname(s);
 }
 
 static const struct inode_operations proc_self_inode_operations = {
 	.readlink	= proc_self_readlink,
 	.follow_link	= proc_self_follow_link,
+	.put_link	= proc_self_put_link,
 };
 
 /*

which I assume fixes the bug?

> I'm still not 100% sure which way to go for -stable (and .33 - these are
> equivalent in that respect).  Posted patches touch only the codepaths
> where we are currently guaranteed to leak and all things equal that'd be
> an argument in their favour.  OTOH, the minimal alternative for e.g. gfs2
> would be to make buffer allocation unconditional, use nd_set_link() instead
> of vfs_follow_link() and leave freeing to put_link().  Which can be followed
> by killing special gfs2 ->readlink(), since now generic_readlink() will
> work just fine (and gfs2_readlinki() can be folded into gfs2_follow_link(),
> simplifying things even more).  In other words, long-term variant is not
> much more intrusive and it's just as safe.  So that argument in favour
> of posted variant is not particulary strong, especially wrt 2.6.33.
> 
> So basically it boils down to doing truly minimal fix vs. doing the same
> thing (almost as trivial) we'll do past .33.
> 
> FWIW, it may be as simple as "is posted gfs2 patch already in a published
> gfs2 tree and if it is, how inconvenient for gfs2 folks would it be to
> replace it?"; I'm really ambivalent about that one...

But nothing for 2.6.33 or -stable yet?

What we could do is to merge the above into 2.6.34-rc1 with a
Cc:stable@kernel.org in the changelog and when it's had a bit of
testing, the -stable guys could merge it back into 2.6.33.x, 2.6.32.x,
etc?


