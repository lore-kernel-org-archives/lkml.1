Return-Path: <linux-kernel-owner+w=401wt.eu-S1754596AbYBQHhF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754596AbYBQHhF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 02:37:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751452AbYBQHgy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 02:36:54 -0500
Received: from rv-out-0910.google.com ([209.85.198.185]:47027 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751531AbYBQHgx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 02:36:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Bl4zlu/OFoXEuG02EQExVLbolBBxVFb2j9cRqCdFl9cgcE1Q024lh8jKUcLvb2pMIhK5oyRsr+8iLbOIw/7MPBL4HQndMeAkNTdXVkst8JWuYk24MqrrpsPIsPR7+giqUpn9A79HaMGMx5rZbvsq2RcF/TadMidrLVdPB1cy+kc=
Message-ID: <86802c440802162336he3cdef1y38ed3fcae89f3cc7@mail.gmail.com>
Date: Sat, 16 Feb 2008 23:36:38 -0800
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH 3/4] x86_64: Fold pda into per cpu area
Cc: travis@sgi.com, "Andrew Morton" <akpm@linux-foundation.org>,
       "Andi Kleen" <ak@suse.de>, "Thomas Gleixner" <tglx@linutronix.de>,
       "Jeremy Fitzhardinge" <jeremy@goop.org>,
       "Christoph Lameter" <clameter@sgi.com>,
       "Jack Steiner" <steiner@sgi.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <86802c440802162222k47f5bebbhf42fef0f11ce3243@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080201191414.961558000@sgi.com>
	 <20080201191415.450555000@sgi.com> <20080215201640.GA6200@elte.hu>
	 <86802c440802162222k47f5bebbhf42fef0f11ce3243@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Feb 16, 2008 10:22 PM, Yinghai Lu <yhlu.kernel@gmail.com> wrote:
> On Feb 15, 2008 12:16 PM, Ingo Molnar <mingo@elte.hu> wrote:
> >
> > * travis@sgi.com <travis@sgi.com> wrote:
> >
> > >  include/asm-generic/vmlinux.lds.h |    2 +
> > >  include/linux/percpu.h            |    9 ++++-
> >
> > couldnt these two generic bits be done separately (perhaps a preparatory
> > but otherwise NOP patch pushed upstream straight away) to make
> > subsequent patches only touch x86 architecture files?
>
> this patch need to apply to mainline asap.
>
> or you need revert to the patch about include/asm-x86/percpu.h
>
> +#ifdef CONFIG_X86_64
> +#include <linux/compiler.h>
> +
> +/* Same as asm-generic/percpu.h, except that we store the per cpu offset
> +   in the PDA. Longer term the PDA and every per cpu variable
> +   should be just put into a single section and referenced directly
> +   from %gs */
> +
> +#ifdef CONFIG_SMP
> +#include <asm/pda.h>
> +
> +#define __per_cpu_offset(cpu) (cpu_pda(cpu)->data_offset)
> +#define __my_cpu_offset read_pda(data_offset)
> +
> +#define per_cpu_offset(x) (__per_cpu_offset(x))
> +
>  #endif
> +#include <asm-generic/percpu.h>
> +
> +DECLARE_PER_CPU(struct x8664_pda, pda);
> +
> +#else /* CONFIG_X86_64 */
>
> because current tree
> in setup_per_cpu_areas will have
>      cpu_pda(i)->data_offset = ptr - __per_cpu_start;
>
> but at that time all APs will use cpu_pda for boot cpu...,and APs will
> get their pda in do_boot_cpu()

sorry, boot_cpu_pda is array... so that is safe.

YH
