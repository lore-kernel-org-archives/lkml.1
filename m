Return-Path: <linux-kernel-owner+w=401wt.eu-S1753102AbZALLJc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753102AbZALLJc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 06:09:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754532AbZALLJL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 06:09:11 -0500
Received: from ozlabs.org ([203.10.76.45]:52114 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754327AbZALLJF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 06:09:05 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Kyle McMartin <kyle@infradead.org>
Subject: Re: [PATCH] [RFC] remove (more or less) unnecessary cacheline_aligned from module_ref
Date: Mon, 12 Jan 2009 21:38:48 +1030
User-Agent: KMail/1.10.3 (Linux/2.6.27-9-generic; KDE/4.1.3; i686; ; )
Cc: linux-kernel@vger.kernel.org
References: <20090112031841.GC21090@bombadil.infradead.org>
In-Reply-To: <20090112031841.GC21090@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901122138.49092.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 12 January 2009 13:48:41 Kyle McMartin wrote:
> On x86_64 systems with CONFIG_MAXSMP set, NR_CPUS is exploded to 4096
> cpus. This cacheline_aligned attribute on the local_t in module_ref
> results in struct module bloating to over 512KB in size on x86_64, which
> tends to, er, add up. This results in insane disk usage on distro
> kernel configs (1GB+ on Fedora.)
> 
> Killing cacheline_aligned reduces the size of struct module to somewhat
> more sane levels.
> 
> Signed-off-by: Kyle McMartin <kyle@redhat.com>

Yep, I've applied this.

> I'll followup with a patch to make mod->ref dynamically allocated, but
> that needs a bit more thinking because module_unload_init currently
> doesn't have a failure path.

Thanks, that'd be good.  And it'll be even nicer when the new per-cpu
allocator goes in.

Thanks,
Rusty.


It really needs the per-cpu alloc patches which are pending to make it

> 
> Of course, reducing NR_CPUS to something sane was an easy way to patch
> over the problem.
> 
> diff --git a/include/linux/module.h b/include/linux/module.h
> index 4f7ea12..32b0bda 100644
> --- a/include/linux/module.h
> +++ b/include/linux/module.h
> @@ -222,7 +222,7 @@ void *__symbol_get_gpl(const char *symbol);
>  struct module_ref
>  {
>  	local_t count;
> -} ____cacheline_aligned;
> +};
>  
>  enum module_state
>  {
> 
