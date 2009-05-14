Return-Path: <linux-kernel-owner+w=401wt.eu-S1761350AbZENMEk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761350AbZENMEk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 08:04:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755845AbZENMEb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 08:04:31 -0400
Received: from wf-out-1314.google.com ([209.85.200.171]:36908 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754930AbZENMEa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 08:04:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=s+fHqgbn73dqs77uwTEYxvioIUrtYzFi3eFG5PuPixefhnDsSXUJ1SDeWTczfF2GMG
         s7/pkwa0MllNy4IsVC6Zp2Myin/Mif3Kt/mBXmwaV3tcss8ohhEwCR7TEBL5bz3m99ay
         x8oSDYkVTgRmFglJTGE/nIf1jUav7AQCeUyOs=
MIME-Version: 1.0
In-Reply-To: <a8e1da0905102316v1037c89cs48cb052924c250a9@mail.gmail.com>
References: <a8e1da0905102316v1037c89cs48cb052924c250a9@mail.gmail.com>
Date: Thu, 14 May 2009 20:04:31 +0800
Message-ID: <a8e1da0905140504x1d1d99ebq911018d5aaa80a16@mail.gmail.com>
Subject: Re: [PATCH 1/3] kobject : kobject_set_name_vargs leak fix
From: Dave Young <hidave.darkstar@gmail.com>
To: Greg KH <gregkh@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 11, 2009 at 2:16 PM, Dave Young <hidave.darkstar@gmail.com> wrote:
> kobject_set_name_vargs will leak the old_name when return -ENOMEM,
> move the kfree(old_name) before the return path.

Hi, greg

I rethought about this problem, does such issue exist really? I means
that kobject->name != NULL scenario.

there's following comments of this function:

 * This sets the name of the kobject.  If you have already added the
 * kobject to the system, you must call kobject_rename() in order to
 * change the name of the kobject

So what if something like :

if (kobject->name) {
 WARN(1, KERN_WARNING, "there's name for kobject already!");
 return -EINVAL;
}

if (!fmt)
 return 0;

>
> Signed-off-by: Dave Young <hidave.darkstar@gmail.com>
> ---
> lib/kobject.c |    2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff -uprN linux.old/lib/kobject.c linux.new/lib/kobject.c
> --- linux.old/lib/kobject.c     2009-05-11 13:59:01.000000000 +0800
> +++ linux.new/lib/kobject.c     2009-05-11 13:59:34.000000000 +0800
> @@ -221,6 +221,7 @@ int kobject_set_name_vargs(struct kobjec
>        if (kobj->name && !fmt)
>                return 0;
>
> +       kfree(old_name);
>        kobj->name = kvasprintf(GFP_KERNEL, fmt, vargs);
>        if (!kobj->name)
>                return -ENOMEM;
> @@ -229,7 +230,6 @@ int kobject_set_name_vargs(struct kobjec
>        while ((s = strchr(kobj->name, '/')))
>                s[0] = '!';
>
> -       kfree(old_name);
>        return 0;
>  }
>



-- 
Regards
dave
