Return-Path: <linux-kernel-owner+w=401wt.eu-S1756732AbYF0L27@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756732AbYF0L27 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 07:28:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752844AbYF0L2q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 07:28:46 -0400
Received: from [194.117.236.238] ([194.117.236.238]:38567 "EHLO
	heracles.linux360.ro" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1756109AbYF0L2l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 07:28:41 -0400
Date: Fri, 27 Jun 2008 14:28:00 +0300
From: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
To: Johannes Weiner <hannes@saeurebad.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, tzanussi@gmail.com,
       penberg@cs.helsinki.fi, torvalds@linux-foundation.org,
       compudj@krystal.dyndns.org, vegard.nossum@gmail.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] Full conversion to early_initcall() interface,
 remove old interface.
Message-ID: <20080627142800.2c0b5cf1@linux360.ro>
In-Reply-To: <87d4m3ywpu.fsf@skyscraper.fehenstaub.lan>
References: <20080623153056.1862c14e@linux360.ro>
	<20080623172742.be332a53.akpm@linux-foundation.org>
	<20080625120151.56180b47@linux360.ro>
	<87d4m3ywpu.fsf@skyscraper.fehenstaub.lan>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Jun 2008 12:54:21 +0200
Johannes Weiner <hannes@saeurebad.de> wrote:

> Hi Eduard,

Hi.
 
> You forgot to remove the declaration from linux/interrupt.h.

The last patch was made against linux-next, as Andrew Morton
suggested, where spawn_ksoftirqd() was declared in the scope of
__do_pre_smp_initcall():
@@ -793,17 +784,6 @@ static void __init __do_pre_smp_initcalls(void)
 		do_one_initcall(*call);
 }
 
-static void __init do_pre_smp_initcalls(void)
-{
-	extern int spawn_ksoftirqd(void);
-
-	init_call_single_data();
-	migration_init();
-	spawn_ksoftirqd();
-	if (!nosoftlockup)
-		spawn_softlockup_task();
-}
-

It may be that some other patch in -mmotm moves that into
include/linux/interrupt.h. In linux-next with my patch, running
$ find . -name \*.h | xargs grep "spawn_ksoftirqd"
shows nothing.

Thanks for spotting this difference.

(Using -mmotm + quilt myself is an additional headache, since git
already does what I want in terms of patch (read commits) management;
that's why I prefered linux-next.)

> Andrew, the following fix is needed for -mmotm:
> 
> From: Johannes Weiner <hannes@saeurebad.de>
> Subject:
> full-conversion-to-early_initcall-interface-remove-old-interface-fix
> 
> Original patch made spawn_softirqd() static but failed to remove the
> global definition.  Do so now.
> 
> Signed-off-by: Johannes Weiner <hannes@saeurebad.de>
> ---
> 
> diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h
> index 30da779..62aa4f8 100644
> --- a/include/linux/interrupt.h
> +++ b/include/linux/interrupt.h
> @@ -299,7 +299,6 @@ extern void softirq_init(void);
>  #define __raise_softirq_irqoff(nr) do { or_softirq_pending(1UL <<
> (nr)); } while (0) extern void raise_softirq_irqoff(unsigned int nr);
>  extern void raise_softirq(unsigned int nr);
> -extern int spawn_ksoftirqd(void);
>  
>  
>  /* Tasklets --- multithreaded analogue of BHs.


	Cheers,
	Eduard
