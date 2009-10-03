Return-Path: <linux-kernel-owner+w=401wt.eu-S1753592AbZJCHVb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753592AbZJCHVb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Oct 2009 03:21:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753147AbZJCHVa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Oct 2009 03:21:30 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:35650 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752849AbZJCHVa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Oct 2009 03:21:30 -0400
Date: Sat, 3 Oct 2009 09:21:27 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Matteo Croce <technoboy85@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Subject: Re: i686 quirk for AMD Geode
Message-ID: <20091003072127.GC21407@elte.hu>
References: <40101cc30910021912r17b3a08bue1b9412e4fa47d89@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <40101cc30910021912r17b3a08bue1b9412e4fa47d89@mail.gmail.com>
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


* Matteo Croce <technoboy85@gmail.com> wrote:

> Hi,
> 
> the AMD GEode LX has an x86 id of 5 (i586) tought it's technically an i686:
> 
> root@alix:/usr/src# cat /proc/cpuinfo
> processor       : 0
> vendor_id       : AuthenticAMD
> cpu family      : 5
> model           : 10
> model name      : Geode(TM) Integrated Processor by AMD PCS
> stepping        : 2
> cpu MHz         : 498.060
> cache size      : 128 KB
> fdiv_bug        : no
> hlt_bug         : no
> f00f_bug        : no
> coma_bug        : no
> fpu             : yes
> fpu_exception   : yes
> cpuid level     : 1
> wp              : yes
> flags           : fpu de pse tsc msr cx8 sep pge cmov clflush mmx
> mmxext 3dnowext 3dnow
> bogomips        : 996.12
> clflush size    : 32
> cache_alignment : 32
> address sizes   : 32 bits physical, 32 bits virtual
> power management:
> 
> indeed it has mmx, mmxext and cmov.
> So I added the quirk below and I can confirm that the system is running fine.
> I did an x264 encode to trigger any SIGILL due to missing opcodes, but
> it worked.
> 
> I also did this simple test which gives a ~2.5x speed boost:
> http://pastebin.ca/1590089
> 
> I wish some feedback from someone, I really dunno why AMD set the
> cpuid value to 5
> 
> --- a/arch/x86/kernel/cpu/bugs.c	2009-10-03 03:43:02.399323313 +0200
> +++ b/arch/x86/kernel/cpu/bugs.c	2009-10-03 03:54:22.582205090 +0200
> @@ -151,6 +151,12 @@
>  #endif
>  }
> 
> +static void __init check_geode_i586(void)
> +{
> +	if(boot_cpu_data.x86_vendor == X86_VENDOR_AMD &&
> +	   boot_cpu_data.x86_model == 10 && boot_cpu_data.x86 == 5)
> +		boot_cpu_data.x86 = 6;
> +}
> 
>  void __init check_bugs(void)
>  {
> @@ -163,6 +169,7 @@
>  	check_fpu();
>  	check_hlt();
>  	check_popad();
> +	check_geode_i586();
>  	init_utsname()->machine[1] =
>  		'0' + (boot_cpu_data.x86 > 6 ? 6 : boot_cpu_data.x86);
>  	alternative_instructions();

Looks good, but your signoff line is missing.

	Ingo
