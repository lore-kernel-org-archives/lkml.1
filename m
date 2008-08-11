Return-Path: <linux-kernel-owner+w=401wt.eu-S1755539AbYHKRUU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755539AbYHKRUU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 13:20:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752191AbYHKRUI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 13:20:08 -0400
Received: from smtpq1.groni1.gr.home.nl ([213.51.130.200]:36226 "EHLO
	smtpq1.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751193AbYHKRUH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 13:20:07 -0400
Message-ID: <48A074D1.4070803@keyaccess.nl>
Date: Mon, 11 Aug 2008 19:20:17 +0200
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.16 (X11/20080707)
MIME-Version: 1.0
To: Cyrill Gorcunov <gorcunov@gmail.com>, Ingo Molnar <mingo@elte.hu>
CC: Andrew Morton <akpm@osdl.org>, Yinghai Lu <yhlu.kernel@gmail.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: kill arch/x86/kernel/mpparse.c debugging printk.
References: <489C77C6.7040408@keyaccess.nl> <20080811122038.GA10082@elte.hu> <48A05E79.4030304@keyaccess.nl> <48A05EB1.3050508@keyaccess.nl> <20080811164508.GA18969@lenovo>
In-Reply-To: <20080811164508.GA18969@lenovo>
Content-Type: multipart/mixed;
 boundary="------------050308060901000304000107"
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------050308060901000304000107
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

On 11-08-08 18:45, Cyrill Gorcunov wrote:

> | From: Rene Herman <rene.herman@gmail.com>
> | Date: Mon, 11 Aug 2008 17:35:41 +0200
> | Subject: [PATCH] x86: make "apic" an early_param() on 32-bit

[ ... ]

> you turned it into early_param so now it's NULL injecting vulnerabled.
> Could you please add checking for NULL str param?

Ah, I was unaware of that difference, thank you. Ingo, can you replace 
the previous incarnation with this one?

Rene.

--------------050308060901000304000107
Content-Type: text/plain;
 name="0001-x86-make-apic-an-early_param-on-32-bit.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="0001-x86-make-apic-an-early_param-on-32-bit.patch"

>From 98cf69c9acbc2c1a29fdaa6fc8c29f1bacae8316 Mon Sep 17 00:00:00 2001
From: Rene Herman <rene.herman@gmail.com>
Date: Mon, 11 Aug 2008 17:35:41 +0200
Subject: [PATCH] x86: make "apic" an early_param() on 32-bit

On 32-bit, "apic" is a __setup() param meaning it is parsed rather
late in the game. Make it an early_param() for apic_printk() use
by arch/x86/kernel/mpparse.c.

On 64-bit, it already is an early_param().

Signed-off-by: Rene Herman <rene.herman@gmail.com>
---
 arch/x86/kernel/apic_32.c |   14 +++++++++-----
 1 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/apic_32.c b/arch/x86/kernel/apic_32.c
index d6c8983..039a8d4 100644
--- a/arch/x86/kernel/apic_32.c
+++ b/arch/x86/kernel/apic_32.c
@@ -1720,15 +1720,19 @@ static int __init parse_lapic_timer_c2_ok(char *arg)
 }
 early_param("lapic_timer_c2_ok", parse_lapic_timer_c2_ok);
 
-static int __init apic_set_verbosity(char *str)
+static int __init apic_set_verbosity(char *arg)
 {
-	if (strcmp("debug", str) == 0)
+	if (!arg)
+		return -EINVAL;
+
+	if (strcmp(arg, "debug") == 0)
 		apic_verbosity = APIC_DEBUG;
-	else if (strcmp("verbose", str) == 0)
+	else if (strcmp(arg, "verbose") == 0)
 		apic_verbosity = APIC_VERBOSE;
-	return 1;
+
+	return 0;
 }
-__setup("apic=", apic_set_verbosity);
+early_param("apic", apic_set_verbosity);
 
 static int __init lapic_insert_resource(void)
 {
-- 
1.5.5


--------------050308060901000304000107--
