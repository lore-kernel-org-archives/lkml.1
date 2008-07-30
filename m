Return-Path: <linux-kernel-owner+w=401wt.eu-S1759526AbYG3IRJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759526AbYG3IRJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 04:17:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752878AbYG3IQy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 04:16:54 -0400
Received: from smtp-out.google.com ([216.239.33.17]:44309 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752858AbYG3IQw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 04:16:52 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=R8PdjMueHwla8Q6fCKz3lYILpTeT1RxbIa1lBZNDdI9q8V4nM4Nqf+ykVIhOIU16x
	2E3Zwz7dq8Zme8QRRLCJg==
Message-ID: <6599ad830807300116x13c308bck80b0629e5808357f@mail.gmail.com>
Date: Wed, 30 Jul 2008 01:16:40 -0700
From: "Paul Menage" <menage@google.com>
To: "Li Zefan" <lizf@cn.fujitsu.com>
Subject: Re: [PATCH] cgroup: fix possible memory leak
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "Linux Containers" <containers@lists.linux-foundation.org>
In-Reply-To: <488D2D08.2090903@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <488D2D08.2090903@cn.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 27, 2008 at 7:20 PM, Li Zefan <lizf@cn.fujitsu.com> wrote:
> There's a leak if copy_from_user() returns failure.
>
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>

Acked-by: Paul Menage <menage@google.com>

Thanks, good catch.

> ---
>  kernel/cgroup.c |    7 +++++--
>  1 files changed, 5 insertions(+), 2 deletions(-)
>
> diff --git a/kernel/cgroup.c b/kernel/cgroup.c
> index 657f8f8..28debe4 100644
> --- a/kernel/cgroup.c
> +++ b/kernel/cgroup.c
> @@ -1424,14 +1424,17 @@ static ssize_t cgroup_write_string(struct cgroup *cgrp, struct cftype *cft,
>                if (buffer == NULL)
>                        return -ENOMEM;
>        }
> -       if (nbytes && copy_from_user(buffer, userbuf, nbytes))
> -               return -EFAULT;
> +       if (nbytes && copy_from_user(buffer, userbuf, nbytes)) {
> +               retval = -EFAULT;
> +               goto out;
> +       }
>
>        buffer[nbytes] = 0;     /* nul-terminate */
>        strstrip(buffer);
>        retval = cft->write_string(cgrp, cft, buffer);
>        if (!retval)
>                retval = nbytes;
> +out:
>        if (buffer != local_buffer)
>                kfree(buffer);
>        return retval;
> --
> 1.5.4.rc3
>
