Return-Path: <linux-kernel-owner+w=401wt.eu-S939586AbXGSRsf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939586AbXGSRsf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 13:48:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758766AbXGSRsZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 13:48:25 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:38344 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756755AbXGSRsY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 13:48:24 -0400
Subject: Re: [PATCH] [15/58] i386: Rewrite sched_clock
From: Daniel Walker <dwalker@mvista.com>
To: Andi Kleen <ak@suse.de>
Cc: patches@x86-64.org, linux-kernel@vger.kernel.org
In-Reply-To: <200707191938.18988.ak@suse.de>
References: <200707191154.642492000@suse.de> <200707191922.34388.ak@suse.de>
	 <1184866316.6458.31.camel@dhcp193.mvista.com>
	 <200707191938.18988.ak@suse.de>
Content-Type: text/plain
Date: Thu, 19 Jul 2007 10:43:49 -0700
Message-Id: <1184867029.6458.40.camel@dhcp193.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-1.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-07-19 at 19:38 +0200, Andi Kleen wrote:
> On Thursday 19 July 2007 19:31:56 Daniel Walker wrote:
> 
> > >From my perspective a downside to sched_clock is that the math is
> > duplicated per architecture .. I think it would be a win to use the
> > generic functions if it's possible..
> 
> They can't be used because they're not cpu local. The whole basic 
> concept behind the new sched_clock is to be cpu local. 

Your not following me .. The cpu localness is retained in the multiply
value, which is component of the math .. It's got nothing to do with the
conversion code itself.

You do the same operation to convert from cycles to nanosecond
regardless of the values you use. Example,

+static inline u64 __cycles_2_ns(struct sc_data *sc, u64 cyc)
+{
+       u64 ns;
+
+       cyc -= sc->sync_base;
+       ns = (cyc * sc->cyc2ns_scale) >> CYC2NS_SCALE_FACTOR;
+       ns += sc->ns_base;
+
+       return ns;
+}

Above the line "(cyc * sc->cyc2ns_scale) >> CYC2NS_SCALE_FACTOR;" is
part of the duplication that I'm referring to, not the surrounding code.

Which looks very much like this,

static inline s64 cyc2ns(struct clocksource *cs, cycle_t cycles)
{
        u64 ret = (u64)cycles;
        ret = (ret * cs->mult) >> cs->shift;
        return ret;
}

Daniel

