Return-Path: <linux-kernel-owner+w=401wt.eu-S1759021AbZCZQKd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759021AbZCZQKd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 12:10:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757097AbZCZQKY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 12:10:24 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:44668 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754924AbZCZQKX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 12:10:23 -0400
Date: Thu, 26 Mar 2009 16:10:19 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Hua Zhong <hzhong@gmail.com>, Steven Rostedt <rostedt@goodmis.org>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Roland McGrath <roland@redhat.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Steven Rostedt <srostedt@redhat.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Matt Mackall <mpm@selenic.com>
Subject: Re: [PATCH 2/5] mm: remove unlikly NULL from kfree
Message-ID: <20090326161019.GT28946@ZenIV.linux.org.uk>
References: <20090325051920.406564281@goodmis.org> <20090325052023.071564146@goodmis.org> <84144f020903250034j24e1782bt5f73809b9349346c@mail.gmail.com> <009101c9ad20$1ae231c0$50a69540$@com> <1237968394.30175.12.camel@penberg-laptop> <84144f020903250651o13c723cgf64643091459a5ac@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <84144f020903250651o13c723cgf64643091459a5ac@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 25, 2009 at 03:51:49PM +0200, Pekka Enberg wrote:
> OK, so according to Steven, audit_syscall_exit() is one such call-site
> that shows up in the traces. I don't really understand what's going on
> there but if it is sane, maybe that warrants the removal of unlikely()
> from kfree(). Hmm?

*Shrug*

We certainly can add explicit check, but that'll keep asking for
patches "removing useless check".  The same applies to other places,
really.

And making kfree(NULL) break will keep reintroducing bugs, since people
will expect the behaviour of free(3)...

I don't have any serious objections to adding a check there; indeed,
the normal case there (
                if (context->state != AUDIT_RECORD_CONTEXT) {
                        kfree(context->filterkey);
                        context->filterkey = NULL;
                }
) is context->state != AUDIT_RECORD_CONTEXT, context->filterkey == NULL,
so it might be worth turning into
		if (unlikely(context->filterkey)) {
			if (context->state != AUDIT_RECORD_CONTEXT) {
				kfree(context->filterkey);
				context->filterkey = NULL;
			}
		}
anyway.  Just dubious about the goal in general...
