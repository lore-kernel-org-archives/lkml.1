Return-Path: <linux-kernel-owner+w=401wt.eu-S1752295AbXE3Aig@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752295AbXE3Aig (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 20:38:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751094AbXE3Ai2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 20:38:28 -0400
Received: from smtp1.linux-foundation.org ([207.189.120.13]:41381 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750904AbXE3Ai1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 20:38:27 -0400
Date: Tue, 29 May 2007 17:38:18 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-m68k@vger.kernel.org,
       Roman Zippel <zippel@linux-m68k.org>
Subject: Re: [patch 1/2] m68k: runtime patching infrastructure
Message-Id: <20070529173818.fd94ae81.akpm@linux-foundation.org>
In-Reply-To: <20070528191715.352919509@mail.of.borg>
References: <20070528191630.377693320@mail.of.borg>
	<20070528191715.352919509@mail.of.borg>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 May 2007 21:16:31 +0200
Geert Uytterhoeven <geert@linux-m68k.org> wrote:

> --- a/include/asm-m68k/module.h
> +++ b/include/asm-m68k/module.h
> @@ -1,7 +1,38 @@
>  #ifndef _ASM_M68K_MODULE_H
>  #define _ASM_M68K_MODULE_H
> -struct mod_arch_specific { };
> +
> +struct mod_arch_specific {
> +	struct m68k_fixup_info *fixup_start, *fixup_end;
> +};

Here we use struct m68k_fixup_info.

> +#define MODULE_ARCH_INIT {				\
> +	.fixup_start		= __start_fixup,	\
> +	.fixup_end		= __stop_fixup,		\
> +}
> +
>  #define Elf_Shdr Elf32_Shdr
>  #define Elf_Sym Elf32_Sym
>  #define Elf_Ehdr Elf32_Ehdr
> +
> +
> +enum m68k_fixup_type {
> +	m68k_fixup_memoffset,
> +};
> +
> +struct m68k_fixup_info {
> +	enum m68k_fixup_type type;
> +	void *addr;
> +};

and later we define it.

How come it doesn't spit warnings?

I think it could be tightened up even if it happens not to warn?

> +#define m68k_fixup(type, addr)			\
> +	"	.section \".m68k_fixup\",\"aw\"\n"	\
> +	"	.long " #type "," #addr "\n"	\
> +	"	.previous\n"
> +
> +extern struct m68k_fixup_info __start_fixup[], __stop_fixup[];
> +
> +struct module;
> +extern void module_fixup(struct module *mod, struct m68k_fixup_info *start,
> +			 struct m68k_fixup_info *end);
