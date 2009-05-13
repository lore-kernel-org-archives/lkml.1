Return-Path: <linux-kernel-owner+w=401wt.eu-S1761656AbZEMWGp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761656AbZEMWGp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 18:06:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753514AbZEMWGg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 18:06:36 -0400
Received: from sj-iport-1.cisco.com ([171.71.176.70]:28927 "EHLO
	sj-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752509AbZEMWGf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 18:06:35 -0400
X-IronPort-AV: E=Sophos;i="4.41,190,1241395200"; 
   d="scan'208";a="185148337"
From: Roland Dreier <rdreier@cisco.com>
To: Jeff Garzik <jeff@garzik.org>
Cc: Hitoshi Mitake <h.mitake@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       David Miller <davem@davemloft.net>,
       Linus Torvalds <torvalds@linux-foundation.org>, hpa@zytor.com,
       tglx@linutronix.de, rpjday@crashcourse.ca, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: Remove readq()/writeq() on 32-bit
References: <49EE37AF.4020507@zytor.com>
	<20090421.173123.191021055.davem@davemloft.net>
	<adak55438gp.fsf_-_@cisco.com>
	<20090428.221228.217954247.davem@davemloft.net>
	<20090429115654.GC11586@elte.hu> <49F843BC.7020902@garzik.org>
	<adahc071ie4.fsf@cisco.com> <49F8B1A1.4010208@garzik.org>
	<a6b9f31a0905122232s2d23b4e3h6e447c3fa5c29ee6@mail.gmail.com>
	<4A0B30D0.4060806@garzik.org>
X-Message-Flag: Warning: May contain useful information
Date: Wed, 13 May 2009 15:06:35 -0700
In-Reply-To: <4A0B30D0.4060806@garzik.org> (Jeff Garzik's message of "Wed, 13
	May 2009 16:42:56 -0400")
Message-ID: <ada8wl0iro4.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.91 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 13 May 2009 22:06:35.0730 (UTC) FILETIME=[14EECB20:01C9D417]
Authentication-Results: sj-dkim-1; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim1004 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


 > To repeat what has already been stated, each case was re-evaluated:
 > http://marc.info/?l=linux-kernel&m=124103527326835&w=2
 > 
 > Roland's patch was acked, apparently, _in spite of_ the commonly
 > accepted readq() definition already being in use!
 > 
 > Thusfar, I see two things:
 > 
 > (1) years of history has shown that non-atomic readq/writeq on 32-bit
 > platforms has been sufficient, based on testing and experience.  In
 > fact, in niu's case, a common readq/writeq would have PREVENTED a bug.

But the fact that the 32-bit x86 define would have worked for niu is
pure luck -- if the clear-on-read bits had been in the other half of the
register in question, then it would have caused a bug.  And I really
don't trust all ASIC designers writing RTL to think about which half of
a 64-bit register is going to be read first.

To me, the point is that the current situation of having the defines for
32-bit x86 has zero benefit -- not one driver-specific definition can be
removed, because there are other 32-bit architectures to worry about.
So we just added another copy of the compatibility wrapper, in a not
particularly good location -- we certainly don't want to have the same
defines copied into every 32-bit architecture's <asm/io.h> header.

And the risk introduced is not zero -- very few devices have 64-bit
registers and very few drivers use readq or writeq, but perhaps as
end-to-end 64-bit buses become more prevalent with PCIe, we may see
more.  And it's certainly the case that emulation 64-bit register
operations by doing to 32-bit operations on the register halves carries
a non-zero risk of making the hardware do something wacky.

So to me the it's pretty clear: the current situation has benefit == 0
&& risk > 0, so we should revert to the previous situation until someone
implements something more complete like hpa's opt-in header scheme.

 - R.
