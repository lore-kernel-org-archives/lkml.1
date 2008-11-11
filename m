Return-Path: <linux-kernel-owner+w=401wt.eu-S1755941AbYKKJJr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755941AbYKKJJr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 04:09:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752852AbYKKJJa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 04:09:30 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:39625 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752237AbYKKJJ3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 04:09:29 -0500
Date: Tue, 11 Nov 2008 10:09:15 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 2/2] ring-buffer: replace most bug ons with warn on and
	disable buffer
Message-ID: <20081111090915.GA14165@elte.hu>
References: <20081111041114.360885196@goodmis.org> <20081111041209.104332033@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081111041209.104332033@goodmis.org>
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


* Steven Rostedt <rostedt@goodmis.org> wrote:

> +#define RB_WARN_ON_RET_INT(buffer, cond)			\
> +	do {							\
> +		if (unlikely(cond)) {				\
> +			atomic_inc(&buffer->record_disabled);	\
> +			WARN_ON(1);				\
>  			return -1;				\
>  		}						\

btw., the _RET() methods are rather ugly as they include an implicit 
code flow change (a 'return' statement).

Please change it to a more readable form that preserves the code flow, 
something like:

  if (RB_WARN_ON(buffer, cond))
	return -1;

See kernel/lockdep.c about how to do this cleanly: introduce a 
_single_ global "oh, we are broken" flag which is increased once and 
never decreased again.

In the case of lockdep that's the debug_locks flag. It's used in 
various code-flow-preserving forms of debug checks:

...
        if (DEBUG_LOCKS_WARN_ON(depth >= 20))
                return;
...
                if (!debug_locks_off_graph_unlock())
                        return NULL;
...
        if (!debug_locks_off_graph_unlock())
                return 0;
...
        if (!__raw_spin_is_locked(&lockdep_lock))
                return DEBUG_LOCKS_WARN_ON(1);

etc.

	Ingo
