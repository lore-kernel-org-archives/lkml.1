Return-Path: <linux-kernel-owner+w=401wt.eu-S1760168AbZB0U4W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760168AbZB0U4W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 15:56:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759362AbZB0U4G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 15:56:06 -0500
Received: from mail-fx0-f176.google.com ([209.85.220.176]:58384 "EHLO
	mail-fx0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755650AbZB0U4F convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 15:56:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=L+yKwKWgN5zIczi6jD9nGFkm0cn3lCXfMHBe9QxxFnnxz7RTSySVHUb3uts9QvfzbX
         TDYKqxHS1BwnRBuCHFuIFSaOoDd605sf6kz86PJXbXCMy0GUFEhDjnlGBAOzyByuxoNJ
         vqurSVBvzO+si9caxjU44VCmDwM7suycFV9Ng=
MIME-Version: 1.0
In-Reply-To: <20090227203426.9F73083F@kernel>
References: <20090227203425.F3B51176@kernel> <20090227203426.9F73083F@kernel>
Date: Fri, 27 Feb 2009 21:56:00 +0100
Message-ID: <19f34abd0902271256r49a06336rcba56234c06645a7@mail.gmail.com>
Subject: Re: [RFC][PATCH 2/8] breakout fdinfo sprintf() into its own function
From: Vegard Nossum <vegard.nossum@gmail.com>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>,
       containers <containers@lists.linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Serge E. Hallyn" <serue@us.ibm.com>,
       Oren Laadan <orenl@cs.columbia.edu>,
       Alexey Dobriyan <adobriyan@gmail.com>, hch@infradead.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/2/27 Dave Hansen <dave@linux.vnet.ibm.com>:
>
> I'll be adding to this in a moment and it is in a bad place
> to do that cleanly now.
>
> Also, increase the buffer size.  Most /proc files can
> output up to a page, so use the same here.
>
> Signed-off-by: Dave Hansen <dave@linux.vnet.ibm.com>
> ---
>
>  linux-2.6.git-dave/fs/proc/base.c |   23 +++++++++++++++--------
>  1 file changed, 15 insertions(+), 8 deletions(-)
>
> diff -puN fs/proc/base.c~breakout-fdinfo fs/proc/base.c
> --- linux-2.6.git/fs/proc/base.c~breakout-fdinfo        2009-02-27 12:07:37.000000000 -0800
> +++ linux-2.6.git-dave/fs/proc/base.c   2009-02-27 12:07:37.000000000 -0800
> @@ -1632,7 +1632,18 @@ out:
>        return ~0U;
>  }
>
> -#define PROC_FDINFO_MAX 64
> +#define PROC_FDINFO_MAX PAGE_SIZE
> +
> +static void proc_fd_write_info(struct file *file, char *info)
> +{
> +       int max = PROC_FDINFO_MAX;
> +       int p = 0;
> +       if (!info)
> +               return;
> +
> +       p += snprintf(info+p, max-p, "pos:\t%lli\n", (long long) file->f_pos);
> +       p += snprintf(info+p, max-p, "flags:\t0%o\n", file->f_flags);

Actually, snprintf() is not the right function to use here.
scnprintf(), perhaps?


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
