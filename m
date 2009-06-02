Return-Path: <linux-kernel-owner+w=401wt.eu-S1757218AbZFBQRa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757218AbZFBQRa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 12:17:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753159AbZFBQRX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 12:17:23 -0400
Received: from www.tglx.de ([62.245.132.106]:35688 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751981AbZFBQRX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 12:17:23 -0400
Date: Tue, 2 Jun 2009 18:11:04 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Jeremy Fitzhardinge <jeremy@goop.org>
cc: Ingo Molnar <mingo@elte.hu>, the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Christophe Saout <chtephan@leto.intern.saout.de>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: Re: [PATCH 14/16] paravirtualize IO permission bitmap
In-Reply-To: <1242163718-2934-15-git-send-email-jeremy@goop.org>
Message-ID: <alpine.LFD.2.00.0906021751510.3419@localhost.localdomain>
References: <1242163718-2934-1-git-send-email-jeremy@goop.org> <1242163718-2934-15-git-send-email-jeremy@goop.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 May 2009, Jeremy Fitzhardinge wrote:

> From: Christophe Saout <chtephan@leto.intern.saout.de>
> 
> A PV Xen guest kernel has no TSS of its own, so the IO permission
> bitmap must be paravirtualized.  This patch adds set_io_bitmap
> as a paravirt op, and defines a native version which updates the tss,
> and a Xen version which uses a hypercall.
> 
> This is much easier now that 32 and 64-bit use the same code to
> manage the IO bitmap.

  Sigh, is there a plan to limit the paravirt horror at some point or
  are we keeping on adding to it forever ?

> --- a/arch/x86/kernel/ioport.c
> +++ b/arch/x86/kernel/ioport.c
> @@ -30,14 +30,31 @@ static void set_bitmap(unsigned long *bitmap, unsigned int base,
>  	}
>  }

This needs kernel doc annotation and a comment about the calling
conventions i.e. preemption disabled.
  
> +void native_set_io_bitmap(struct thread_struct *t,
> +			  int changed, unsigned long bytes_updated)
> +{
> +	struct tss_struct *tss;
> +
> +	if (!bytes_updated)
> +		return;
> +
> +	tss = &__get_cpu_var(init_tss);
> +
> +	/* Update the TSS: */
> +	if (t->io_bitmap_ptr)
> +		memcpy(tss->io_bitmap, t->io_bitmap_ptr, bytes_updated);
> +	else
> +		memset(tss->io_bitmap, 0xff, bytes_updated);
> +}
> +

Thanks,

	tglx
