Return-Path: <linux-kernel-owner+w=401wt.eu-S1755180AbZDTLQk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755180AbZDTLQk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 07:16:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754632AbZDTLQb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 07:16:31 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:40432 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754613AbZDTLQa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 07:16:30 -0400
Date: Mon, 20 Apr 2009 13:16:19 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [git-pull -tip] x86: cpu_debug patches
Message-ID: <20090420111619.GE6670@elte.hu>
References: <1240190145.3106.90.camel@ht.satnam> <1240191359.3106.93.camel@ht.satnam> <1240217428.3083.2.camel@ht.satnam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1240217428.3083.2.camel@ht.satnam>
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


* Jaswinder Singh Rajput <jaswinder@kernel.org> wrote:

>  static DEFINE_PER_CPU(struct cpu_cpuX_base, cpu_arr[CPU_REG_ALL_BIT]);
>  static DEFINE_PER_CPU(struct cpu_private *, priv_arr[MAX_CPU_FILES]);
>  static DEFINE_PER_CPU(unsigned, cpu_modelflag);
>  static DEFINE_PER_CPU(int, cpu_priv_count);
> -static DEFINE_PER_CPU(unsigned, cpu_model);
> +
> +/* Storing vendor locally because it is used excessive in this code */
> +static unsigned cpu_vendor;

There's still no need to store it locally - what's wrong with 
cpu_data(cpu) or current_cpu_data?

Also, do we need the per-cpu cpu_modelflag variable too? I'd suggest 
to integrate that kind of enumeration into struct cpuinfo_x86 and 
cpu_info. We often have such kinds of constructs in x86 code:

	c->x86 <= 0x11

So extending your scheme to other code would benefit all code.

Plus this kind of enumeration:

        switch (model) {
        case 0x0501:
        case 0x0502:
        case 0x0504:
                flag = CPU_INTEL_PENTIUM;
                break;
        case 0x0601:
        case 0x0603:
        case 0x0605:
        case 0x0607:
        case 0x0608:
        case 0x060A:
        case 0x060B:
                flag = CPU_INTEL_P6;

The 0x05/0x06 there is already available as the family flag in 
cpuinfo_x86, as cpu_info::x86. The 01,02...0B model portion is also 
already available as cpu_info::x86_model.

[ there's also cpu_info::x86_mask, which gives the stepping. ]

This is what i meant when i said that you needlessly duplicate 
already existing information. You encode/decode it in some weird 
looking way instead of using the already existing, per CPU 
information of cpu_info.

	Ingo
