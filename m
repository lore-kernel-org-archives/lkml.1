Return-Path: <linux-kernel-owner+w=401wt.eu-S936182AbXHIGhr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936182AbXHIGhr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 02:37:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760565AbXHIGhj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 02:37:39 -0400
Received: from gw.goop.org ([64.81.55.164]:57440 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758869AbXHIGhi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 02:37:38 -0400
Message-ID: <46BAB5C8.5090906@goop.org>
Date: Wed, 08 Aug 2007 23:35:52 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Glauber de Oliveira Costa <gcosta@redhat.com>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       rusty@rustcorp.com.au, ak@suse.de, mingo@elte.hu, chrisw@sous-sol.org,
       avi@qumranet.com, anthony@codemonkey.ws,
       virtualization@lists.linux-foundation.org, lguest@ozlabs.org,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 25/25] [PATCH] add paravirtualization support for x86_64
References: <11865467522495-git-send-email-gcosta@redhat.com> <1186546785346-git-send-email-gcosta@redhat.com> <1186546789356-git-send-email-gcosta@redhat.com> <11865467931543-git-send-email-gcosta@redhat.com> <11865467973510-git-send-email-gcosta@redhat.com> <11865468003673-git-send-email-gcosta@redhat.com> <11865468043920-git-send-email-gcosta@redhat.com> <118654680831-git-send-email-gcosta@redhat.com> <11865468122642-git-send-email-gcosta@redhat.com> <11865468162812-git-send-email-gcosta@redhat.com> <1186546820708-git-send-email-gcosta@redhat.com> <11865468243612-git-send-email-gcosta@redhat.com> <11865468281860-git-send-email-gc! osta@redhat.com> <11865468321629-git-send-email-gcosta@redhat.com> <11865468362401-git-send-email-gcosta@redhat.com> <11865468394005-git-send-email-gcosta@redhat.com> <11865468431616-git-send-email-gcosta@redhat.com> <1186546847263-git-send-email-gcosta@redhat.com> <11865468513077-git-send-email-gcosta@redhat.com>
In-Reply-To: <11865468513077-git-send-email-gcosta@redhat.com>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Glauber de Oliveira Costa wrote:
> +static unsigned native_patch(u8 type, u16 clobbers, void *insns, unsigned len)
> +{
> +	const unsigned char *start, *end;
> +	unsigned ret;
> +
> +	switch(type) {
> +#define SITE(x)	case PARAVIRT_PATCH(x):	start = start_##x; end = end_##x; goto patch_site
> +		SITE(irq_disable);
> +		SITE(irq_enable);
> +		SITE(restore_fl);
> +		SITE(save_fl);
> +		SITE(iret);
> +		SITE(sysret);
> +		SITE(swapgs);
> +		SITE(read_cr2);
> +		SITE(read_cr3);
> +		SITE(write_cr3);
> +		SITE(clts);
> +		SITE(flush_tlb_single);
> +		SITE(wbinvd);
> +#undef SITE
> +
> +	patch_site:
> +		ret = paravirt_patch_insns(insns, len, start, end);
> +		break;
> +
> +	case PARAVIRT_PATCH(make_pgd):
> +	case PARAVIRT_PATCH(pgd_val):
> +	case PARAVIRT_PATCH(make_pte):
> +	case PARAVIRT_PATCH(pte_val):
> +	case PARAVIRT_PATCH(make_pmd):
> +	case PARAVIRT_PATCH(pmd_val):
> +	case PARAVIRT_PATCH(make_pud):
> +	case PARAVIRT_PATCH(pud_val):
> +		/* These functions end up returning what
> +		   they're passed in the first argument */
>   

Is this still true with 64-bit?  Either way, I don't think its worth
having this here.  The damage to codegen around all those sites has
already happened, and the additional cost of a noop direct call is
pretty trivial.  I think this is a nanooptimisation which risks more
problems than it could possibly be worth.

> +	case PARAVIRT_PATCH(set_pte):
> +	case PARAVIRT_PATCH(set_pmd):
> +	case PARAVIRT_PATCH(set_pud):
> +	case PARAVIRT_PATCH(set_pgd):
> +		/* These functions end up storing the second
> +		 * argument in the location pointed by the first */
> +		ret = paravirt_patch_store_reg(insns, len);
> +		break;
>   

Ditto, really.  Do this in a later patch if it actually seems to help.

> +unsigned paravirt_patch_copy_reg(void *site, unsigned len)
> +{
> +	unsigned char *mov = site;
> +	if (len < 3)
> +		return len;
> +
> +	/* This is mov %rdi, %rax */
> +	*mov++ = 0x48;
> +	*mov++ = 0x89;
> +	*mov   = 0xf8;
> +	return 3;
> +}
> +
> +unsigned paravirt_patch_store_reg(void *site, unsigned len)
> +{
> +	unsigned char *mov = site;
> +	if (len < 3)
> +		return len;
> +
> +	/* This is mov %rsi, (%rdi) */
> +	*mov++ = 0x48;
> +	*mov++ = 0x89;
> +	*mov   = 0x37;
> +	return 3;
> +}
>   

These seem excessively special-purpose.  Are their only uses the ones I
commented on above.

> +/*
> + * integers must be use with care here. They can break the PARAVIRT_PATCH(x)
> + * macro, that divides the offset in the structure by 8, to get a number
> + * associated with the hook. Dividing by four would be a solution, but it
> + * would limit the future growth of the structure if needed.
>   

Why not just stick them at the end of the structure?


    J

