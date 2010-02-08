Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752253Ab0BHHIp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Feb 2010 02:08:45 -0500
Received: from mail-pz0-f172.google.com ([209.85.222.172]:63678 "EHLO
	mail-pz0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751488Ab0BHHIo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Feb 2010 02:08:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=BGs8nboJktj9/uTja/QnVhVUw64rbI6xQxNa1zO968lkPinbRhnYqbFHY3W0AurWKl
         rqEeiH88KYIwxTr+MaAhQVtmcBlWADhfP1iB36nOxw8mjVMVDa9akUGfn1ERWRZXaYWR
         AkgJrupwr1y5PteNBHPWS0QgEZeZlyRerCLY0=
MIME-Version: 1.0
In-Reply-To: <628d1651002072257m154de288y38158afe55ca1d07@mail.gmail.com>
References: <628d1651002072257m154de288y38158afe55ca1d07@mail.gmail.com>
Date: Mon, 8 Feb 2010 15:08:41 +0800
Message-ID: <7b6bb4a51002072308p7a1bc346m6b2647c73283527@mail.gmail.com>
Subject: Re: [PATCH] security/integrity/ima/ima_iint.c: Remove goto out int 
	ima_inode_alloc()
From: Xiaotian Feng <xtfeng@gmail.com>
To: wzt wzt <wzt.wzt@gmail.com>
Cc: linux-kernel@vger.kernel.org, zohar@us.ibm.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 8, 2010 at 2:57 PM, wzt wzt <wzt.wzt@gmail.com> wrote:
> Signed-off-by: wzt <zhitong.wangzt@alibaba-inc.com>
>
> diff --git a/security/integrity/ima/ima_iint.c
> b/security/integrity/ima/ima_iint.c
> index 0d83edc..4e2df22 100644
> --- a/security/integrity/ima/ima_iint.c
> +++ b/security/integrity/ima/ima_iint.c
> @@ -57,18 +57,17 @@ int ima_inode_alloc(struct inode *inode)
>                return -ENOMEM;
>
>        rc = radix_tree_preload(GFP_NOFS);
> -       if (rc < 0)
> -               goto out;
> +       if (rc < 0) {
> +               kmem_cache_free(iint_cache, iint);
> +               radix_tree_preload_end();
> +               return rc;
> +       }
>
>        spin_lock(&ima_iint_lock);
>        rc = radix_tree_insert(&ima_iint_store, (unsigned long)inode, iint);
>        spin_unlock(&ima_iint_lock);
> -out:
> -       if (rc < 0)
> -               kmem_cache_free(iint_cache, iint);

So if radix_tree_insert failed, the memory will be leaked.
This patch doesn't fix anything but introduces new bug....

>
>        radix_tree_preload_end();
> -
>        return rc;
>  }
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
