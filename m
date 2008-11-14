Return-Path: <linux-kernel-owner+w=401wt.eu-S1753944AbYKNP0n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753944AbYKNP0n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2008 10:26:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751497AbYKNP0f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Nov 2008 10:26:35 -0500
Received: from gw1.cosmosbay.com ([86.65.150.130]:41273 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751469AbYKNP0e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2008 10:26:34 -0500
Message-ID: <491D987F.1000301@cosmosbay.com>
Date: Fri, 14 Nov 2008 16:25:51 +0100
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>, Robert Richter <robert.richter@amd.com>,
       oprofile-list@lists.sf.net
CC: Ingo Molnar <mingo@elte.hu>, Jiri Kosina <jkosina@suse.cz>,
       Jiri Benc <jbenc@suse.cz>, Vilem Marsik <vmarsik@suse.cz>,
       Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org
Subject: Oprofile : need to adjust PC by 16 bytes
References: <alpine.LNX.1.10.0811132147030.19853@jikos.suse.cz> <20081113212446.GA5694@elte.hu> <alpine.LNX.1.10.0811132226140.19853@jikos.suse.cz> <20081113213744.GA8429@elte.hu> <491CA0DC.8070405@cosmosbay.com>
In-Reply-To: <491CA0DC.8070405@cosmosbay.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Fri, 14 Nov 2008 16:25:58 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Very strange results on my Intel E5450 CPU

I found that I have to bias regs->ip by 16 bytes in order to have
correct profiling.

Does it rings a bell to anyone ?

opcontrol --version
opcontrol: oprofile 0.9.4 compiled on Nov  3 2008 06:45:57

Thank you

diff --git a/arch/x86/oprofile/op_model_ppro.c b/arch/x86/oprofile/op_model_ppro.c
index 3f1b81a..051fb16 100644
--- a/arch/x86/oprofile/op_model_ppro.c
+++ b/arch/x86/oprofile/op_model_ppro.c
@@ -131,7 +131,9 @@ static int ppro_check_ctrs(struct pt_regs * const regs,
                        continue;
                rdmsrl(msrs->counters[i].addr, val);
                if (CTR_OVERFLOWED(val)) {
+                       regs->ip -= 0x10;
                        oprofile_add_sample(regs, i);
+                       regs->ip += 0x10;
                        wrmsrl(msrs->counters[i].addr, -reset_value[i]);
                }
        }

