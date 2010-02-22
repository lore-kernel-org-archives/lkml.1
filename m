Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754278Ab0BVUVj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 15:21:39 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:62752 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754081Ab0BVUVi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 15:21:38 -0500
MIME-Version: 1.0
In-Reply-To: <1266519351-3218-3-git-send-email-andy.shevchenko@gmail.com>
References: <1266519351-3218-1-git-send-email-andy.shevchenko@gmail.com>
	 <1266519351-3218-2-git-send-email-andy.shevchenko@gmail.com>
	 <1266519351-3218-3-git-send-email-andy.shevchenko@gmail.com>
Date: Mon, 22 Feb 2010 15:21:36 -0500
Message-ID: <7e0fb38c1002221221xf8a2fb8ob3eb0098e8e75faf@mail.gmail.com>
Subject: Re: [PATCH 02/12] audit: use kernel's method to get byte in hex form
From: Eric Paris <eparis@parisplace.org>
To: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Andy Shevchenko <ext-andriy.shevchenko@nokia.com>, aviro@redhat.com,
       Eric Paris <eparis@redhat.com>, Steve Grubb <sgrubb@redhat.com>,
       dwalsh@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 18, 2010 at 1:55 PM, Andy Shevchenko
<andy.shevchenko@gmail.com> wrote:
> From: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>
>
> Signed-off-by: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>


It changes the case from ABCDEF to abcdef but there are a number of
userspace tools which might not be able to handle it, have you tested
any or all of these?  The two that come to mind are ausearch and
setroubleshoot, which I believe both may try to recreate pathnames
when they contain a space....

-Eric


> ---
>  kernel/audit.c |    8 +++-----
>  1 files changed, 3 insertions(+), 5 deletions(-)
>
> diff --git a/kernel/audit.c b/kernel/audit.c
> index 5feed23..160abad 100644
> --- a/kernel/audit.c
> +++ b/kernel/audit.c
> @@ -58,6 +58,7 @@
>  #include <linux/inotify.h>
>  #include <linux/freezer.h>
>  #include <linux/tty.h>
> +#include <linux/kernel.h>
>
>  #include "audit.h"
>
> @@ -1308,7 +1309,6 @@ void audit_log_n_hex(struct audit_buffer *ab, const unsigned char *buf,
>        int i, avail, new_len;
>        unsigned char *ptr;
>        struct sk_buff *skb;
> -       static const unsigned char *hex = "0123456789ABCDEF";
>
>        if (!ab)
>                return;
> @@ -1326,10 +1326,8 @@ void audit_log_n_hex(struct audit_buffer *ab, const unsigned char *buf,
>        }
>
>        ptr = skb_tail_pointer(skb);
> -       for (i=0; i<len; i++) {
> -               *ptr++ = hex[(buf[i] & 0xF0)>>4]; /* Upper nibble */
> -               *ptr++ = hex[buf[i] & 0x0F];      /* Lower nibble */
> -       }
> +       for (i=0; i<len; i++)
> +               ptr = pack_hex_byte(ptr, buf[i]);
>        *ptr = 0;
>        skb_put(skb, len << 1); /* new string is twice the old string */
>  }
> --
> 1.5.6.5
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
