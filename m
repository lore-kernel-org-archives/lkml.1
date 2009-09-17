Return-Path: <linux-kernel-owner+w=401wt.eu-S1758050AbZIQG7d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758050AbZIQG7d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 02:59:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756006AbZIQG7c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 02:59:32 -0400
Received: from mail-qy0-f192.google.com ([209.85.221.192]:57311 "EHLO
	mail-qy0-f192.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755930AbZIQG7c convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 02:59:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=XptUw2AzZQjRtI+LJZeY2q+kPtmCfHnpisDmEForlbDKZCxOT3S3dEdK9WP4yhQ4Xt
         enrcEPLtZ8O3JI5cI0jfCiggtDBIaCBRSGii7ppUFwjDZ0tKB3+Jn8sc3hONg7JTHNTj
         92DxdzMhDQNLnFotUUYyHoAR4QY5rE7QzIeSQ=
MIME-Version: 1.0
In-Reply-To: <20090917114509.a9eb9f2c.kamezawa.hiroyu@jp.fujitsu.com>
References: <2375c9f90909160235m1f052df0qb001f8243ed9291e@mail.gmail.com>
	 <1bc66b163326564dafb5a7dd8959fd56.squirrel@webmail-b.css.fujitsu.com>
	 <20090917114138.e14a1183.kamezawa.hiroyu@jp.fujitsu.com>
	 <20090917114509.a9eb9f2c.kamezawa.hiroyu@jp.fujitsu.com>
Date: Thu, 17 Sep 2009 14:59:35 +0800
Message-ID: <2375c9f90909162359m14ec7640m88ddd7ba54d6e793@mail.gmail.com>
Subject: Re: [PATCH 3/3][mmotm] updateing size of kcore
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 17, 2009 at 10:45 AM, KAMEZAWA Hiroyuki
<kamezawa.hiroyu@jp.fujitsu.com> wrote:
>
> After memory hotplug (or other events in future), kcore size
> can be modified.
>
> To update inode->i_size, we have to know inode/dentry but we
> can't get it from inside /proc directly.
> But considerinyg memory hotplug, kcore image is updated only when
> it's opened. Then, updating inode->i_size at open() is enough.
>
> Cc: WANG Cong <xiyou.wangcong@gmail.com>
> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>


This patch looks fine.

However, I am thinking if kcore is the only file under /proc whose size
is changed dynamically? If no, that probably means we need to change
generic proc code.

Thanks!

> ---
>  fs/proc/kcore.c |    5 +++++
>  1 file changed, 5 insertions(+)
>
> Index: mmotm-2.6.31-Sep14/fs/proc/kcore.c
> ===================================================================
> --- mmotm-2.6.31-Sep14.orig/fs/proc/kcore.c
> +++ mmotm-2.6.31-Sep14/fs/proc/kcore.c
> @@ -546,6 +546,11 @@ static int open_kcore(struct inode *inod
>                return -EPERM;
>        if (kcore_need_update)
>                kcore_update_ram();
> +       if (i_size_read(inode) != proc_root_kcore->size) {
> +               mutex_lock(&inode->i_mutex);
> +               i_size_write(inode, proc_root_kcore->size);
> +               mutex_unlock(&inode->i_mutex);
> +       }
>        return 0;
>  }
>
>
>
