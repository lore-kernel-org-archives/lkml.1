Return-Path: <linux-kernel-owner+w=401wt.eu-S1757356AbZDOBc5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757356AbZDOBc5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 21:32:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753109AbZDOBcs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 21:32:48 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:51518 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752762AbZDOBcs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 21:32:48 -0400
Subject: [RESEND][PATCH 0/2] Convert acked !GENERIC_TIME architectures to
 use the generic timekeeping core.
From: john stultz <johnstul@us.ibm.com>
To: lkml <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: rmk+lkml@arm.linux.org.uk, cooloney@kernel.org, starvik@axis.com,
       takata@linux-m32r.org, geert@linux-m68k.org,
       Roman Zippel <zippel@linux-m68k.org>, lethal@linux-sh.org,
       Magnus Damm <magnus.damm@gmail.com>, wli@holomorphy.com,
       rth@twiddle.net
Content-Type: text/plain
Date: Tue, 14 Apr 2009 18:32:43 -0700
Message-Id: <1239759163.6064.25.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew, All,

	Its been two and a half years since the GENERIC_TIME infrastructure
landed. It allowed architectures that have free running counters to only
have to provide a clocksource driver and leave the rest of the
timekeeping management to generic code.

So far out of the 23 architectures we've fully converted 15 of them over
to GENERIC_TIME. The remaining 8 (alpha, arm, blackfin, cris, m32r,
m68k, sh, sparc) have in some cases been able to convert, but not fully.
The issue that keeps most architectures from converting is that they do
not have free running counters. They instead use the counter on their
tick timer to determine their inter-tick time. This counter usually
wraps every interrupt, so its not really efficient to use as a
clocksource.

This has created some difficulty as the generic timekeeping core has had
to deal with both GENERIC_TIME arches as well as !GENERIC_TIME arches,
and since it didn't manage 100% of the calculation in the !GENERIC_TIME
case, we've been limited in some of the changes we could make.

So since these last remaining architectures are unlikely to be able to
fully convert to GENERIC_TIME as it stands, the generic core should try
to adopt to their needs so we can bring them into the fold and reduce
code duplication.

The solution is to provide a arch callout from the generic timekeeping
core: arch_gettimeoffset().  On architectures that do not provide a
clocksource, the jiffies clocksource is used, and arch_gettimeoffset is
added in to create finer grained inter-tick time.


The patchset I'm submitting for -mm does the following:
1) Introduces the arch_gettimeoffset infrastructure to the timekeeping
core.
2) Converts Acked arch (sh) to use the arch_gettimeoffset()hook.

The sparc arch was earlier acked, but I found some complications when
cross-compile testing it, so I'll be reworking it and requesting a new
ack later.

I still have patches for the 6 other arches that need to be converted,
but have not received acks for them yet. Instead of stalling the
patchset for all of those arches, I'm submitting these, so overloaded
arch maintainers can convert their arches or take my patches on their
schedule without blocking arches that are ready to go.

Once all 8 arches are converted, I'll send a final cleanup patch that
removes all conditionals and references to GENERIC_TIME.

I'll be sending the unacked patches I'm not submitting to -mm shortly.

Credits to Roman for initially suggesting the idea quite awhile back.

thanks
-john

