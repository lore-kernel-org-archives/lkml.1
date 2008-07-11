Return-Path: <linux-kernel-owner+w=401wt.eu-S1757031AbYGKXWR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757031AbYGKXWR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 19:22:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753230AbYGKXWH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 19:22:07 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:46706 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752315AbYGKXWE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 19:22:04 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Elias Oltmanns <eo@nebensachen.de>, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Clark Williams <clark.williams@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jon Masters <jonathan@jonmasters.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>
References: <Pine.LNX.4.58.0807101242070.3740@gandalf.stny.rr.com>
	<87zlop7bp6.fsf@denkblock.local>
	<20080710132832.38cc5048.randy.dunlap@oracle.com>
	<Pine.LNX.4.58.0807101956120.7719@gandalf.stny.rr.com>
	<Pine.LNX.4.58.0807102035550.7719@gandalf.stny.rr.com>
	<20080711121655.05810822.akpm@linux-foundation.org>
	<Pine.LNX.4.58.0807111546560.25977@gandalf.stny.rr.com>
	<20080711153740.b86acadd.akpm@linux-foundation.org>
Date: Fri, 11 Jul 2008 16:16:43 -0700
In-Reply-To: <20080711153740.b86acadd.akpm@linux-foundation.org> (Andrew
	Morton's message of "Fri, 11 Jul 2008 15:37:40 -0700")
Message-ID: <m13amg9fl0.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Andrew Morton <akpm@linux-foundation.org>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	*  0.0 BAYES_50 BODY: Bayesian spam probability is 40 to 60%
	*      [score: 0.4661]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.5 XM_Body_Dirty_Words Contains a dirty word
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [PATCH -v2] ftrace: Documentation
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mgr1.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> writes:

> On Fri, 11 Jul 2008 16:59:53 -0400 (EDT) Steven Rostedt <rostedt@goodmis.org>

>> > > +
>> > > +Here's an example of the output format of the file "trace"
>> > > +
>> > > +                             --------
>> > > +# tracer: ftrace
>> > > +#
>> > > +#           TASK-PID   CPU#    TIMESTAMP  FUNCTION
>> > > +#              | |      |          |         |
>> > > +            bash-4251  [01] 10152.583854: path_put <-path_walk
>> > > +            bash-4251  [01] 10152.583855: dput <-path_put
>> > > +            bash-4251  [01] 10152.583855: _atomic_dec_and_lock <-dput
>> > > +                             --------
>> >
>> > pids are no longer unique system-wide, and any part of the kernel ABI which
>> > exports them to userspace is, basically, broken.  Oh well.
>> 
>> What should be used instead?  Of course we're not using a kernel ABI, we
>> are using an API (text based ;-) But more on that later.
>
> Well that's an interesting question and it has come up before.  There
> are times when the kernel wants to display a process identifier at
> least in a printk.  Oopses are one prominent example.
>
> Perhaps we do need a way of doing this in a post-pid-namespace-world. 
> Presumably it would be of the form "pidns-identifier:pid", and just
> plain old "pid" if no pid namespaces are in operation, for some
> back-compatibility where possible.
>
> Eric, any thoughts?

I don't quite know what we are doing here.  Is this a /proc or /sysfs file?

After a long series of discussion on semantics what we came up with
was that the pid namespaces are hierarchical and that a struct pid
will have a numerical identifier in each pid namespace.  Which means
that for printing pids in the case of printks especially for oops
reports we can just go with pid number in the init_pid_ns.  Which is
the classic system wide pid.

In every other case I know besides printk we are delivering the data to an
application, and that application is running in a pid namespace
therefore we really want to figure out the pid namespace and give it the
information.

For filesystem interfaces (besides proc which provides a natural split)
the classic answer is to capture namespaces at mount time.  And display
the data in the filesystem relative to the namespaces we captured.

Eric




