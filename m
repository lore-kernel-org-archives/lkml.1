Return-Path: <linux-kernel-owner+w=401wt.eu-S932217AbZEAUZ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932217AbZEAUZ1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 16:25:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757790AbZEAUZP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 16:25:15 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:27395 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757449AbZEAUZN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 16:25:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=EUSqwN4pAf5//SZe3DeotQsTjkY+qbBJ/xxzFf8E2SrzGGSREN4LEvP/kZx79Tpc+w
         fcOBWhRo0W+7UAuzsvSIpJm/KTIfLCqgN2dtvhrMmN4t2erRmm4Q0fH3SBfFS+bIw8jG
         c/Kobl5rh+NNYuXYnhqExMd+GiViSJIQwfWV0=
Date: Sat, 2 May 2009 00:25:11 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>, Jack Steiner <steiner@sgi.com>
Subject: Re: [PATCH -tip] x86: uv - prevent NULL dereference in
	uv_system_init
Message-ID: <20090501202511.GE4633@lenovo>
References: <20090501195638.GC4633@lenovo> <20090501200331.GA2645@elte.hu> <20090501200937.GD4633@lenovo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090501200937.GD4633@lenovo>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Cyrill Gorcunov - Sat, May 02, 2009 at 12:09:37AM +0400]
| [Ingo Molnar - Fri, May 01, 2009 at 10:03:31PM +0200]
| | 
| | * Cyrill Gorcunov <gorcunov@openvz.org> wrote:
| | 
| | > We may reach NULL dereference oops if kmalloc failed.
| | > Lets do panic better with sensible message.
| | > 
| | > Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
| | > ---
| | > 
| | > Actually there is a dubious place as well at early_get_nodeid.
| | > Is there a guarantee that we _never_ fail in early_ioremap?
| | > 
| | >  arch/x86/kernel/apic/x2apic_uv_x.c |    9 +++++++++
| | >  1 file changed, 9 insertions(+)
| | > 
| | > Index: linux-2.6.git/arch/x86/kernel/apic/x2apic_uv_x.c
| | > =====================================================================
| | > --- linux-2.6.git.orig/arch/x86/kernel/apic/x2apic_uv_x.c
| | > +++ linux-2.6.git/arch/x86/kernel/apic/x2apic_uv_x.c
| | > @@ -584,15 +584,21 @@ void __init uv_system_init(void)
| | >  
| | >  	bytes = sizeof(struct uv_blade_info) * uv_num_possible_blades();
| | >  	uv_blade_info = kmalloc(bytes, GFP_KERNEL);
| | > +	if (!uv_blade_info)
| | > +		goto err_nomem;
| | 
| | hm, i think a BUG_ON() might be shorter and more appropriate here. 
| | We really shouldnt be running out of memory during system init.
| | 
| | 	Ingo
| | 
| 
| Yeah, indeed! I was thinking of __GPF_NOFAIL here as well with
| message on top like pr_debug("UV: allocating memory\n") or something
| like that. It would make it even cleaner I guess. Hmm?
| 
| 	-- Cyrill

Here is an updated one.

	-- Cyrill
---
From: Cyrill Gorcunov <gorcunov@openvz.org>
Subject: [PATCH -tip] x86: uv - prevent NULL dereference in uv_system_init

We may reach NULL dereference oops if kmalloc failed.
Prevent it with explisit BUG_ON.

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
---
 arch/x86/kernel/apic/x2apic_uv_x.c |    3 +++
 1 file changed, 3 insertions(+)

Index: linux-2.6.git/arch/x86/kernel/apic/x2apic_uv_x.c
=====================================================================
--- linux-2.6.git.orig/arch/x86/kernel/apic/x2apic_uv_x.c
+++ linux-2.6.git/arch/x86/kernel/apic/x2apic_uv_x.c
@@ -584,15 +584,18 @@ void __init uv_system_init(void)
 
 	bytes = sizeof(struct uv_blade_info) * uv_num_possible_blades();
 	uv_blade_info = kmalloc(bytes, GFP_KERNEL);
+	BUG_ON(!uv_blade_info);
 
 	get_lowmem_redirect(&lowmem_redir_base, &lowmem_redir_size);
 
 	bytes = sizeof(uv_node_to_blade[0]) * num_possible_nodes();
 	uv_node_to_blade = kmalloc(bytes, GFP_KERNEL);
+	BUG_ON(!uv_node_to_blade);
 	memset(uv_node_to_blade, 255, bytes);
 
 	bytes = sizeof(uv_cpu_to_blade[0]) * num_possible_cpus();
 	uv_cpu_to_blade = kmalloc(bytes, GFP_KERNEL);
+	BUG_ON(!uv_cpu_to_blade);
 	memset(uv_cpu_to_blade, 255, bytes);
 
 	blade = 0;
