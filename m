Return-Path: <linux-kernel-owner+w=401wt.eu-S1753226AbZGNDPb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753226AbZGNDPb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 23:15:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753153AbZGNDPb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 23:15:31 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:46460 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752854AbZGNDPa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 23:15:30 -0400
From: "Zhang, Sonic" <Sonic.Zhang@analog.com>
X-IronPort-AV: E=Sophos;i="4.42,394,1243828800"; 
   d="scan'208";a="3796053"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-Class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Subject: RE: [Uclinux-dist-devel] [PATCH] arch/blackfin: Add kmalloc NULL tests
Date: Tue, 14 Jul 2009 11:17:12 +0800
Message-ID: <0F1B54C89D5F954D8535DB252AF412FA045E83A0@chinexm1.ad.analog.com>
In-Reply-To: <Pine.LNX.4.64.0907131054390.6808@ask.diku.dk>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [Uclinux-dist-devel] [PATCH] arch/blackfin: Add kmalloc NULL tests
Thread-Index: AcoDuu3z0vhyr+V+RCmlhIdx49v74wAdqD9Q
References: <Pine.LNX.4.64.0907131054390.6808@ask.diku.dk>
To: "Julia Lawall" <julia@diku.dk>, <vapier@gentoo.org>,
       <uclinux-dist-devel@blackfin.uclinux.org>,
       <linux-kernel@vger.kernel.org>, <kernel-janitors@vger.kernel.org>
X-OriginalArrivalTime: 14 Jul 2009 03:15:29.0360 (UTC) FILETIME=[57090D00:01CA0431]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks.

Applied.

Sonic 

-----Original Message-----
From: uclinux-dist-devel-bounces@blackfin.uclinux.org
[mailto:uclinux-dist-devel-bounces@blackfin.uclinux.org] On Behalf Of
Julia Lawall
Sent: Monday, July 13, 2009 4:55 PM
To: vapier@gentoo.org; uclinux-dist-devel@blackfin.uclinux.org;
linux-kernel@vger.kernel.org; kernel-janitors@vger.kernel.org
Subject: [Uclinux-dist-devel] [PATCH] arch/blackfin: Add kmalloc NULL
tests

From: Julia Lawall <julia@diku.dk>

Check that the result of kmalloc is not NULL before passing it to other
functions.

In the first two cases, the new code returns -ENOMEM, which seems
compatible with what is done for similar functions for other
architectures.

In the last two cases, the new code fails silently, ie just returns,
because the function has void return type.

The semantic match that finds this problem is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@@
expression *x;
identifier f;
constant char *C;
@@

x = \(kmalloc\|kcalloc\|kzalloc\)(...);
... when != x == NULL
    when != x != NULL
    when != (x || ...)
(
kfree(x)
|
f(...,C,...,x,...)
|
*f(...,x,...)
|
*x->f
)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 arch/blackfin/mach-common/smp.c     |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/arch/blackfin/mach-common/smp.c
b/arch/blackfin/mach-common/smp.c index 6184005..10dd298 100644
--- a/arch/blackfin/mach-common/smp.c
+++ b/arch/blackfin/mach-common/smp.c
@@ -211,6 +211,8 @@ int smp_call_function(void (*func)(void *info), void
*info, int wait)
 		return 0;
 
 	msg = kmalloc(sizeof(*msg), GFP_ATOMIC);
+	if (!msg)
+		return -ENOMEM;
 	INIT_LIST_HEAD(&msg->list);
 	msg->call_struct.func = func;
 	msg->call_struct.info = info;
@@ -252,6 +254,8 @@ int smp_call_function_single(int cpuid, void (*func)
(void *info), void *info,
 	cpu_set(cpu, callmap);
 
 	msg = kmalloc(sizeof(*msg), GFP_ATOMIC);
+	if (!msg)
+		return -ENOMEM;
 	INIT_LIST_HEAD(&msg->list);
 	msg->call_struct.func = func;
 	msg->call_struct.info = info;
@@ -287,6 +291,8 @@ void smp_send_reschedule(int cpu)
 		return;
 
 	msg = kmalloc(sizeof(*msg), GFP_ATOMIC);
+	if (!msg)
+		return;
 	memset(msg, 0, sizeof(msg));
 	INIT_LIST_HEAD(&msg->list);
 	msg->type = BFIN_IPI_RESCHEDULE;
@@ -314,6 +320,8 @@ void smp_send_stop(void)
 		return;
 
 	msg = kmalloc(sizeof(*msg), GFP_ATOMIC);
+	if (!msg)
+		return;
 	memset(msg, 0, sizeof(msg));
 	INIT_LIST_HEAD(&msg->list);
 	msg->type = BFIN_IPI_CPU_STOP;
_______________________________________________
Uclinux-dist-devel mailing list
Uclinux-dist-devel@blackfin.uclinux.org
https://blackfin.uclinux.org/mailman/listinfo/uclinux-dist-devel
