Return-Path: <linux-kernel-owner+w=401wt.eu-S1753175AbYH0EbS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753175AbYH0EbS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 00:31:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750904AbYH0EbH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 00:31:07 -0400
Received: from wf-out-1314.google.com ([209.85.200.172]:13991 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750903AbYH0EbG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 00:31:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:cc:subject:references
         :in-reply-to:content-type:content-transfer-encoding;
        b=tN016k//QuY7nUCVqTWySpDAAgyZDYx7iMXmGCwe+v4RhkOmtmFOpt+aPFYZQOPJ66
         W+wSZ17701d2Z/Z9UJIwDfYARwN/6wJUFT794fET0de2DtxmOJxwPhk9FjPFl8X/z7nz
         i6O9tCr83C4jv/KuFpBMTFeTrk5JWxI+JUJHA=
Message-ID: <48B4D884.5040204@gmail.com>
Date: Tue, 26 Aug 2008 21:31:00 -0700
From: Zev Weiss <zevweiss@gmail.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
CC: Andrew Morton <akpm@linux-foundation.org>, linux-mtd@lists.infradead.org,
       linux-kernel@vger.kernel.org, Rodolfo Giometti <giometti@enneenne.com>,
       David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH] [MTD] mtdchar.c: Fix regression in MEMGETREGIONINFO ioctl()
References: <48ABCC0B.40607@gmail.com>	<20080822153451.bb79bd1f.akpm@linux-foundation.org>	<48AFC5ED.50005@gmail.com> <20080823222707.2fb972b5.akpm@linux-foundation.org> <48B13F88.3080306@gmail.com>
In-Reply-To: <48B13F88.3080306@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Zev Weiss wrote:
> Andrew Morton wrote:
>  > On Sat, 23 Aug 2008 01:10:21 -0700 Zev Weiss <zevweiss@gmail.com> wrote:
>  >
>  >> Hmm.  Well, I may be misunderstanding what you're saying (again, I'm 
> very much
>  >> a newbie to kernelspace), but I *think* the "copying four u32's out to
>  >> userspace" thing isn't really a problem with my patch.  It does 
> certainly copy
>  >> those four u32's, but given that `ur' (struct mtd_region_info_user) is
>  >> initialized by copying from userspace, its fourth u32 (the 
> `regionindex'
>  >> member) should be identical when copied back out to userspace, given 
> that it's
>  >> not touched in the memberwise modification of the struct.
>  >
>  > OK, that's fortuitously bug-free in single-threaded userspace but
>  > fantastically-improbably-buggy if userspace is threaded.
>  >
>  > But it's something the kernel shouldn't be doing.
>  >
> 
> Ah, good point -- that hadn't occurred to me at all.  Though it looks 
> pretty
> clumsy/simpleminded to me, I guess something like this would avoid 
> copying and rewriting the fourth u32 ("Well, duh" may be the appropriate 
> response here):
> 
> diff --git a/drivers/mtd/mtdchar.c b/drivers/mtd/mtdchar.c
> index 13cc67a..424f318 100644
> --- a/drivers/mtd/mtdchar.c
> +++ b/drivers/mtd/mtdchar.c
> @@ -410,16 +410,20 @@ static int mtd_ioctl(struct inode *inode, struct 
> file *file,
> 
>         case MEMGETREGIONINFO:
>         {
> -               struct region_info_user ur;
> +               u32 ur_idx;
> +               struct mtd_erase_region_info *kr;
> +               struct region_info_user *ur = (struct region_info_user 
> *) argp;
> 
> -               if (copy_from_user(&ur, argp, sizeof(struct 
> region_info_user)))
> +               if (get_user(ur_idx,&(ur->regionindex)))
>                         return -EFAULT;
> 
> -               if (ur.regionindex >= mtd->numeraseregions)
> -                       return -EINVAL;
> -               if (copy_to_user(argp, 
> &(mtd->eraseregions[ur.regionindex]),
> -                               sizeof(struct mtd_erase_region_info)))
> +               kr = &(mtd->eraseregions[ur_idx]);
> +
> +               if (put_user(kr->offset, &(ur->offset))
> +                   || put_user(kr->erasesize, &(ur->erasesize))
> +                   || put_user(kr->numblocks, &(ur->numblocks)))
>                         return -EFAULT;
> +
>                 break;
>         }
> 
> 
> [Note: this is not even so much as compile-tested, and will remain that way
> until Monday, but I think you get the picture.]
> 

Well, for what little it's probably worth, I've now tested this patch, with no 
resulting surprises (seems to work fine for me).  Though I see now that, much to 
my chagrin, something in my email chain seems to have spacified my code.  If 
there's any need I can resend appropriately.

Zev
