Return-Path: <linux-kernel-owner+w=401wt.eu-S1758079AbXIZOBk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758079AbXIZOBk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 10:01:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753144AbXIZOBc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 10:01:32 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:57713 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752770AbXIZOBa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 10:01:30 -0400
Date: Wed, 26 Sep 2007 10:01:11 -0400
Message-Id: <200709261401.l8QE1B3P025688@agora.fsl.cs.sunysb.edu>
From: Erez Zadok <ezk@cs.sunysb.edu>
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: Erez Zadok <ezk@cs.sunysb.edu>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       viro@ftp.linux.org.uk, hch@infradead.org
Subject: Re: [PATCH 03/25] Unionfs: display informational messages only if debug is on 
In-reply-to: Your message of "Wed, 26 Sep 2007 10:36:27 +0200."
             <Pine.LNX.4.64.0709261036140.3121@fbirervta.pbzchgretzou.qr> 
X-MailKey: Erez_Zadok
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

In message <Pine.LNX.4.64.0709261036140.3121@fbirervta.pbzchgretzou.qr>, Jan Engelhardt writes:
> 
> On Sep 25 2007 23:09, Erez Zadok wrote:
> >--- a/fs/unionfs/commonfops.c
> >+++ b/fs/unionfs/commonfops.c
> >@@ -394,8 +394,8 @@ int unionfs_file_revalidate(struct file *file, bool willwrite)
> > 	if (willwrite && IS_WRITE_FLAG(file->f_flags) &&
> > 	    !IS_WRITE_FLAG(unionfs_lower_file(file)->f_flags) &&
> > 	    is_robranch(dentry)) {
> >-		printk(KERN_DEBUG "unionfs: do delay copyup of \"%s\"\n",
> >-		       dentry->d_name.name);
> >+		dprintk(KERN_DEBUG "unionfs: do delay copyup of \"%s\"\n",
> >+			dentry->d_name.name);
> 
> Don't we have pr_debug() for that?

Jan, what's the policy on people writing their own debugging printk systems.
I've looked at what other file systems do, and found out that it varies a
lot: some use a simple mapping wrapper from printk->dprintk, while others
define complex ways to have debugging levels/bitmaps where users can
selectively decide (say, by a mount option), what debugging output they'd
like to see or not.  Here's a small sampling of what some file systems use:

9p/fid.c:		P9_DPRINTK(P9_DEBUG_VFS, "fid %d dentry %s\n",
autofs/inode.c:		DPRINTK(("autofs: shutting down\n"));
lockd/svcproc.c:	dprintk("lockd: GRANTED_RES   called\n");
ncpfs/dir.c:		DDPRINTK("ncp_lookup_validate: result=%d\n", val);
nfs/client.c:		dprintk("<-- nfs_free_client()\n");
nfsd/export.c:		dprintk("found domain %s\n", buf);
partitions/efi.c:	Dprintk("GPT my_lba incorrect: %lld != %lld\n",

Not much standardization there :-) but "dprintk" does appear to be the more
common use.

I wanted something simple to allow me to not printk something that's just
for informational/debugging purposes, but w/o having to #ifdef the printk in
question, or define a complex debugging-level printk system.

Now, looking at pr_debug (in linux/kernel.h), and indeed some filesystems
(e.g., affs and configfs) use it.  But pr_debug is only active when #define
DEBUG is on (not CONFIG_DEBUG).  I didn't see a config option that enable
DEBUG: is there one?

>From other file systems, it appears that the more common convention is for
filesystem XYZ to offer a config option CONFIG_DEBUG_XYZ, which makes its
debugging more self-contained and keeps the config option closer to where
the f/s itself is enabled.

Thanks,
Erez.
