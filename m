Return-Path: <linux-kernel-owner+w=401wt.eu-S1760769AbYBMMqR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760769AbYBMMqR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 07:46:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752931AbYBMMqF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 07:46:05 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:44251 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751015AbYBMMqC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 07:46:02 -0500
Date: Wed, 13 Feb 2008 13:45:48 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Tejun Heo <htejun@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH REPOST] printk: fix possible printk buffer overrun
	introduced with recursion check
Message-ID: <20080213124548.GB6344@elte.hu>
References: <47B2AE7C.608@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47B2AE7C.608@gmail.com>
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


* Tejun Heo <htejun@gmail.com> wrote:

> printk recursion detection prepends message to printk_buf and offsets 
> printk_buf when actual message is printed but it forgets to trim 
> buffer length accordingly.  This can result in buffer overrun in 
> extreme cases.
> 
> While at it, make printk_recursion_bug_msg static and move static 
> variables for recursion check into vprintk().

> @@ -666,7 +664,7 @@ asmlinkage int vprintk(const char *fmt, va_list args)
>  	}
>  	/* Emit the output into the temporary buffer */
>  	printed_len += vscnprintf(printk_buf + printed_len,
> -				  sizeof(printk_buf), fmt, args);
> +				  sizeof(printk_buf) - printed_len, fmt, args);
>  
>  	/*

nice one! I missed that.

Acked-by: Ingo Molnar <mingo@elte.hu>

but i'm not sure i agree with the moving of these variables inside 
vprintk:

> -/* cpu currently holding logbuf_lock */
> -static volatile unsigned int printk_cpu = UINT_MAX;
> -
> -const char printk_recursion_bug_msg [] =
> -			KERN_CRIT "BUG: recent printk recursion!\n";
> -static int printk_recursion_bug;
> -
>  asmlinkage int vprintk(const char *fmt, va_list args)
>  {
> +	/* cpu currently holding logbuf_lock */
> +	static volatile unsigned int printk_cpu = UINT_MAX;
> +	static const char printk_recursion_bug_msg [] =
> +		KERN_CRIT "BUG: recent printk recursion!\n";
> +	static int printk_recursion_bug;
>  	static int log_level_unknown = 1;
>  	static char printk_buf[1024];

it's easy to miss a static variable inside a function local variables 
block. It would b ebetter to move log_level_unknown and printk_buf 
_outside_ the function, to the other ones. [and to mark 
printk_recursion_bug_msg static]

	Ingo
