Return-Path: <linux-kernel-owner+w=401wt.eu-S1752016AbXDKKOK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752016AbXDKKOK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 06:14:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752030AbXDKKOK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 06:14:10 -0400
Received: from wr-out-0506.google.com ([64.233.184.228]:22888 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752016AbXDKKOH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 06:14:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=a9tHFGOFjgOH9FtjBw+Wj5RLpj3/Tv0y0mQ2AcmJRnCWSiKemZ+bPpZEjIFDVDsd52PFjHajHdjlD5wa4Sojfxrs2EuYai5PDIa0F9b3b/M+/mQCX4GtxQrRT7pT8eQUWMvcaZ9vJr8kWxRtJVZEzWm2Avic/HUfaLepkEtgJp4=
Date: Wed, 11 Apr 2007 19:13:59 +0900
From: Tejun Heo <htejun@gmail.com>
To: Cornelia Huck <cornelia.huck@de.ibm.com>
Cc: gregkh@suse.de, maneesh@in.ibm.com, dmitry.torokhov@gmail.com,
       oneukum@suse.de, rpurdie@rpsys.net, James.Bottomley@SteelEye.com,
       stern@rowland.harvard.edu, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH 12/14 UPDATED] sysfs: implement sysfs_dirent active reference and immediate disconnect
Message-ID: <20070411101359.GF10619@htj.dyndns.org>
References: <11760923261269-git-send-email-htejun@gmail.com> <11760923292724-git-send-email-htejun@gmail.com> <20070411041515.GA10619@htj.dyndns.org> <20070411110006.1007b209@gondolin.boeblingen.de.ibm.com> <461CA9D2.7020501@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <461CA9D2.7020501@gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 11, 2007 at 06:26:42PM +0900, Tejun Heo wrote:
> Hello,
> 
> Cornelia Huck wrote:
> > =======================================================
> > [ INFO: possible circular locking dependency detected ]
> > 2.6.21-rc6-ge666c753-dirty #54
> > -------------------------------------------------------
> > kslowcrw/64 is trying to acquire lock:
> >  (&sch->reg_mutex){--..}, at: [<00000000004233b2>] mutex_lock+0x3e/0x4c
> > 
> > but task is already holding lock:
> >  (&sd->s_active){----}, at: [<0000000000209578>] remove_dir+0xec/0x144
> > 
> > which lock already depends on the new lock.
> 
> This is probably because s_active has different write locked and
> unlocked by different threads but it doesn't tell lockdep about it.
> I'll read lockdep docs and update it.

Does this patch fix the problem?

Index: work/fs/sysfs/dir.c
===================================================================
--- work.orig/fs/sysfs/dir.c	2007-04-11 19:12:02.000000000 +0900
+++ work/fs/sysfs/dir.c	2007-04-11 19:12:12.000000000 +0900
@@ -26,7 +26,8 @@ void release_sysfs_dirent(struct sysfs_d
 	 * locked.  If @sd is cursor for directory walk or being
 	 * released prematurely, s_active has no reader or writer.
 	 */
-	down_write_trylock(&sd->s_active);
+	if (!down_write_trylock(&sd->s_active))
+		rwsem_acquire(&sd->s_active.dep_map, 0, 0, _RET_IP_);
 	up_write(&sd->s_active);
 
 	if (sd->s_type & SYSFS_KOBJ_LINK)
Index: work/fs/sysfs/sysfs.h
===================================================================
--- work.orig/fs/sysfs/sysfs.h	2007-04-11 19:12:02.000000000 +0900
+++ work/fs/sysfs/sysfs.h	2007-04-11 19:12:03.000000000 +0900
@@ -171,6 +171,7 @@ static inline void sysfs_put_active_two(
 static inline void sysfs_deactivate(struct sysfs_dirent *sd)
 {
 	down_write(&sd->s_active);
+	rwsem_release(&sd->s_active.dep_map, 1, _RET_IP_);
 }
 
 static inline int sysfs_is_shadowed_inode(struct inode *inode)
