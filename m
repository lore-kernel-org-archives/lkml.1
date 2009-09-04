Return-Path: <linux-kernel-owner+w=401wt.eu-S932552AbZIDARS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932552AbZIDARS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 20:17:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932524AbZIDARR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 20:17:17 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46696 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932505AbZIDARR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 20:17:17 -0400
Date: Thu, 3 Sep 2009 17:16:27 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: arjan@infradead.org, linux-kernel@vger.kernel.org, isdn@linux-pingi.de,
       isdn4linux@listserv.isdn4linux.de, tj@elte.hu,
       "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH, v3] isdn: Fix stack corruption in isdnloop_init()
Message-Id: <20090903171627.2a7e62b8.akpm@linux-foundation.org>
In-Reply-To: <20090902140201.GA10854@elte.hu>
References: <20090902124402.GA5539@elte.hu>
	<20090902130336.GA16906@elte.hu>
	<20090902061439.6c60124c@infradead.org>
	<20090902140201.GA10854@elte.hu>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 Sep 2009 16:02:01 +0200
Ingo Molnar <mingo@elte.hu> wrote:

> From: Ingo Molnar <mingo@elte.hu>
> Date: Tue, 26 May 2009 21:18:22 +0200
> Subject: [PATCH] isdn: Fix stack corruption in isdnloop_init()
> 
> -tip testing found this stack corruption and bootup crash
> in the ISDN subsystem, reported by stackprotector:

I added this to my little pile of things to send to Linus tomorrow.


From: Ingo Molnar <mingo@elte.hu>

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

Is sized one byte too small to store strings based on the 'revision'
string.

This is a truly ancient bug: it has been introduced in the v2.4.2.1
kernel, ~8.5 years ago, which extended the length of 'revision' by 1 byte.

Instead of using a fixed size temporary array, size it based on the
'revision' string.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
Cc: Arjan van de Ven <arjan@infradead.org>
Cc: Karsten Keil <isdn@linux-pingi.de>
Cc: Tejun Heo <tj@kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/isdn/isdnloop/isdnloop.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/isdn/isdnloop/isdnloop.c~isdn-fix-stack-corruption-in-isdnloop_init drivers/isdn/isdnloop/isdnloop.c
--- a/drivers/isdn/isdnloop/isdnloop.c~isdn-fix-stack-corruption-in-isdnloop_init
+++ a/drivers/isdn/isdnloop/isdnloop.c
@@ -15,7 +15,7 @@
 #include <linux/sched.h>
 #include "isdnloop.h"
 
-static char *revision = "$Revision: 1.11.6.7 $";
+static char revision[] = "$Revision: 1.11.6.7 $";
 static char *isdnloop_id = "loop0";
 
 MODULE_DESCRIPTION("ISDN4Linux: Pseudo Driver that simulates an ISDN card");
@@ -1494,7 +1494,7 @@ static int __init
 isdnloop_init(void)
 {
 	char *p;
-	char rev[10];
+	char rev[sizeof(revision)];
 
 	if ((p = strchr(revision, ':'))) {
 		strcpy(rev, p + 1);
_

