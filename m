Return-Path: <linux-kernel-owner+w=401wt.eu-S1751226AbZHHQCU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751226AbZHHQCU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Aug 2009 12:02:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750777AbZHHQCT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Aug 2009 12:02:19 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:48020 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750738AbZHHQCT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Aug 2009 12:02:19 -0400
Date: Sat, 8 Aug 2009 18:02:11 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Tom Zanussi <tzanussi@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Li Zefan <lizf@cn.fujitsu.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [2.6.31 PATCH] tracing/filters: always free pred on
	filter_add_subsystem_pred() failure
Message-ID: <20090808160211.GM28892@elte.hu>
References: <1249746593.6453.32.camel@tropicana>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1249746593.6453.32.camel@tropicana>
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


* Tom Zanussi <tzanussi@gmail.com> wrote:

> If filter_add_subsystem_pred() fails due to ENOSPC or ENOMEM, the 
> pred doesn't get freed, while as a side effect it does for other 
> errors. Make it so the caller always frees the pred for any error.

thanks, i've queued this up for .31.

Just to make sure: tracing/core has the filter code changed 
substantially, and this issue seems to be moot there - correct?

So the total impact from both patches on -tip is the patch below - 
right?

	Ingo

diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events_filter.c
index 27c2dbe..490337a 100644
--- a/kernel/trace/trace_events_filter.c
+++ b/kernel/trace/trace_events_filter.c
@@ -1050,6 +1050,8 @@ static int replace_preds(struct event_subsystem *system,
 
 		pred = create_pred(elt->op, operand1, operand2);
 add_pred:
+		if (!pred)
+			return -ENOMEM;
 		if (call)
 			err = filter_add_pred(ps, call, pred, false);
 		else
