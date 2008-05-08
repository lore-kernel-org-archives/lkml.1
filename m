Return-Path: <linux-kernel-owner+w=401wt.eu-S1763177AbYEHK75@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763177AbYEHK75 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 06:59:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761032AbYEHK7s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 06:59:48 -0400
Received: from www.tglx.de ([62.245.132.106]:44197 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754084AbYEHK7q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 06:59:46 -0400
Date: Thu, 8 May 2008 12:59:33 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Philipp Kohlbecher <xt28@gmx.de>
cc: linux-kernel@vger.kernel.org, John Stultz <johnstul@us.ibm.com>
Subject: Re: clocksources: order of preference
In-Reply-To: <4822D8B6.4090008@gmx.de>
Message-ID: <alpine.LFD.1.10.0805081243570.3318@apollo.tec.linutronix.de>
References: <4822D8B6.4090008@gmx.de>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 May 2008, Philipp Kohlbecher wrote:
> Why is the TSC preferred to the HPET as a clocksource for the x86
> architecture?

Performance. TSC access is extremly fast as it is a per CPU
register. HPET is a chipset device and scales bad when multiple CPUs
try to access it simultanously as the access is serialized in
hardware. Even on a UP system the access overhead is somewhere in the
range of factor 100.

> "Understanding the Linux Kernel" states that the HPET is preferable to the TSC
> due to its richer architecture. Up to version 2.6.17.14,
> arch/i386/kernel/timers/timer.c also contained a comment to that effect and
> accordingly ranked the HPET before the TSC.
> 
> This was changed when the new clocksource infrastructure was introduced with
> version 2.6.18. (The HPET clocksource received a rating of 250; the TSC, 300.)

We always tried to use TSC as the first choice.
 
> Preferring the TSC leads to problems when it is unstable. While this can be
> prevented by setting CONFIG_X86_TSC, certain distribution kernels (striving
> for compatibility) don't, resulting in soft lockups.

No, we only use the TSC, when:

- the TSC is known to be stable (not affected by CPU frequency changes)
- the TSC is sychronized accross CPUs

We also check the TSC with a watchdog mechanism, which verifies that
is is keeping accurate time. When we detect that TSC does not, we
replace it by the next available clock source.

> Are there better reasons to prefer the TSC or may I submit a patch that swaps
> the respective ratings?

You may submit one, but it's very unlikely that is gets applied. :)

Thanks,
	tglx
