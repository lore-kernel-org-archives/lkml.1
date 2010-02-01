Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754412Ab0BAVuG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 16:50:06 -0500
Received: from ozlabs.org ([203.10.76.45]:52812 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752728Ab0BAVuD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 16:50:03 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Siarhei Liakh <sliakh.lkml@gmail.com>
Subject: Re: [PATCH V9] RO/NX protection for loadable kernel modules
Date: Tue, 2 Feb 2010 08:19:55 +1030
User-Agent: KMail/1.12.2 (Linux/2.6.31-17-generic; KDE/4.3.2; i686; ; )
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       linux-next@vger.kernel.org, Arjan van de Ven <arjan@infradead.org>,
       James Morris <jmorris@namei.org>,
       Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@muc.de>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@elte.hu>, Stephen Rothwell <sfr@canb.auug.org.au>,
       Dave Jones <davej@redhat.com>
References: <817ecb6f1002010829m712ffff4hfb64ff3ea236e1f1@mail.gmail.com>
In-Reply-To: <817ecb6f1002010829m712ffff4hfb64ff3ea236e1f1@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201002020819.55499.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2 Feb 2010 02:59:41 am Siarhei Liakh wrote:
> V9: coding style fixes

But not compile tested:

> +void set_page_attributes(void *start, void *end,
> +		void (*set)(unsigned long start, int num_pages))
> +{
> +	unsigned long begin_pfn = PFN_DOWN((unsigned long)start);
> +	unsigned long end_pfn = PFN_DOWN((unsigned long)end);
> +	if (end_pfn > begin_pfn)
> +		set(begin_pfn << PAGE_SHIFT, end_pfn - begin_pfn);
> +}
...
> +	if (ro_size > 0) {
> +		set_page_attributes((unsigned long)base,
> +					(unsigned long)base + ro_size,
> +					set_memory_ro);

The casts here should cause a warning. 

> +	if (total_size > text_size) {
> +		begin_pfn = PFN_UP((unsigned long)base + text_size);
> +		end_pfn = PFN_UP((unsigned long)base + total_size);
> +		if (end_pfn > begin_pfn)
> +			set_memory_nx(begin_pfn << PAGE_SHIFT,
> +						end_pfn - begin_pfn);

Use the helper here too?

> +		if ((mod->module_core) && (mod->core_text_size)) {
> +			set_page_attributes((unsigned long)mod->module_core,
> +						(unsigned long)mod->module_core
> +							+ mod->core_text_size,
> +						set_memory_rw);
> +		}
> +		if ((mod->module_init) && (mod->init_text_size)) {
> +			set_page_attributes((unsigned long)mod->module_init,
> +						(unsigned long)mod->module_init
> +							+ mod->init_text_size,
> +						set_memory_rw);

More unwanted casts...

> +			set_page_attributes((unsigned long)mod->module_core,
> +						(unsigned long)mod->module_core
> +							+ mod->core_text_size,
> +						set_memory_ro);
> +		}
> +		if ((mod->module_init) && (mod->init_text_size)) {
> +			set_page_attributes((unsigned long)mod->module_init,
> +						(unsigned long)mod->module_init
> +							+ mod->init_text_size,
> +						set_memory_ro);

Here, too.

Thanks,
Rusty.
