Return-Path: <linux-kernel-owner+w=401wt.eu-S1753413AbYJ1JcE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753413AbYJ1JcE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 05:32:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752620AbYJ1Jbl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 05:31:41 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:38694 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751650AbYJ1Jbk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 05:31:40 -0400
Date: Tue, 28 Oct 2008 10:31:21 +0100
From: Ingo Molnar <mingo@elte.hu>
To: qinghuang feng <qhfeng.kernel@gmail.com>
Cc: sniper <s3c24xx@gmail.com>, mingo@redhat.com, peterz@infradead.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] LOCKDEP: minor fix for debug_show_all_locks()
Message-ID: <20081028093121.GU15734@elte.hu>
References: <9bd6b5360810271303teb198dejde3116f69cfffd46@mail.gmail.com> <20081028082920.GK15734@elte.hu> <21d34cad0810280224t7382c419k95ff89750caef6b2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <21d34cad0810280224t7382c419k95ff89750caef6b2@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* qinghuang feng <qhfeng.kernel@gmail.com> wrote:

> When we failed to get tasklist_lock eventually (count equals 0),
> we should only print " ignoring it.\n", and not print
> " locked it.\n" needlessly.
> 
> Signed-off-by: Qinghuang Feng <qhfeng.kernel@gmail.com>
> ---

> diff --git a/kernel/lockdep.c b/kernel/lockdep.c
> index dbda475..6533fd9 100644
> --- a/kernel/lockdep.c
> +++ b/kernel/lockdep.c
> @@ -3417,8 +3417,7 @@ retry:
>  		}
>  		printk(" ignoring it.\n");
>  		unlock = 0;
> -	}
> -	if (count != 10)
> +	} else if (count != 10)
>  		printk(" locked it.\n");
> 

applied to tip/core/urgent, thanks!

note that i've done two small tweaks to the patch:

 - added curly braces to the else branch as well - the convention is 
   to mirror the curly braces of the main branch in such cases.

 - added KERN_CONT for the printk

	Ingo

-------------->
>From 46fec7ac40e452a2ea5e63648d98b6bb2b5898f9 Mon Sep 17 00:00:00 2001
From: qinghuang feng <qhfeng.kernel@gmail.com>
Date: Tue, 28 Oct 2008 17:24:28 +0800
Subject: [PATCH] lockdep: minor fix for debug_show_all_locks()

When we failed to get tasklist_lock eventually (count equals 0),
we should only print " ignoring it.\n", and not print
" locked it.\n" needlessly.

Signed-off-by: Qinghuang Feng <qhfeng.kernel@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/lockdep.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index dbda475..11832ac 100644
--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -3417,9 +3417,10 @@ retry:
 		}
 		printk(" ignoring it.\n");
 		unlock = 0;
+	} else {
+		if (count != 10)
+			printk(KERN_CONT " locked it.\n");
 	}
-	if (count != 10)
-		printk(" locked it.\n");
 
 	do_each_thread(g, p) {
 		/*
