Return-Path: <linux-kernel-owner+w=401wt.eu-S1755141AbZDOF7Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755141AbZDOF7Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 01:59:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753557AbZDOF7P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 01:59:15 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:48556 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752801AbZDOF7P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 01:59:15 -0400
Date: Wed, 15 Apr 2009 07:58:39 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Joe Perches <joe@perches.com>, Sam Ravnborg <sam@ravnborg.org>,
       Rusty Russell <rusty@rustcorp.com.au>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>, Zhaolei <zhaolei@cn.fujitsu.com>,
       Tom Zanussi <tzanussi@gmail.com>, Li Zefan <lizf@cn.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: RFC: introduce struct ksymbol
Message-ID: <20090415055839.GA12040@elte.hu>
References: <1239753659-11790-1-git-send-email-fweisbec@gmail.com> <1239771791.32241.6.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1239771791.32241.6.camel@localhost>
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


(Sam and Rusty Cc:-ed)

* Joe Perches <joe@perches.com> wrote:

> On Wed, 2009-04-15 at 02:00 +0200, Frederic Weisbecker wrote:
> > arch/blackfin/kernel/traps.c:   symname = kallsyms_lookup(address, &symsize, &offset, &modname, namebuf);
> > arch/powerpc/xmon/xmon.c:               name = kallsyms_lookup(pc, &size, &offset, NULL, tmpstr);
> > arch/sh/kernel/cpu/sh5/unwind.c:        sym = kallsyms_lookup(pc, NULL, &offset, NULL, namebuf);
> > arch/x86/kernel/ftrace.c:       kallsyms_lookup((unsigned long) syscall, NULL, NULL, NULL, str);
> > kernel/kprobes.c:               sym = kallsyms_lookup((unsigned long)p->addr, NULL,
> > kernel/lockdep.c:       return kallsyms_lookup((unsigned long)key, NULL, NULL, NULL, str);
> > kernel/trace/ftrace.c:  kallsyms_lookup(rec->ip, NULL, NULL, NULL, str);
> > kernel/trace/ftrace.c:  kallsyms_lookup(rec->ip, NULL, NULL, NULL, str);
> > kernel/trace/ftrace.c:  kallsyms_lookup((unsigned long)rec->ops->func, NULL, NULL, NULL, str);
> > kernel/trace/ftrace.c:  kallsyms_lookup(rec->ip, NULL, NULL, NULL, str);
> > kernel/trace/ftrace.c:  kallsyms_lookup(rec->ip, NULL, NULL, NULL, str);
> > kernel/trace/ftrace.c:  kallsyms_lookup(rec->ip, NULL, NULL, &modname, str);
> > kernel/trace/ftrace.c:  kallsyms_lookup(*ptr, NULL, NULL, NULL, str);
> > kernel/trace/trace_functions.c: kallsyms_lookup(ip, NULL, NULL, NULL, str);
> > kernel/trace/trace_output.c:    kallsyms_lookup(address, NULL, NULL, NULL, str);
> 
> Perhaps a conversion from
> 
> "char str[KSYM_SYMBOL_LEN]"
> to
> "struct ksymbol sym"?
> 
> could be useful.
> 
> There are a few places that use a hard coded length of 128
> instead of KSYM_SYMBOL_LENGTH that are also converted.
> 
> Compile tested only

Why not 'struct ksym'? That name is unused right now, it is shorter 
and just as descriptive.

Regarding the change... dunno. Sam, Rusty - what do you think?

Downsides would be loss of awareness of stack footprint impact. A 
plain struct is easy to slap on, and it's not immediately visible 
that it carries 128 bytes of weight. It might also be confusing in 
terms of the nature of the interface - whether it's a pointery 
object or not.

Prior use:

        char str[KSYM_SYMBOL_LEN];

        kallsyms_lookup(rec->ip, NULL, NULL, NULL, str);

New use:

	struct ksym sym;

	kallsyms_lookup(rec->ip, NULL, NULL, NULL, &sym);

Dunno.

	Ingo
