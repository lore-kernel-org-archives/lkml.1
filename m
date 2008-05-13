Return-Path: <linux-kernel-owner+w=401wt.eu-S1760594AbYEMODd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760594AbYEMODd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 10:03:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755785AbYEMOD0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 10:03:26 -0400
Received: from qb-out-0506.google.com ([72.14.204.238]:56335 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751167AbYEMODY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 10:03:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=mkz5vXGfc9yqr4n7jOerwLITf+sEy/DFA+9wwAjLqcUIQ9PHcbxc/OgYjlQqD4GDqvAdHlPnodCgLsZZVupjCRsAk57fxF1BzJNL/64Djcnbth7UX3jjtiA20v2HZGEBOD8MtBGxQXpcUtMLeI4MgBXfIaaCTXirgDIVnj/6IZc=
Message-ID: <5d6222a80805130703n68018048se32e7feadea26dc4@mail.gmail.com>
Date: Tue, 13 May 2008 11:03:21 -0300
From: "Glauber Costa" <glommer@gmail.com>
To: "Hugh Dickins" <hugh@veritas.com>
Subject: Re: [PATCH] x86: fix app crashes after SMP resume
Cc: "Glauber Costa" <gcosta@redhat.com>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Ingo Molnar" <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       "Theodore Ts'o" <tytso@mit.edu>, "Carlos R. Mafra" <crmafra2@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0805131420030.5781@blonde.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0805131420030.5781@blonde.site>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 13, 2008 at 10:26 AM, Hugh Dickins <hugh@veritas.com> wrote:
> After resume on a 2cpu laptop, kernel builds collapse with a sed hang,
>  sh or make segfault (often on 20295564), real-time signal to cc1 etc.
>
>  Several hurdles to jump, but a manually-assisted bisect led to -rc1's
>  d2bcbad5f3ad38a1c09861bca7e252dde7bb8259 x86: do not zap_low_mappings
>  in __smp_prepare_cpus.  Though the low mappings were removed at bootup,
>  they were left behind (with Global flags helping to keep them in TLB)
>  after resume or cpu online, causing the crashes seen.
>
>  Reinstate zap_low_mappings (with local __flush_tlb_all) for each cpu_up
>  on x86_32.  This used to be serialized by smp_commenced_mask: that's now
>  gone, but a low_mappings flag will do.  No need for native_smp_cpus_done
>  to repeat the zap: let mem_init zap BSP's low mappings just like on UP.

Great!

Thanks for finding and fixing this, hugh.

>  --- 2.6.26-rc2/arch/x86/kernel/smpboot.c        2008-05-12 02:01:05.000000000 +0100
>  +++ linux/arch/x86/kernel/smpboot.c     2008-05-12 14:07:06.000000000 +0100
>  @@ -86,6 +86,7 @@ void *x86_bios_cpu_apicid_early_ptr;
>
>   #ifdef CONFIG_X86_32
>   u8 apicid_2_node[MAX_APICID];
>  +static int low_mappings;
>   #endif
>
>   /* State of each CPU */
>  @@ -326,6 +327,12 @@ static void __cpuinit start_secondary(vo
>                 enable_8259A_irq(0);
>         }
>
>  +#ifdef CONFIG_X86_32
>  +       while (low_mappings)
>  +               cpu_relax();
>  +       __flush_tlb_all();
>  +#endif
>  +

If possible, we don't want to introduce any more ifdefs. Should be
better to do it openly, define low_mappings as always 0 for x86_64. We
can use an unlikely() test to make it faster too.

>         /* This must be done before setting cpu_online_map */
>         set_cpu_sibling_map(raw_smp_processor_id());
>         wmb();
>  @@ -1040,14 +1047,20 @@ int __cpuinit native_cpu_up(unsigned int
>   #ifdef CONFIG_X86_32
>         /* init low mem mapping */
>         clone_pgd_range(swapper_pg_dir, swapper_pg_dir + KERNEL_PGD_BOUNDARY,
>  -                       min_t(unsigned long, KERNEL_PGD_PTRS, KERNEL_PGD_BOUNDARY));
>  +               min_t(unsigned long, KERNEL_PGD_PTRS, KERNEL_PGD_BOUNDARY));
>         flush_tlb_all();
>  -#endif
>  +       low_mappings = 1;
>
>         err = do_boot_cpu(apicid, cpu);
>  -       if (err < 0) {
>  +
>  +       zap_low_mappings();
>  +       low_mappings = 0;
>  +#else
>  +       err = do_boot_cpu(apicid, cpu);
>  +#endif
>  +       if (err) {
>                 Dprintk("do_boot_cpu failed %d\n", err);
>  -               return err;
>  +               return -EIO;
>         }
>
>         /*
>  @@ -1259,9 +1272,6 @@ void __init native_smp_cpus_done(unsigne
>         setup_ioapic_dest();
>   #endif
>         check_nmi_watchdog();
>  -#ifdef CONFIG_X86_32
>  -       zap_low_mappings();
>  -#endif
>   }
>
>   #ifdef CONFIG_HOTPLUG_CPU
>  --- 2.6.26-rc2/arch/x86/mm/init_32.c    2008-05-03 21:54:41.000000000 +0100
>  +++ linux/arch/x86/mm/init_32.c 2008-05-12 14:07:06.000000000 +0100
>  @@ -438,8 +438,6 @@ void zap_low_mappings(void)
>   {
>         int i;
>
>  -       save_pg_dir();
>  -
>         /*
>          * Zap initial low-memory mappings.
>          *
>  @@ -663,16 +661,8 @@ void __init mem_init(void)
>                 test_wp_bit();
>
>         cpa_init();
>  -
>  -       /*
>  -        * Subtle. SMP is doing it's boot stuff late (because it has to
>  -        * fork idle threads) - but it also needs low mappings for the
>  -        * protected-mode entry to work. We zap these entries only after
>  -        * the WP-bit has been tested.
>  -        */
>  -#ifndef CONFIG_SMP
>  +       save_pg_dir();
>         zap_low_mappings();
>  -#endif
>   }
>
>   #ifdef CONFIG_MEMORY_HOTPLUG
>



-- 
Glauber Costa.
"Free as in Freedom"
http://glommer.net

"The less confident you are, the more serious you have to act."
