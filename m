Return-Path: <linux-kernel-owner+w=401wt.eu-S1758198AbZANHTT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758198AbZANHTT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 02:19:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753847AbZANHTG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 02:19:06 -0500
Received: from fg-out-1718.google.com ([72.14.220.152]:51811 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753951AbZANHTE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 02:19:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=kNxv8lQlbCFF3DNmBsJXGCxv3Mm1z6tGWwv3HwGyEHTCYaFn45bC3S8UYZ1mNLWFRz
         KMJHVSAnSAoqU5dr0wDEvksMO0b3WGjkJtOjLwT4Oo4FbMxfzJ+CQdvCa1alz7FTya3A
         6tNY5BIGYbWP5h1X8xhebRthj4XbAS0DYIQmM=
Message-ID: <84144f020901132319g50dc9e50o283b0d263f287eea@mail.gmail.com>
Date: Wed, 14 Jan 2009 09:19:01 +0200
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [PATCH] lib/idr.c: Zero memory properly in idr_remove_all
Cc: "Manfred Spraul" <manfred@colorfullife.com>, krh@redhat.com,
       stefanr@s5r6.in-berlin.de, dcm@acm.org, Nadia.Derbey@bull.net,
       linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       paulmck@us.ibm.com
In-Reply-To: <20090113144802.39dc4c23.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1231571060.3538.18.camel@localhost.localdomain>
	 <49686465.70501@s5r6.in-berlin.de>
	 <20090110011557.9d94e111.akpm@linux-foundation.org>
	 <496872E0.9030007@s5r6.in-berlin.de>
	 <1231773620.6365.21.camel@gaara.bos.redhat.com>
	 <496B9FC7.3090108@colorfullife.com>
	 <1231792712.6365.31.camel@gaara.bos.redhat.com>
	 <496BAD1C.5060201@colorfullife.com>
	 <20090113144802.39dc4c23.akpm@linux-foundation.org>
X-Google-Sender-Auth: 8a88ef8db710d06a
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 14, 2009 at 12:48 AM, Andrew Morton
<akpm@linux-foundation.org> wrote:
>> If the idr code passes uninitialized objects to kmem_cache_free(), then
>> the next kmem_cache_alloc will return a bad object.
>>
>
> None of this got us much closer to fixing the bug ;)
>
> What do we think of just removing the constructor and using
> kmem_cache_zalloc()?

Why do I get the feeling that we have merged a similar patch before?

Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>

>
> --- a/lib/idr.c~a
> +++ a/lib/idr.c
> @@ -121,7 +121,7 @@ int idr_pre_get(struct idr *idp, gfp_t g
>  {
>        while (idp->id_free_cnt < IDR_FREE_MAX) {
>                struct idr_layer *new;
> -               new = kmem_cache_alloc(idr_layer_cache, gfp_mask);
> +               new = kmem_cache_zalloc(idr_layer_cache, gfp_mask);
>                if (new == NULL)
>                        return (0);
>                move_to_free_list(idp, new);
> @@ -623,16 +623,10 @@ void *idr_replace(struct idr *idp, void
>  }
>  EXPORT_SYMBOL(idr_replace);
>
> -static void idr_cache_ctor(void *idr_layer)
> -{
> -       memset(idr_layer, 0, sizeof(struct idr_layer));
> -}
> -
>  void __init idr_init_cache(void)
>  {
>        idr_layer_cache = kmem_cache_create("idr_layer_cache",
> -                               sizeof(struct idr_layer), 0, SLAB_PANIC,
> -                               idr_cache_ctor);
> +                               sizeof(struct idr_layer), 0, SLAB_PANIC, NULL);
>  }
>
>  /**
> _
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
