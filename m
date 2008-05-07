Return-Path: <linux-kernel-owner+w=401wt.eu-S1761450AbYEGGm3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761450AbYEGGm3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 02:42:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755717AbYEGGmR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 02:42:17 -0400
Received: from rv-out-0506.google.com ([209.85.198.225]:7423 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755354AbYEGGmO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 02:42:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=vHM7gewlVf0QL7hGGkvWuCKZTifXi9qX467XY0D6dbBZSc6GbkqaIkR5hhrZbcInw4k27s13hfVVn6GffawhrSxcO/EecxVyMPgVvnKavIYpVMuvTKdtQdQnS0H+gVKz2VUvGk5V3aQ2BZAAuNgWi1v4/MI9FXEsp/JcFMFZ1Eo=
Message-ID: <19f34abd0805062341x21caa29dld03d838057d498e3@mail.gmail.com>
Date: Wed, 7 May 2008 08:41:31 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Arjan van de Ven" <arjan@infradead.org>
Subject: Re: [patch 2/3] Add a WARN() macro; this is WARN_ON() + printk arguments
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
In-Reply-To: <20080506232113.7f066c26@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080506232017.247001e0@infradead.org>
	 <20080506232113.7f066c26@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

On Wed, May 7, 2008 at 8:21 AM, Arjan van de Ven <arjan@infradead.org> wrote:
> Subject: Add a WARN() macro; this is WARN_ON() + printk arguments
>  From: Arjan van de Ven <arjan@linux.intel.com>
>
>  Add a WARN() macro that acts like WARN_ON(), with the added feature that
>  it takes a printk like argument that is printed as part of the warning
>  message.

[...]

>  +#ifndef WARN
>  +#define WARN(condition, format...) ({                                          \
>  +       int __ret_warn_on = !!(condition);                              \
>  +       if (unlikely(__ret_warn_on))                                    \
>  +               __WARN_printf(format);                                  \
>  +       unlikely(__ret_warn_on);                                        \
>  +})
>  +#endif

Is there a good reason why this is not a static inline function? If
I've understood correctly, we want to turn as many macros as possible
into functions, and I don't see an immediate reason why this one can't
be one.

>  +void warn_slowpath(const char *file, int line, const char *fmt, ...)
>  +{
>  +       va_list args;
>  +
>  +
>  +       char function[KSYM_SYMBOL_LEN];
>  +       unsigned long caller = (unsigned long) __builtin_return_address(0);

If WARN() is made a static inline, you can call
__builtin_return_address(0) there and pass it into here instead. This
seems like a kind of low-level internal function anyway, because of
the file/line info.

OTOH, why can't you use __FUNCTION__ or __func__ to determine the
caller (in WARN) rather than doing it here, at run-time? If it's to
save space (or something like that), I think it should be documented?

>  +       sprint_symbol(function, caller);
>  +
>  +       printk(KERN_WARNING "------------[ cut here ]------------\n");
>  +       printk(KERN_WARNING "WARNING: at %s:%d %s()\n", file,
>  +               line, function);
>  +       va_start(args, fmt);
>  +       vprintk(fmt, args);
>  +       va_end(args);
>  +
>  +       print_modules();
>  +       dump_stack();
>  +       print_oops_end_marker();
>  +       add_taint(TAINT_WARN);
>  +}
>  +EXPORT_SYMBOL(warn_slowpath);
>   #endif


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
