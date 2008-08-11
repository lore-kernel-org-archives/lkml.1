Return-Path: <linux-kernel-owner+w=401wt.eu-S1755054AbYHKRmU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755054AbYHKRmU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 13:42:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752527AbYHKRmF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 13:42:05 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:41917 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751459AbYHKRmD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 13:42:03 -0400
Date: Mon, 11 Aug 2008 19:41:47 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Rene Herman <rene.herman@keyaccess.nl>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>, Andrew Morton <akpm@osdl.org>,
       Yinghai Lu <yhlu.kernel@gmail.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: kill arch/x86/kernel/mpparse.c debugging printk.
Message-ID: <20080811174147.GO4524@elte.hu>
References: <489C77C6.7040408@keyaccess.nl> <20080811122038.GA10082@elte.hu> <48A05E79.4030304@keyaccess.nl> <48A05EB1.3050508@keyaccess.nl> <20080811164508.GA18969@lenovo> <48A074D1.4070803@keyaccess.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48A074D1.4070803@keyaccess.nl>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Rene Herman <rene.herman@keyaccess.nl> wrote:

> On 11-08-08 18:45, Cyrill Gorcunov wrote:
>
>> | From: Rene Herman <rene.herman@gmail.com>
>> | Date: Mon, 11 Aug 2008 17:35:41 +0200
>> | Subject: [PATCH] x86: make "apic" an early_param() on 32-bit
>
> [ ... ]
>
>> you turned it into early_param so now it's NULL injecting vulnerabled.
>> Could you please add checking for NULL str param?
>
> Ah, I was unaware of that difference, thank you. Ingo, can you replace  
> the previous incarnation with this one?

sure - but some other commits were queued already so i've applied the 
delta fix below.

	Ingo

-------------->
>From 48d97cb65e62a5f1122ac2cf1149800d4f4693e8 Mon Sep 17 00:00:00 2001
From: Rene Herman <rene.herman@keyaccess.nl>
Date: Mon, 11 Aug 2008 19:20:17 +0200
Subject: [PATCH] x86: make "apic" an early_param() on 32-bit, NULL check

Cyrill Gorcunov observed:

> you turned it into early_param so now it's NULL injecting vulnerabled.
> Could you please add checking for NULL str param?

fix that.

Also, change the name of 'str' into 'arg', to make it more apparent
that this is an optional argument that can be NULL, not a string
parameter that is empty when unset.

Reported-by: Cyrill Gorcunov <gorcunov@gmail.com>
Signed-off-by: Rene Herman <rene.herman@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/apic_32.c |   10 +++++++---
 1 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/apic_32.c b/arch/x86/kernel/apic_32.c
index f432d48..039a8d4 100644
--- a/arch/x86/kernel/apic_32.c
+++ b/arch/x86/kernel/apic_32.c
@@ -1720,12 +1720,16 @@ static int __init parse_lapic_timer_c2_ok(char *arg)
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
+
 	return 0;
 }
 early_param("apic", apic_set_verbosity);
