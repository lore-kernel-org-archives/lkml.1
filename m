Return-Path: <linux-kernel-owner+w=401wt.eu-S1756886AbXERMfi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756886AbXERMfi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 08:35:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754522AbXERMfb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 08:35:31 -0400
Received: from ns2.suse.de ([195.135.220.15]:34744 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753170AbXERMfa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 08:35:30 -0400
From: Andi Kleen <ak@suse.de>
To: Tim Hockin <thockin@google.com>
Subject: Re: [PATCH] x86_64: mcelog tolerant level cleanup
Date: Fri, 18 May 2007 14:35:01 +0200
User-Agent: KMail/1.9.1
Cc: vojtech@suse.cz, akpm@google.com, linux-kernel@vger.kernel.org
References: <20070516202956.GA27184@google.com>
In-Reply-To: <20070516202956.GA27184@google.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705181435.01562.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 16 May 2007 22:29, Tim Hockin wrote:
> From: Tim Hockin <thockin@google.com>
>
> Background:
>  The MCE handler has several paths that it can take, depending on various
>  conditions of the MCE status and the value of the 'tolerant' knob.  The
>  exact semantics are not well defined and the code is a bit twisty.
>
> Description:
>  This patch makes the MCE handler's behavior more clear by documenting the
>  behavior for various 'tolerant' levels.  It also fixes or enhances
>  several small things in the handler.  Specifically:
>      * If RIPV is set it is not safe to restart, so set the 'no way out'
>        flag rather than the 'kill it' flag.

Why? It is not PCC. We cannot return of course, but killing isn't returning.

>      * Don't panic() on correctable MCEs.

The idea behind this was that if you get an exception it is always a bit risky
because there are a few potential deadlocks that cannot be avoided.
And normally non UC is just polled which will never cause a panic.
So I don't quite see the value of this change.

> This patch also calls nonseekable_open() in mce_open (as suggested by akpm).

That should be a separate patch

> +		0: always panic on uncorrected errors, log corrected errors
> +		1: panic or SIGBUS on uncorrected errors, log corrected errors
> +		2: SIGBUS or log uncorrected errors, log corrected errors

Just saying SIGBUS is misleading because it isn't a catchable
signal.



> +
> +	/*
> +	 * If the error seems to be unrecoverable, something should be
> +	 * done.  Try to kill as little as possible.  If we can kill just
> +	 * one task, do that.  If the user has set the tolerance very
> +	 * high, don't try to do anything at all.
> +	 */
> +	if (kill_it && tolerant < 3) {
>  		int user_space = 0;
>
> -		if (m.mcgstatus & MCG_STATUS_RIPV)
> +		/*
> +		 * If the EIPV bit is set, it means the saved IP is the
> +		 * instruction which caused the MCE.
> +		 */
> +		if (m.mcgstatus & MCG_STATUS_EIPV)
>  			user_space = panicm.rip && (panicm.cs & 3);
> -
> -		/* When the machine was in user space and the CPU didn't get
> -		   confused it's normally not necessary to panic, unless you
> -		   are paranoid (tolerant == 0)
> -
> -		   RED-PEN could be more tolerant for MCEs in idle,
> -		   but most likely they occur at boot anyways, where
> -		   it is best to just halt the machine. */
> -		if ((!user_space && (panic_on_oops || tolerant < 2)) ||
> -		    (unsigned)current->pid <= 1)
> -			mce_panic("Uncorrected machine check", &panicm, mcestart);
> -
> -		/* do_exit takes an awful lot of locks and has as
> -		   slight risk of deadlocking. If you don't want that
> -		   don't set tolerant >= 2 */
> -		if (tolerant < 3)
> +
> +		/*
> +		 * If we know that the error was in user space, send a
> +		 * SIGBUS.  Otherwise, panic if tolerance is low.
> +		 *
> +		 * do_exit() takes an awful lot of locks and has a slight
> +		 * risk of deadlocking.
> +		 */
> +		if (user_space) {
>  			do_exit(SIGBUS);
> +		} else if (panic_on_oops || tolerant < 2) {
> +			mce_panic("Uncorrected machine check",
> +				&panicm, mcestart);
> +		}

Why did you remove the idle special case?


-Andi
