Return-Path: <linux-kernel-owner+w=401wt.eu-S1756856AbZFYS4D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756856AbZFYS4D (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 14:56:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754600AbZFYSzz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 14:55:55 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40661 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754302AbZFYSzy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 14:55:54 -0400
Date: Thu, 25 Jun 2009 11:54:23 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: maximilian attems <max@stro.at>
Cc: linux-kernel@vger.kernel.org, tj@kernel.org, dhowells@redhat.com,
       ink@jurassic.park.msu.ru
Subject: Re: >= 2.6.30 broken alpha smp build
Message-Id: <20090625115423.6a31b49c.akpm@linux-foundation.org>
In-Reply-To: <20090625090842.GA17936@stro.at>
References: <20090625090842.GA17936@stro.at>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Jun 2009 11:08:42 +0200
maximilian attems <max@stro.at> wrote:

> CC [M]  arch/alpha/kernel/srm_env.o
> In file included from /build/buildd-linux-2.6_2.6.30-1-alpha-vHGTgq/linux-2.6-2.6.30/debian/build/source_alpha_none/include/linux/percpu.h:10,
>                  from /build/buildd-linux-2.6_2.6.30-1-alpha-vHGTgq/linux-2.6-2.6.30/debian/build/source_alpha_none/arch/alpha/include/asm/local.h:4,
>                  from /build/buildd-linux-2.6_2.6.30-1-alpha-vHGTgq/linux-2.6-2.6.30/debian/build/source_alpha_none/include/linux/module.h:20,
>                  from /build/buildd-linux-2.6_2.6.30-1-alpha-vHGTgq/linux-2.6-2.6.30/debian/build/source_alpha_none/arch/alpha/kernel/srm_env.c:33:
> /build/buildd-linux-2.6_2.6.30-1-alpha-vHGTgq/linux-2.6-2.6.30/debian/build/source_alpha_none/arch/alpha/include/asm/percpu.h:100:1: error: "PER_CPU_ATTRIBUTES" redefined
> /build/buildd-linux-2.6_2.6.30-1-alpha-vHGTgq/linux-2.6-2.6.30/debian/build/source_alpha_none/arch/alpha/include/asm/percpu.h:52:1: error: this is the location of the previous definition
> make[6]: *** [arch/alpha/kernel/srm_env.o] Error 1
> make[5]: *** [arch/alpha/kernel] Error 2
> make[4]: *** [sub-make] Error 2
> make[3]: *** [all] Error 2
> make[2]: *** [debian/stamps/build_alpha_none_alpha-smp_plain] Error 2
> make[1]: *** [build_alpha_none_alpha-smp_real] Error 2

Me too.

> belows patch fixes aboves error but gives a new one on SMP
> 
> diff --git a/arch/alpha/include/asm/percpu.h b/arch/alpha/include/asm/percpu.h
> index 06c5c7a..622d585 100644
> --- a/arch/alpha/include/asm/percpu.h
> +++ b/arch/alpha/include/asm/percpu.h
> @@ -95,8 +95,8 @@ extern unsigned long __per_cpu_offset[NR_CPUS];
>  #define PER_CPU_SHARED_ALIGNED_SECTION ""
>  #define PER_CPU_FIRST_SECTION ""
>  
> -#endif
> -
>  #define PER_CPU_ATTRIBUTES
>  
> +#endif
> +
>  #endif /* __ALPHA_PERCPU_H */
> 
>   CC [M]  arch/alpha/kernel/srm_env.o

That fixed it.

> cc1: warnings being treated as errors
> In file included from /home/maks/src/linux-2.6-2.6.30/debian/build/source_alpha_none/include/linux/sched.h:86,
>                  from /home/maks/src/linux-2.6-2.6.30/debian/build/source_alpha_none/arch/alpha/include/asm/uaccess.h:5,
>                  from /home/maks/src/linux-2.6-2.6.30/debian/build/source_alpha_none/arch/alpha/kernel/srm_env.c:37:
> /home/maks/src/linux-2.6-2.6.30/debian/build/source_alpha_none/include/linux/hrtimer.h:310: error: ___~@~X__used_____~@~Y attribute ignored
> In file included from /home/maks/src/linux-2.6-2.6.30/debian/build/source_alpha_none/arch/alpha/include/asm/uaccess.h:5,
>                  from /home/maks/src/linux-2.6-2.6.30/debian/build/source_alpha_none/arch/alpha/kernel/srm_env.c:37:
> /home/maks/src/linux-2.6-2.6.30/debian/build/source_alpha_none/include/linux/sched.h:134: error: ___~@~X__used_____~@~Y attribute ignored
> make[6]: *** [arch/alpha/kernel/srm_env.o] Error 1
> 

This is the

#define PER_CPU_ATTRIBUTES	__used

in arch/alpha/include/asm/percpu.h, added by 

commit 9267b4b3880d00dc2dab90f1d817c856939114f7
Author:     Ivan Kokshaysky <ink@jurassic.park.msu.ru>
AuthorDate: Sat Jun 21 03:25:39 2008 +0400
Commit:     Linus Torvalds <torvalds@linux-foundation.org>
CommitDate: Fri Jun 20 16:46:10 2008 -0700

    alpha: fix module load failures on smp (bug #10926)


There's no indication in the changelog why this was added and afacit no
other architectures do it.  So I'm at a loss to help here. 
