Return-Path: <linux-kernel-owner+w=401wt.eu-S1753414AbYINEoQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753414AbYINEoQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2008 00:44:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750776AbYINEoB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Sep 2008 00:44:01 -0400
Received: from rv-out-0506.google.com ([209.85.198.230]:12908 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750765AbYINEoA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2008 00:44:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=nZdFVwDK9lwysvkK8JTifL0mrUR//qr/2cwF+BNiiPQHKTHdmY1sbemKGGXPSgjGOy
         2epxUJ+1sxnbfxXlrzNwC0ZkLKuiDmc6wynh0JMXfFGLYK0T0HzLr9VW9faiw4eswRpK
         7AaBbkoVJ3fC2VMJIWJeWjyAks8fUzRLlLpew=
Message-ID: <86802c440809132143p287edb82i6a73efbc53e6e93f@mail.gmail.com>
Date: Sat, 13 Sep 2008 21:43:59 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Krzysztof Helt" <krzysztof.h1@wp.pl>
Subject: Re: [PATCH] x86: better CPU identification without the CPUID
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, tglx@linutronix.de,
       mingo@redhat.com
In-Reply-To: <20080913125606.d655bdcf.krzysztof.h1@wp.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080913125606.d655bdcf.krzysztof.h1@wp.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 13, 2008 at 3:56 AM, Krzysztof Helt <krzysztof.h1@wp.pl> wrote:
> From: Krzysztof Helt <krzysztof.h1@wp.pl>
>
> cpus without the CPUID instruction are identified
> as general 386 or 486 while some cpus (mostly made
> by Cyrix) provide c_identify function which identify
> correctly older cpus using cpu specific registers).
>
> Cyrix cpus are even worse as 5x86 and 6x68 have
> the CPUID instruction disabled. The CPUID is
> enabled by the c_identify() but the c_identify
> is only called when the CPUID is available.
>
> Fix this by calling the c_identify() for all known
> cpu families if there is no the CPUID instruction
>
> Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
> ---
>
> I have tested it on Cyrix Cx486DX2 cpu.
>
> I suspect that coma_bug field and mtrr support is not
> set correctly for the Cyrix 6x86 family. I have not a cpu from
> the Cyrix 6x68 family to test.
>
> The code path is (+ where the patch code is added)
>
> if (have_cpuid_p()) {
>
> }
> + } else {
> ...
> + }
>
> so it does not affect cpus with the CPUID instruction.
>
> Regards,
> Krzysztof
>
> diff -urp linux-mm/arch/x86/kernel/cpu/common.c linux-486/arch/x86/kernel/cpu/common.c
> --- linux-mm/arch/x86/kernel/cpu/common.c       2008-09-05 23:38:20.295563396 +0200
> +++ linux-486/arch/x86/kernel/cpu/common.c      2008-09-12 22:53:27.062265329 +0200
> @@ -444,6 +444,17 @@ static void __cpuinit generic_identify(s
>
>                init_scattered_cpuid_features(c);
>                detect_nopl(c);
> +       } else {
> +               int i;
> +               for (i = 0; i < X86_VENDOR_NUM; i++)
> +                       if (cpu_devs[i] && cpu_devs[i]->c_identify) {
> +                               c->x86_vendor_id[0] = 0;
> +                               cpu_devs[i]->c_identify(c);
> +                               if (c->x86_vendor_id[0]) {
> +                                       get_cpu_vendor(c, 0);
> +                                       break;
> +                               }
> +                       }
>        }
>  }
>
> --

1. can you check tip/master?
2. please check if you can add code in early_identify_cpu
3. need to move c_identify_cpu calling to identify_cpu

YH
