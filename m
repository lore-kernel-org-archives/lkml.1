Return-Path: <linux-kernel-owner+w=401wt.eu-S1756393AbXLLEnX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756393AbXLLEnX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 23:43:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754594AbXLLEm6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 23:42:58 -0500
Received: from smtp108.mail.mud.yahoo.com ([209.191.85.218]:38887 "HELO
	smtp108.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754086AbXLLEm5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 23:42:57 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=rtHzyfaPf8kBaW5MrQarmULPHF2CwbcD2Spdth22zzD65XMchcd3vWL6FFeD5pA5/dJNTJ+KKkeOy5FR9sJyQa0Tp4AHKj/5LVx5CW5OKBc2RnAIZWzdQz2aBjhNazTBVevrJpdE7Tb7hf/5R6Hg8AFRFbqNdy/eBAtwTYmtgRk=  ;
X-YMail-OSG: vyVf..4VM1lNcmvz5D_TDQoj4LVHJ8HC50nbITGuzVEsAr_2wRb094.PUqOCYQ8mVFYlp0TC1PZDaqIkjQwd6qee49a7Z2Duvsk.hiAwm22.tkKH3Hb054tKre7FRg--
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] scheduler: fix x86 regression in native_sched_clock
Date: Wed, 12 Dec 2007 15:42:45 +1100
User-Agent: KMail/1.9.5
Cc: Stefano Brivio <stefano.brivio@polimi.it>, Robert Love <rml@tech9.net>,
       linux-kernel@vger.kernel.org, Dave Jones <davej@redhat.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Michael Buesch <mb@bu3sch.de>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, Len Brown <lenb@kernel.org>
References: <20071207021952.6f0ac922@morte> <200712081157.27840.nickpiggin@yahoo.com.au> <20071208085207.GE30997@elte.hu>
In-Reply-To: <20071208085207.GE30997@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712121542.45957.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 08 December 2007 19:52, Ingo Molnar wrote:

> the scariest bit is the adding of cpu_clock() to kernel/printk.c so late
> in the game, and the anti-recursion code i did there. Maybe because this
> only affects CONFIG_PRINTK_TIME we could try it even for v2.6.24.

Printk recursion I guess shouldn't happen, but if there is a bug
somewhere in eg. the scheduler locking, then it may trigger, right?

Probably pretty rare case, however it would be nice to be able to
find out where the recursion comes from? Can you put an instruction
pointer in the recursion message perhaps?


> i've now completed a couple of hundred random bootups on x86 overnight,
> with the full stack of these patches applied, and no problems.
>
> Could have a really critical look at the two patches below and give your
> Reviewed-by line(s) if you agree with having them in v2.6.24? I'd feel a
> lot better about this that way :-) I do have the feeling that it makes
> printk printout a lot more robust in general, independently of the
> cpu_clock() change - especially with more complex consoles like
> netconsole or fbcon.

Reviewed-by: Nick Piggin <npiggin@suse.de>

for both of them. However I don't feel good to get this into 2.6.24
just for printk timestamps :P But if you can convince others, I won't
stand in your way ;)

BTW. shouldn't we still disable the tsc for this machine for 2.6.24?
Because even if you did get these patches in, the sched_clock still
goes pretty wild if the tsc is not constant. cpu_clock can filter it
somewhat, but it would still lead to wrong values...

Nick

