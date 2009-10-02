Return-Path: <linux-kernel-owner+w=401wt.eu-S1755326AbZJBWBw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755326AbZJBWBw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 18:01:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753490AbZJBWBw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 18:01:52 -0400
Received: from smtp-out.google.com ([216.239.33.17]:59516 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754749AbZJBWBv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 18:01:51 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=QgY30ED0ELCbhgEzDXuCIYSdJoAUnXb+pKwEM5q1meQTzitY2jCFO9aY1uiAbD3LS
	LDQwEAd5lpImRlFK+a0kA==
MIME-Version: 1.0
In-Reply-To: <20091002173955.5F72.A69D9226@jp.fujitsu.com>
References: <20091002173635.5F6C.A69D9226@jp.fujitsu.com>
	 <20091002173955.5F72.A69D9226@jp.fujitsu.com>
Date: Fri, 2 Oct 2009 15:01:48 -0700
Message-ID: <6599ad830910021501s66cfc108r9a109b84b0f658a4@mail.gmail.com>
Subject: Re: [PATCH 3/3] cgroup: fix strstrip() abuse
From: Paul Menage <menage@google.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Li Zefan <lizf@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 2, 2009 at 1:41 AM, KOSAKI Motohiro
<kosaki.motohiro@jp.fujitsu.com> wrote:
> cgroup_write_X64() and cgroup_write_string() ignore the return
> value of strstrip().
> it makes small inconsistent behavior.
>
> example:
> =========================
>  # cd /mnt/cgroup/hoge
>  # cat memory.swappiness
>  60
>  # echo "59 " > memory.swappiness
>  # cat memory.swappiness
>  59
>  # echo " 58" > memory.swappiness
>  bash: echo: write error: Invalid argument
>
>
> This patch fixes it.
>
> Cc: Li Zefan <lizf@cn.fujitsu.com>
> Cc: Paul Menage <menage@google.com>
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

Acked-by: Paul Menage <menage@google.com>

Thanks - although I think I'd s/abuse/misuse/ in the description.

> ---
>  kernel/cgroup.c |    8 +++-----
>  1 file changed, 3 insertions(+), 5 deletions(-)
>
> Index: b/kernel/cgroup.c
> ===================================================================
> --- a/kernel/cgroup.c
> +++ b/kernel/cgroup.c
> @@ -1710,14 +1710,13 @@ static ssize_t cgroup_write_X64(struct c
>                return -EFAULT;
>
>        buffer[nbytes] = 0;     /* nul-terminate */
> -       strstrip(buffer);
>        if (cft->write_u64) {
> -               u64 val = simple_strtoull(buffer, &end, 0);
> +               u64 val = simple_strtoull(strstrip(buffer), &end, 0);
>                if (*end)
>                        return -EINVAL;
>                retval = cft->write_u64(cgrp, cft, val);
>        } else {
> -               s64 val = simple_strtoll(buffer, &end, 0);
> +               s64 val = simple_strtoll(strstrip(buffer), &end, 0);
>                if (*end)
>                        return -EINVAL;
>                retval = cft->write_s64(cgrp, cft, val);
> @@ -1753,8 +1752,7 @@ static ssize_t cgroup_write_string(struc
>        }
>
>        buffer[nbytes] = 0;     /* nul-terminate */
> -       strstrip(buffer);
> -       retval = cft->write_string(cgrp, cft, buffer);
> +       retval = cft->write_string(cgrp, cft, strstrip(buffer));
>        if (!retval)
>                retval = nbytes;
>  out:
>
>
>
