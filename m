Return-Path: <linux-kernel-owner+w=401wt.eu-S1756581AbXGRO3b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756581AbXGRO3b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 10:29:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752816AbXGRO3X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 10:29:23 -0400
Received: from wa-out-1112.google.com ([209.85.146.180]:2574 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752319AbXGRO3W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 10:29:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=OLxM6MtFFfa0q2CbvA6K8rxEpLJCDH+4RZ3cKSeGkEZ6uwOKquDFoXHBmRbRNmgwmzkIHPRJyjFEfg6Q6b6hz6G8i2DNn4g5TV+jOe0LbljL7kO1sZ+jvZ8y20EXPhH+hQOk7cqpny4gbK5F+tX8oHsxO8mOCoClB1PuQP3ENIU=
Message-ID: <a44ae5cd0707180729q1cd48c72ya26f6ca7c3e19265@mail.gmail.com>
Date: Wed, 18 Jul 2007 07:29:17 -0700
From: "Miles Lane" <miles.lane@gmail.com>
To: "Tejun Heo" <htejun@gmail.com>
Subject: Re: [PATCH] sysfs: kill an extra put in sysfs_create_link() failure path
Cc: "Gabriel C" <nix.or.die@googlemail.com>,
       "Satyam Sharma" <satyam.sharma@gmail.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Christoph Lameter" <clameter@sgi.com>, gregkh@suse.de
In-Reply-To: <20070718071445.GI23568@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <a781481a0707142239l397672c6p4fd1dc8dfb73e07c@mail.gmail.com>
	 <a781481a0707151414l3efcd2d0q93db88a32b90e344@mail.gmail.com>
	 <469A9D5D.10509@googlemail.com> <469B61C8.8010902@googlemail.com>
	 <a781481a0707160819w1be9128cxb3cdd06ba068b20d@mail.gmail.com>
	 <469BB7B8.3060002@gmail.com> <469BB9CA.6090500@googlemail.com>
	 <469BC2D6.5090008@googlemail.com> <469BC34C.4080107@googlemail.com>
	 <20070718071445.GI23568@htj.dyndns.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/18/07, Tejun Heo <htejun@gmail.com> wrote:
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
>         sd = sysfs_new_dirent(name, S_IFLNK|S_IRWXUGO, SYSFS_KOBJ_LINK);
>         if (!sd)
>                 goto out_put;
> +
>         sd->s_elem.symlink.target_sd = target_sd;
> +       target_sd = NULL;       /* reference is now owned by the symlink */
>
>         sysfs_addrm_start(&acxt, parent_sd);
>
> diff --git a/net/core/net-sysfs.c b/net/core/net-sysfs.c
>

Great!  I tested with both patches applied to 2.6.22-rc6-mm1 and was
able to remove ipw2200 without triggering the BUG.

Thanks,
            Miles
