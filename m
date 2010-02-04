Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754136Ab0BDJ0g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 04:26:36 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:51483 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751592Ab0BDJ0b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 04:26:31 -0500
Date: Thu, 4 Feb 2010 10:26:13 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH 1/9] perf symbols: Remove perf_session usage in symbols
 layer
Message-ID: <20100204092613.GA32169@elte.hu>
References: <1265223128-11786-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=unknown-8bit
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1265223128-11786-1-git-send-email-acme@infradead.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

these changes reintroduce the 'perf top exits' bug:

 $ perf top -v
 map_groups__set_modules_path_dir: cannot open /lib/modules/2.6.33-rc6-tip-00586-g398dde3-dirty/kernel dir

It's the non-existence of modules that causes a disorderly exit. I sent you 
my config with the earlier bugreport - i think if you tried that config you'd 
see a similar failure. I've fixed it via the commit below for now.

	Ingo

------------>
>From 2161db969313cb94ffd9377a525fb75c3fee9eeb Mon Sep 17 00:00:00 2001
From: Ingo Molnar <mingo@elte.hu>
Date: Thu, 4 Feb 2010 10:22:01 +0100
Subject: [PATCH] perf tools: Fix session init on non-modular kernels
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

perf top and perf record refuses to initialize on non-modular kernels:
refuse to initialize:

 $ perf top -v
  map_groups__set_modules_path_dir: cannot open /lib/modules/2.6.33-rc6-tip-00586-g398dde3-dirty/

Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
LKML-Reference: <1265223128-11786-1-git-send-email-acme@infradead.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/util/symbol.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index a60ba2b..6882e9f 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -1937,7 +1937,7 @@ int map_groups__create_kernel_maps(struct map_groups *self,
 		return -1;
 
 	if (symbol_conf.use_modules && map_groups__create_modules(self) < 0)
-		return -1;
+		return 0;
 	/*
 	 * Now that we have all the maps created, just set the ->end of them:
 	 */
