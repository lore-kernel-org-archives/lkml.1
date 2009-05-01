Return-Path: <linux-kernel-owner+w=401wt.eu-S932290AbZEAUDz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932290AbZEAUDz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 16:03:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755592AbZEAUDn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 16:03:43 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:54995 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750940AbZEAUDm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 16:03:42 -0400
Date: Fri, 1 May 2009 22:03:31 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>, Jack Steiner <steiner@sgi.com>
Subject: Re: [PATCH -tip] x86: uv - prevent NULL dereference in
	uv_system_init
Message-ID: <20090501200331.GA2645@elte.hu>
References: <20090501195638.GC4633@lenovo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090501195638.GC4633@lenovo>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Cyrill Gorcunov <gorcunov@openvz.org> wrote:

> We may reach NULL dereference oops if kmalloc failed.
> Lets do panic better with sensible message.
> 
> Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
> ---
> 
> Actually there is a dubious place as well at early_get_nodeid.
> Is there a guarantee that we _never_ fail in early_ioremap?
> 
>  arch/x86/kernel/apic/x2apic_uv_x.c |    9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> Index: linux-2.6.git/arch/x86/kernel/apic/x2apic_uv_x.c
> =====================================================================
> --- linux-2.6.git.orig/arch/x86/kernel/apic/x2apic_uv_x.c
> +++ linux-2.6.git/arch/x86/kernel/apic/x2apic_uv_x.c
> @@ -584,15 +584,21 @@ void __init uv_system_init(void)
>  
>  	bytes = sizeof(struct uv_blade_info) * uv_num_possible_blades();
>  	uv_blade_info = kmalloc(bytes, GFP_KERNEL);
> +	if (!uv_blade_info)
> +		goto err_nomem;

hm, i think a BUG_ON() might be shorter and more appropriate here. 
We really shouldnt be running out of memory during system init.

	Ingo
