Return-Path: <linux-kernel-owner+w=401wt.eu-S1755332AbZHDMSy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755332AbZHDMSy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 08:18:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755138AbZHDMSy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 08:18:54 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:47725 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755091AbZHDMSx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 08:18:53 -0400
Date: Tue, 4 Aug 2009 14:18:38 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Akinobu Mita <akinobu.mita@gmail.com>, mingo@redhat.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de,
       linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/asm] x86: Introduce GDT_ENTRY_INIT()
Message-ID: <20090804121838.GA4367@elte.hu>
References: <20090718151219.GD11294@localhost.localdomain> <tip-d520da1173abd1f918b7e690220e14ba0fc56cfc@git.kernel.org> <20090803062024.GA22365@elte.hu> <4A768339.9060904@zytor.com> <961aa3350908030811n6467b2d7hf42dfd58e3a438e7@mail.gmail.com> <4A76FF8E.80507@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A76FF8E.80507@zytor.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* H. Peter Anvin <hpa@zytor.com> wrote:

> On 08/03/2009 08:11 AM, Akinobu Mita wrote:
> >>>>
> >> OK, I spotted the following error, which certainly would explain a crash on
> >> an APM machine:
> >>
> >>        /* data */
> >> -       [GDT_ENTRY_APMBIOS_BASE+2]      = { { { 0x0000ffff, 0x00409200 } }
> >> },
> >> +       [GDT_ENTRY_APMBIOS_BASE+2]      = GDT_ENTRY_INIT(0x409a, 0, 0xffff),
> > 
> > Oops, I really should have checked the binary because the compiler should
> > generate same code with this patch.
> > 
> 
> Well, it doesn't even on the best of days, because the last hunk changes
> a dynamic initializer to a strange mix between static and dynamic:
> 
> -static struct desc_struct bad_bios_desc;
> +static struct desc_struct bad_bios_desc = GDT_ENTRY_INIT(0x4092, 0, 0);
> 
>  /*
>   * At some point we want to use this stack frame pointer to unwind
> @@ -476,9 +476,6 @@ void pnpbios_calls_init(union
> pnp_bios_install_struct *header)
>         pnp_bios_callpoint.offset = header->fields.pm16offset;
>         pnp_bios_callpoint.segment = PNP_CS16;
> 
> -       bad_bios_desc.a = 0;
> -       bad_bios_desc.b = 0x00409200;
> -
>         set_desc_base(&bad_bios_desc, (unsigned long)__va(0x40UL << 4));
>         set_desc_limit(&bad_bios_desc, 4095 - (0x40 << 4));
> 
> This is about at strange as it comes; I think we could simply do:
> 
> GDT_ENTRY_INIT(0x4092, (unsigned long)__va(0x400UL), 4095-0x400);
> 
> Although perhaps the 4095 should really be PAGE_SIZE-1...

I've removed the patch for now - please resubmit when fixed.

	Ingo
