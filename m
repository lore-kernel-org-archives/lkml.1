Return-Path: <linux-kernel-owner+w=401wt.eu-S1752032AbXCDXhy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752032AbXCDXhy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2007 18:37:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752033AbXCDXhx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Mar 2007 18:37:53 -0500
Received: from waste.org ([66.93.16.53]:33896 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752032AbXCDXhx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2007 18:37:53 -0500
Date: Sun, 4 Mar 2007 17:24:43 -0600
From: Matt Mackall <mpm@selenic.com>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       john stultz <johnstul@us.ibm.com>, Roman Zippel <zippel@linux-m68k.org>,
       Christian Borntraeger <cborntra@de.ibm.com>, linux-s390@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch] timer/hrtimer: take per cpu locks in sane order
Message-ID: <20070304232443.GP16722@waste.org>
References: <20070227153051.GD7911@osiris.boeblingen.de.ibm.com> <20070302125848.GA8226@osiris.boeblingen.de.ibm.com> <20070302130433.GA4391@elte.hu> <20070302142308.GB8226@osiris.boeblingen.de.ibm.com> <20070302084833.732d09dd.akpm@linux-foundation.org> <20070302190836.GA7942@osiris.ibm.com> <20070302114524.1c61cf22.akpm@linux-foundation.org> <20070302213959.GA9514@osiris.ibm.com> <20070302224752.GB9514@osiris.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070302224752.GB9514@osiris.ibm.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 02, 2007 at 11:47:52PM +0100, Heiko Carstens wrote:
>  /*
> + * Locks two spinlocks l1 and l2.
> + * l1_first indicates if spinlock l1 should be taken first.
> + */
> +static inline void double_spin_lock(spinlock_t *l1, spinlock_t *l2,
> +				    bool l1_first)
> +	__acquires(l1)
> +	__acquires(l2)
> +{
> +	if (l1_first) {
> +		spin_lock(l1);
> +		spin_lock(l2);
> +	} else {
> +		spin_lock(l2);
> +		spin_lock(l1);
> +	}
> +}

Two observations:

- We probably don't want people using this for locks that aren't
  explicitly in the same level of the hierarchy. The name should
  somehow indicate that. Something like spin_lock_siblings()?

- And once we know that, we can internally impose a natural stable
  ordering on them based on their addresses, eliminating the third
  argument and the need to duplicate the ordering calculation.

-- 
Mathematics is the supreme nostalgia of our time.
