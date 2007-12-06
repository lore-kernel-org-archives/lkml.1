Return-Path: <linux-kernel-owner+w=401wt.eu-S1754584AbXLFIbv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754584AbXLFIbv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 03:31:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753125AbXLFIbn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 03:31:43 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58515 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752944AbXLFIbm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 03:31:42 -0500
Date: Thu, 6 Dec 2007 00:31:34 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Giacomo Catenazzi <cate@cateee.net>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, linux-kernel@vger.kernel.org,
       "Denis V. Lunev" <den@openvz.org>
Subject: Re: proc/bus.usb regression in : [NETNS]: Fix /proc/net breakage
Message-Id: <20071206003134.80a7ad57.akpm@linux-foundation.org>
In-Reply-To: <4757B121.6000308@cateee.net>
References: <200712031900.lB3J0PR9025742@hera.kernel.org>
	<20071205040236.ff102b9e.akpm@linux-foundation.org>
	<4757B121.6000308@cateee.net>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 06 Dec 2007 09:21:53 +0100 Giacomo Catenazzi <cate@cateee.net> wrote:

> Andrew Morton wrote:
> > On Mon, 3 Dec 2007 19:00:25 GMT Linux Kernel Mailing List <linux-kernel@vger.kernel.org> wrote:
> > 
> >> Gitweb:     http://git.kernel.org/git/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=2b1e300a9dfc3196ccddf6f1d74b91b7af55e416
> >> Commit:     2b1e300a9dfc3196ccddf6f1d74b91b7af55e416
> >> Parent:     e03ba84adb62fbc6049325a5bc00ef6932fa5e39
> >> Author:     Eric W. Biederman <ebiederm@xmission.com>
> >> AuthorDate: Sun Dec 2 00:33:17 2007 +1100
> >> Committer:  Herbert Xu <herbert@gondor.apana.org.au>
> >> CommitDate: Sun Dec 2 00:33:17 2007 +1100
> >>
> >>     [NETNS]: Fix /proc/net breakage
> >>     
> >>     Well I clearly goofed when I added the initial network namespace support
> >>     for /proc/net.  Currently things work but there are odd details visible to
> >>     user space, even when we have a single network namespace.
> >>     
> >>     Since we do not cache proc_dir_entry dentries at the moment we can just
> >>     modify ->lookup to return a different directory inode depending on the
> >>     network namespace of the process looking at /proc/net, replacing the
> >>     current technique of using a magic and fragile follow_link method.
> >>     
> >>     To accomplish that this patch:
> >>     - introduces a shadow_proc method to allow different dentries to
> >>       be returned from proc_lookup.
> >>     - Removes the old /proc/net follow_link magic
> >>     - Fixes a weakness in our not caching of proc generic dentries.
> >>     
> >>     As shadow_proc uses a task struct to decided which dentry to return we can
> >>     go back later and fix the proc generic caching without modifying any code
> >>     that uses the shadow_proc method.
> > 
> > This patch caused the binfmt_misc regression reported in
> > http://bugzilla.kernel.org/show_bug.cgi?id=9504
> 
> This patch also doesn't allow to mount /proc/bus/usb
> 

Does Denis's patch fix it?

Thanks.


From: "Denis V. Lunev" <den@openvz.org>

/proc/sys/fs/binfmt_misc dentry disappeared during d_revalidate. 
d_revalidate only dentries from shadowed one and below. 
http://bugzilla.kernel.org/show_bug.cgi?id=9504

Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Marcus Better <marcus@better.se>
Signed-off-by: Denis V. Lunev <den@openvz.org>
Cc: Marcus Better <marcus@better.se>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/generic.c |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff -puN fs/proc/generic.c~lost-content-of-proc-sys-fs-binfmt_misc fs/proc/generic.c
--- a/fs/proc/generic.c~lost-content-of-proc-sys-fs-binfmt_misc
+++ a/fs/proc/generic.c
@@ -380,12 +380,17 @@ static int proc_revalidate_dentry(struct
 	return 0;
 }
 
-static struct dentry_operations proc_dentry_operations =
+static struct dentry_operations proc_dentry_shadow_operations =
 {
 	.d_delete	= proc_delete_dentry,
 	.d_revalidate	= proc_revalidate_dentry,
 };
 
+static struct dentry_operations proc_dentry_operations =
+{
+	.d_delete	= proc_delete_dentry,
+};
+
 /*
  * Don't create negative dentries here, return -ENOENT by hand
  * instead.
@@ -394,6 +399,7 @@ struct dentry *proc_lookup(struct inode 
 {
 	struct inode *inode = NULL;
 	struct proc_dir_entry * de;
+	int use_shadow = 0;
 	int error = -ENOENT;
 
 	lock_kernel();
@@ -406,8 +412,10 @@ struct dentry *proc_lookup(struct inode 
 			if (!memcmp(dentry->d_name.name, de->name, de->namelen)) {
 				unsigned int ino;
 
-				if (de->shadow_proc)
+				if (de->shadow_proc) {
 					de = de->shadow_proc(current, de);
+					use_shadow = 1;
+				}
 				ino = de->low_ino;
 				de_get(de);
 				spin_unlock(&proc_subdir_lock);
@@ -423,6 +431,8 @@ struct dentry *proc_lookup(struct inode 
 
 	if (inode) {
 		dentry->d_op = &proc_dentry_operations;
+		dentry->d_op = use_shadow ?
+			&proc_dentry_shadow_operations : dentry->d_parent->d_op;
 		d_add(dentry, inode);
 		return NULL;
 	}
_

