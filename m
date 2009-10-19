Return-Path: <linux-kernel-owner+w=401wt.eu-S1757977AbZJSXqn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757977AbZJSXqn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Oct 2009 19:46:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754793AbZJSXqm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Oct 2009 19:46:42 -0400
Received: from casper.infradead.org ([85.118.1.10]:58657 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754719AbZJSXql (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Oct 2009 19:46:41 -0400
Date: Tue, 20 Oct 2009 08:43:35 +0900
From: Arjan van de Ven <arjan@infradead.org>
To: Kees Cook <kees.cook@canonical.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Jan Beulich <jbeulich@novell.com>, Vegard Nossum <vegardno@ifi.uio.no>,
       Yinghai Lu <yinghai@kernel.org>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [x86] detect and report lack of NX protections
Message-ID: <20091020084335.4e8d97e9@infradead.org>
In-Reply-To: <20091019184234.GN5394@outflux.net>
References: <20091019184234.GN5394@outflux.net>
Organization: Intel
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.16.6; i586-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Oct 2009 11:42:34 -0700
Kees Cook <kees.cook@canonical.com> wrote:

> It is possible for x86_64 systems to lack the NX bit (see
> check_efer()) either due to the hardware lacking support or the BIOS
> having turned off the CPU capability, so NX status should be
> reported.  Additionally, anyone booting NX-capable CPUs in 32bit mode
> without PAE will lack NX functionality, so this change provides
> feedback for that case as well.
> 
> Signed-off-by: Kees Cook <kees.cook@canonical.com>
> ---
>  arch/x86/mm/init.c     |   10 ++++++++++
>  arch/x86/mm/setup_nx.c |    2 ++
>  2 files changed, 12 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
> index 73ffd55..8472293 100644
> --- a/arch/x86/mm/init.c
> +++ b/arch/x86/mm/init.c
> @@ -149,6 +149,16 @@ unsigned long __init_refok
> init_memory_mapping(unsigned long start, set_nx();
>  	if (nx_enabled)
>  		printk(KERN_INFO "NX (Execute Disable) protection:
> active\n");
> +	else if (cpu_has_pae)
> +#if defined(CONFIG_X86_64) || defined(CONFIG_X86_PAE)
> +		/* PAE kernel, PAE CPU, without NX */
> +		printk(KERN_WARNING "Warning: NX (Execute Disable)
> protection "
> +		       "missing in CPU or disabled in BIOS!\n");
> +#else
> +		/* 32bit non-PAE kernel, PAE CPU */
> +		printk(KERN_WARNING "Warning: NX (Execute Disable)
> protection "
> +		       "cannot be enabled: non-PAE kernel!\n");
> +#endif

can we please not use "Warning" for something like this in the
message...

lets keep "Warning" for real WARN_ON() kind of events.
