Return-Path: <linux-kernel-owner+w=401wt.eu-S1753374AbXJAGpQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753374AbXJAGpQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 02:45:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751408AbXJAGpF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 02:45:05 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:38670 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750947AbXJAGpD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 02:45:03 -0400
Date: Mon, 1 Oct 2007 08:44:48 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andy Whitcroft <apw@shadowen.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: checkpatch and kernel/sched.c
Message-ID: <20071001064448.GA4239@elte.hu>
References: <20070928105345.GC18163@shadowen.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070928105345.GC18163@shadowen.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


(lkml Cc:-ed - this might be of interest to others too)

* Andy Whitcroft <apw@shadowen.org> wrote:

> WARNING: EXPORT_SYMBOL(foo); should immediately follow its function/variable
> #411: FILE: home/apw/git/linux-2.6/kernel/sched.c:408:
> +EXPORT_SYMBOL_GPL(cpu_clock);

yes, this is a legit warning and i fix it every time i see it. (I cannot 
fix this one now because mainline does not have an EXPORT_SYMBOL_GPL for 
cpu_clock(), it's added in -mm? But i cannot find it in mm either. I'll 
fix it once i find the patch :)

> WARNING: printk() should include KERN_ facility level
> #4838: FILE: home/apw/git/linux-2.6/kernel/sched.c:4835:
> +	printk("%-13.13s %c", p->comm,
> 
> WARNING: printk() should include KERN_ facility level
> #5622: FILE: home/apw/git/linux-2.6/kernel/sched.c:5619:
> +				printk("\n");
> 
> WARNING: printk() should include KERN_ facility level
> #5633: FILE: home/apw/git/linux-2.6/kernel/sched.c:5630:
> +				printk("\n");
> 
> WARNING: printk() should include KERN_ facility level
> #5640: FILE: home/apw/git/linux-2.6/kernel/sched.c:5637:
> +			printk(" %s", str);
> 
> These are actually only in debug code and so are unimportant, but 
> technically they are wrong.  This check is a very difficult one in the 
> face of these constructs.  But in this case I think it has got the 
> report right.

this is actually a false positive - as the debug code constructs a 
printk output _without_ \n. So the script should check whether there's 
any \n in the printk string - if there is none, do not emit a warning. 
(if you implement that then i think it can remain a warning and does not 
need to move to CHECK.)

> At this point _if_ we took an error we would not have _DEBUG open and so
> a start would be required, otherwise not.
> 
>                         printk(" %s", str);
> 
> To be 100% correct I assume it would need to have a 
> printk(KERN_DEBUG); after each of the KERN_ERR printk's.

i've fixed this in my tree. But i dont think checkpatch.pl notices this 
level of bug - it just detects the missing KERN_ prefix in printk(), 
right?

> WARNING: braces {} are not necessary for single statement blocks
> #5706: FILE: home/apw/git/linux-2.6/kernel/sched.c:5703:
> +	if (parent->groups == parent->groups->next) {
> +		pflags &= ~(SD_LOAD_BALANCE |
> +				SD_BALANCE_NEWIDLE |
> +				SD_BALANCE_FORK |
> +				SD_BALANCE_EXEC |
> +				SD_SHARE_CPUPOWER |
> +				SD_SHARE_PKG_RESOURCES);
> +	}
> 
> Ok, this one is "correct" at least for the rules as I have them.
> Perhaps the message should not be emitted for very long blocks?

If a statement is not single-line, then braces _are_ fine. Where does 
CodingStyle say that it's not fine?

> WARNING: no space between function name and open parenthesis '('
> #5768: FILE: home/apw/git/linux-2.6/kernel/sched.c:5765:
> +__setup ("isolcpus=", isolated_cpu_setup);
> 
> Almost all other instances of __setup do not have a space, so I assume
> this is a reasonable report.

yes. I have just fixed it in my tree.

> WARNING: externs should be avoided in .c files
> #6545: FILE: home/apw/git/linux-2.6/kernel/sched.c:6542:
> +	extern char __sched_text_start[], __sched_text_end[];
> 
> That one ... dunno.  This check is a difficult one.  Should it be a 
> CHECK?

no, this is a legitimate warning - externs in .c files should move into 
the proper .h file. So i'd suggest to keep this a WARNING.

there are a few other valid warnings that checkpatch.pl emits: such as 
the kfree one - i fixed that too in sched.c.

(Could you send me the v11-to-be version of checkpatch.pl so that i can 
check the remaining issues?)

	Ingo
