Return-Path: <linux-kernel-owner+w=401wt.eu-S1758259AbZD2R0K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758259AbZD2R0K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 13:26:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752872AbZD2RZ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 13:25:56 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:48032 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753117AbZD2RZz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 13:25:55 -0400
X-IronPort-AV: E=Sophos;i="4.40,267,1238976000"; 
   d="scan'208";a="295247240"
From: Roland Dreier <rdreier@cisco.com>
To: Jeff Garzik <jeff@garzik.org>
Cc: Ingo Molnar <mingo@elte.hu>, David Miller <davem@davemloft.net>,
       Linus Torvalds <torvalds@linux-foundation.org>, hpa@zytor.com,
       tglx@linutronix.de, h.mitake@gmail.com, rpjday@crashcourse.ca,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: Remove readq()/writeq() on 32-bit
References: <49EE37AF.4020507@zytor.com>
	<20090421.173123.191021055.davem@davemloft.net>
	<adak55438gp.fsf_-_@cisco.com>
	<20090428.221228.217954247.davem@davemloft.net>
	<20090429115654.GC11586@elte.hu> <49F843BC.7020902@garzik.org>
X-Message-Flag: Warning: May contain useful information
Date: Wed, 29 Apr 2009 10:25:55 -0700
In-Reply-To: <49F843BC.7020902@garzik.org> (Jeff Garzik's message of "Wed, 29
	Apr 2009 08:10:36 -0400")
Message-ID: <adahc071ie4.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.91 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 29 Apr 2009 17:25:55.0190 (UTC) FILETIME=[8D67D160:01C9C8EF]
Authentication-Results: sj-dkim-2; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim2002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > This removal patch is completely pointless, because it moves us
 > backwards to the point where we had a bunch of drivers defining it.

No, the current kernel still requires drivers to define it anyway,
because there are tons of 32-bit architectures that are not x86.

And more than that, centralizing the definition makes the API much more
dangerous for driver authors.

 > At least the networking drivers I messed with (until 11/2008) were
 > always fine with a non-atomic readq.

The commit to niu I keep citing (e23a59e1, "niu: Fix readq
implementation when architecture does not provide one.") shows that
drivers need to take care.  Now, the x86 implementation would happen to
work for that hardware, but eg drivers/infiniband/hw/amso1100 defines
readq with the opposite order -- whether that's required or just an
arbitrary choice, I don't know.  And drivers/infiniband/hw/mthca has
some uses of __raw_writeq() that only work if no other CPU accesses to
the same page can happen between the two halves, so it adds a per-page
spinlock for 32-bit architectures.  etc.

 - R.
