Return-Path: <linux-kernel-owner+w=401wt.eu-S1752245AbZJXUJk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752245AbZJXUJk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Oct 2009 16:09:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752165AbZJXUJj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Oct 2009 16:09:39 -0400
Received: from mail-ew0-f208.google.com ([209.85.219.208]:35423 "EHLO
	mail-ew0-f208.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752026AbZJXUJi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Oct 2009 16:09:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=b/kSWBv/0DVivBP4Al5fRX5HISjJOxlQiK1s3HJGduwCYT4mvF2xKd8/fu3MoLRZyr
         dDvzH3elWu8rqBgcwy04rKoEOFaUFKDALdp8ZCIZVeylLHtWkcf9Q82wPgQR4QqYYZdL
         OcDhR3Tj7PF9Bnyx3Ki+DRZMZ/CGfZD53ORMI=
MIME-Version: 1.0
In-Reply-To: <20091023233756.941535000@alcatraz.americas.sgi.com>
References: <20091023233743.439628000@alcatraz.americas.sgi.com>
	 <20091023233756.941535000@alcatraz.americas.sgi.com>
Date: Sat, 24 Oct 2009 22:09:42 +0200
Message-ID: <b647ffbd0910241309u7b2f8c94t1f886ef31882539e@mail.gmail.com>
Subject: Re: [PATCH 6/8] SGI x86_64 UV: Limit the number of microcode messages
From: Dmitry Adamushko <dmitry.adamushko@gmail.com>
To: Mike Travis <travis@sgi.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jack Steiner <steiner@sgi.com>,
       Tigran Aivazian <tigran@aivazian.fsnet.co.uk>,
       "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
       Andreas Mohr <andi@lisas.de>, Hugh Dickins <hugh@veritas.com>,
       Hannes Eder <hannes@hanneseder.net>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/10/24 Mike Travis <travis@sgi.com>:
> Limit number of microcode messages of the form:
>
> [   50.887135] microcode: CPU0 sig=0x206e5, pf=0x4, revision=0xffff001
>
> [ ... ]
>
> --- linux.orig/arch/x86/kernel/microcode_intel.c
> +++ linux/arch/x86/kernel/microcode_intel.c
> @@ -165,7 +165,9 @@
>        /* get the current revision from MSR 0x8B */
>        rdmsr(MSR_IA32_UCODE_REV, val[0], csig->rev);
>
> -       printk(KERN_INFO "microcode: CPU%d sig=0x%x, pf=0x%x, revision=0x%x\n",
> +       if (cpu_num < 4 || !limit_console_output(false))
> +               printk(KERN_INFO
> +                       "microcode: CPU%d sig=0x%x, pf=0x%x, revision=0x%x\n",
>                        cpu_num, csig->sig, csig->pf, csig->rev);
>

Hmm, I guess we wouldn't lose a lot by simply removing those messages
completely. Per-cpu pf/revision is available via /sys anyway.

Alternatively, we might move the output into
microcode_core.c::collect_cpu_info() (or even microcode_init_cpu()) so
that the same logic is also applied for amd and do something as
following:

don't print if a cpu info is equal to the info of CPU#0. I guess, any
non-0 cpu would be even better as the microcode for cpu#0 can be
loaded by BIOS, if I'm not mistaken. But then we can only be sure
about the presence of cpu#0.

Anyway, it's not worthy of any additional complexity so I'd say let's
just remove the output :-)


-- Dmitry
