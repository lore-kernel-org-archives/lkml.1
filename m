Return-Path: <linux-kernel-owner+w=401wt.eu-S1758431AbXLGXPb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758431AbXLGXPb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2007 18:15:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753954AbXLGXPW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Dec 2007 18:15:22 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58090 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756227AbXLGXPV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2007 18:15:21 -0500
Date: Fri, 7 Dec 2007 15:14:44 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: gnome42@gmail.com, linux-kernel@vger.kernel.org, bfields@fieldses.org,
       rjw@sisk.pl, "Eric W. Biederman" <ebiederm@xmission.com>,
       "Denis V. Lunev" <den@openvz.org>
Subject: Re: 2.6.24-rc3-git4 NFS crossmnt regression
Message-Id: <20071207151444.af5d8e11.akpm@linux-foundation.org>
In-Reply-To: <1197067918.10831.13.camel@heimdal.trondhjem.org>
References: <fa4052ef0712062045o743a2666u3562a3569c1aa989@mail.gmail.com>
	<20071207040219.e231cbc7.akpm@linux-foundation.org>
	<fa4052ef0712071014l524951e2we4705d84c5005cf3@mail.gmail.com>
	<1197053179.7532.23.camel@heimdal.trondhjem.org>
	<fa4052ef0712071055r2fe33f2ep34fed2537970c8ef@mail.gmail.com>
	<fa4052ef0712071116x2b727faau190ec14e4b2a2d47@mail.gmail.com>
	<fa4052ef0712071139x30ada982r570513c5a0fb2657@mail.gmail.com>
	<1197067918.10831.13.camel@heimdal.trondhjem.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 07 Dec 2007 17:51:58 -0500
Trond Myklebust <trond.myklebust@fys.uio.no> wrote:

> 
> On Fri, 2007-12-07 at 14:39 -0500, Shane wrote:
> > On Dec 7, 2007 2:16 PM, Shane <gnome42@gmail.com> wrote:
> > ...
> > > Confirmed working in rc4-git5.  I'll deploy this kernel in a few more
> > > spots and check for other regressions.
> > 
> > Hmm, I installed a new kernel built from the same sources on the NFS
> > server. And now I don't see anything at all in the crossmnt dirs.
> > 
> > ls /dirA/dirB/dirC  --> zero output (empty dir)
> > 
> > Are there any other pending fixes?
> > 
> > Shane
> 
> You've probably fallen afoul of 
> 
>    http://bugzilla.kernel.org/show_bug.cgi?id=9504
> 

Yeah.

I have a tentative fix below but I can't seem to get Eric and Denis to get
a suitable fix nailed down.  It's urgent!



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

