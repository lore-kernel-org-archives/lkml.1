Return-Path: <linux-kernel-owner+w=401wt.eu-S1755751AbYLDIfh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755751AbYLDIfh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 03:35:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751944AbYLDIf1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 03:35:27 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:33564 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751952AbYLDIfZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 03:35:25 -0500
Date: Thu, 4 Dec 2008 09:35:07 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Dave Hansen <dave@linux.vnet.ibm.com>, containers@lists.osdl.org,
       Eric Biederman <ebiederm@xmission.com>,
       Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
       "Serge E. Hallyn" <serue@us.ibm.com>
Subject: Re: [PATCH 0/3] ftrace: updates for tip
Message-ID: <20081204083507.GE32594@elte.hu>
References: <20081203203656.776893226@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081203203656.776893226@goodmis.org>
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


* Steven Rostedt <rostedt@goodmis.org> wrote:

> Ingo,
> 
> This series has three patches.
> 
> The first patch adds a new feature that I've been wanting to have for 
> some time and Arjan even requested. That is to pick a function and only 
> trace that function and its children. Dynamic ftrace and function graph 
> needs to be enabled for this.
> 
> To do the above, I added a "trace" flags field in the task structure. 
> The second patch uses this for the ftrace pid code. It searches for the 
> task based on the pid and sets the trace flag, then in the ftrace 
> function caller it only needs to check this flag.

Btw., i'd love to see this done via the regular regexp interface though, 
if possible - instead of the add-on interface you added.

( Also perhaps enable to toggle tracing via the /proc/<PID>/ hierarchy - 
  a /proc/<PID>/tracing_enabled switch or so. )

Regarding the filter functions, the basic principle should be 
mathematical set operations, like we have it now: add and remove, union, 
wildcards, etc.

I'd suggest a natural and intuitive extension of the current syntax. 
(while keeping all the current bits)

I already suggested a 'inverse' filter in a previous mail:

  echo "-schedule*" >> set_ftrace_filter

This rule operates on the current set of filter functions: it strikes out 
all existing filter functions that match this pattern.

To handle PIDs, we could do something like:

  echo "sshd-312:schedule" > set_ftrace_filter

This would restrict tracing to the sshd-pid:312 task.

Note: the PID portion of the filter rules still stay separate from the 
function names - we dont want per task function filter rules.

A natural variation would be:

  echo "312:schedule" > set_ftrace_filter

to only specify the PID, or:

  echo "312,313:schedule" > set_ftrace_filter

to specify two PIDs, or:

  echo "sshd:schedule" > set_ftrace_filter

to only specify the 'comm' part, which expands to all PIDs where 
task->comm matches sshd. Another variation would be:

  echo "loop*:schedule" > set_ftrace_filter

that matches all PIDs where task->comm matches loop*.

To specify recursive tracing, we could use something like:

  echo "loop*+schedule" > set_ftrace_filter

the '+' would signal that the 'schedule' function is 'expanded' and all 
its child functions are traced as well.

btw., maybe it makes sense to separate the regexp rule-set from the set 
of functions that we are tracing right now. For example:

  $ echo "schedule*" >  set_ftrace_filter
  $ echo "time*"     >> set_ftrace_filter
  $ echo "sys_*"     >> set_ftrace_filter

  $ cat set_ftrace_filter
  schedule*
  time*
  sys_*

We'd also have a separate, current_ftrace_functions file as well which 
shows all traced functions. (on a global basis - with possible PID filter 
rules added where applicable)

I know this will be hellishly hard to implement, but it would be _very_ 
elegant, and _very_ usable.

What do you think?

	Ingo
