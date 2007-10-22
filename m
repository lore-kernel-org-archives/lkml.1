Return-Path: <linux-kernel-owner+w=401wt.eu-S1754787AbXJVMkx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754787AbXJVMkx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 08:40:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752036AbXJVMkp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 08:40:45 -0400
Received: from rv-out-0910.google.com ([209.85.198.191]:28225 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752017AbXJVMko (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 08:40:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=lbcFpl9JpSAJqCLl0reM6u0xJCr7riNCtSSm3Y1DolU1sS2VUVTNcJQdWYmfwtkNbLaUfnYFL3h2sNnuVh/AQBf6il3FGtwR1eWqVaGmvvriD/U3kAFcp270J9jvxi7vkaVpA+YMekSQdx2Pw5pcjoaPYlKPVwG6siDewhvyKio=
Message-ID: <84144f020710220540i7be08eednf40db8367669825f@mail.gmail.com>
Date: Mon, 22 Oct 2007 15:40:44 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Roel Kluin" <12o3l@tiscali.nl>
Subject: Re: [PATCH] unlock before bug returns
Cc: "Rik van Riel" <riel@redhat.com>, lkml <linux-kernel@vger.kernel.org>,
       "Christoph Lameter" <clameter@sgi.com>
In-Reply-To: <471C930D.4000004@tiscali.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <471C0697.1040906@tiscali.nl> <471C11E5.2000003@tiscali.nl>
	 <20071022001045.131ea465@bree.surriel.com>
	 <471C930D.4000004@tiscali.nl>
X-Google-Sender-Auth: 413857e8d9250169
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Roel,

On 10/22/07, Roel Kluin <12o3l@tiscali.nl> wrote:
> diff --git a/mm/slab.c b/mm/slab.c
> index cfa6be4..20c58dc 100644
> --- a/mm/slab.c
> +++ b/mm/slab.c
> @@ -1606,8 +1606,10 @@ void __init kmem_cache_init(void)
>                 struct kmem_cache *cachep;
>                 mutex_lock(&cache_chain_mutex);
>                 list_for_each_entry(cachep, &cache_chain, next)
> -                       if (enable_cpucache(cachep))
> +                       if (enable_cpucache(cachep)) {
> +                               mutex_unlock(&cache_chain_mutex);
>                                 BUG();
> +                       }
>                 mutex_unlock(&cache_chain_mutex);
>         }

NAK. This will cause double-unlock when CONFIG_BUG is disabled. It's
incorrect to assume that BUG() will always terminate the current
process.
