Return-Path: <linux-kernel-owner+w=401wt.eu-S1752021AbZIBNDt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752021AbZIBNDt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Sep 2009 09:03:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751326AbZIBNDs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Sep 2009 09:03:48 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:56611 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751128AbZIBNDs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Sep 2009 09:03:48 -0400
Date: Wed, 2 Sep 2009 15:03:36 +0200
From: Ingo Molnar <mingo@elte.hu>
To: linux-kernel@vger.kernel.org, Karsten Keil <isdn@linux-pingi.de>,
       isdn4linux@listserv.isdn4linux.de
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>, tj@elte.hu
Subject: [PATCH, v2] isdn: Fix stack corruption in isdnloop_init()
Message-ID: <20090902130336.GA16906@elte.hu>
References: <20090902124402.GA5539@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090902124402.GA5539@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


[ v2: use strlen instead of sizeof. ]

-tip testing found this stack corruption and bootup crash
in the ISDN subsystem, reported by stackprotector:

[   25.656688] calling  isdn_init+0x0/0x2c2 @ 1
[   25.660388] ISDN subsystem Rev: 1.1.2.3/1.1.2.3/1.1.2.2/1.1.2.3/1.1.2.2/1.1.2.2
[   25.668179] initcall isdn_init+0x0/0x2c2 returned 0 after 6510 usecs
[   25.670005] calling  isdn_bsdcomp_init+0x0/0x45 @ 1
[   25.673336] PPP BSD Compression module registered
[   25.676674] initcall isdn_bsdcomp_init+0x0/0x45 returned 0 after 3255 usecs
[   25.680005] calling  isdnloop_init+0x0/0x88 @ 1
[   25.683337] isdnloop-ISDN-driver Rev 1.11.6.7
[   25.686705] isdnloop: (loop0) virtual card added
[   25.690004] Kernel panic - not syncing: stack-protector: Kernel stack is corrupted in: c1de2d8b
[   25.690006]
[   25.693338] Pid: 1, comm: swapper Not tainted 2.6.31-rc8-tip-01250-geed031c-dirty #9565
[   25.696672] Call Trace:
[   25.700008]  [<c190f517>] ? printk+0x1d/0x30
[   25.703339]  [<c190f45d>] panic+0x50/0xed
[   25.706677]  [<c1059194>] __stack_chk_fail+0x1e/0x42
[   25.710005]  [<c1de2d8b>] ? isdnloop_init+0x83/0x88
[   25.713338]  [<c1de2d8b>] isdnloop_init+0x83/0x88
[   25.716674]  [<c1001056>] _stext+0x56/0x15a
[   25.720007]  [<c1da8368>] kernel_init+0x8f/0xf1
[   25.723338]  [<c1da82d9>] ? kernel_init+0x0/0xf1
[   25.726675]  [<c1025c67>] kernel_thread_helper+0x7/0x58
[   25.730005] Rebooting in 1 seconds..Press any key to enter the menu

The bug is that the temporary array:

	char rev[10];

Is sized one byte too small to store strings based on
the 'revision' string.

This is a truly ancient bug: it has been introduced in
the v2.4.2.1 kernel, ~8.5 years ago, which extended
the length of 'revision' by 1 byte.

Instead of using a fixed size temporary array, size
it based on the 'revision' string.

Cc: <stable@kernel.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 drivers/isdn/isdnloop/isdnloop.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/isdn/isdnloop/isdnloop.c b/drivers/isdn/isdnloop/isdnloop.c
index a335c85..0c8d8cb 100644
--- a/drivers/isdn/isdnloop/isdnloop.c
+++ b/drivers/isdn/isdnloop/isdnloop.c
@@ -1494,7 +1494,7 @@ static int __init
 isdnloop_init(void)
 {
 	char *p;
-	char rev[10];
+	char rev[strlen(revision)+1];
 
 	if ((p = strchr(revision, ':'))) {
 		strcpy(rev, p + 1);
