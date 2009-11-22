Return-Path: <linux-kernel-owner+w=401wt.eu-S1755029AbZKVMfq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755029AbZKVMfq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Nov 2009 07:35:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754403AbZKVMfp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Nov 2009 07:35:45 -0500
Received: from h5.dl5rb.org.uk ([81.2.74.5]:46760 "EHLO h5.dl5rb.org.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753538AbZKVMfp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Nov 2009 07:35:45 -0500
Date: Sun, 22 Nov 2009 12:35:09 +0000
From: Ralf Baechle <ralf@linux-mips.org>
To: Wu Zhangjin <wuzhangjin@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-mips@linux-mips.org,
       Thomas Gleixner <tglx@linutronix.de>, Michal Simek <monstr@monstr.eu>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] MIPS: Add a high resolution sched_clock() via
	cnt32_to_63().
Message-ID: <20091122123509.GA1941@linux-mips.org>
References: <dae45f23b5d34f64fc60a445015e7dfe05aa0d07.1258875717.git.wuzhangjin@gmail.com> <20091122081328.GB24558@elte.hu> <1258888086.4548.52.camel@falcon.domain.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1258888086.4548.52.camel@falcon.domain.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 22, 2009 at 07:08:05PM +0800, Wu Zhangjin wrote:

> > > +	data = (0xffffffffUL / tclk / 2 - 2) * HZ;
> 
> Because the MIPS c0 count's frequency is half of the cpu frequency(Hi,
> Ralf, does every MIPS c0 count meet this feature?), so, the above line
> should be:

There are processors which have no cp0 counter at all; these are mostly
very old pre-R4000 era 32-bit MIPS I and MIPS II cores.

Of those which have a cp0 counter most will clock it at "half the maximum
instruction issue rate" and a few at the full rate.  Finally for a few
such as the RM52xx either half or the full count the rate is selectable by
the reset initialization bitstream fed into the processor.  Too make this
feature suck nicely there is no way for software to find out which rate
was selected so software must know that or calibrate against a timer of
known frequency.

Platform-specific code does this by setting mips_hpt_frequency to the
count rate before calling init_r4k_clocksource; it's also the value being
passed into setup_sched_clock_update() so you don't need to count for the
half / full clock rate thing there.

I don't see why you need the -2 in your formula so the whole thing can
be simplified to:

	data = 0x80000000 / tclk * HZ;

  Ralf
