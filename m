Return-Path: <linux-kernel-owner+w=401wt.eu-S1753561AbXJaDvT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753561AbXJaDvT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 23:51:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752446AbXJaDvE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 23:51:04 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:33368 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752113AbXJaDvB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 23:51:01 -0400
Date: Tue, 30 Oct 2007 20:55:06 -0700
From: Greg KH <greg@kroah.com>
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Kay Sievers <kay.sievers@vrfy.org>,
       linux-scsi <linux-scsi@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sysfs: add filter function to groups
Message-ID: <20071031035506.GH14910@kroah.com>
References: <1193671019.3383.13.camel@localhost.localdomain> <1193676852.2655.21.camel@lov.site> <1193677071.3383.56.camel@localhost.localdomain> <47261F50.3050901@s5r6.in-berlin.de> <1193768743.3321.91.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1193768743.3321.91.camel@localhost.localdomain>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 30, 2007 at 01:25:43PM -0500, James Bottomley wrote:
> On Mon, 2007-10-29 at 18:58 +0100, Stefan Richter wrote:
> > James Bottomley wrote:
> > >> >  struct attribute_group {
> > >> >  	const char		*name;
> > >> > +	int			(*filter_show)(struct kobject *, int);
> > 
> > > Actually, it returns a true/false value indicating whether the given
> > > attribute should be displayed.
> > 
> > How about this:
> > 
> > 	int (*is_visible)(...);
> 
> OK, so is this latest revision acceptable to everyone?
> 
> James
> 
> Index: BUILD-2.6/fs/sysfs/group.c
> ===================================================================
> --- BUILD-2.6.orig/fs/sysfs/group.c	2007-10-28 17:27:04.000000000 -0500
> +++ BUILD-2.6/fs/sysfs/group.c	2007-10-30 12:35:47.000000000 -0500
> @@ -16,25 +16,31 @@
>  #include "sysfs.h"
>  
>  
> -static void remove_files(struct sysfs_dirent *dir_sd,
> +static void remove_files(struct sysfs_dirent *dir_sd, struct kobject *kobj,
>  			 const struct attribute_group *grp)
>  {
>  	struct attribute *const* attr;
> +	int i;
>  
> -	for (attr = grp->attrs; *attr; attr++)
> -		sysfs_hash_and_remove(dir_sd, (*attr)->name);
> +	for (i = 0, attr = grp->attrs; *attr; i++, attr++)
> +		if (grp->is_visible &&
> +		    grp->is_visible(kobj, *attr, i))
> +			sysfs_hash_and_remove(dir_sd, (*attr)->name);

Hm, doesn't this break for the zillions of attribute groups that do not
have the is_visible function set?

> -static int create_files(struct sysfs_dirent *dir_sd,
> +static int create_files(struct sysfs_dirent *dir_sd, struct kobject *kobj,
>  			const struct attribute_group *grp)
>  {
>  	struct attribute *const* attr;
> -	int error = 0;
> +	int error = 0, i;
>  
> -	for (attr = grp->attrs; *attr && !error; attr++)
> -		error = sysfs_add_file(dir_sd, *attr, SYSFS_KOBJ_ATTR);
> +	for (i = 0, attr = grp->attrs; *attr && !error; i++, attr++)
> +		if (grp->is_visible &&
> +		    grp->is_visible(kobj, *attr, i))
> +			error |=
> +				sysfs_add_file(dir_sd, *attr, SYSFS_KOBJ_ATTR);

Same problem here, if grp->is_visible is not set, sysfs_add_file() would
never be called, right?

Other than the logic problem (I think), I have no issue with this idea
at all.  Care to redo this so it works?

thanks,

greg k-h
