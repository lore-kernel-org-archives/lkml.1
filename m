Return-Path: <linux-kernel-owner+w=401wt.eu-S1755636AbZGJOIm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755636AbZGJOIm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 10:08:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751806AbZGJOIe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 10:08:34 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:40777 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751268AbZGJOId (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 10:08:33 -0400
Date: Fri, 10 Jul 2009 16:07:49 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Frans Pop <elendil@planet.nl>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Robin Getz <rgetz@blackfin.uclinux.org>
Cc: linux-kernel@vger.kernel.org, cryptsetup@packages.debian.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH,RFC,resend] printk: restore previous console_loglevel
	when re-enabling logging
Message-ID: <20090710140749.GD26264@elte.hu>
References: <200907061331.49930.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200907061331.49930.elendil@planet.nl>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Frans Pop <elendil@planet.nl> wrote:

> When logging to console is disabled from userspace using klogctl()
> and later re-enabled, console_loglevel gets set to the default
> log level instead to the previous value.
> This means that if the kernel was booted with 'quiet', the boot is
> suddenly no longer quiet after logging to console gets re-enabled.
> 
> Save the current console_loglevel when logging is disabled and
> restore to that value. If the log level is set to a specific value
> while disabled, this is interpreted as an implicit re-enabling of
> the logging.
> 
> Signed-off-by: Frans Pop <elendil@planet.nl>
> ---
> 
> Resend. The problem that prompted this patch is described in
> http://lkml.org/lkml/2009/6/28/234
> 
> There are two variations possible on the patch below.
> 
> 1) If klogctl(7) is called while logging is not disabled, then set level
>    to default (partially preserving current functionality):
>  	case 7:		/* Enable logging to console */
> -		console_loglevel = default_console_loglevel;
> +		if (saved_console_loglevel == -1)
> +			console_loglevel = default_console_loglevel;
> +		else {
> +			console_loglevel = saved_console_loglevel;
> +			saved_console_loglevel = -1;
> +		}
> 
> 2) If klogctl(8) is called while logging is disabled, then don't enable
>    logging, but remember the requested value for when logging does get
>    enabled again:
>  	case 8:		/* Set level of messages printed to console */
> [...]
> - 		console_loglevel = len;
> +		if (saved_console_loglevel == -1)
> +	 		console_loglevel = len;
> +		else
> +			saved_console_loglevel = len;
> 
> Yet another option would be to ignore the request.

Looks like a possible solution to a real problem (most distros today 
boot with quiet) - albeit it does change previous behavior so 
objections are possible on those grounds.

I've queued it up in the tip:core/printk tree and will push it out 
to linux-next in a few days if there are no objections.

Small sidenote: i moved the (somewhat obscurely placed) 
saved_console_loglevel static variable out of local variable scope 
and next to the console loglevel definitions (such as 
console_printk[]), to increase its visibility as globally relevant 
state and to move it next to the state this variable affects.

Thanks,

	Ingo
