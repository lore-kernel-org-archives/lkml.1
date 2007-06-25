Return-Path: <linux-kernel-owner+w=401wt.eu-S1753203AbXFYVhR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753203AbXFYVhR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 17:37:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753510AbXFYVgw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 17:36:52 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34696 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753184AbXFYVgv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 17:36:51 -0400
Date: Mon, 25 Jun 2007 14:32:59 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: lkml <linux-kernel@vger.kernel.org>, ak@suse.de
Subject: Re: [PATCH] mtrr/cyrix: fix sections
Message-Id: <20070625143259.d3dece4f.akpm@linux-foundation.org>
In-Reply-To: <20070625134851.78873cc0.randy.dunlap@oracle.com>
References: <20070625134851.78873cc0.randy.dunlap@oracle.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 25 Jun 2007 13:48:51 -0700
Randy Dunlap <randy.dunlap@oracle.com> wrote:

> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Are there peculiarities about Cyrix that mean this isn't needed?
> 
> main.c::mtrr_add() or mtrr_del() [exported]
> calls main.c::mtrr_add_page() or mtrr_del_page() or mtrr_restore() [resume]
> calls main.c::set_mtrr()
> calls main.c::ipi_handler()
> calls main.c::mtrr_if->set_all() == which can be cyrix_set_all
> 
> WARNING: arch/i386/kernel/built-in.o(.text+0x8657): Section mismatch: reference to .init.data: (between 'cyrix_set_all' and 'centaur_get_free_region')
> WARNING: arch/i386/kernel/built-in.o(.text+0x866b): Section mismatch: reference to .init.data: (between 'cyrix_set_all' and 'centaur_get_free_region')
> WARNING: arch/i386/kernel/built-in.o(.text+0x867e): Section mismatch: reference to .init.data: (between 'cyrix_set_all' and 'centaur_get_free_region')
> WARNING: arch/i386/kernel/built-in.o(.text+0x8684): Section mismatch: reference to .init.data: (between 'cyrix_set_all' and 'centaur_get_free_region')
> WARNING: arch/i386/kernel/built-in.o(.text+0x868a): Section mismatch: reference to .init.data: (between 'cyrix_set_all' and 'centaur_get_free_region')
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> ---
>  arch/i386/kernel/cpu/mtrr/cyrix.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> --- linux-2.6.22-rc6.orig/arch/i386/kernel/cpu/mtrr/cyrix.c
> +++ linux-2.6.22-rc6/arch/i386/kernel/cpu/mtrr/cyrix.c
> @@ -233,12 +233,12 @@ typedef struct {
>  	mtrr_type type;
>  } arr_state_t;
>  
> -static arr_state_t arr_state[8] __devinitdata = {
> +static arr_state_t arr_state[8] = {
>  	{0UL, 0UL, 0UL}, {0UL, 0UL, 0UL}, {0UL, 0UL, 0UL}, {0UL, 0UL, 0UL},
>  	{0UL, 0UL, 0UL}, {0UL, 0UL, 0UL}, {0UL, 0UL, 0UL}, {0UL, 0UL, 0UL}
>  };
>  
> -static unsigned char ccr_state[7] __devinitdata = { 0, 0, 0, 0, 0, 0, 0 };
> +static unsigned char ccr_state[7] = { 0, 0, 0, 0, 0, 0, 0 };
>  
>  static void cyrix_set_all(void)
>  {

Looks right to me.  Certainly it's safe.

Now, possibly mtrr_ops.set_all _should_ point at __init functions, but we
dont' have a way of expressing that, and
arch/i386/kernel/cpu/mtrr/main.c:ipi_handler() looks like it's called at
non-initcall time.

So I'll plan on merging this fix as-is, for 2.6.22.

