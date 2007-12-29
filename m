Return-Path: <linux-kernel-owner+w=401wt.eu-S1756130AbXL2CXB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756130AbXL2CXB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2007 21:23:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754209AbXL2CWl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Dec 2007 21:22:41 -0500
Received: from mail.suse.de ([195.135.220.2]:51205 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754111AbXL2CWk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2007 21:22:40 -0500
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH] x86: unify x86 Makefile(s)
Date: Sat, 29 Dec 2007 03:22:35 +0100
User-Agent: KMail/1.9.6
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>
References: <20071228212341.GA6939@uranus.ravnborg.org>
In-Reply-To: <20071228212341.GA6939@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200712290322.35471.ak@suse.de>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 28 December 2007 22:23:41 Sam Ravnborg wrote:
> - For 64 bit the sub architecture stuff is not used but structure
>  is kept to make it easy to introduce.

I hope not. subarch is one of the main disaster areas in the i386 port.

> +        # gcc doesn't support -march=core2 yet as of gcc 4.3, but I hope it
> +        # will eventually. Use -mtune=generic as fallback

The comment is out of date, 4.3 has a -march=core2 now. 

> +        cflags-$(CONFIG_MCORE2) += \
> +                $(call cc-option,-march=core2,$(call cc-option,-mtune=generic))
> +        cflags-$(CONFIG_GENERIC_CPU) += $(call cc-option,-mtune=generic)
> +        KBUILD_CFLAGS += $(cflags-y)
> +
> +        KBUILD_CFLAGS += -mno-red-zone
> +        KBUILD_CFLAGS += -mcmodel=kernel
> +
> +        KBUILD_CFLAGS += -Wno-sign-compare

That one should be on for i386 too. It was a workaround for a gcc prelease
that unfortunately was shipped in a suse release.

> +        KBUILD_CFLAGS += -fno-asynchronous-unwind-tables

And that too should be on for i386 too.

> +        ifneq ($(CONFIG_DEBUG_INFO),y)
> +                # -fweb shrinks the kernel a bit, but the difference is very small
> +                # it also messes up debugging, so don't use it for now.
> +                #KBUILD_CFLAGS += $(call cc-option,-fweb)
> +        endif

Can be dropped completely now.

> +        # -funit-at-a-time shrinks the kernel .text considerably
> +        # unfortunately it makes reading oopses harder.
> +        KBUILD_CFLAGS += $(call cc-option,-funit-at-a-time)

Should be on for i386 too (see other mail)
> +
> +        # prevent gcc from generating any FP code by mistake
> +        KBUILD_CFLAGS += $(call cc-option,-mno-sse -mno-mmx -mno-sse2 -mno-3dnow,)

Should be on for i386 too (in fact i thought it was already, surprised) 

> +        # this works around some issues with generating unwind tables in older gccs
> +        # newer gccs do it by default
> +        KBUILD_CFLAGS += -maccumulate-outgoing-args

That is only needed for the unwinder; I readd it on i386 too in the out of tree
unwinder patch. Strictly without it it's not needed, although it can be useful
for kgdb or fireproxy or crash for the gdb unwinder. But that applies to i386 too.
So probably it should be either dropped on both or readded to i386. I would
be for readding. iirc it was dropped because it increased code size slightly,
but code size is not everything. debuggability is more important.

-Andi
