Return-Path: <linux-kernel-owner+w=401wt.eu-S966540AbXEVSbu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966540AbXEVSbu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 14:31:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759837AbXEVSbk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 14:31:40 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58099 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759829AbXEVSbj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 14:31:39 -0400
Date: Tue, 22 May 2007 11:29:51 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: linux-kernel@vger.kernel.org, xiaosuo@gmail.com
Subject: Re: + procfs-directory-entry-cleanup.patch added to -mm tree
Message-Id: <20070522112951.1a980a46.akpm@linux-foundation.org>
In-Reply-To: <20070522174348.GA5689@martell.zuzino.mipt.ru>
References: <200705210341.l4L3f1BH001692@shell0.pdx.osdl.net>
	<20070522174348.GA5689@martell.zuzino.mipt.ru>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 May 2007 21:43:49 +0400
Alexey Dobriyan <adobriyan@gmail.com> wrote:

> On Sun, May 20, 2007 at 08:41:02PM -0700, akpm@linux-foundation.org wrote:
> > Subject: procfs directory entry cleanup
> > From: "Changli Gao" <xiaosuo@gmail.com>
> >
> > Function proc_register() will assign proc_dir_operations and
> > proc_dir_inode_operations to ent's members proc_fops and proc_iops
> > correctly if ent is a directory. So the early assignment isn't
> > necessary.
> 
> > --- a/fs/proc/generic.c~procfs-directory-entry-cleanup
> > +++ a/fs/proc/generic.c
> > @@ -649,9 +649,6 @@ struct proc_dir_entry *proc_mkdir_mode(c
> >  
> >  	ent = proc_create(&parent, name, S_IFDIR | mode, 2);
> >  	if (ent) {
> > -		ent->proc_fops = &proc_dir_operations;
> > -		ent->proc_iops = &proc_dir_inode_operations;
> > -
> >  		if (proc_register(parent, ent) < 0) {
> >  			kfree(ent);
> >  			ent = NULL;
> > @@ -686,10 +683,6 @@ struct proc_dir_entry *create_proc_entry
> >  
> >  	ent = proc_create(&parent,name,mode,nlink);
> >  	if (ent) {
> > -		if (S_ISDIR(mode)) {
> > -			ent->proc_fops = &proc_dir_operations;
> > -			ent->proc_iops = &proc_dir_inode_operations;
> > -		}
> >  		if (proc_register(parent, ent) < 0) {
> >  			kfree(ent);
> >  			ent = NULL;
> 
> This should add race because new PDE for directory will be glued to tree
> with NULL ->proc_iops and, at least, vfs_getattr() doesn't check for
> NULL ->i_op.
> 
> I've tried to reproduce this scenario with udelay() inserted before
> S_ISDIR checks in proc_register() but got some panic while in X,
> so no cookie for me. Maybe it's impossible, indeed.
> 
> Anyway, this patch + moving ->proc_fops and ->proc_iops initialization
> before gluing is OK with me.

Like this?

diff -puN fs/proc/generic.c~procfs-directory-entry-cleanup-fix fs/proc/generic.c
--- a/fs/proc/generic.c~procfs-directory-entry-cleanup-fix
+++ a/fs/proc/generic.c
@@ -529,12 +529,6 @@ static int proc_register(struct proc_dir
 		return -EAGAIN;
 	dp->low_ino = i;
 
-	spin_lock(&proc_subdir_lock);
-	dp->next = dir->subdir;
-	dp->parent = dir;
-	dir->subdir = dp;
-	spin_unlock(&proc_subdir_lock);
-
 	if (S_ISDIR(dp->mode)) {
 		if (dp->proc_iops == NULL) {
 			dp->proc_fops = &proc_dir_operations;
@@ -550,6 +544,13 @@ static int proc_register(struct proc_dir
 		if (dp->proc_iops == NULL)
 			dp->proc_iops = &proc_file_inode_operations;
 	}
+
+	spin_lock(&proc_subdir_lock);
+	dp->next = dir->subdir;
+	dp->parent = dir;
+	dir->subdir = dp;
+	spin_unlock(&proc_subdir_lock);
+
 	return 0;
 }
 
_

