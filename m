Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751504Ab0BHMyG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Feb 2010 07:54:06 -0500
Received: from fg-out-1718.google.com ([72.14.220.153]:57778 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751241Ab0BHMyC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Feb 2010 07:54:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=UBHttWHUJeQLiQGyiFslmrOv9TEVk0CXJlaHgeoocM6MsOv6UaTPWiq+U3NoNH/b9b
         4+rlyXvtIpIe1LNWbaKRMlfsC78ndiVAz2Nv/zEwD6ztB3jpVrBTgHjcBPZJwaLlJA8+
         GecjgH8R/NdjoA/teGM9JJikfPo4zO6cIYsqI=
MIME-Version: 1.0
In-Reply-To: <20100208111624.5387.37948.stgit@pc1117.cambridge.arm.com>
References: <20100208111624.5387.37948.stgit@pc1117.cambridge.arm.com>
Date: Mon, 8 Feb 2010 14:54:00 +0200
X-Google-Sender-Auth: 3341fee49dc92840
Message-ID: <84144f021002080454j2db78133veda0c50a7eff7e6f@mail.gmail.com>
Subject: Re: [PATCH] kmemcheck: Test the full object in kmemcheck_is_obj_initialized()
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-kernel@vger.kernel.org, Vegard Nossum <vegardno@ifi.uio.no>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christian Casteyde <casteyde.christian@free.fr>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 8, 2010 at 1:16 PM, Catalin Marinas <catalin.marinas@arm.com> wrote:
> This is a fix for bug #14845 (bugzilla.kernel.org). The
> update_checksum() function in mm/kmemleak.c calls
> kmemcheck_is_obj_initialised() before scanning an object. When
> KMEMCHECK_PARTIAL_OK is enabled, this function returns true. However,
> the crc32_le() reads smaller intervals (32-bit) for which
> kmemleak_is_obj_initialised() may be false leading to a kmemcheck
> warning.
>
> Note that kmemcheck_is_obj_initialized() is currently only used by
> kmemleak before scanning a memory location.
>
> Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Christian Casteyde <casteyde.christian@free.fr>
> Cc: Pekka Enberg <penberg@cs.helsinki.fi>
> Cc: Vegard Nossum <vegardno@ifi.uio.no>

Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>

Andrew, Vegard has been rather quiet lately so do you mind picking up
this patch? Alternatively, I can pick it up in slab.git if you so
prefer.

> ---
>  arch/x86/mm/kmemcheck/kmemcheck.c |    2 +-
>  arch/x86/mm/kmemcheck/shadow.c    |   16 ++++++++++++++--
>  arch/x86/mm/kmemcheck/shadow.h    |    2 ++
>  3 files changed, 17 insertions(+), 3 deletions(-)
>
> diff --git a/arch/x86/mm/kmemcheck/kmemcheck.c b/arch/x86/mm/kmemcheck/kmemcheck.c
> index 8cc1833..b3b531a 100644
> --- a/arch/x86/mm/kmemcheck/kmemcheck.c
> +++ b/arch/x86/mm/kmemcheck/kmemcheck.c
> @@ -337,7 +337,7 @@ bool kmemcheck_is_obj_initialized(unsigned long addr, size_t size)
>        if (!shadow)
>                return true;
>
> -       status = kmemcheck_shadow_test(shadow, size);
> +       status = kmemcheck_shadow_test_all(shadow, size);
>
>        return status == KMEMCHECK_SHADOW_INITIALIZED;
>  }
> diff --git a/arch/x86/mm/kmemcheck/shadow.c b/arch/x86/mm/kmemcheck/shadow.c
> index 3f66b82..aec1242 100644
> --- a/arch/x86/mm/kmemcheck/shadow.c
> +++ b/arch/x86/mm/kmemcheck/shadow.c
> @@ -125,12 +125,12 @@ void kmemcheck_mark_initialized_pages(struct page *p, unsigned int n)
>
>  enum kmemcheck_shadow kmemcheck_shadow_test(void *shadow, unsigned int size)
>  {
> +#ifdef CONFIG_KMEMCHECK_PARTIAL_OK
>        uint8_t *x;
>        unsigned int i;
>
>        x = shadow;
>
> -#ifdef CONFIG_KMEMCHECK_PARTIAL_OK
>        /*
>         * Make sure _some_ bytes are initialized. Gcc frequently generates
>         * code to access neighboring bytes.
> @@ -139,13 +139,25 @@ enum kmemcheck_shadow kmemcheck_shadow_test(void *shadow, unsigned int size)
>                if (x[i] == KMEMCHECK_SHADOW_INITIALIZED)
>                        return x[i];
>        }
> +
> +       return x[0];
>  #else
> +       return kmemcheck_shadow_test_all(shadow, size);
> +#endif
> +}
> +
> +enum kmemcheck_shadow kmemcheck_shadow_test_all(void *shadow, unsigned int size)
> +{
> +       uint8_t *x;
> +       unsigned int i;
> +
> +       x = shadow;
> +
>        /* All bytes must be initialized. */
>        for (i = 0; i < size; ++i) {
>                if (x[i] != KMEMCHECK_SHADOW_INITIALIZED)
>                        return x[i];
>        }
> -#endif
>
>        return x[0];
>  }
> diff --git a/arch/x86/mm/kmemcheck/shadow.h b/arch/x86/mm/kmemcheck/shadow.h
> index af46d9a..ff0b2f7 100644
> --- a/arch/x86/mm/kmemcheck/shadow.h
> +++ b/arch/x86/mm/kmemcheck/shadow.h
> @@ -11,6 +11,8 @@ enum kmemcheck_shadow {
>  void *kmemcheck_shadow_lookup(unsigned long address);
>
>  enum kmemcheck_shadow kmemcheck_shadow_test(void *shadow, unsigned int size);
> +enum kmemcheck_shadow kmemcheck_shadow_test_all(void *shadow,
> +                                               unsigned int size);
>  void kmemcheck_shadow_set(void *shadow, unsigned int size);
>
>  #endif
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
