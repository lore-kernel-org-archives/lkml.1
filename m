Return-Path: <linux-kernel-owner+w=401wt.eu-S1763126AbXEWTfW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763126AbXEWTfW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 15:35:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756240AbXEWTfJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 15:35:09 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:63225 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755127AbXEWTfH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 15:35:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=igj3o5pTAKKazhi8Co7MQyE576elPAAbLxQlK/okKy5SMHubTSQi12Y+f2tP3+YkwalPf/GtJXtIVDl3qxZHci87H9Tb2PB1FgMFXlvtz85MwjcUj7uBmo+Cc6dTUl2H1Kix8hbYp2hxVfoqcfp16Gvw3rhOv/TKc8p9GbWe2VY=
Message-ID: <a781481a0705231234m62327134mbfd1c1478b6fb99a@mail.gmail.com>
Date: Thu, 24 May 2007 01:04:50 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Nitin Gupta" <nitingupta910@gmail.com>
Subject: Re: [RFC] LZO de/compression support - take 3
Cc: linux-kernel@vger.kernel.org, "Richard Purdie" <richard@openedhand.com>,
       linux-mm-cc@laptop.org
In-Reply-To: <4cefeab80705230127r58e8f9e1sa644092e95eb81eb@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4cefeab80705230127r58e8f9e1sa644092e95eb81eb@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Nitin,

On 5/23/07, Nitin Gupta <nitingupta910@gmail.com> wrote:
> [...]
> diff --git a/Makefile b/Makefile
> index 34210af..88053ba 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -826,11 +826,18 @@ include/config/kernel.release:
> include/config/auto.conf FORCE
>  # Listed in dependency order
>  PHONY += prepare archprepare prepare0 prepare1 prepare2 prepare3
>
> +# prepare4 does module specific things prior to compilation
> +prepare4:
> +ifneq ($(CONFIG_LZO1X),n)
> +       $(Q)ln -sf $(srctree)/lib/lzo1x/lzo1x_decompress.c \
> +               $(srctree)/lib/lzo1x/lzo1x_decompress_safe.c
> +endif
> +

Is this addition to the master Makefile really necessary? We're just
setting up a source file link here ... is this something temporary that
you're proposing that'll last only till this gets tested or do you want
this kind of special-casing for lzo1x here permanently?

> diff --git a/include/linux/lzo1x.h b/include/linux/lzo1x.h
> [...]
> +/* Size of temp buffer (workmem) required by lzo1x_compress */
> +#define LZO1X_WORKMEM_SIZE     ((size_t) (16384L * sizeof(unsigned char *)))
> +
> +/*
> + * This required 'workmem' of size LZO1X_WORKMEM_SIZE
> + */
> +int lzo1x_compress(const unsigned char *src, size_t src_len,
> +               unsigned char *dst, size_t *dst_len,
> +               void *workmem);

Just defining and exporting LZO1X_WORKMEM_SIZE may not be enough
to guarantee that users _will_ pass in workmem of size exactly that much.

