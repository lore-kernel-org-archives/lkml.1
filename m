Return-Path: <linux-kernel-owner+w=401wt.eu-S1755845AbYAJJNw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755845AbYAJJNw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 04:13:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751944AbYAJJNl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 04:13:41 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:50725 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751352AbYAJJNj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 04:13:39 -0500
Date: Thu, 10 Jan 2008 10:13:19 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [patch]  Add a simple backtrace test module
Message-ID: <20080110091319.GB23878@elte.hu>
References: <20080109224208.541a659f@laptopd505.fenrus.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080109224208.541a659f@laptopd505.fenrus.org>
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


* Arjan van de Ven <arjan@infradead.org> wrote:

> During the work on the x86 32 and 64 bit backtrace code I found it 
> useful to have a simple test module to test a process and irq context 
> backtrace. Since the existing backtrace code was buggy, I figure it 
> might be useful to have such a test module in the kernel so that maybe 
> we can even detect such bugs earlier..

cool patch, applied!

a few suggestions:

a fundamental one: could you do a save_stack_trace() and check that both 
the process context and the irq context functions are present in that 
trace? If not then flag it as a regression and emit a real WARN_ON() 
warning.

i.e. use save_stack_trace() to do a "silent" test - instead of emitting 
backtraces during bootup. (which are marked via 'this is not a bug' but 
which are visually active nevertheless.)

the locking selftests use similar techniques to never emit real 
warnings, just a readable table of test results:

 | Locking API testsuite:
 ----------------------------------------------------------------------------
                                  | spin |wlock |rlock |mutex | wsem | rsem |
   --------------------------------------------------------------------------
                      A-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
                  A-B-B-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |

internally, while the test is running, lockdep is triggered for real but 
the debug output and the backtraces are supressed.

and a few small details:

> +	printk("====[ backtrace testing ]===========\n");
> +	printk("Testing a backtrace from process context.\n");
> +	printk("The following trace is a kernel self test and not a bug!\n");

the printks need a KERN_ attribute.

> +	dump_stack();
> +
> +	init_timer(&backtrace_timer);
> +	backtrace_timer.function = backtrace_test_timer;
> +	mod_timer(&backtrace_timer, jiffies + 10);
> +
> +	msleep(10);
> +	printk("====[ end of backtrace testing ]====\n");

would be nice to have a testcase for the NMI watchdog and the softlockup 
watchdog as well: do they properly detect lockups on all CPUs?

> +static void exitf(void)

s/exitf/exit_backtrace_test

> +	  This option provides a kernel module that can be used to test
> +	  the kernel stack backtrace code. This option is not useful
> +	  for distributions or general kernels, but only for kernel
> +	  developers working on architecture code.

s/but only/only

	Ingo
