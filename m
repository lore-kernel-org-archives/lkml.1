Return-Path: <linux-kernel-owner+w=401wt.eu-S1030346AbXDJPHO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030346AbXDJPHO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 11:07:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753911AbXDJPHO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 11:07:14 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:45306 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753910AbXDJPHM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 11:07:12 -0400
Date: Tue, 10 Apr 2007 17:06:50 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>, Robin Holt <holt@sgi.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Chris Snook <csnook@redhat.com>, linux-kernel@vger.kernel.org,
       Jack Steiner <steiner@americas.sgi.com>
Subject: Re: init's children list is long and slows reaping children.
Message-ID: <20070410150650.GA9946@elte.hu>
References: <46159987.6090006@redhat.com> <Pine.LNX.4.64.0704051825400.6730@woody.linux-foundation.org> <m1hcru9rki.fsf@ebiederm.dsl.xmission.com> <20070406104301.GB19755@lnx-holt.americas.sgi.com> <m1mz1l8qdr.fsf@ebiederm.dsl.xmission.com> <20070406163100.GA554@tv-sign.ru> <20070406173249.GA2517@elte.hu> <m11wix73ut.fsf@ebiederm.dsl.xmission.com> <20070410134814.GA28016@elte.hu> <m17iskz3i8.fsf@ebiederm.dsl.xmission.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m17iskz3i8.fsf@ebiederm.dsl.xmission.com>
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


* Eric W. Biederman <ebiederm@xmission.com> wrote:

> > on a second thought: the p->children list is needed for the whole 
> > child/parent task tree, which is needed for sys_getppid().
> 
> Yes, something Oleg said made me realize that.
> 
> As long as the reparent isn't to complex it isn't required that we 
> have exactly one list .
> 
> > The question is, does anything require us to reparent to within the 
> > same thread group?
> 
> I think my head is finally on straight about this question.
> 
> Currently there is the silly linux specific parent death signal 
> (pdeath_signal).  Oleg's memory was a better than mine on this score.
> 
> However there is no indication that the parent death signal being sent 
> when a thread leader dies is actually correct, or even interesting. It 
> probably should only be sent when getppid changes.
> 
> So with pdeath_signal fixed that is nothing that requires us to 
> reparent within the same thread group.
> 
> I'm trying to remember what the story is now.  There is a nasty race 
> somewhere with reparenting, a threaded parent setting SIGCHLD to 
> SIGIGN, and non-default signals that results in an zombie that no one 
> can wait for and reap.  It requires being reparented twice to trigger.
> 
> Anyway it is a real mess and if we can remove the stupid multi-headed 
> child lists things would become much simpler and the problem could not 
> occur.
> 
> Plus the code would become much simpler...
> 
> utrace appears to have removed the ptrace_children list and the 
> special cases that entailed.

so ... is anyone pursuing this? This would allow us to make sys_wait4() 
faster and more scalable: no tasklist_lock bouncing for example.

	Ingo
