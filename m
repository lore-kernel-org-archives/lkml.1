Return-Path: <linux-kernel-owner+w=401wt.eu-S1752903AbYLIDti@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752903AbYLIDti (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 22:49:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751369AbYLIDt2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 22:49:28 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:53269 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750888AbYLIDt1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 22:49:27 -0500
Subject: [RFC][PATCH 0/3] Convert the remaining !GENERIC_TIME architectures
	to use the full timekeeping core.
From: john stultz <johnstul@us.ibm.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: rmk+lkml@arm.linux.org.uk, cooloney@kernel.org, starvik@axis.com,
       takata@linux-m32r.org, geert@linux-m68k.org,
       Roman Zippel <zippel@linux-m68k.org>, lethal@linux-sh.org,
       Magnus Damm <magnus.damm@gmail.com>, wli@holomorphy.com,
       chris@zankel.net, Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain
Date: Mon, 08 Dec 2008 19:49:21 -0800
Message-Id: <1228794561.6918.57.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,
	Its been two and a half years since the GENERIC_TIME infrastructure
landed. It allowed architectures that have free running counters to only
have to provide a clocksource driver and leave the rest of the
timekeeping management to generic code.

So far out of the 23 architectures we've fully converted 15 of them over
to GENERIC_TIME. The remaining 8 have in some cases been able to
convert, but not fully. The issue that keeps most architectures from
converting is that they do not have free running counters. They instead
use the counter on their tick timer to determine their inter-tick time.
This counter usually wraps every interrupt, so its not really efficient
to use as a clocksource.

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

The patchset is split up into three parts.
1) Introducing the arch_gettimeoffset infrastructure to the timekeeping
core.
2) Converting the remaining arches over to use arch_gettimeoffset()
3) Finally, Removing all conditionals and references to GENERIC_TIME.

The full patchset reduces the kernel by about 550 lines.

 43 files changed, 141 insertions(+), 701 deletions(-)

Any thoughts or feedback would be appreciated. I've been unable to test
the arch conversions, so any help in getting those right would be
appreciated. I expect this will probably take a few tries.

And credit to Roman for initially suggesting the idea quite awhile back.

thanks
-john

