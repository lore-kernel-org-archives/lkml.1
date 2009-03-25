Return-Path: <linux-kernel-owner+w=401wt.eu-S1754750AbZCYImP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754750AbZCYImP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 04:42:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752846AbZCYIl6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 04:41:58 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:55363 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752362AbZCYIl4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 04:41:56 -0400
Date: Wed, 25 Mar 2009 09:40:54 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       ltt-dev@lists.casi.polymtl.ca, Frederic Weisbecker <fweisbec@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Peter Zijlstra <peterz@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, Hideo AOKI <haoki@redhat.com>,
       Takashi Nishiie <t-nishiie@np.css.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
Subject: Re: [patch 7/9] LTTng instrumentation - kernel
Message-ID: <20090325084054.GB11217@elte.hu>
References: <20090324155625.420966314@polymtl.ca> <20090324160148.872305963@polymtl.ca> <20090324183313.GH31117@elte.hu> <200903251143.12472.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200903251143.12472.rusty@rustcorp.com.au>
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


* Rusty Russell <rusty@rustcorp.com.au> wrote:

> On Wednesday 25 March 2009 05:03:13 Ingo Molnar wrote:
> > 
> > (Rusty Cc:-ed - for the module.c tracepoints below)
> 
> Thanks, tho they look fine and non-intrusive to me.

Thanks - i'll take this as an Acked-by :-)

( Mathieu, mind re-sending a variant that does them via
  TRACE_EVENT(), against the tracing tree? That makes it useful not 
  just to LTTng but the default mainline kernel as well. Thanks! )

> > I believe that to have a complete picture of module usage, module 
> > refcount get/put events should be included as well, beyond the basic 
> > load/free events.
> > 
> > These both have performance impact (a module get/put in a fastpath 
> > hurts scalability), and are informative in terms of establishing the 
> > module dependency graph.
> 
> A module_get()/put() should not hurt scalability at all!  I went 
> to great and horrible lengths to ensure that was the case since 
> the rewrite in 2.4.

i know, it uses percpu refcounts :) Still it can be somewhat 
non-trivial in a fastpath:

static inline int try_module_get(struct module *module)
{
        int ret = 1;

        if (module) {
                unsigned int cpu = get_cpu();
                if (likely(module_is_live(module)))
                        local_inc(__module_ref_addr(module, cpu));
                else
                        ret = 0;
                put_cpu();
        }
        return ret;
}

So we want to reduce excessive uses of it.

[ And please forget i mentioned scalability - that bit is fine and 
  you were offended rightfully :) ]

This reminds me. Couldnt we now:

 #ifdef CONFIG_SMP
         char *refptr;
 #else
         local_t ref;
 #endif

... unify these bits to just standardize on a per-cpu refptr all the 
time, with Tejun's ueber-cool percpu changes in place?

> But a module dependency graph et. al. would be kind of cool.

Yeah. Can be in a separate patch as well - load/unload events are 
meaningful in isolation as well.

	Ingo
