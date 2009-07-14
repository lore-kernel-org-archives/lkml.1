Return-Path: <linux-kernel-owner+w=401wt.eu-S1755428AbZGNSaA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755428AbZGNSaA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 14:30:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755187AbZGNS37
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 14:29:59 -0400
Received: from mail-yx0-f184.google.com ([209.85.210.184]:62658 "EHLO
	mail-yx0-f184.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754230AbZGNS36 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 14:29:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=bUhRPVuj3LHrJ0sv+jV3AFrg7k66MwPFEDPsz+AAXjvv1k1zR6d8Lk9vS+xyS3UWQE
         bcG6GsX9sO7GslIpvRZrQ3buFGWQfeYbn/xc1X4EBb0PvsnbiDPwvKDLXRdc0Uy/5aCq
         0Q46TI9Qz6bx4Hea+KIh6zRoibOPF0oEF3Zps=
MIME-Version: 1.0
In-Reply-To: <1247492991-26009-1-git-send-email-adkulkar@umail.iu.edu>
References: <1247492991-26009-1-git-send-email-adkulkar@umail.iu.edu>
Date: Tue, 14 Jul 2009 13:29:57 -0500
Message-ID: <a4e6962a0907141129r7c7fd19jb6da6ff229433a13@mail.gmail.com>
Subject: Re: [PATCH] [net/9p] Possible regression in p9_client_stat
From: Eric Van Hensbergen <ericvh@gmail.com>
To: Abhishek Kulkarni <adkulkar@umail.iu.edu>
Cc: linux-kernel@vger.kernel.org, v9fs-developer@lists.sourceforge.net,
       netdev@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

applied v9fs-devel

On Mon, Jul 13, 2009 at 8:49 AM, Abhishek Kulkarni<adkulkar@umail.iu.edu> wrote:
> Fix a possible regression with p9_client_stat where it can try to kfree an ERR_PTR
> after an erroneous p9pdu_readf. Also remove an unnecessary data buffer increment
> in p9_client_read.
>
> Signed-off-by: Abhishek Kulkarni <adkulkar@umail.iu.edu>
> ---
> :100644 100644 dd43a82... cc25e63... M  net/9p/client.c
>  net/9p/client.c |    7 ++-----
>  1 files changed, 2 insertions(+), 5 deletions(-)
>
> diff --git a/net/9p/client.c b/net/9p/client.c
> index dd43a82..cc25e63 100644
> --- a/net/9p/client.c
> +++ b/net/9p/client.c
> @@ -1098,7 +1098,6 @@ p9_client_read(struct p9_fid *fid, char *data, char __user *udata, u64 offset,
>
>        if (data) {
>                memmove(data, dataptr, count);
> -               data += count;
>        }
>
>        if (udata) {
> @@ -1192,9 +1191,9 @@ struct p9_wstat *p9_client_stat(struct p9_fid *fid)
>
>        err = p9pdu_readf(req->rc, clnt->dotu, "wS", &ignored, ret);
>        if (err) {
> -               ret = ERR_PTR(err);
>                p9pdu_dump(1, req->rc);
> -               goto free_and_error;
> +               p9_free_req(clnt, req);
> +               goto error;
>        }
>
>        P9_DPRINTK(P9_DEBUG_9P,
> @@ -1211,8 +1210,6 @@ struct p9_wstat *p9_client_stat(struct p9_fid *fid)
>        p9_free_req(clnt, req);
>        return ret;
>
> -free_and_error:
> -       p9_free_req(clnt, req);
>  error:
>        kfree(ret);
>        return ERR_PTR(err);
> --
> 1.6.0.4
>
>
