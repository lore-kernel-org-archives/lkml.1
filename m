Return-Path: <linux-kernel-owner+w=401wt.eu-S1755151AbZKDKgZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755151AbZKDKgZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 05:36:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754403AbZKDKgY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 05:36:24 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:57922 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753377AbZKDKgW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 05:36:22 -0500
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: <linux-fsdevel@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
       sds@tycho.nsa.gov, jmorris@namei.org, casey@schaufler-ca.com,
       linux-security-module@vger.kernel.org
Subject: Re: [PATCH] sysfs: Don't leak secdata when a sysfs_dirent is freed.
References: <m13a4vdg7f.fsf@fess.ebiederm.org>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Wed, 04 Nov 2009 02:36:20 -0800
In-Reply-To: <m13a4vdg7f.fsf@fess.ebiederm.org> (Eric W. Biederman's message of "Tue\, 03 Nov 2009 03\:02\:12 -0800")
Message-ID: <m1hbta4lwb.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); Unknown failure
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Grr.  Please all ignore the 01/42 in the subject.  Clearly I was
a bit too tired when I sent this but the fix is good and fixes a bug
2.6.32-rc5 that should be there in the first place.


ebiederm@xmission.com (Eric W. Biederman) writes:

> While refreshing my sysfs patches I noticed a leak in the secdata
> implementation.  We don't free the secdata when we free the
> sysfs dirent. 
>
> This is a bug in 2.6.32-rc5 that we really should close.
>
> Signed-off-by: Eric W. Biederman <ebiederm@aristanetworks.com>

> ---
>  fs/sysfs/dir.c |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)
>
> diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
> index 5fad489..e020183 100644
> --- a/fs/sysfs/dir.c
> +++ b/fs/sysfs/dir.c
> @@ -21,6 +21,7 @@
>  #include <linux/completion.h>
>  #include <linux/mutex.h>
>  #include <linux/slab.h>
> +#include <linux/security.h>
>  #include "sysfs.h"
>  
>  DEFINE_MUTEX(sysfs_mutex);
> @@ -285,6 +286,9 @@ void release_sysfs_dirent(struct sysfs_dirent * sd)
>  		sysfs_put(sd->s_symlink.target_sd);
>  	if (sysfs_type(sd) & SYSFS_COPY_NAME)
>  		kfree(sd->s_name);
> +	if (sd->s_iattr && sd->s_iattr->ia_secdata)
> +		security_release_secctx(sd->s_iattr->ia_secdata,
> +					sd->s_iattr->ia_secdata_len);
>  	kfree(sd->s_iattr);
>  	sysfs_free_ino(sd->s_ino);
>  	kmem_cache_free(sysfs_dir_cachep, sd);
> -- 
> 1.6.5.2.143.g8cc62
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