>
> 	Ingo
>
> -------------------->
> Subject: printk: make printk more robust by not allowing recursion
> From: Ingo Molnar <mingo@elte.hu>
>
> make printk more robust by allowing recursion only if there's a crash
> going on. Also add recursion detection.
>
> I've tested it with an artificially injected printk recursion - instead
> of a lockup or spontaneous reboot or other crash, the output was a well
> controlled:
>
> [   41.057335] SysRq : <2>BUG: recent printk recursion!
> [   41.057335] loglevel0-8 reBoot Crashdump show-all-locks(D) tErm Full
> kIll saK showMem Nice powerOff showPc show-all-timers(Q) unRaw Sync
> showTasks Unmount shoW-blocked-tasks
>
> also do all this printk-debug logic with irqs disabled.
>
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> ---
>  kernel/printk.c |   48 ++++++++++++++++++++++++++++++++++++++----------
>  1 file changed, 38 insertions(+), 10 deletions(-)
>
> Index: linux/kernel/printk.c
> ===================================================================
> --- linux.orig/kernel/printk.c
> +++ linux/kernel/printk.c
> @@ -628,30 +628,57 @@ asmlinkage int printk(const char *fmt, .
>  /* cpu currently holding logbuf_lock */
>  static volatile unsigned int printk_cpu = UINT_MAX;
>
> +const char printk_recursion_bug_msg [] =
> +			KERN_CRIT "BUG: recent printk recursion!\n";
> +static int printk_recursion_bug;
> +
>  asmlinkage int vprintk(const char *fmt, va_list args)
>  {
> +	static int log_level_unknown = 1;
> +	static char printk_buf[1024];
> +
>  	unsigned long flags;
> -	int printed_len;
> +	int printed_len = 0;
> +	int this_cpu;
>  	char *p;
> -	static char printk_buf[1024];
> -	static int log_level_unknown = 1;
>
>  	boot_delay_msec();
>
>  	preempt_disable();
> -	if (unlikely(oops_in_progress) && printk_cpu == smp_processor_id())
> -		/* If a crash is occurring during printk() on this CPU,
> -		 * make sure we can't deadlock */
> -		zap_locks();
> -
>  	/* This stops the holder of console_sem just where we want him */
>  	raw_local_irq_save(flags);
> +	this_cpu = smp_processor_id();
> +
> +	/*
> +	 * Ouch, printk recursed into itself!
> +	 */
> +	if (unlikely(printk_cpu == this_cpu)) {
> +		/*
> +		 * If a crash is occurring during printk() on this CPU,
> +		 * then try to get the crash message out but make sure
> +		 * we can't deadlock. Otherwise just return to avoid the
> +		 * recursion and return - but flag the recursion so that
> +		 * it can be printed at the next appropriate moment:
> +		 */
> +		if (!oops_in_progress) {
> +			printk_recursion_bug = 1;
> +			goto out_restore_irqs;
> +		}
> +		zap_locks();
> +	}
> +
>  	lockdep_off();
>  	spin_lock(&logbuf_lock);
> -	printk_cpu = smp_processor_id();
> +	printk_cpu = this_cpu;
>
> +	if (printk_recursion_bug) {
> +		printk_recursion_bug = 0;
> +		strcpy(printk_buf, printk_recursion_bug_msg);
> +		printed_len = sizeof(printk_recursion_bug_msg);
> +	}
>  	/* Emit the output into the temporary buffer */
> -	printed_len = vscnprintf(printk_buf, sizeof(printk_buf), fmt, args);
> +	printed_len += vscnprintf(printk_buf + printed_len,
> +				  sizeof(printk_buf), fmt, args);
>
>  	/*
>  	 * Copy the output into log_buf.  If the caller didn't provide
> @@ -744,6 +771,7 @@ asmlinkage int vprintk(const char *fmt,
>  		printk_cpu = UINT_MAX;
>  		spin_unlock(&logbuf_lock);
>  		lockdep_on();
> +out_restore_irqs:
>  		raw_local_irq_restore(flags);
>  	}
>
> -------------------->
> Subject: sched: fix CONFIG_PRINT_TIME's reliance on sched_clock()
> From: Ingo Molnar <mingo@elte.hu>
>
> Stefano Brivio reported weird printk timestamp behavior during
> CPU frequency changes:
>
>   http://bugzilla.kernel.org/show_bug.cgi?id=9475
>
> fix CONFIG_PRINT_TIME's reliance on sched_clock() and use cpu_clock()
> instead.
>
> Reported-and-bisected-by: Stefano Brivio <stefano.brivio@polimi.it>
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> ---
>  kernel/printk.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> Index: linux/kernel/printk.c
> ===================================================================
> --- linux.orig/kernel/printk.c
> +++ linux/kernel/printk.c
> @@ -707,7 +707,7 @@ asmlinkage int vprintk(const char *fmt,
>  					loglev_char = default_message_loglevel
>  						+ '0';
>  				}
> -				t = printk_clock();
> +				t = cpu_clock(printk_cpu);
>  				nanosec_rem = do_div(t, 1000000000);
>  				tlen = sprintf(tbuf,
>  						"<%c>[%5lu.%06lu] ",
