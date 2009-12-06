Return-Path: <linux-kernel-owner+w=401wt.eu-S934273AbZLFVa5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934273AbZLFVa5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 16:30:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934221AbZLFVa4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 16:30:56 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:34378 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934216AbZLFVaz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 16:30:55 -0500
Date: Sun, 6 Dec 2009 10:51:31 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Philip Wernersbach <philip.wernersbach@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ext2/3 as ext4
Message-ID: <20091206095130.GA3317@ucw.cz>
References: <1daf33050912011730l5def95brac3ce60647bc2040@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1daf33050912011730l5def95brac3ce60647bc2040@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi!

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
> 
> Let me know if you use this patch, if enough people use it I will
> write a proper KCONFIG and submit it for inclusion into the kernel.
> 
> So without further ado, here is the patch.
> 
> Sincerely,
> Philip Wernersbach <philip.wernersbach@gmail.com>

(I believe patch was whitespace damaged).

> --- linux-2.6.31.6.orig/fs/namespace.c  2009-11-28 22:30:07.178682500 -0500
> +++ linux-2.6.31.6/fs/namespace.c       2009-11-28 22:32:42.813462139 -0500
> @@ -6,6 +6,8 @@
>  *
>  * Based on code from fs/super.c, copyright Linus Torvalds and others.
>  * Heavily rewritten.
> + *
> + * Uses ext2/3 as ext4 patch by Philip Wernersbach (November 2009)
>  */
> 

Add yourself to the CREDITS; we don't use comments for changelog these days.

> +/*
> + * compare_fs_names(char *fs1, char *fs2) - Part of the ext2/3 as ext4 patch
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

Ouch?

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

Can you use memcmp, instead?

> @@ -1891,6 +1921,22 @@
>        struct path path;
>        int retval = 0;
>        int mnt_flags = 0;
> +
> +       /*
> +        * This causes ext2 filesystems to be mounted with the ext4 driver.
> +        *
> +        * Part of the ext2/3 as ext4 patch.
> +        */
> +       if (compare_fs_names(type_page, "ext2") == 0)
> +               type_page[3] = '4';

Actualy strcmp() may be appropriate.

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