If this workmem is really merely a temp buffer required by lzo1x_compress(),
I'd suggest you rename lzo1x_compress() in lzo1x_compress.c to
__lzo1x_compress(), and implement a lzo1x_compress() wrapper for the
user that handles the allocation (and subsequent free'ing) of this temp
buffer itself.

[ I vaguely remember discussing something of this sort with Richard
when he had submitted his patchset too, perhaps you can look into
his implementation to see how he's managing this ... ]

> +/*
> + * This decompressor expects valid compressed data.
> + *
> + * If the compressed data gets corrupted somehow (e.g. transmission
> + * via an erroneous channel, disk errors, ...) it will probably crash
> + * your application because absolutely no additional checks are done.
           ^^^^^^^^^^^

Whoa! "your application" here is _kernel code_ and not a userspace
program ... "crashing" it is something we could do without :-)

> + */
> +int lzo1x_decompress(const unsigned char *src, size_t src_len,
> +               unsigned char *dst, size_t *dst_len);
> +
> +
> +/*
> + * The `safe' decompressor. Somewhat slower.
> + *
> + * This decompressor will catch all compressed data violations and
> + * return an error code in this case.
> + */
> +int lzo1x_decompress_safe(const unsigned char *src, size_t src_len,
> +               unsigned char *dst, size_t *dst_len);
> +#endif

I just read the follow-ups to this, so perhaps we /can/ use the unsafe
versions in certain situations. But I agree with Michael's suggestion
to rename _safe to decompress and decompress to _unsafe ...

> diff --git a/lib/lzo1x/Makefile b/lib/lzo1x/Makefile
> [...]
> +#
> +# When compiling this module out of tree, do 'make prepare_lzo'
> +# before compiling as usual
> +#
> +obj-$(CONFIG_LZO1X) += lzo1x.o
> +CFLAGS_lzo1x_decompress_safe.o += -DLZO1X_DECOMPRESS_SAFE
> +lzo1x-objs := lzo1x_compress.o lzo1x_decompress.o lzo1x_decompress_safe.o
> +
> +prepare_lzo:
> +       @ln -sf lzo1x_decompress.c lzo1x_decompress_safe.c
> +

... ah, so that's why the master Makefile changes.

Hmmm, perhaps you could extract the common stuff between the
_safe and _unsafe versions out into a separate function and then
reuse it from _safe and _unsafe wrappers? In any case, this kind
of Makefile jugglery (even in the master Makefile) just to avoid the
above doesn't seem quite right ...

> diff --git a/lib/lzo1x/lzo1x_decompress.c b/lib/lzo1x/lzo1x_decompress.c
> [...]
> +#if defined(LZO1X_DECOMPRESS_SAFE)
> +input_overrun:
> +    *out_len = (size_t)(op - out);
> +    return LZO_E_INPUT_OVERRUN;
> +
> +output_overrun:
> +    *out_len = (size_t)(op - out);
> +    return LZO_E_OUTPUT_OVERRUN;
> +
> +lookbehind_overrun:
> +    *out_len = (size_t)(op - out);
> +    return LZO_E_LOOKBEHIND_OVERRUN;
> +#endif
> +}
> +
> +EXPORT_SYMBOL(lzo1x_decompress);

Ok, so this is all there is between _safe and _unsafe, it seems ...

> diff --git a/lib/lzo1x/lzo1x_int.h b/lib/lzo1x/lzo1x_int.h
> [...]
> +/* Macros for 'safe' decompression */
> +#ifdef LZO1X_DECOMPRESS_SAFE
> +
> +#define lzo1x_decompress lzo1x_decompress_safe
> +#define TEST_IP        (ip < ip_end)
> +#define NEED_IP(x) \
> +       if ((size_t)(ip_end - ip) < (size_t)(x)) goto input_overrun
> +#define NEED_OP(x) \
> +       if ((size_t)(op_end - op) < (size_t)(x)) goto output_overrun
> +#define TEST_LB(m_pos) \
> +       if (m_pos < out || m_pos >= op) goto lookbehind_overrun
> +#define HAVE_TEST_IP
> +#define HAVE_ANY_OP
> +
> +#else  /* !LZO1X_DECOMPRESS_SAFE */
> +
> +#define        TEST_IP         1
> +#define        TEST_LB(x)      ((void) 0)
> +#define        NEED_IP(x)      ((void) 0)
> +#define        NEED_OP(x)      ((void) 0)
> +#undef HAVE_TEST_IP
> +#undef HAVE_ANY_OP
> +
> +#endif /* LZO1X_DECOMPRESS_SAFE */

... ugh. Yes, extracting the common stuff between the _safe and _unsafe
variants in a common low-level __lzo1x_decompress kind of function
definitely looks doable. The low-level function could simply take an extra
argument (say, set by the _safe and _unsafe wrappers) that tells it
whether it is being called as safe or unsafe ... helps us get rid of the
disruptions to all the Makefiles above and these #ifdef's ugliness ...

BTW, it'd be really cool if Richard and yourself could get together and
pool your energies / efforts to develop a common / same patchset for this.
(I wonder how different your implementations are, actually, and if there
are any significant performance disparities, especially.) I really like your
work, as it clears up the major gripe I had with Richard's patchset -- the
ugliness (and monstrosity) of it. But he's also worked up the glue code for
cryptoapi / jffs2 etc for this, so no point duplicating his efforts.

Satyam
