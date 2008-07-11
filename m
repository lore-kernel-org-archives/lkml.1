Return-Path: <linux-kernel-owner+w=401wt.eu-S1757218AbYGKIlc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757218AbYGKIlc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 04:41:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751812AbYGKIlY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 04:41:24 -0400
Received: from py-out-1112.google.com ([64.233.166.177]:48199 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752352AbYGKIlX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 04:41:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=SjTBTYv6IMGg75BGThQ7Jq86qteJ073GllmBoicd1gbWb5zDLhpp1thPtxkHmT7tG4
         2FO3yjNB4j8ME2pvF7AL3Spa1Dwkfhin1/F0Z6LEXRewU7jZ+ZyAaYUDvCTE9T64qJNF
         fL5wtrXq4OSXy2CDreDfberdUwiBMpxPNpll4=
Message-ID: <84144f020807110141r7e54e20drea8d04a0a327850c@mail.gmail.com>
Date: Fri, 11 Jul 2008 11:41:20 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Eduard - Gabriel Munteanu" <eduard.munteanu@linux360.ro>
Subject: Re: [RFC PATCH 1/5] kmemtrace: Core implementation.
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       "Christoph Lameter" <cl@linux-foundation.org>
In-Reply-To: <20080710210557.5777979c@linux360.ro>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1215712946-23572-1-git-send-email-eduard.munteanu@linux360.ro>
	 <20080710210557.5777979c@linux360.ro>
X-Google-Sender-Auth: 066d912e325c1f33
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Eduard-Gabriel,

On Thu, Jul 10, 2008 at 9:05 PM, Eduard - Gabriel Munteanu
<eduard.munteanu@linux360.ro> wrote:
> kmemtrace provides tracing for slab allocator functions, such as kmalloc,
> kfree, kmem_cache_alloc, kmem_cache_free etc.. Collected data is then fed
> to the userspace application in order to analyse allocation hotspots,
> internal fragmentation and so on, making it possible to see how well an
> allocator performs, as well as debug and profile kernel code.
>
> Signed-off-by: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>

> new file mode 100644
> index 0000000..11cd8e2
> --- /dev/null
> +++ b/include/linux/kmemtrace.h
> @@ -0,0 +1,110 @@
> +/*
> + * Copyright (C) 2008 Eduard - Gabriel Munteanu
> + *
> + * This file is released under GPL version 2.
> + */
> +
> +#ifndef _LINUX_KMEMTRACE_H
> +#define _LINUX_KMEMTRACE_H
> +
> +#include <linux/types.h>
> +
> +/* ABI definition starts here. */
> +
> +#define KMEMTRACE_ABI_VERSION          1
> +
> +enum kmemtrace_event_id {
> +       KMEMTRACE_EVENT_NULL = 0,       /* Erroneous event. */
> +       KMEMTRACE_EVENT_ALLOC,
> +       KMEMTRACE_EVENT_FREE,
> +};
> +
> +enum kmemtrace_kind_id {
> +       KMEMTRACE_KIND_KERNEL = 0,      /* kmalloc() / kfree(). */
> +       KMEMTRACE_KIND_CACHE,           /* kmem_cache_*(). */
> +       KMEMTRACE_KIND_PAGES,           /* __get_free_pages() and friends. */
> +};

Can we do s/kind/type/, please? Also, the names "kernel" and "cache"
are confusing. Can we just call them "kmalloc" and "kmem_cache"
instead?

> +
> +struct kmemtrace_event {
> +       __u16           event_id;       /* Allocate or free? */
> +       __u16           kind_id;        /* Kind of allocation/free. */
> +       __s32           node;           /* Target CPU. */
> +       __u64           call_site;      /* Caller address. */
> +       __u64           ptr;            /* Pointer to allocation. */
> +       __u64           bytes_req;      /* Number of bytes requested. */
> +       __u64           bytes_alloc;    /* Number of bytes allocated. */
> +       __u64           gfp_flags;      /* Requested flags. */
> +       __s64           timestamp;      /* When the operation occured in ns. */
> +} __attribute__ ((__packed__));

Why do you need to use the __packed__ attribute here? Looks like the
struct is already laid out properly.

> +
> +/* End of ABI definition. */
