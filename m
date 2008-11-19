Return-Path: <linux-kernel-owner+w=401wt.eu-S1752802AbYKSJYO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752802AbYKSJYO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 04:24:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752302AbYKSJX6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 04:23:58 -0500
Received: from mtagate3.de.ibm.com ([195.212.29.152]:47674 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752080AbYKSJX5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 04:23:57 -0500
Date: Wed, 19 Nov 2008 10:23:54 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: ftrace: preemptoff selftest not working
Message-ID: <20081119092354.GA5305@osiris.boeblingen.de.ibm.com>
References: <20081118125359.GA4417@osiris.boeblingen.de.ibm.com> <alpine.DEB.1.10.0811180826510.15003@gandalf.stny.rr.com> <20081118135221.GE31146@elte.hu> <alpine.DEB.1.10.0811180931270.15003@gandalf.stny.rr.com> <20081118144751.GA30358@elte.hu> <20081118170635.GB4417@osiris.boeblingen.de.ibm.com> <alpine.DEB.1.10.0811181220530.15003@gandalf.stny.rr.com> <20081118205558.GA6243@elte.hu> <20081119090223.GA25282@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081119090223.GA25282@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 19, 2008 at 10:02:23AM +0100, Ingo Molnar wrote:
> 
> >  #ifdef CONFIG_FTRACE_STARTUP_TEST
> > +	/*
> > +	 * When this gets called we hold the BKL which means that preemption
> > +	 * is disabled. Various trace selftests however need to disable
> > +	 * and enable preemption for successful tests. So we drop the BKL here
> > +	 * and grab it after the tests again.
> > +	 */
> > +	unlock_kernel();
> >  	if (type->selftest) {
> >  		struct tracer *saved_tracer = current_trace;
> >  		struct trace_array *tr = &global_trace;
> > @@ -562,6 +569,7 @@ int register_tracer(struct tracer *type)
> >  		}
> >  		printk(KERN_CONT "PASSED\n");
> >  	}
> > +	lock_kernel();
> 
> dropping the BKL was a good idea, but the code flow was not 
> investigated thoroughly enough, which caused this crash to trigger in 
> -tip testing:

Yes, I came to the same conlcusion this morning after reading the patch
again and wanted to send a follow-up patch. But you were faster ;)

Anyway, what bothers me more is the question if the idea to drop the BKL
in register_tracer is good. It's probably just a question of time until
the first tracers come in modules. And then the unlock_kernel()/lock_kernel()
sequence would be broken.
So it probably might make more sense to drop and grab the BKL in the
init functions that register a tracer?

But.. maybe the BKL is gone until this is an issue ;)
