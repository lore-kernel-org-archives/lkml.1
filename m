Return-Path: <linux-kernel-owner+w=401wt.eu-S1750999AbXCZHHQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750999AbXCZHHQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 03:07:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751747AbXCZHHQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 03:07:16 -0400
Received: from wx-out-0506.google.com ([66.249.82.224]:37605 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750999AbXCZHHO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 03:07:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=HpfOxuEKLJJpxsGL7OgUAhgWG893PH0qX9x0UVUb2QZmu4//d4OWyDK5Kn6R16Slb0EQYknFLmSc82/KSkDQfIXRF7WcttdsF8HLl5AY1LNG7AFd9EjDYDYkR2jK/s5W3HDRqklaBRvhi6GEGSqhb78S23+fGG8lA694Sgs7iM4=
Message-ID: <2fe399760703260007u7cea0599y7bcce8f779e02c71@mail.gmail.com>
Date: Mon, 26 Mar 2007 00:07:13 -0700
From: "Phy Prabab" <phyprabab@gmail.com>
To: "Neil Brown" <neilb@suse.de>
Subject: Re: Opps in 2.6.21-rc4 nfsd
Cc: "Adrian Bunk" <bunk@stusta.de>, linux-kernel@vger.kernel.org,
       nfs@lists.sourceforge.net
In-Reply-To: <17927.7414.722426.438730@notabene.brown>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <2fe399760703221224g40fc44ddof41d1fcd442612d5@mail.gmail.com>
	 <20070323152913.GH752@stusta.de>
	 <2fe399760703230845s4f652df0v9fd57e1aa7943e4e@mail.gmail.com>
	 <17927.6359.721594.133569@notabene.brown>
	 <17927.7414.722426.438730@notabene.brown>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Opps, forgot, this is for 2.6.20.x, guess I'll wait for the updated patch.

Thanks!
Phy

On 3/25/07, Neil Brown <neilb@suse.de> wrote:
> On Monday March 26, neilb@suse.de wrote:
> >
> > I'll try to have a patch for you to try on 2.6.21rc4 shortly.
> >
>
> This patch should remove the Oops, but I have a suspicion that
> something else is wrong, so I'd be very interested if you could run
> with this for a few days and report the results.
>
> NeilBrown
>
> Signed-off-by: Neil Brown <neilb@suse.de>
>
> ### Diffstat output
>  ./fs/nfsd/nfsfh.c |   37 +++++++++++++++++++++++++++++++++++--
>  1 file changed, 35 insertions(+), 2 deletions(-)
>
> diff .prev/fs/nfsd/nfsfh.c ./fs/nfsd/nfsfh.c
> --- .prev/fs/nfsd/nfsfh.c       2007-03-26 10:51:01.000000000 +1000
> +++ ./fs/nfsd/nfsfh.c   2007-03-26 11:04:20.000000000 +1000
> @@ -324,7 +324,7 @@ fh_compose(struct svc_fh *fhp, struct sv
>          *
>          */
>
> -       u8 version = 1;
> +       u8 version;
>         u8 fsid_type = 0;
>         struct inode * inode = dentry->d_inode;
>         struct dentry *parent = dentry->d_parent;
> @@ -342,12 +342,45 @@ fh_compose(struct svc_fh *fhp, struct sv
>          * the reference filehandle (if it is in the same export)
>          * or the export options.
>          */
> + retry:
> +       version = 1;
>         if (ref_fh && ref_fh->fh_export == exp) {
>                 version = ref_fh->fh_handle.fh_version;
>                 if (version == 0xca)
>                         fsid_type = FSID_DEV;
> -               else
> +               else {
>                         fsid_type = ref_fh->fh_handle.fh_fsid_type;
> +                       /* need to check that this type works for this
> +                        * export point.  As the lookup was done with
> +                        * help from user-space, there is no guarantee
> +                        */
> +                       if (ref_fh == fhp)
> +                               fh_put(ref_fh);
> +                       ref_fh = NULL;
> +                       switch(fsid_type) {
> +                       case FSID_DEV:
> +                               if (!old_valid_dev(ex_dev))
> +                                       goto retry;
> +                               break;
> +                       case FSID_NUM:
> +                               if (! (exp->ex_flags & NFSEXP_FSID))
> +                                       goto retry;
> +                               break;
> +                       case FSID_MAJOR_MINOR:
> +                       case FSID_ENCODE_DEV:
> +                               break;
> +                       case FSID_UUID8:
> +                       case FSID_UUID16:
> +                               if (!root_export)
> +                                       goto retry;
> +                               /* fall through */
> +                       case FSID_UUID4_INUM:
> +                       case FSID_UUID16_INUM:
> +                               if (exp->ex_uuid == NULL)
> +                                       goto retry;
> +                               break;
> +                       }
> +               }
>                 /* We know this version/type works for this export
>                  * so there is no need for further checks.
>                  */
>
