Return-Path: <linux-kernel-owner+w=401wt.eu-S1754047AbZLBB6F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754047AbZLBB6F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 20:58:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753071AbZLBB6E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 20:58:04 -0500
Received: from mail-vw0-f197.google.com ([209.85.212.197]:35901 "EHLO
	mail-vw0-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753719AbZLBB6D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 20:58:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=uVHccsHCp4Z2xfYFnxS/ZZfpz1grKRRmb81XeRi91qZ9QsgRofSeiFMaD90a6Rvj5W
         tyz1DJDdhGl8LyT2Rs1wWXLL0iB+H2O0Cob6HWJ9QDABETLa4mWf2zYewfOy7rwK0cWM
         aOvpMXSSFWjzQE1C1thTFKdpWi0WQubfNNfyI=
Message-ID: <4B15C9AD.3080004@gmail.com>
Date: Tue, 01 Dec 2009 18:58:05 -0700
From: Richard Holden <aciddeath@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Philip Wernersbach <philip.wernersbach@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ext2/3 as ext4
References: <1daf33050912011730l5def95brac3ce60647bc2040@mail.gmail.com>
In-Reply-To: <1daf33050912011730l5def95brac3ce60647bc2040@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Philip Wernersbach wrote:
> Hello Everyone,
>      Below is a small patch I wrote for kernel version 2.6.31.6. It
> causes ext2/3 filesystems to be mounted using the ext4 driver, in a
> way that is transparent to the userspace (and kernelspace for that
> matter, as long as the code uses the kernel's mounting API) and
> requires no change to the userspace (/kernelspace). This patch is
> useful because: 1) It allows minimalist kernel fanatics, like myself,
> to drop 2 drivers from their builds without any loss in functionality.
> 2) It allows the ext2/3 filesystems to take advantage of the
> performance/general improvements in the ext4 driver. 3) In the future,
> with this patch, the ext2/3 driver code could be dropped from the
> kernel without any loss in functionality. I have been using this patch
> for 2 months now with no flaws on my home Linux box, which uses ext3
> drives on a daily basis.

I will have to give this a try on few of my dev boxes and see how it
works out.

> Let me know if you use this patch, if enough people use it I will
> write a proper KCONFIG and submit it for inclusion into the kernel.
>
> So without further ado, here is the patch.
>
> Sincerely,
> Philip Wernersbach <philip.wernersbach@gmail.com>
>
> --- linux-2.6.31.6.orig/fs/namespace.c  2009-11-28 22:30:07.178682500
-0500
> +++ linux-2.6.31.6/fs/namespace.c       2009-11-28 22:32:42.813462139
-0500
> @@ -6,6 +6,8 @@
>  *
>  * Based on code from fs/super.c, copyright Linus Torvalds and others.
>  * Heavily rewritten.
> + *
> + * Uses ext2/3 as ext4 patch by Philip Wernersbach (November 2009)
>  */
>
>  #include <linux/syscalls.h>
> @@ -1838,6 +1840,34 @@
>        return n;
>  }
>
> +/*
> + * compare_fs_names(char *fs1, char *fs2) - Part of the ext2/3 as
ext4 patch
> + *
> + * The following is a standard string compare function, made to compare
> + * filesystem names, it returns 0 if they equal, and 1 if they do not.
> + * It only handles strings up to 255 characters though, so be cautious.
> + */
> +static int compare_fs_names(char *fs1, char *fs2)
> +{
> +               int i;
> +
> +               if (fs1 == 0L || fs2 == 0L) return 1;
> +
> +               for (i=0;i<256;i++)
> +               {
> +                       if (fs1[i] != fs2[i])
> +                               return 1;
> +                       if (fs1[i] == 0 && fs2[i] == 0)
> +                               return 0;
> +                       if (fs1[i] == 0)
> +                               return 1;
> +                       if (fs2[i] == 0)
> +                               return 1;
> +               }
> +               return 0;
> +}
> +
> +

Why the open coded strcmp?

>  int copy_mount_options(const void __user * data, unsigned long *where)
>  {
>        int i;
> @@ -1891,6 +1921,22 @@
>        struct path path;
>        int retval = 0;
>        int mnt_flags = 0;
> +
> +       /*
> +        * This causes ext2 filesystems to be mounted with the ext4
driver.
> +        *
> +        * Part of the ext2/3 as ext4 patch.
> +        */
> +       if (compare_fs_names(type_page, "ext2") == 0)
> +               type_page[3] = '4';
> +
> +       /*
> +        * This causes ext3 filesystems to be mounted with the ext4
driver.
> +        *
> +        * Part of the ext2/3 as ext4 patch.
> +        */
> +       if (compare_fs_names(type_page, "ext3") == 0)
> +               type_page[3] = '4';

I would put these 2 conditionals into a single if ||, and consolidate
the type_page setting into 1 place, then you limit where you handle the
ext2/ext3 filesystems inside of ext4.

>
>        /* Discard magic */
>        if ((flags & MS_MGC_MSK) == MS_MGC_VAL)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-Richard Holden
