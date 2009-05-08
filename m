Return-Path: <linux-kernel-owner+w=401wt.eu-S1761459AbZEHJp7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761459AbZEHJp7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 05:45:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753591AbZEHJpq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 05:45:46 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:56985 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751207AbZEHJpo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 05:45:44 -0400
Date: Fri, 8 May 2009 11:44:48 +0200
From: Ingo Molnar <mingo@elte.hu>
To: James Morris <jmorris@namei.org>
Cc: Adam Langley <agl@google.com>, Andrew Morton <akpm@linux-foundation.org>,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Tom Zanussi <tzanussi@gmail.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       markus@google.com, linux-security-module@vger.kernel.org
Subject: Re: [RFC 1/1] seccomp: Add bitmask of allowed system calls.
Message-ID: <20090508094448.GD3559@elte.hu>
References: <396556a20805301217k293e5718h6bbf02b234897235@europa> <20090507221447.GE28770@elte.hu> <alpine.LRH.2.00.0905081208480.2761@tundra.namei.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.00.0905081208480.2761@tundra.namei.org>
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


* James Morris <jmorris@namei.org> wrote:

> On Fri, 8 May 2009, Ingo Molnar wrote:
> 
> > > In general, I believe that ftrace based solutions cannot safely 
> > > validate arguments which are in user-space memory when multiple 
> > > threads could be racing to change the memory between ftrace and 
> > > the eventual copy_from_user. Because of this, many useful 
> > > arguments (such as the sockaddr to connect, the filename to open 
> > > etc) are out of reach. LSM hooks appear to be the best way to 
> > > impose limits in such cases. (Which we are also experimenting 
> > > with).
> > 
> > That assessment is incorrect, there's no difference between safety 
> > here really.
> > 
> > LSM cannot magically inspect user-space memory either when multiple 
> > threads may access it. The point would be to define filters for 
> > system call _arguments_, which are inherently thread-local and safe.
> 
> LSM hooks are placed so that they can access objects safely, e.g. 
> after copy_from_user() and with all apropriate kernel locks for 
> that object held, and also with all security-relevant information 
> available for the particular operation.
> 
> You cannot do this with system call interception: it's an 
> inherently racy and limited mechanism (and very well known for 
> being so).

Two things.

Firstly, the seccomp + filter engine based filtering method does not 
have to be limited to system call interception at all: by placing a 
tracepoint at that place seccomp can register itself to the same 
point as the LSM hook, and enumerate and expose the fields. It can 
be expressed in the string filter namespace just fine.

[ do we have nestable LSM hooks? If yes then seccomp could layer
  itself below any existing security context, in a hierarchical way, 
  to provide add-on restrictions. It is all about further 
  restrictions, not to creation or overruling of existing security 
  policies/modules. ]

Secondly, pure system call argument based filtering is already very 
powerful for _sandboxing_. Seccomp v1 is the proof for that, it is 
equivalent to the:

{ { "sys_read",			"1" },
  { "sys_write",		"1" },
  { "sys_ret_from_signal",	"1" } }

filter rules. Your argument really pertains to full-system security 
solutions - while maximising compatibility and capability and 
minimizing user invenience. _That_ is an extremely hard problem with 
many pitfalls and snake-oil merchants flooding the roads. But that 
is not our goal here: the goal is to restrict execution in very 
brutal but still performant ways.

That means we'd like to give finegrained but still very brutally 
constructed permissions to untrusted contexts. Instead of the 
seccomp v1 rules above, an app might want to inject these rules into 
a sandbox context:

{ { "sys_read",			"fd == 0" },
  { "sys_write",		"fd == 1" },
  { "sys_sigreturn",		"1" },
  { "sys_gettimeofday",		"tz == NULL" },

Note how such a (simple!) set of rules expands over seccomp v1 in a 
very meaningful way:

 - The sys_read rule restricts the read() syscall to stdin only. 
   Even if other fds exist.

 - The sys_write() rule restricts the write() syscall to stdout 
   only.

 - sys_gettimeofday() is allowed, but only tv is allowed - tz not. 

Note how we were able to _further restrict_ the seccomp v1 
sandboxing concept: under seccomp v1 the task would be able to write 
to stdin or read from stdout.

Furthermore, only fds 0 and 1 are allowed - under seccomp v1 if any 
other fd gets into the sandboxed context accidentally, it could make 
use of them. With the above filtering scheme that is denied.

Also, note the gettimeofday rule: we were able to 'halve' the 
security cross-section of the sys_gettimeofday() permission: we only 
allow &tv to be recovered, not the time zone.

So the filtering engine allows the very finegrained tailoring of the 
system call environment, right in the context of the sandboxed task, 
without context-switches.

The filtering engine is also 'safe' in that unprivileged tasks can 
use PRCTL_SECCOMP_SET with arbitrary strings, and the resulting 
filter expression is still to be parsed and later on executed by the 
kernel.

> I'm concerned that we're seeing yet another security scheme being 
> designed on the fly, without a well-formed threat model, and 
> without taking into account lessons learned from the seemingly 
> endless parade of similar, failed schemes.

I do agree that that danger is there (as with any security scheme), 
so this all has to be designed carefully.

[ I think as long as we shape it as "only additional restrictions on
  top of what is already there", in a strictly nested way, there's
  little danger of impacting existing security measures. ]

There's also the very real possibility of having a really flexible 
sandboxing model :) So i think Adam's work is fundamentally useful.

	Ingo
