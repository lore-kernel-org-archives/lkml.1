Return-Path: <linux-kernel-owner+w=401wt.eu-S1755865AbXE2OhY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755865AbXE2OhY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 10:37:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751634AbXE2OhM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 10:37:12 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:59118 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751230AbXE2OhL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 10:37:11 -0400
Date: Wed, 30 May 2007 00:37:02 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Stephane Eranian <eranian@frankl.hpl.hp.com>
Cc: linux-kernel@vger.kernel.org, eranian@hpl.hp.com
Subject: Re: [PATCH 01/22] 2.6.22-rc3 perfmon2: arch-specific infrastructure
 changes
Message-Id: <20070530003702.88220bd3.sfr@canb.auug.org.au>
In-Reply-To: <200705291348.l4TDmF4w019619@frankl.hpl.hp.com>
References: <200705291348.l4TDmF4w019619@frankl.hpl.hp.com>
X-Mailer: Sylpheed 2.4.0 (GTK+ 2.10.12; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__30_May_2007_00_37_02_+1000_x_l+zbFLLe_zt9Ah"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__30_May_2007_00_37_02_+1000_x_l+zbFLLe_zt9Ah
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: 7bit

Hi Stephane,

Just a few white space nits.

On Tue, 29 May 2007 06:48:15 -0700 Stephane Eranian <eranian@frankl.hpl.hp.com> wrote:
>
> diff -urNp --exclude=.git linux-2.6.22.orig/arch/mips/kernel/smp.c linux-2.6.22.base/arch/mips/kernel/smp.c
> --- linux-2.6.22.orig/arch/mips/kernel/smp.c	2007-04-25 20:08:32.000000000 -0700
> +++ linux-2.6.22.base/arch/mips/kernel/smp.c	2007-05-29 03:20:21.000000000 -0700
> @@ -203,6 +203,52 @@ void smp_call_function_interrupt(void)
>  	}
>  }
>
> +int smp_call_function_single (int cpu, void (*func) (void *info), void *info, int retry,

We don't put spaces between the function name and the open parenthesis.

> +			      int wait)
> +{
> +  struct call_data_struct data;
> +  int me = smp_processor_id();
> +
> +  /*
> +     * Can die spectacularly if this CPU isn't yet marked online
> +      */
> +  BUG_ON(!cpu_online(me));
> +  if (cpu == me) {
> +    WARN_ON(1);
> +    return -EBUSY;
> +    }
> +
> +  /* Can deadlock when called with interrupts disabled */
> +  WARN_ON(irqs_disabled());
> +
> +  data.func = func;
> +  data.info = info;
> +  atomic_set(&data.started, 0);
> +  data.wait = wait;
> +  if (wait)
> +    atomic_set(&data.finished, 0);
> +
> +  spin_lock(&smp_call_lock);
> +  call_data = &data;
> +  mb();
> +
> +  /* Send a message to the other CPU */
> +  core_send_ipi(cpu, SMP_CALL_FUNCTION);
> +
> +  /* Wait for response */
> +  /* FIXME: lock-up detection, backtrace on lock-up */
> +  while (atomic_read(&data.started) != 1)
> +    barrier();
> +
> +  if (wait)
> +    while (atomic_read(&data.finished) != 1)
> +      barrier();
> +  call_data = NULL;
> +  spin_unlock(&smp_call_lock);
> +
> +  return 0;
> +}

Please use tabs for indentation ...

> diff -urNp --exclude=.git linux-2.6.22.orig/include/asm-avr32/thread_info.h linux-2.6.22.base/include/asm-avr32/thread_info.h
> --- linux-2.6.22.orig/include/asm-avr32/thread_info.h	2007-05-29 03:16:27.000000000 -0700
> +++ linux-2.6.22.base/include/asm-avr32/thread_info.h	2007-05-29 03:20:21.000000000 -0700
> @@ -74,20 +74,18 @@ static inline struct thread_info *curren
>   * - other flags in MSW
>   */
>  #define TIF_SYSCALL_TRACE       0       /* syscall trace active */
> -#define TIF_NOTIFY_RESUME       1       /* resumption notification requested */
> -#define TIF_SIGPENDING          2       /* signal pending */
> -#define TIF_NEED_RESCHED        3       /* rescheduling necessary */
> -#define TIF_POLLING_NRFLAG      4       /* true if poll_idle() is polling
> +#define TIF_SIGPENDING          1       /* signal pending */
> +#define TIF_NEED_RESCHED        2       /* rescheduling necessary */
> +#define TIF_POLLING_NRFLAG      3       /* true if poll_idle() is polling

These could be tab indented since you are changing them anyway.  And
similarly in some of the other files.

--
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__30_May_2007_00_37_02_+1000_x_l+zbFLLe_zt9Ah
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFGXDqUFdBgD/zoJvwRAkGkAJ97wHuqWhleI2MHi4sQBm7wwdKgLQCeOboD
iyC9qBdcj+mIP321kUEM0mc=
=6YGF
-----END PGP SIGNATURE-----

--Signature=_Wed__30_May_2007_00_37_02_+1000_x_l+zbFLLe_zt9Ah--
