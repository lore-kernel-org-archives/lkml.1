Return-Path: <linux-kernel-owner+w=401wt.eu-S1756536AbYGLDMl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756536AbYGLDMl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 23:12:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752931AbYGLDMd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 23:12:33 -0400
Received: from nf-out-0910.google.com ([64.233.182.184]:23681 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752665AbYGLDMc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 23:12:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=u9PcsJKMF/NJfkTaEsgqg1VfPUc5whFo3cl4hNQX94x1OPZA+0xO1CPMAjzB3BJAeD
         aoguTRNAtXoX2C8fxWktb/bz/HOeEIE+2mvGKoRHR4P0QTOUEaTOR0ui2FxOzsixgxuU
         t7B28JqXE95OHYsxoiV8zFwUxRp1m2ZVi841Q=
Message-ID: <6d291e080807112012r7ae44318oc41366b83d484b7f@mail.gmail.com>
Date: Fri, 11 Jul 2008 22:12:30 -0500
From: "Stoyan Gaydarov" <stoyboyker@gmail.com>
To: "Denis V. Lunev" <den@openvz.org>
Subject: Re: [PATCH 9/12] ipv4: assign PDE->data before gluing PDE into /proc tree
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       "Alexey Dobriyan" <adobriyan@openvz.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "David S. Miller" <davem@davemloft.net>
In-Reply-To: <1209467602-20001-9-git-send-email-den@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1209467538.29647.11.camel@iris.sw.ru>
	 <1209467602-20001-9-git-send-email-den@openvz.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

First off, sorry to bring such an old email back but I can seem to get
a bad feeling when looking back over it.

On Tue, Apr 29, 2008 at 6:13 AM, Denis V. Lunev <den@openvz.org> wrote:
> The check for PDE->data != NULL becomes useless after the replacement
> of proc_net_fops_create with proc_create_data.
>
> Signed-off-by: Denis V. Lunev <den@openvz.org>
> Cc: Alexey Dobriyan <adobriyan@openvz.org>
> Cc: Eric W. Biederman <ebiederm@xmission.com>
> Cc: David S. Miller <davem@davemloft.net>
> ---
>  net/ipv4/tcp_ipv4.c |   10 +++-------
>  net/ipv4/udp.c      |    7 +++----
>  2 files changed, 6 insertions(+), 11 deletions(-)
>
> diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
> index 7766151..4d97b28 100644
> --- a/net/ipv4/tcp_ipv4.c
> +++ b/net/ipv4/tcp_ipv4.c
> @@ -2214,9 +2214,6 @@ static int tcp_seq_open(struct inode *inode, struct file *file)
>        struct tcp_iter_state *s;
>        int err;
>
> -       if (unlikely(afinfo == NULL))
> -               return -EINVAL;
I think that this check needs to stay in some form, reason below.
> -
>        err = seq_open_net(inode, file, &afinfo->seq_ops,
>                          sizeof(struct tcp_iter_state));
>        if (err < 0)
> @@ -2241,10 +2238,9 @@ int tcp_proc_register(struct net *net, struct tcp_seq_afinfo *afinfo)
>        afinfo->seq_ops.next            = tcp_seq_next;
>        afinfo->seq_ops.stop            = tcp_seq_stop;
>
> -       p = proc_net_fops_create(net, afinfo->name, S_IRUGO, &afinfo->seq_fops);
> -       if (p)
> -               p->data = afinfo;
> -       else
> +       p = proc_create_data(afinfo->name, S_IRUGO, net->proc_net,

When you try to pass in afinfo->name (and also the seq_fops) you are
assuming that afinfo is not null meaning in the unlikely(as shown
above) even that it is null you get a very bad null pointer problem.
If I am just way off do let me know because this just seams to me like
a bad idea. This is also still present in 2.6.26-rc9.

-Stoyan G

> +                            &afinfo->seq_fops, afinfo);
> +       if (!p)
>                rc = -ENOMEM;
>        return rc;
>  }
> diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
> index b053ac7..c19c491 100644
> --- a/net/ipv4/udp.c
> +++ b/net/ipv4/udp.c
> @@ -1605,10 +1605,9 @@ int udp_proc_register(struct net *net, struct udp_seq_afinfo *afinfo)
>        afinfo->seq_ops.next            = udp_seq_next;
>        afinfo->seq_ops.stop            = udp_seq_stop;
>
> -       p = proc_net_fops_create(net, afinfo->name, S_IRUGO, &afinfo->seq_fops);
> -       if (p)
> -               p->data = afinfo;
> -       else
> +       p = proc_create_data(afinfo->name, S_IRUGO, net->proc_net,
> +                            &afinfo->seq_fops, afinfo);
> +       if (!p)
>                rc = -ENOMEM;
>        return rc;
>  }
> --
> 1.5.3.rc5
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
