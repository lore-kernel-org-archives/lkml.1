Return-Path: <linux-kernel-owner+w=401wt.eu-S1754616Ab0AIAak@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754616Ab0AIAak (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jan 2010 19:30:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754567Ab0AIAai
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jan 2010 19:30:38 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39877 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754551Ab0AIAag (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jan 2010 19:30:36 -0500
Date: Fri, 8 Jan 2010 16:29:30 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Allow linker to eliminate unused functions in lib/*
Message-Id: <20100108162930.a011749a.akpm@linux-foundation.org>
In-Reply-To: <20100105145917.GA25570@basil.fritz.box>
References: <20100105145917.GA25570@basil.fritz.box>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 Jan 2010 15:59:18 +0100
Andi Kleen <andi@firstfloor.org> wrote:

> Allow linker to eliminate unused functions in lib/*
> 
> Right now a lot of code in lib/* is obj-y and always linked
> in. The reason is that there is no other way to ensure the EXPORT_SYMBOLs
> get included.
> 
> This patch moves the EXPORT_SYMBOLs into separate files instead. This
> way the files actually implementing the code can be made lib-y again,
> and the separate export symbols pull them in for modular kernels.
> 
> For non modular kernels the linker can decide whether to use them
> or not. 
> 
> This shrinks a allnoconfig+CONFIG_EMBEDDED=y+all options disabled
> kernel by about 1k on x86. Not much, but also not too shabby.
> 
> In some ways that's similar to the old ksyms.c files, but
> not as centralized.
> 
> I didn't do this for the functions in lib/* which already have 
> Kconfig symbol. Presumably that is usually only set on demand
> when they are actually needed (although I'm not sure it's true
> for all cases).
> 

Sneaky.

It's a bit sad to reduce the code cleanliness and maintainability in
this way, but 1k is 1k.

Removing the module.h include from the .c files will hopefully help
people realise that new exports shouldn't be added to the .c files.

> --- linux-2.6.33-rc2-ak.orig/lib/lib-syms.c
> +++ linux-2.6.33-rc2-ak/lib/lib-syms.c
> @@ -5,9 +5,13 @@
>   * On modular kernels it keeps a reference to all the lib files with
>   * exports so that they can be used by modules.  On non modular
>   * kernels it does nothing and the linker can decide whether a lib
> - * object file is needed or not.
> + * object file is needed or not. This way unneeded library functions
> + * can be eliminated.
>   */

The patch assumes a pre-existing lib-syms.c.  Confused.
