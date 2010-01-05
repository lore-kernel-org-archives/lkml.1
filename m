Return-Path: <linux-kernel-owner+w=401wt.eu-S1755183Ab0AEWXh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755183Ab0AEWXh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 17:23:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754782Ab0AEWXg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 17:23:36 -0500
Received: from mail-gx0-f217.google.com ([209.85.217.217]:43008 "EHLO
	mail-gx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754620Ab0AEWXg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 17:23:36 -0500
X-Greylist: delayed 347 seconds by postgrey-1.27 at vger.kernel.org; Tue, 05 Jan 2010 17:23:36 EST
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=Th4VDVmLoAXYBKPbn9fYRoEIJ+tOfcz+w4uQxZLR6aZwNWl+DchJm96aBfLMb6A5c+
         eX4y2DLnrWI8LZlKRBzvc2ZPYA+HapMGycoysQcJU8zAEBP76XJf9yEBJulpgsJyCvW4
         QbHXGENibKIR6Bf4694s48ZNXo/ncXtEj98hE=
MIME-Version: 1.0
In-Reply-To: <20100105220437.940473705@quilx.com>
References: <20100105220417.400092933@quilx.com> <20100105220437.940473705@quilx.com>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Tue, 5 Jan 2010 17:17:28 -0500
Message-ID: <8bd0f97a1001051417w288440b4h65b6b01d4ad36a72@mail.gmail.com>
Subject: Re: [RFC local_t removal V1 1/4] Add add_local() and 
	add_local_return()
To: Christoph Lameter <cl@linux-foundation.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 5, 2010 at 17:04, Christoph Lameter wrote:
> --- /dev/null   1970-01-01 00:00:00.000000000 +0000
> +++ linux-2.6/include/asm-generic/add-local.h   2010-01-05 15:36:02.000000000 -0600
> @@ -0,0 +1,13 @@
> +#ifndef __ASM_GENERIC_ADD_LOCAL_H
> +#define __ASM_GENERIC_ADD_LOCAL_H

needs comment header (blurb/copyright/license)

> +#define add_return_local(ptr, v)                                       \
> +       ((__typeof__(*(ptr)))__add_return_local_generic((ptr),          \
> +                       (unsigned long)(v), sizeof(*(ptr))))
> +
> +#define add_local(ptr, v) (void)__add_return_local_generic((ptr),      \
> +                       (unsigned long)(v), sizeof(*(ptr)))

the only difference here is the cast ... perhaps define an
_add_local() macro to avoid the duplication

> --- /dev/null   1970-01-01 00:00:00.000000000 +0000
> +++ linux-2.6/arch/alpha/include/asm/add-local.h        2010-01-05 15:36:02.000000000 -0600
> @@ -0,0 +1,2 @@
> +#include <asm-generic/add-local.h>
> +

these arch stubs all have an extra new line

> --- /dev/null   1970-01-01 00:00:00.000000000 +0000
> +++ linux-2.6/include/asm-generic/add-local-generic.h   2010-01-05 15:36:02.000000000 -0600
> @@ -0,0 +1,40 @@
> +#ifndef __ASM_GENERIC_ADD_LOCAL_GENERIC_H
> +#define __ASM_GENERIC_ADD_LOCAL_GENERIC_H

needs comment header (blurb/copyright/license)

> +/*
> + * Generic version of __add_return_local (disables interrupts). Takes an
> + * unsigned long parameter, supporting various types of architectures.
> + */
> +static inline unsigned long __add_return_local_generic(volatile void *ptr,
> +               unsigned long value, int size)

size_t for size ?


> +extern unsigned long wrong_size_add_local(volatile void *ptr);
> ...
> +       /*
> +        * Sanity checking, compile-time.
> +        */
> +       if (size == 8 && sizeof(unsigned long) != 8)
> +               wrong_size_add_local(ptr);
> ...
> +       default:
> +               wrong_size_add_local(ptr);
> +       }

should be BUILD_BUG_ON() ?
-mike
