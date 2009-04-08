Return-Path: <linux-kernel-owner+w=401wt.eu-S1756788AbZDHINL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756788AbZDHINL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 04:13:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754622AbZDHIMx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 04:12:53 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:34553 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753539AbZDHIMv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 04:12:51 -0400
Date: Wed, 8 Apr 2009 10:12:25 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jens Axboe <jens.axboe@oracle.com>, Arjan van de Ven <arjan@infradead.org>
Cc: Justin Madru <jdm64@gawab.com>, lkml <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: 2.6.30-rc1: invalid opcode with call trace
Message-ID: <20090408081225.GB11097@elte.hu>
References: <49DC367A.90603@gawab.com> <20090408063240.GQ5178@kernel.dk> <20090408064733.GA16984@elte.hu> <20090408065201.GA6490@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090408065201.GA6490@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
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


* Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Ingo Molnar <mingo@elte.hu> wrote:
> 
> > I too have an async hang/crash, on an old-style SCSI (aic7xxx) box 
> > - hang log attached below.
> > [...]
> >
> > ( Full bootlog attached below as well - i'm sending the config as a 
> >   reply as this mail is close to lkml size limits already. )
> 
> Config attached.
> 
>  known bad  : v2.6.29-9854-gd508afb
>  known good : v2.6.29
> 
> Suspected commit introducing the regression:
> 
>  9710794: async: remove the temporary (2.6.29) "async is off by default" code
> 
> (i'll now try a revert of this.)

The revert of 9710794 (see below) brings the box back to life again.

	Ingo

----------------->
>From daac36664613a70cb3cfef5d6111f1008751c7cb Mon Sep 17 00:00:00 2001
From: Ingo Molnar <mingo@elte.hu>
Date: Wed, 8 Apr 2009 08:52:44 +0200
Subject: [PATCH] Revert "async: remove the temporary (2.6.29) "async is off by default" code"

This reverts commit 9710794383ee5008d67f1a6613a4717bf6de47bc.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/async.c |   18 +++++++++++++-----
 1 files changed, 13 insertions(+), 5 deletions(-)

diff --git a/kernel/async.c b/kernel/async.c
index 968ef94..f565891 100644
--- a/kernel/async.c
+++ b/kernel/async.c
@@ -49,7 +49,6 @@ asynchronous and synchronous parts of the kernel.
 */
 
 #include <linux/async.h>
-#include <linux/bug.h>
 #include <linux/module.h>
 #include <linux/wait.h>
 #include <linux/sched.h>
@@ -388,11 +387,20 @@ static int async_manager_thread(void *unused)
 
 static int __init async_init(void)
 {
-	async_enabled =
-		!IS_ERR(kthread_run(async_manager_thread, NULL, "async/mgr"));
-
-	WARN_ON(!async_enabled);
+	if (async_enabled)
+		if (IS_ERR(kthread_run(async_manager_thread, NULL,
+				       "async/mgr")))
+			async_enabled = 0;
 	return 0;
 }
 
+static int __init setup_async(char *str)
+{
+	async_enabled = 1;
+	return 1;
+}
+
+__setup("fastboot", setup_async);
+
+
 core_initcall(async_init);
