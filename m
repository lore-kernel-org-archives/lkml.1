Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752778Ab0BHOid (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Feb 2010 09:38:33 -0500
Received: from mail-bw0-f223.google.com ([209.85.218.223]:51485 "EHLO
	mail-bw0-f223.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752643Ab0BHOib convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Feb 2010 09:38:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=eQ5sgQzLniEdlxXi25oR/M7TKaW5NEUsn8wVZbXj6b74e0GopUay6pMxwDCj9bU+ay
         Fh24XaHmawFO155TR85B9rDirrr2rU82ufJlQ+T2uO3zWvUxySFm/xZehJBlwXHKCWmx
         RktJ8n8/7vPqvwan3AksmiiIRlDwhHciSAzwA=
MIME-Version: 1.0
In-Reply-To: <20100208111624.5387.37948.stgit@pc1117.cambridge.arm.com>
References: <20100208111624.5387.37948.stgit@pc1117.cambridge.arm.com>
From: roel kluin <roel.kluin@gmail.com>
Date: Mon, 8 Feb 2010 15:38:09 +0100
Message-ID: <25e057c01002080638g149c974r759f50365cd05233@mail.gmail.com>
Subject: Re: [PATCH] kmemcheck: Test the full object in kmemcheck_is_obj_initialized()
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-kernel@vger.kernel.org, Vegard Nossum <vegardno@ifi.uio.no>,
       Andrew Morton <akpm@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Christian Casteyde <casteyde.christian@free.fr>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 8, 2010 at 12:16 PM, Catalin Marinas
<catalin.marinas@arm.com> wrote:
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

Are we certain that size cannot be 0 in kmemcheck_shadow_test()
and kmemcheck_shadow_test_all() or other functions in
arch/x86/mm/kmemcheck/shadow.c with these unsigned
comparisons in loops?

Roel
