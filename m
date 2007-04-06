Return-Path: <linux-kernel-owner+w=401wt.eu-S932319AbXDFTno@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932319AbXDFTno (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2007 15:43:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932339AbXDFTno
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Apr 2007 15:43:44 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:46590 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932319AbXDFTnn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2007 15:43:43 -0400
Date: Fri, 6 Apr 2007 21:43:29 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>, Robin Holt <holt@sgi.com>,
       Chris Snook <csnook@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: init's children list is long and slows reaping children.
Message-ID: <20070406194329.GB21322@elte.hu>
References: <20070406084250.GA179@tv-sign.ru> <m18xd5amwq.fsf@ebiederm.dsl.xmission.com> <20070406094413.GA673@tv-sign.ru> <m1lkh58q16.fsf@ebiederm.dsl.xmission.com> <20070406154750.GA541@tv-sign.ru> <Pine.LNX.4.64.0704061013060.6730@woody.linux-foundation.org> <20070406193621.GA96@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070406193621.GA96@tv-sign.ru>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Oleg Nesterov <oleg@tv-sign.ru> wrote:

> > I'd almost prefer to just not add kernel threads to any parent 
> > process list *at*all*.
> 
> Yes sure, I didn't argue with that. However, "->exit_state = -1" does 
> matter, we can't detach process unless we make it auto-reap.

> Off course, we also need to add preparent_to_init() to kthread() and 
> (say) stopmachine(). Or we can create kernel_thread_detached() and 
> modify callers to use it.

this isnt a kernel-thread special case. The right solution IMO is to 
first migrate wait4()'s ->children use over to a new p->exiting_children 
list and then to gradually get rid of all remaining uses of p->children. 
(the first patch of which i sent a few minutes ago)

that way wait4() will be sped up, and quite dramatically i believe. No 
need to deal with kthreads here at all - those just wont ever show up in 
the ->exiting_children list. Am i missing something?

	Ingo
