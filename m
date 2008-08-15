Return-Path: <linux-kernel-owner+w=401wt.eu-S1757460AbYHOWZQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757460AbYHOWZQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 18:25:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753550AbYHOWZE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 18:25:04 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:41685
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753468AbYHOWZB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 18:25:01 -0400
Date: Fri, 15 Aug 2008 15:25:01 -0700 (PDT)
Message-Id: <20080815.152501.193746275.davem@davemloft.net>
To: michael@ellerman.id.au
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: bug in lmb_enforce_memory_limit()
From: David Miller <davem@davemloft.net>
In-Reply-To: <1218713213.10673.17.camel@localhost>
References: <20080814.012004.193702132.davem@davemloft.net>
	<1218713213.10673.17.camel@localhost>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Ellerman <michael@ellerman.id.au>
Date: Thu, 14 Aug 2008 21:26:53 +1000

> Perhaps after the first loop we should set memory_limit to equal
> lmb_end_of_DRAM(), then the second loop should work as it is.

Sounds great.  Mind if I push the following to Linus?

lmb: Fix reserved region handling in lmb_enforce_memory_limit().

The idea of the implementation of this fix is from Michael Ellerman.

This function has two loops, but they each interpret the memory_limit
value differently.  The first loop interprets it as a "size limit"
whereas the second loop interprets it as an "address limit".

Before the second loop runs, reset memory_limit to lmb_end_of_DRAM()
so that it all works out.

Signed-off-by: David S. Miller <davem@davemloft.net>

diff --git a/lib/lmb.c b/lib/lmb.c
index 5d7b928..97e5470 100644
--- a/lib/lmb.c
+++ b/lib/lmb.c
@@ -462,6 +462,8 @@ void __init lmb_enforce_memory_limit(u64 memory_limit)
 	if (lmb.memory.region[0].size < lmb.rmo_size)
 		lmb.rmo_size = lmb.memory.region[0].size;
 
+	memory_limit = lmb_end_of_DRAM();
+
 	/* And truncate any reserves above the limit also. */
 	for (i = 0; i < lmb.reserved.cnt; i++) {
 		p = &lmb.reserved.region[i];
