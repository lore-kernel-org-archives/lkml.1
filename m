Return-Path: <linux-kernel-owner+w=401wt.eu-S1752567AbZH1IuJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752567AbZH1IuJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Aug 2009 04:50:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752509AbZH1IuG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Aug 2009 04:50:06 -0400
Received: from wa-out-1112.google.com ([209.85.146.179]:12349 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752478AbZH1IuE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Aug 2009 04:50:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=lwGXhReVXoSAAOJv7sCXKEV9EhFE6DKeMFFgnj79wpya+NEvcYSGm06kZjSi5JX+rE
         0bqCVrp+hiQoVAwNHQgpqnhFTk4DG3ja3Fv3CSLbl+NRov8h/YFODsmc7ePl8VHqmo+9
         UjhebciOZgtM61w2qe3CpNMrONHaBybYr8U/Q=
Date: Fri, 28 Aug 2009 16:52:22 +0800
From: Amerigo Wang <xiyou.wangcong@gmail.com>
To: Siarhei Liakh <sliakh.lkml@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       Arjan van de Ven <arjan@infradead.org>,
       James Morris <jmorris@namei.org>,
       Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@muc.de>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH V2] x86: NX protection for kernel data
Message-ID: <20090828085222.GB4849@cr0.nay.redhat.com>
References: <817ecb6f0908261020y2267218h8f435e8dc392f69a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <817ecb6f0908261020y2267218h8f435e8dc392f69a@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 26, 2009 at 01:20:19PM -0400, Siarhei Liakh wrote:
>This patch expands functionality of CONFIG_DEBUG_RODATA to set main
>(static) kernel data area as NX.
>The following steps are taken to achieve this:
>1. Linker script is adjusted so .text always starts and ends on a page boundary
>2. Linker script is adjusted so .rodata and .data always start and
>end on a page boundary
>3. void mark_nxdata_nx(void) added to init/main.c with actual
>functionality: NX is set for all
>pages from _etext through _end.
>4. mark_nxdata_nx() called from init_post(void) in init/main.c (after
>init has been released)
>5. free_init_pages() sets released memory NX in arch/x86/mm/init.c
>
>The patch have been developed for Linux 2.6.31-rc7 x86 by Siarhei Liakh
><sliakh.lkml@gmail.com> and Xuxian Jiang <jiang@cs.ncsu.edu>.
>


{snip}


>
> #include <linux/types.h>
>@@ -91,6 +93,21 @@ extern void radix_tree_init(void);
> extern void free_initmem(void);
> #ifndef CONFIG_DEBUG_RODATA
> static inline void mark_rodata_ro(void) { }
>+static inline void mark_nxdata_nx(void) { }
>+#else
>+void mark_nxdata_nx(void)
>+{
>+	/*
>+	 * When this called, init has already been executed and released,
>+	 * so everything past _etext sould be NX.
>+	 */
>+	unsigned long start = PFN_ALIGN(_etext);
>+	unsigned long size = PFN_ALIGN(_end) - start;
>+
>+	printk(KERN_INFO "NX-protecting the kernel data: %lx, %lu pages\n",
>+		start, size >> PAGE_SHIFT);
>+	set_pages_nx(virt_to_page(start), size >> PAGE_SHIFT);
>+}


I am afraid this function has to be in arch/x86/mm/init.c.
Seems set_pages_nx() is x86-specific.

Have you tested this on other arch?

