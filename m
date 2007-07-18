Return-Path: <linux-kernel-owner+w=401wt.eu-S1760080AbXGRLRL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760080AbXGRLRL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 07:17:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751521AbXGRLQ5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 07:16:57 -0400
Received: from mtagate4.uk.ibm.com ([195.212.29.137]:53407 "EHLO
	mtagate4.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752088AbXGRLQ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 07:16:56 -0400
Date: Wed, 18 Jul 2007 13:16:46 +0200
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: Tejun Heo <htejun@gmail.com>
Cc: Gabriel C <nix.or.die@googlemail.com>,
       Satyam Sharma <satyam.sharma@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Christoph Lameter <clameter@sgi.com>, gregkh@suse.de,
       miles.lane@gmail.com
Subject: Re: [PATCH] sysfs: kill an extra put in sysfs_create_link() failure
 path
Message-ID: <20070718131646.2c9cdab0@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <20070718071445.GI23568@htj.dyndns.org>
References: <a781481a0707142239l397672c6p4fd1dc8dfb73e07c@mail.gmail.com>
	<469A5C94.7030201@googlemail.com>
	<a781481a0707151414l3efcd2d0q93db88a32b90e344@mail.gmail.com>
	<469A9D5D.10509@googlemail.com>
	<469B61C8.8010902@googlemail.com>
	<a781481a0707160819w1be9128cxb3cdd06ba068b20d@mail.gmail.com>
	<469BB7B8.3060002@gmail.com>
	<469BB9CA.6090500@googlemail.com>
	<469BC2D6.5090008@googlemail.com>
	<469BC34C.4080107@googlemail.com>
	<20070718071445.GI23568@htj.dyndns.org>
Organization: IBM Deutschland Entwicklung GmbH
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.13; i486-pc-linux-gnu)
X-Legal: IBM Deutschland Entwicklung GmbH Vorsitzender des Aufsichtsrats:
 Johann Weihen =?ISO-8859-15?Q?Gesch=E4ftsf=FChrung:?= Herbert Kircher Sitz
 der Gesellschaft: =?ISO-8859-15?Q?B=F6blingen?= Registergericht:
 Amtsgericht Stuttgart, HRB 243294
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Jul 2007 16:14:45 +0900,
Tejun Heo <htejun@gmail.com> wrote:

> There is a subtle bug in sysfs_create_link() failure path.  When
> symlink creation fails because there's already a node with the same
> name, the target sysfs_dirent is put twice - once by failure path of
> sysfs_create_link() and once more when the symlink is released.
> 
> Fix it by making only the symlink node responsible for putting
> target_sd.
> 
> Signed-off-by: Tejun Heo <htejun@gmail.com>
> ---
> Gabriel, Miles, please verify this fixes your problem.  Thanks.
> 
>  fs/sysfs/symlink.c |    2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/fs/sysfs/symlink.c b/fs/sysfs/symlink.c
> index 2f86e04..d056e96 100644
> --- a/fs/sysfs/symlink.c
> +++ b/fs/sysfs/symlink.c
> @@ -86,7 +86,9 @@ int sysfs_create_link(struct kobject * kobj, struct kobject * target, const char
>  	sd = sysfs_new_dirent(name, S_IFLNK|S_IRWXUGO, SYSFS_KOBJ_LINK);
>  	if (!sd)
>  		goto out_put;
> +
>  	sd->s_elem.symlink.target_sd = target_sd;
> +	target_sd = NULL;	/* reference is now owned by the symlink */
> 
>  	sysfs_addrm_start(&acxt, parent_sd);
> 

A subtle bug indeed. The patch looks sane to me.

Reviewed-by: Cornelia Huck <cornelia.huck@de.ibm.com>
