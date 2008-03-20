Return-Path: <linux-kernel-owner+w=401wt.eu-S1756673AbYCTTcu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756673AbYCTTcu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2008 15:32:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754621AbYCTTcj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Mar 2008 15:32:39 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:36504 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754616AbYCTTci (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2008 15:32:38 -0400
Date: Thu, 20 Mar 2008 15:32:35 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org
Subject: Re: [PATCH -rt] rt-slab: fix cpu inconsistency case
In-Reply-To: <47E2A63B.4020003@ct.jp.nec.com>
Message-ID: <Pine.LNX.4.58.0803201519160.21990@gandalf.stny.rr.com>
References: <47E2A63B.4020003@ct.jp.nec.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Hiroshi,

Thanks for looking into it. I'll take a deeper look at it later, but
first I have a few nitpicks with the patch.

On Thu, 20 Mar 2008, Hiroshi Shimamoto wrote:
>
> Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
> ---
>  mm/slab.c |   18 +++++++++---------
>  1 files changed, 9 insertions(+), 9 deletions(-)
>
> diff --git a/mm/slab.c b/mm/slab.c
> index 4bf6ca8..7beb378 100644
> --- a/mm/slab.c
> +++ b/mm/slab.c
> @@ -138,8 +138,8 @@
>   *
>   * (On PREEMPT_RT, these are NOPs, but we have to drop/get the irq locks.)
>   */
> -# define slab_irq_disable_nort()	local_irq_disable()
> -# define slab_irq_enable_nort()		local_irq_enable()
> +# define slab_irq_disable_nort(cpu)	slab_irq_disable(cpu)
> +# define slab_irq_enable_nort(cpu)	slab_irq_enable(cpu)

This is the !PREEMPT_RT version. It should stay as is (with the
exception of ignoring the "cpu" variable. [ (void)cpu; ? ]

#define slab_irq_disable_nort(cpu) \
	do { \
		(void)cpu;  \
		local_irq_disable(); \
	} while(0)


>  # define slab_irq_disable_rt(flags)	do { (void)(flags); } while (0)
>  # define slab_irq_enable_rt(flags)	do { (void)(flags); } while (0)
>  # define slab_spin_lock_irq(lock, cpu) \
> @@ -160,8 +160,8 @@ DEFINE_PER_CPU_LOCKED(int, slab_irq_locks) = { 0, };
>  	do { slab_irq_enable(cpu); (void) (flags); } while (0)
>  # define slab_irq_disable_rt(cpu)	slab_irq_disable(cpu)
>  # define slab_irq_enable_rt(cpu)	slab_irq_enable(cpu)
> -# define slab_irq_disable_nort()	do { } while (0)
> -# define slab_irq_enable_nort()		do { } while (0)
> +# define slab_irq_disable_nort(cpu)	do { } while (0)
> +# define slab_irq_enable_nort(cpu)	do { } while (0)

And these are the PREEMPT_RT version. So basically, this patch is a nop
for PREEMPT_RT. I doubt it will solve your bug ;-)


-- Steve

