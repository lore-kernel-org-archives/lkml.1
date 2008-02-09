Return-Path: <linux-kernel-owner+w=401wt.eu-S1754742AbYBIHCS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754742AbYBIHCS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2008 02:02:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751178AbYBIHCK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Feb 2008 02:02:10 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:47899 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750968AbYBIHCH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2008 02:02:07 -0500
Date: Sat, 9 Feb 2008 08:01:44 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [git pull] latency tracer
Message-ID: <20080209070144.GA21046@elte.hu>
References: <20080208214522.GA31101@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080208214522.GA31101@elte.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Ingo Molnar <mingo@elte.hu> wrote:

> It does include one very interesting new feature that deserves to be 
> mentioned outside of the shortlog: 'dynamic ftrace' - which is a 
> transparent kernel-image-patcher mechanism that lazily patches out 
> mcount callsites from all functions that get executed. [if tracing is 
> disabled] These patched out callsites are remembered, and are patched 
> back in when tracing is enabled.
> 
> This technique does not just accelelerate the "tracing disabled" case 
> enormously, we were in fact unable to measure _any_ performance 
> difference (within noise) between an mcount-enabled dyn-ftrace [but 
> tracing-disabled] and a vanilla kernel (!), on modern CPUs.

hot off the presses: Steve has just finished doing a complete set of 
lmbench and hbackbench runs (on 2.8GHz Xeons, dual socket). The 
comparison results are at:

    http://rostedt.homelinux.com/dyn-ftrace-lmbench/lmbench-table

the results show zero lmbench/hackbench overhead from dyn-ftrace (with 
thousands of functions instrumented) apart of the usual lmbench jitter.

The core kernel results for example [these used to be rather sensitive 
on mcount overhead]:

Host                 OS  Mhz null null      open slct sig  sig  fork exec sh
                             call  I/O stat clos TCP  inst hndl proc proc proc
--------- ------------- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----
ftrace-jm  Linux 2.6.24 2783 0.65 0.74 4.74 6.96 5.28 0.76 4.29 290. 866. 2626
ftrace-no  Linux 2.6.24 2784 0.65 0.74 4.75 7.14 5.31 0.76 3.92 282. 837. 2591
no-patche  Linux 2.6.24 2786 0.64 0.71 4.86 7.10 5.34 0.78 3.89 283. 829. 2572
patched-n  Linux 2.6.24 2784 0.64 0.71 4.72 6.98 5.35 0.78 3.94 284. 832. 2582

"ftrace-jm": dyn-ftrace, 2-byte JMPs patched in the mcount callsite 
"ftrace-no": dyn-ftrace, 5-byte NOPs patched in (devel patch, not in 
             this pull request)
"no-patche": no patches [vanilla Linus -git kernel]
"patched-n": patched with the ftrace tree, all tracer options off

i can see an outlier in the "Create" results - that's noise i think 
because the patched+options-off kernel is in essence the same as 
vanilla. "File reread" is noisy and unreliable as ever. 16-task 
ctx-switch results are noisy too (especially the 64k working set ones) - 
this is a HT system hence the multi-threaded results are fundamentally 
noisy due to sibling interaction.

The hackbench results look good too.

enabling full tracing of all the tens of thousands of kernel functions 
makes things measurably slower - but that is expected. (filtered 
patching of a user-selected list of function names is an upcoming 
feature)

the full raw results are at:

   http://rostedt.homelinux.com/dyn-ftrace-lmbench/

	Ingo
