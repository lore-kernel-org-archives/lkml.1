Return-Path: <linux-kernel-owner+w=401wt.eu-S1751431AbXDKKYg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751431AbXDKKYg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 06:24:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752063AbXDKKYg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 06:24:36 -0400
Received: from mtagate6.de.ibm.com ([195.212.29.155]:7477 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751431AbXDKKYf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 06:24:35 -0400
Date: Wed, 11 Apr 2007 12:26:52 +0200
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: Tejun Heo <htejun@gmail.com>
Cc: gregkh@suse.de, maneesh@in.ibm.com, dmitry.torokhov@gmail.com,
       oneukum@suse.de, rpurdie@rpsys.net, James.Bottomley@SteelEye.com,
       stern@rowland.harvard.edu, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH 12/14 UPDATED] sysfs: implement sysfs_dirent active
 reference and immediate disconnect
Message-ID: <20070411122652.74d3ecd1@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <20070411101359.GF10619@htj.dyndns.org>
References: <11760923261269-git-send-email-htejun@gmail.com>
	<11760923292724-git-send-email-htejun@gmail.com>
	<20070411041515.GA10619@htj.dyndns.org>
	<20070411110006.1007b209@gondolin.boeblingen.de.ibm.com>
	<461CA9D2.7020501@gmail.com>
	<20070411101359.GF10619@htj.dyndns.org>
Organization: IBM Deutschland Entwicklung GmbH
X-Mailer: Claws Mail 2.8.0 (GTK+ 2.8.20; i486-pc-linux-gnu)
X-Legal: IBM Deutschland Entwicklung GmbH Vorsitzender des Aufsichtsrats:
 Johann Weihen =?ISO-8859-15?Q?Gesch=E4ftsf=FChrung:?= Herbert Kircher Sitz
 der Gesellschaft: =?ISO-8859-15?Q?B=F6blingen?= Registergericht:
 Amtsgericht Stuttgart, HRB 243294
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Apr 2007 19:13:59 +0900,
Tejun Heo <htejun@gmail.com> wrote:

> Does this patch fix the problem?
> 
> Index: work/fs/sysfs/dir.c
> ===================================================================
> --- work.orig/fs/sysfs/dir.c	2007-04-11 19:12:02.000000000 +0900
> +++ work/fs/sysfs/dir.c	2007-04-11 19:12:12.000000000 +0900
> @@ -26,7 +26,8 @@ void release_sysfs_dirent(struct sysfs_d
>  	 * locked.  If @sd is cursor for directory walk or being
>  	 * released prematurely, s_active has no reader or writer.
>  	 */
> -	down_write_trylock(&sd->s_active);
> +	if (!down_write_trylock(&sd->s_active))
> +		rwsem_acquire(&sd->s_active.dep_map, 0, 0, _RET_IP_);
>  	up_write(&sd->s_active);
> 
>  	if (sd->s_type & SYSFS_KOBJ_LINK)
> Index: work/fs/sysfs/sysfs.h
> ===================================================================
> --- work.orig/fs/sysfs/sysfs.h	2007-04-11 19:12:02.000000000 +0900
> +++ work/fs/sysfs/sysfs.h	2007-04-11 19:12:03.000000000 +0900
> @@ -171,6 +171,7 @@ static inline void sysfs_put_active_two(
>  static inline void sysfs_deactivate(struct sysfs_dirent *sd)
>  {
>  	down_write(&sd->s_active);
> +	rwsem_release(&sd->s_active.dep_map, 1, _RET_IP_);
>  }
> 
>  static inline int sysfs_is_shadowed_inode(struct inode *inode)

This seems to work fine now, thanks.
