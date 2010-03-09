Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756402Ab0CIBLh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 20:11:37 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:36592 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756322Ab0CIBLd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 20:11:33 -0500
Date: Tue, 09 Mar 2010 10:11:21 +0900 (JST)
Message-Id: <20100309.101121.193684481.d.hatayama@jp.fujitsu.com>
To: petkovbb@googlemail.com
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fs, binfmt_aout: Fix pointer warnings
From: Daisuke HATAYAMA <d.hatayama@jp.fujitsu.com>
In-Reply-To: <20100308154601.GA30454@a1.tnic>
References: <20100308154601.GA30454@a1.tnic>
X-Mailer: Mew version 6.2 on Emacs 22.2 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=utf-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id o291BjmE024284

Thanks for your report.

From: Borislav Petkov <petkovbb@googlemail.com>
Subject: [PATCH] fs, binfmt_aout: Fix pointer warnings
Date: Mon, 8 Mar 2010 16:46:01 +0100

> Hi,
> 
> I'm getting the warnings in the commit message below with current git. Maybe fix
> them like this:
> 
> --
> From: Borislav Petkov <petkovbb@gmail.com>
> Date: Mon, 8 Mar 2010 16:37:42 +0100
> Subject: [PATCH] fs, binfmt_aout: Fix pointer warnings
> MIME-Version: 1.0
> Content-Type: text/plain; charset=UTF-8
> Content-Transfer-Encoding: 8bit
> 
> I get
> 
> fs/binfmt_aout.c: In function â€˜aout_core_dumpâ€™:
> fs/binfmt_aout.c:125: warning: passing argument 2 of â€˜dump_writeâ€™ makes pointer from integer without a cast
> include/linux/coredump.h:12: note: expected â€˜const void *â€™ but argument is of type â€˜long unsigned intâ€™
> fs/binfmt_aout.c:132: warning: passing argument 2 of â€˜dump_writeâ€™ makes pointer from integer without a cast
> include/linux/coredump.h:12: note: expected â€˜const void *â€™ but argument is of type â€˜long unsigned intâ€™
> 
> due to dump_write() expecting a user void *. Fold casts into the
> START_DATA/START_STACK macros and shut up the warnings.
> 
> Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
> ---
>  fs/binfmt_aout.c |   14 ++++++++------
>  1 files changed, 8 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/binfmt_aout.c b/fs/binfmt_aout.c
> index 15d80bb..9b6aef0 100644
> --- a/fs/binfmt_aout.c
> +++ b/fs/binfmt_aout.c
> @@ -75,14 +75,16 @@ static int aout_core_dump(struct coredump_params *cprm)
>  	struct file *file = cprm->file;
>  	mm_segment_t fs;
>  	int has_dumped = 0;
> -	unsigned long dump_start, dump_size;
> +	void __user *dump_start;
> +	int dump_size;
>  	struct user dump;
>  #ifdef __alpha__
> -#       define START_DATA(u)	(u.start_data)
> +#       define START_DATA(u)	((void __user *)u.start_data)
>  #else
> -#	define START_DATA(u)	((u.u_tsize << PAGE_SHIFT) + u.start_code)
> +#	define START_DATA(u)	((void __user *)((u.u_tsize << PAGE_SHIFT) + \
> +				 u.start_code))
>  #endif
> -#       define START_STACK(u)   (u.start_stack)
> +#       define START_STACK(u)   ((void __user *)u.start_stack)
>  
>  	fs = get_fs();
>  	set_fs(KERNEL_DS);
> @@ -104,9 +106,9 @@ static int aout_core_dump(struct coredump_params *cprm)
>  
>  /* make sure we actually have a data and stack area to dump */
>  	set_fs(USER_DS);
> -	if (!access_ok(VERIFY_READ, (void __user *)START_DATA(dump), dump.u_dsize << PAGE_SHIFT))
> +	if (!access_ok(VERIFY_READ, START_DATA(dump), dump.u_dsize << PAGE_SHIFT))
>  		dump.u_dsize = 0;
> -	if (!access_ok(VERIFY_READ, (void __user *)START_STACK(dump), dump.u_ssize << PAGE_SHIFT))
> +	if (!access_ok(VERIFY_READ, START_STACK(dump), dump.u_ssize << PAGE_SHIFT))
>  		dump.u_ssize = 0;

Your fixing looks reasonable to me. I understand your patch set as
follows.

 - The START_DATA() and START_STACK() macro calls are all passed to
   the arguments of type (void *), meaning that they need casts in
   the appropreate positions.

 - Moreover, they are more natural to be used directly as (void *)
   than to be casted outside the macro.

Thanks.

>  
>  	set_fs(KERNEL_DS);
> -- 
> 1.6.6.1
> 
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
