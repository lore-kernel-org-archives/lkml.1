Return-Path: <linux-kernel-owner+w=401wt.eu-S1764711AbZEAUbi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764711AbZEAUbi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 16:31:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755281AbZEAUb3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 16:31:29 -0400
Received: from relay3.sgi.com ([192.48.156.57]:38073 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753959AbZEAUb2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 16:31:28 -0400
Date: Fri, 1 May 2009 15:31:23 -0500
From: Jack Steiner <steiner@sgi.com>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -tip] x86: uv - prevent NULL dereference in uv_system_init
Message-ID: <20090501203123.GA10878@sgi.com>
References: <20090501195638.GC4633@lenovo> <20090501200331.GA2645@elte.hu> <20090501200937.GD4633@lenovo> <20090501202511.GE4633@lenovo>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090501202511.GE4633@lenovo>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 02, 2009 at 12:25:11AM +0400, Cyrill Gorcunov wrote:
> [Cyrill Gorcunov - Sat, May 02, 2009 at 12:09:37AM +0400]
> | [Ingo Molnar - Fri, May 01, 2009 at 10:03:31PM +0200]
> | | 
> | | * Cyrill Gorcunov <gorcunov@openvz.org> wrote:
> | | 
> | | > We may reach NULL dereference oops if kmalloc failed.
> | | > Lets do panic better with sensible message.
> | | > 
> | | > Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
> | | > ---
> | | > 
> | | > Actually there is a dubious place as well at early_get_nodeid.
> | | > Is there a guarantee that we _never_ fail in early_ioremap?
> | | > 
> | | >  arch/x86/kernel/apic/x2apic_uv_x.c |    9 +++++++++
> | | >  1 file changed, 9 insertions(+)
> | | > 
> | | > Index: linux-2.6.git/arch/x86/kernel/apic/x2apic_uv_x.c
> | | > =====================================================================
> | | > --- linux-2.6.git.orig/arch/x86/kernel/apic/x2apic_uv_x.c
> | | > +++ linux-2.6.git/arch/x86/kernel/apic/x2apic_uv_x.c
> | | > @@ -584,15 +584,21 @@ void __init uv_system_init(void)
> | | >  
> | | >  	bytes = sizeof(struct uv_blade_info) * uv_num_possible_blades();
> | | >  	uv_blade_info = kmalloc(bytes, GFP_KERNEL);
> | | > +	if (!uv_blade_info)
> | | > +		goto err_nomem;
> | | 
> | | hm, i think a BUG_ON() might be shorter and more appropriate here. 
> | | We really shouldnt be running out of memory during system init.
> | | 
> | | 	Ingo
> | | 
> | 
> | Yeah, indeed! I was thinking of __GPF_NOFAIL here as well with
> | message on top like pr_debug("UV: allocating memory\n") or something
> | like that. It would make it even cleaner I guess. Hmm?
> | 
> | 	-- Cyrill
> 
> Here is an updated one.


Acked-by: Jack Steiner <steiner@sgi.com>


> 
> 	-- Cyrill
> ---
> From: Cyrill Gorcunov <gorcunov@openvz.org>
> Subject: [PATCH -tip] x86: uv - prevent NULL dereference in uv_system_init
> 
> We may reach NULL dereference oops if kmalloc failed.
> Prevent it with explisit BUG_ON.
> 
> Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
> ---
>  arch/x86/kernel/apic/x2apic_uv_x.c |    3 +++
>  1 file changed, 3 insertions(+)
> 
> Index: linux-2.6.git/arch/x86/kernel/apic/x2apic_uv_x.c
> =====================================================================
> --- linux-2.6.git.orig/arch/x86/kernel/apic/x2apic_uv_x.c
> +++ linux-2.6.git/arch/x86/kernel/apic/x2apic_uv_x.c
> @@ -584,15 +584,18 @@ void __init uv_system_init(void)
>  
>  	bytes = sizeof(struct uv_blade_info) * uv_num_possible_blades();
>  	uv_blade_info = kmalloc(bytes, GFP_KERNEL);
> +	BUG_ON(!uv_blade_info);
>  
>  	get_lowmem_redirect(&lowmem_redir_base, &lowmem_redir_size);
>  
>  	bytes = sizeof(uv_node_to_blade[0]) * num_possible_nodes();
>  	uv_node_to_blade = kmalloc(bytes, GFP_KERNEL);
> +	BUG_ON(!uv_node_to_blade);
>  	memset(uv_node_to_blade, 255, bytes);
>  
>  	bytes = sizeof(uv_cpu_to_blade[0]) * num_possible_cpus();
>  	uv_cpu_to_blade = kmalloc(bytes, GFP_KERNEL);
> +	BUG_ON(!uv_cpu_to_blade);
>  	memset(uv_cpu_to_blade, 255, bytes);
>  
>  	blade = 0;
