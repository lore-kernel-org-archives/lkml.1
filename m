Return-Path: <linux-kernel-owner+w=401wt.eu-S1764269AbXLUARg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764269AbXLUARg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 19:17:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752906AbXLUAR2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 19:17:28 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:33396
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752669AbXLUAR1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 19:17:27 -0500
Date: Thu, 20 Dec 2007 16:17:26 -0800 (PST)
Message-Id: <20071220.161726.68534356.davem@davemloft.net>
To: m.kozlowski@tuxland.pl
Cc: mpm@selenic.com, akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       sparclinux@vger.kernel.org
Subject: Re: 2.6.24-rc5-mm1: problems with cat /proc/kpageflags
From: David Miller <davem@davemloft.net>
In-Reply-To: <200712202047.56745.m.kozlowski@tuxland.pl>
References: <20071220.045359.107684960.davem@davemloft.net>
	<20071220174540.GW19691@waste.org>
	<200712202047.56745.m.kozlowski@tuxland.pl>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Date: Thu, 20 Dec 2007 20:47:55 +0100

> [  145.128915] TSTATE: 0000004411009603 TPC: 00000000005119ac TNPC: 00000000005119b0 Y: 00000000    Not tainted
> [  145.128940] TPC: <kpagecount_read+0x94/0xe0>

My suspicion at this point is that with certain RAM layouts, simply
iterating over PFN's is simply not working out.

pfn_to_page() seems to be doing no range checking, and with sparsemem
vmemmap, which sparc64 always uses, this can be problematic.

It just blindly goes "vmemmap + pfn" which is asking for trouble, in
particular when the physical RAM layout really is sparse.

Maybe it's enough to add a pfn_valid() check here?  If pfn_valid()
means there is a vmemmap translation setup for that page struct too,
it would work.
