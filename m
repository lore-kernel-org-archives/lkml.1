Return-Path: <linux-kernel-owner+w=401wt.eu-S932714AbXGTHN3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932714AbXGTHN3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 03:13:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758076AbXGTHNR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 03:13:17 -0400
Received: from nz-out-0506.google.com ([64.233.162.228]:7310 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758079AbXGTHNP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 03:13:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=CUvP21RpUbv+lfJJoqsB7biOjsZcnbNzR2wIWBJajADNiCBAGglb7hD1mXvL3KwUKAb3jrBrIsnONpv5qJo8I6XQ3Yom5Xxubcm6ydZFd5oNIwjxCHuR+pSfOL9LA+BsBwNoQ3YgNonYObT/97oNATyIh4LmHoNq2t9EhxaUaHM=
Message-ID: <a781481a0707200013g5c2ce008ka63e18f775664984@mail.gmail.com>
Date: Fri, 20 Jul 2007 12:43:13 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Neil Brown" <neilb@suse.de>
Subject: Re: BUG: unable to handle kernel NULL pointer dereference - nfs v3
Cc: "David CHANIAL" <david.ml@euro-web.fr>,
       "Linux Kernel Mailinglist" <linux-kernel@vger.kernel.org>
In-Reply-To: <18080.22813.143226.671265@notabene.brown>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200707160638.15750.david.ml@euro-web.fr>
	 <18076.42052.961808.528867@notabene.brown>
	 <a781481a0707190711s58d7ab24xa53c6975d4172597@mail.gmail.com>
	 <a781481a0707190811y725ac900m13e9b6a02eab7b0@mail.gmail.com>
	 <18080.22813.143226.671265@notabene.brown>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 7/20/07, Neil Brown <neilb@suse.de> wrote:
> On Thursday July 19, satyam.sharma@gmail.com wrote:
> > Ugh, not a good day for me today ... my earlier conclusion was right,
> > but not the reasoning behind it ... hopefully this time I'll do better :-)
>
>
> Looks good.  Thanks for your helpful analysis.

Thanks, good to know I was of some help :-)

[ For pedantic correctness, of course, s/word/dword/ in the last mail,
considering "word" size is still 16-bit on i386 -- but then that's the
weird backward-compatibility nomenclature/behaviour of i386. ]

> > 0x34 bytes is the offset of ex_uuid in struct fh_export.
> > %ecx == 0, which means ex_uuid was NULL.
>
> Yup. That shouldn't happen, but I can see that it is possible.
>
> There was another case were ex_uuid could conceivably be referenced
> while NULL that I fixed a little while ago.  Looks like I need to fix
> this one too.  Something like the following.
>
> Thanks,
> NeilBrown
>
> Signed-off-by: Neil Brown <neilb@suse.de>
>
> ### Diffstat output
>  ./fs/nfsd/nfsfh.c |   20 +++++++++++++++-----
>  1 file changed, 15 insertions(+), 5 deletions(-)
>
> diff .prev/fs/nfsd/nfsfh.c ./fs/nfsd/nfsfh.c
> --- .prev/fs/nfsd/nfsfh.c       2007-07-13 17:41:48.000000000 +1000
> +++ ./fs/nfsd/nfsfh.c   2007-07-20 12:53:36.000000000 +1000
> @@ -566,13 +566,23 @@ enum fsid_source fsid_source(struct svc_
>         case FSID_DEV:
>         case FSID_ENCODE_DEV:
>         case FSID_MAJOR_MINOR:
> -               return FSIDSOURCE_DEV;
> +               if (fhp->fh_export->ex_dentry->d_inode->i_sb->s_type->fs_flags
> +                   & FS_REQUIRES_DEV)
> +                       return FSIDSOURCE_DEV;
> +               break;
>         case FSID_NUM:
> -               return FSIDSOURCE_FSID;
> -       default:
>                 if (fhp->fh_export->ex_flags & NFSEXP_FSID)
>                         return FSIDSOURCE_FSID;
> -               else
> -                       return FSIDSOURCE_UUID;
> +               break;
> +       default:
> +               break;
>         }
> +       /* either a UUID type filehandle, or the filehandle doesn't
> +        * match the export.
> +        */
> +       if (fhp->fh_export->ex_flags & NFSEXP_FSID)
> +               return FSIDSOURCE_FSID;
> +       if (fhp->fh_export->ex_uuid)
> +               return FSIDSOURCE_UUID;
> +       return FSIDSOURCE_DEV;
>  }
>

David, please try this and let us know if it solves your problems.

Thanks,
Satyam
