Return-Path: <linux-kernel-owner+w=401wt.eu-S1753832AbXDXUQF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753832AbXDXUQF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 16:16:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754368AbXDXUQE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 16:16:04 -0400
Received: from nz-out-0506.google.com ([64.233.162.230]:21602 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753832AbXDXUQA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 16:16:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=g/bTSwkEJF3C0GRf4SDDYwWHOlOeaR/oL+pAeJHW5nDzqykWbBVebcgk69CIpy8zRjdhgqLUln4yI+ET/cV2m+IWSb6/SvUndmn/HV/RbZSulF65JEp1hY8EmsS+KN+jUzPayXSgXe9QxPJu19kPnxSHWEfauBVQEn7ginixRAo=
Date: Wed, 25 Apr 2007 05:15:55 +0900
From: Tejun Heo <htejun@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Vincent Vanackere <vincent.vanackere@gmail.com>,
       linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Greg KH <gregkh@suse.de>
Subject: Re: [OOPS 2.6.21-rc7-mm1] kernel BUG at fs/sysfs/inode.c:272 (sysfs_drop_dentry)
Message-ID: <20070424201555.GC17130@htj.dyndns.org>
References: <65258a580704240820lbee4944t1adef1aeb92394ce@mail.gmail.com> <462E3177.4000901@gmail.com> <20070424103358.3be9efcd.akpm@linux-foundation.org> <462E43AF.2040305@gmail.com> <20070424105844.da798b07.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070424105844.da798b07.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 24, 2007 at 10:58:44AM -0700, Andrew Morton wrote:
> On Wed, 25 Apr 2007 02:51:43 +0900 Tejun Heo <htejun@gmail.com> wrote:
> 
> > Andrew Morton wrote:
> > > On Wed, 25 Apr 2007 01:33:59 +0900 Tejun Heo <htejun@gmail.com> wrote:
> > > 
> > >> Vincent Vanackere wrote:
> > >>> Hi,
> > >>>
> > >>> I'm getting the following oops at boot with the latest -mm kernel :
> > >>> ---------------------------------------------------------------
> > >>> kernel BUG at fs/sysfs/inode.c:272
> > >> Known problem.  Working on it.  Thanks.
> > >>
> > > 
> > > If it had been known by me I wouldn't have released known-buggy code to
> > > people who need to be able to test other people's code too. (argh)
> > > 
> > 
> > It's the problem Cornelia reported in the thread the patch was posted.
> 
> Is there a workaround?  What might happen if we just delete that BUG_ON()?

Okay, here's the workaround.  It leaks dentries and inodes if parent
is deleted first but other than that it should be okay.

diff --git a/fs/sysfs/inode.c b/fs/sysfs/inode.c
index eea50a5..b466671 100644
--- a/fs/sysfs/inode.c
+++ b/fs/sysfs/inode.c
@@ -212,8 +212,11 @@ static struct dentry *sysfs_lookup_sd(struct sysfs_dirent *sd)
 	depth = sysfs_path_depth(sd);
 
 	while (depth--) {
-		/* negative intermediate node is a BUG */
-		BUG_ON(!dentry->d_inode);
+		/* XXX */ /* negative intermediate node is a BUG */
+		/* XXX */ /* BUG_ON(!dentry->d_inode); */
+		if (!dentry->d_inode)
+			return NULL;
+		/* XXX */
 
 		for (cur = sd, i = 0; i < depth; i++)
 			cur = cur->s_parent;
@@ -269,7 +272,7 @@ void sysfs_drop_dentry(struct sysfs_dirent *sd)
 	}
 
 	if (isdir) {
-		BUG_ON(!simple_empty(dentry));
+		/* XXX */ /* BUG_ON(!simple_empty(dentry)); */
 		drop_nlink(dir);
 		/* unpin if directory */
 		dput(dentry);
