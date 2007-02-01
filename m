Return-Path: <linux-kernel-owner+w=401wt.eu-S1422823AbXBALho@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422823AbXBALho (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 06:37:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422821AbXBALhJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 06:37:09 -0500
Received: from cantor2.suse.de ([195.135.220.15]:56477 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422822AbXBALgg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 06:36:36 -0500
From: Andi Kleen <ak@suse.de>
To: jbohac@suse.cz
Subject: Re: [patch 5/9] Add all the necessary structures to the vsyscall page
Date: Thu, 1 Feb 2007 12:17:42 +0100
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org, Vojtech Pavlik <vojtech@suse.cz>,
       ssouhlal@freebsd.org, arjan@infradead.org, tglx@linutronix.de,
       johnstul@us.ibm.com, zippel@linux-m68k.org, andrea@suse.de
References: <20070201095952.589234000@jet.suse.cz> <20070201103753.849165000@jet.suse.cz>
In-Reply-To: <20070201103753.849165000@jet.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702011217.42286.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 01 February 2007 10:59, jbohac@suse.cz wrote:
>  struct vxtime_data {
> +	union {
> +		struct {
> +			u64 tsc_slope;		/* TSC to MT coefficient */
> +			u64 tsc_slope_avg;	/* average tsc_slope */
> +			u64 mt_base;		/* approximated MT at the last LAPIC tick */
> +			u64 mt_last;		/* MT at the last LAPIC tick */
> +			u64 tsc_last;		/* TSC at the last LAPIC tick */
> +			u64 last_mt_guess;	/* ensures monotonicity in temporary MT mode */
> +			char tsc_invalid;	/* don't trust the TSC now (frequency changing) */
> +		};
> +		char pad[64];	/* cacheline alignment */

Use some variant of __cacheline_aligned_in_smp

There are far better ways than to hardcode

> +	} cpu[NR_CPUS];

This can become very large with default NR_CPUS==128. I would prefer
a way that waste less space on smaller machines by only sizing the array
num_possible_cpus()

>  	long hpet_address;	/* HPET base address */
> -	int last;
> -	unsigned long last_tsc;
> -	long quot;
> -	long tsc_quot;
> +	u64 mt_q;		/* master timer to nsec quotient */
> +	u64 mt_wall;		/* MT ticks already covered by the jiffies */
> +	s64 ns_drift;		/* MT - xtime drift in the last tick in ns */

Might make sense to duplicate those to all per cpu datas, then they 
only need to acce

-Andi
