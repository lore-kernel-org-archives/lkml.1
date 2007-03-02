Return-Path: <linux-kernel-owner+w=401wt.eu-S965236AbXCBTqF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965236AbXCBTqF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 14:46:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965225AbXCBTqE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 14:46:04 -0500
Received: from smtp.osdl.org ([65.172.181.24]:38849 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965199AbXCBTp4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 14:45:56 -0500
Date: Fri, 2 Mar 2007 11:45:24 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       john stultz <johnstul@us.ibm.com>, Roman Zippel <zippel@linux-m68k.org>,
       Christian Borntraeger <cborntra@de.ibm.com>, linux-s390@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch] timer/hrtimer: take per cpu locks in sane order
Message-Id: <20070302114524.1c61cf22.akpm@linux-foundation.org>
In-Reply-To: <20070302190836.GA7942@osiris.ibm.com>
References: <20070227153051.GD7911@osiris.boeblingen.de.ibm.com>
	<20070302125848.GA8226@osiris.boeblingen.de.ibm.com>
	<20070302130433.GA4391@elte.hu>
	<20070302142308.GB8226@osiris.boeblingen.de.ibm.com>
	<20070302084833.732d09dd.akpm@linux-foundation.org>
	<20070302190836.GA7942@osiris.ibm.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2 Mar 2007 20:08:36 +0100
Heiko Carstens <heiko.carstens@de.ibm.com> wrote:

> +/*
> + * double_hrtimer_lock/unlock are used to ensure that on cpu hotplug the
> + * per cpu timer locks are always taken in the same order.
> + */
> +static void double_hrtimer_lock(struct hrtimer_cpu_base *base1,
> +				struct hrtimer_cpu_base *base2, int ind)
> +	__acquires(base1->lock)
> +	__acquires(base2->lock)
> +{
>
> ...
>
> +/*
> + * double_timer_lock/unlock are used to ensure that on cpu hotplug the
> + * per cpu timer locks are always taken in the same order.
> + */
> +static void __devinit double_timer_lock(tvec_base_t *base1,
> +					tvec_base_t *base2, int ind)
> +	__acquires(base1->lock)
> +	__acquires(base2->lock)

hm.  Can we not just pass in the spinlock_t*'s and use a common function?

	void double_spin_lock(spinlock_t *l1, spinlock_t *l2, int ind);

that way it has nothing to do with timers and can potentially be used
elsewhere in the kernel, too.

(what does "ind" mean?)
