Return-Path: <linux-kernel-owner+w=401wt.eu-S1758894AbYKWQHy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758894AbYKWQHy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2008 11:07:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755360AbYKWQHp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Nov 2008 11:07:45 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:48473 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752401AbYKWQHo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2008 11:07:44 -0500
Date: Sun, 23 Nov 2008 17:07:13 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>, Theodore Tso <tytso@mit.edu>,
       Arjan van de Ven <arjan@infradead.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH] net/wireless/reg.c: fix
Message-ID: <20081123160713.GA29375@elte.hu>
References: <20081121071213.365288293@goodmis.org> <20081121071328.462456268@goodmis.org> <20081123154830.GA24412@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081123154830.GA24412@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> -tip testing found this build failure:
> 
>  net/wireless/reg.c:348:29: error: macro "if" passed 2 arguments, but takes just 1
> 
> with the attached config. Seems the macro confused some aspect of WARN() 

looks like a genuine bug in net/wireless/reg.c.

accidentally gcc was too willing to build this nonsense:

		if (WARN_ON(!is_alpha2_set(alpha2) || !is_an_alpha2(alpha2)),
 				"Invalid Country IE regulatory hint passed "
				"to the wireless core\n")

the fix is to use WARN(), which the intention was most likely.

	Ingo

------------------->
>From de734ba59d249ee785a1ead600e5a6ea1dd62639 Mon Sep 17 00:00:00 2001
From: Ingo Molnar <mingo@elte.hu>
Date: Sun, 23 Nov 2008 20:09:54 +0100
Subject: [PATCH] net/wireless/reg.c: fix

fix:

  net/wireless/reg.c:348:29: error: macro "if" passed 2 arguments, but takes just 1

triggered by the branch-tracer.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
 # Please enter the commit message for your changes. Lines starting
---
 net/wireless/reg.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 626dbb6..eb3b1a9 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -343,9 +343,9 @@ static int ignore_request(struct wiphy *wiphy, enum reg_set_by set_by,
 				return 0;
 			return -EALREADY;
 		}
-		if (WARN_ON(!is_alpha2_set(alpha2) || !is_an_alpha2(alpha2)),
+		if (WARN(!is_alpha2_set(alpha2) || !is_an_alpha2(alpha2),
 				"Invalid Country IE regulatory hint passed "
-				"to the wireless core\n")
+				"to the wireless core\n"))
 			return -EINVAL;
 		/* We ignore Country IE hints for now, as we haven't yet
 		 * added the dot11MultiDomainCapabilityEnabled flag
