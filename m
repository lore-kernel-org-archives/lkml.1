Return-Path: <linux-kernel-owner+w=401wt.eu-S1761019AbYGOCw2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761019AbYGOCw2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 22:52:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754669AbYGOCwS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 22:52:18 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:44294 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754198AbYGOCwR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 22:52:17 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Elias Oltmanns <eo@nebensachen.de>, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Clark Williams <clark.williams@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jon Masters <jonathan@jonmasters.org>
References: <Pine.LNX.4.58.0807101242070.3740@gandalf.stny.rr.com>
	<87zlop7bp6.fsf@denkblock.local>
	<20080710132832.38cc5048.randy.dunlap@oracle.com>
	<Pine.LNX.4.58.0807101956120.7719@gandalf.stny.rr.com>
	<Pine.LNX.4.58.0807102035550.7719@gandalf.stny.rr.com>
	<20080711121655.05810822.akpm@linux-foundation.org>
	<Pine.LNX.4.58.0807111546560.25977@gandalf.stny.rr.com>
	<20080711153740.b86acadd.akpm@linux-foundation.org>
	<m13amg9fl0.fsf@frodo.ebiederm.org>
	<Pine.LNX.4.58.0807142105390.2955@gandalf.stny.rr.com>
	<m1r69wj5t8.fsf@frodo.ebiederm.org>
	<Pine.LNX.4.58.0807142142070.4223@gandalf.stny.rr.com>
	<m13ambkivq.fsf@frodo.ebiederm.org>
	<Pine.LNX.4.58.0807142212030.4530@gandalf.stny.rr.com>
Date: Mon, 14 Jul 2008 19:41:47 -0700
In-Reply-To: <Pine.LNX.4.58.0807142212030.4530@gandalf.stny.rr.com> (Steven
	Rostedt's message of "Mon, 14 Jul 2008 22:18:09 -0400 (EDT)")
Message-ID: <m1fxqbj2c4.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Steven Rostedt <rostedt@goodmis.org>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.2 BAYES_40 BODY: Bayesian spam probability is 20 to 40%
	*      [score: 0.2339]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.5 XM_Body_Dirty_Words Contains a dirty word
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [PATCH -v2] ftrace: Documentation
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mgr1.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt <rostedt@goodmis.org> writes:

>> Ok.  So this is something simpler to use then SystemTap.  Yeah.
>
> Yes, very similar.  SystemTap may even hook into ftrace, and vice versa.

Got it.

>> It sounds like it is reasonable or at least semi reasonable to use
>> this as an unprivileged user.
>
> Currently only root can do the traces. Since some of the tracing can
> hurt the performance of the system.

Reasonable.

>> The easiest model to think of this in is a chroot that does pids as
>> well as the filesystem.  In which case if you are inside one and
>> you use the tracer.  You want pids that are meaningful in your
>> subset of userspace, and not the global ones.
>
> Some tracers do a trace at every function call. This uses the gcc -pg
> option to set up the start of each function to call profiling code.
> Dynamic ftrace is a on the fly code modification to maintain good
> performance while tracing is disabled.
>
> Because of this being such a high critical path, can I get the namespace
> pid information directly from the task structure. Any function that is
> called must also be careful to not fall back into the tracer. The trace
> deals with self recursion, but functions that call back to the tracer
> cause a bigger performance impact while tracing.

All of the interesting functions are inline so it shouldn't be a big deal.
Mostly they exist to keep the semantics clear as we refactor the code.
task_pid_nr(tsk) yields the global pid number, and is currently implemented as just tsk->pid.
task_pid(tsk) yields the struct pid.

task_pid_nr_ns(tsk) yields the pid number from the perspective of a specific
task.

struct pid is interesting because it is immune from pid roll over conflicts.
I don't know if that is any use to you or not.

stuct pid contains an embedded array of the pid_nrs one for each namespace the
struct pid is in.

Eric
