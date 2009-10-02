Return-Path: <linux-kernel-owner+w=401wt.eu-S1755537AbZJBMHx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755537AbZJBMHx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 08:07:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753625AbZJBMHx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 08:07:53 -0400
Received: from mail-bw0-f210.google.com ([209.85.218.210]:37044 "EHLO
	mail-bw0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754218AbZJBMHw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 08:07:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=KHLDIX1SoyfTzARcPiaPuYtYg2SzrDfSEcVbjz+cGzHxxDS6TYeS3UQU2d/RwPRdCR
         ZePDU+7VznHO1YM4NkQ8qjFImgj4nK/oeHVy7+KAVD19+lhP17psORs9oR+SSV0O3cwR
         4CwSFbQV9bKMBHMEHdd0FXUhPYsaJWJmKdMjQ=
MIME-Version: 1.0
In-Reply-To: <1254483680-25578-1-git-send-email-aaro.koskinen@nokia.com>
References: <1254483680-25578-1-git-send-email-aaro.koskinen@nokia.com>
Date: Fri, 2 Oct 2009 14:07:55 +0200
Message-ID: <c62985530910020507u43413e6aj2388771e7caeed01@mail.gmail.com>
Subject: Re: [PATCH] panic: call bust_spinlocks(0) before dying
From: =?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>
To: Aaro Koskinen <aaro.koskinen@nokia.com>
Cc: mingo@elte.hu, akpm@linux-foundation.org, arjan@linux.intel.com,
       ak@linux.intel.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/10/2 Aaro Koskinen <aaro.koskinen@nokia.com>:
> Commit ffd71da4e3f323b7673b061e6f7e0d0c12dc2b49 moved bust_spinlocks(0)
> to the end of the function, which in practice is never reached. As a
> result console_unblank() is not called, and on some systems the user
> may not see the panic message.


Indeed.


> Signed-off-by: Aaro Koskinen <aaro.koskinen@nokia.com>
> ---
>  kernel/panic.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
>
> diff --git a/kernel/panic.c b/kernel/panic.c
> index bcdef26..96b45d0 100644
> --- a/kernel/panic.c
> +++ b/kernel/panic.c
> @@ -90,6 +90,8 @@ NORET_TYPE void panic(const char * fmt, ...)
>
>        atomic_notifier_call_chain(&panic_notifier_list, 0, buf);
>
> +       bust_spinlocks(0);
> +

And it looks like the right place to do that. The rest that is going
to be displayed
is messages about countdown before reboot. The most important messages
have been printk'ed already.

Reviewed-by: Frederic Weisbecker <fweisbec@gmail.com>


>        if (!panic_blink)
>                panic_blink = no_blink;
>
> @@ -136,7 +138,6 @@ NORET_TYPE void panic(const char * fmt, ...)
>                mdelay(1);
>                i++;
>        }
> -       bust_spinlocks(0);
>  }
>
>  EXPORT_SYMBOL(panic);
> --
> 1.5.4.3
>
>
