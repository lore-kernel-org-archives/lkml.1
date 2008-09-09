Return-Path: <linux-kernel-owner+w=401wt.eu-S1756182AbYIIIS3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756182AbYIIIS3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 04:18:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754047AbYIIISQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 04:18:16 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:41325 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753951AbYIIISP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 04:18:15 -0400
Date: Tue, 9 Sep 2008 10:17:13 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Oren Laadan <orenl@cs.columbia.edu>
Cc: dave@linux.vnet.ibm.com, arnd@arndb.de, jeremy@goop.org,
       linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org
Subject: Re: [RFC v4][PATCH 3/9] x86 support for checkpoint/restart
Message-ID: <20080909081713.GA18946@elte.hu>
References: <1220946154-15174-1-git-send-email-orenl@cs.columbia.edu> <1220946154-15174-4-git-send-email-orenl@cs.columbia.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1220946154-15174-4-git-send-email-orenl@cs.columbia.edu>
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


* Oren Laadan <orenl@cs.columbia.edu> wrote:

> +	/* for checkpoint in process context (from within a container)
> +	   the GS and FS registers should be saved from the hardware;
> +	   otherwise they are already sabed on the thread structure */

please use the correct comment style consistently throughout your 
patches. The correct one is like this one:

> +	/*
> +	 * for checkpoint in process context (from within a container),
> +	 * the actual syscall is taking place at this very moment; so
> +	 * we (optimistically) subtitute the future return value (0) of
> +	 * this syscall into the orig_eax, so that upon restart it will
> +	 * succeed (or it will endlessly retry checkpoint...)
> +	 */

incorrect/inconsistent ones are like these:

> +		/* normally, no need to unlazy_fpu(), since TS_USEDFPU flag
> +		 * have been cleared when task was conexted-switched out...
> +		 * except if we are in process context, in which case we do */

> +		/* restore TLS by hand: why convert to struct user_desc if
> +		 * sys_set_thread_entry() will convert it back ? */

> +			/* FIX: add sanity checks (eg. that values makes
> +			 * sense, that we don't overwrite old values, etc */

(and there's many more examples throughout the series)

> +int cr_read_cpu_debug(struct cr_hdr_cpu *hh, struct task_struct *t)
> +{
> +	/* debug regs */
> +
> +	preempt_disable();
> +
> +	if (hh->uses_debug) {
> +		set_debugreg(hh->debugreg0, 0);
> +		set_debugreg(hh->debugreg1, 1);
> +		/* ignore 4, 5 */
> +		set_debugreg(hh->debugreg2, 2);
> +		set_debugreg(hh->debugreg3, 3);
> +		set_debugreg(hh->debugreg6, 6);
> +		set_debugreg(hh->debugreg7, 7);
> +	}
> +
> +	preempt_enable();
> +
> +	return 0;
> +}

hm, the preemption disabling seems pointless here. What does it protect 
against?

> +++ b/checkpoint/ckpt_arch.h
> @@ -0,0 +1,7 @@
> +#include <linux/ckpt.h>
> +
> +int cr_write_thread(struct cr_ctx *ctx, struct task_struct *t);
> +int cr_write_cpu(struct cr_ctx *ctx, struct task_struct *t);
> +
> +int cr_read_thread(struct cr_ctx *ctx);
> +int cr_read_cpu(struct cr_ctx *ctx);

please add 'extern' to prototypes in include files.

> @@ -15,6 +15,8 @@
>  #include <linux/ckpt.h>
>  #include <linux/ckpt_hdr.h>
>  
> +#include "ckpt_arch.h"
> +

plsdntuseannyngabbrvtsngnrcd. [1]

"checkpoint_" should be just fine in most cases.

	Ingo

[1] (please dont use annoying abbreviations in generic code)
