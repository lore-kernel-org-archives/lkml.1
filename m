Return-Path: <linux-kernel-owner+w=401wt.eu-S1753405AbYJALGm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753405AbYJALGm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 07:06:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752732AbYJALGe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 07:06:34 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:60914 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752715AbYJALGd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 07:06:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=p38xIB92AIPuYOmppyme2ym5JdbZx1/tql9LvfiLT9u3Z1BDNccDHVzTrrccvnZHfr
         DJ5jrgi+sSle9bb0Rge0Ry0iHubOomvFKb78BX5YJgiToEFzjWcGi5+DZbHYsa2IdgUC
         KaP1WJmf7dJ8hxzGHA/E7THAIjGRuWRaI/ako=
Message-ID: <48E359B4.7050708@gmail.com>
Date: Wed, 01 Oct 2008 13:06:28 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080720)
MIME-Version: 1.0
To: Vegard Nossum <vegardno@ifi.uio.no>
CC: Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: fix virt_addr_valid() with CONFIG_DEBUG_VIRTUAL=y
References: <20081001104717.GA7925@ben.ifi.uio.no>
In-Reply-To: <20081001104717.GA7925@ben.ifi.uio.no>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/01/2008 12:47 PM, Vegard Nossum wrote:
> Hi,
> 
> Fix for tip/x86/mm-debug (commit 59ea746337c69f6a5f1bc4d5e8544b3cbf12f801).
> I'm not sure if choice of names/structure is entirely correct, comments are
> appreciated.


> From 01613a1949de51c7ab9d0acaaa9a5444722a5cfa Mon Sep 17 00:00:00 2001
> From: Vegard Nossum <vegardno@ben.ifi.uio.no>
> Date: Wed, 1 Oct 2008 12:36:34 +0200
> Subject: [PATCH] x86: fix virt_addr_valid() with CONFIG_DEBUG_VIRTUAL=y
> 
> virt_addr_valid() calls __pa(), which calls __phys_addr(). With
> CONFIG_DEBUG_VIRTUAL=y, __phys_addr() will kill the kernel if the
> address *isn't* valid. That's clearly wrong for virt_addr_valid().
> 
> Cc: Jiri Slaby <jirislaby@gmail.com>
> Cc: Andi Kleen <andi@firstfloor.org>
> Signed-off-by: Vegard Nossum <vegardno@ben.ifi.uio.no>
> ---
> diff --git a/arch/x86/kernel/doublefault_32.c b/arch/x86/kernel/doublefault_32.c
> index 395acb1..1580e0b 100644
> --- a/arch/x86/kernel/doublefault_32.c
> +++ b/arch/x86/kernel/doublefault_32.c
> @@ -66,6 +66,6 @@ struct tss_struct doublefault_tss __cacheline_aligned = {
>  		.ds		= __USER_DS,
>  		.fs		= __KERNEL_PERCPU,
>  
> -		.__cr3		= __phys_addr_const((unsigned long)swapper_pg_dir)
> +		.__cr3	= __phys_addr_nodebug((unsigned long)swapper_pg_dir)

Now, this may be switched back to __pa: __pa_nodebug(swapper_pg_dir);

>  	}
>  };
[...]
> --- a/include/asm-x86/page_64.h
> +++ b/include/asm-x86/page_64.h
> @@ -69,6 +69,7 @@ extern unsigned long max_pfn;
>  extern unsigned long phys_base;
>  
>  extern unsigned long __phys_addr(unsigned long);
> +#define __phys_addr_nodebug(x) __phys_addr(x)
>  #define __phys_reloc_hide(x)	(x)

x86_64 is screwed in the same way, isn't it?
