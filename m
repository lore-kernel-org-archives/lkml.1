Return-Path: <linux-kernel-owner+w=401wt.eu-S1755538AbYDINmB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755538AbYDINmB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2008 09:42:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752935AbYDINly
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Apr 2008 09:41:54 -0400
Received: from saeurebad.de ([85.214.36.134]:45291 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752734AbYDINlx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2008 09:41:53 -0400
From: Johannes Weiner <hannes@saeurebad.de>
To: Roel Kluin <12o3l@tiscali.nl>
Cc: "Maciej W. Rozycki" <macro@linux-mips.org>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] dz: test after postfix decrement fails in dz_console_putchar()
References: <47FC93BC.5020201@tiscali.nl>
Date: Wed, 09 Apr 2008 15:41:13 +0200
In-Reply-To: <47FC93BC.5020201@tiscali.nl> (Roel Kluin's message of "Wed, 09
	Apr 2008 12:00:28 +0200")
Message-ID: <87ve2rqh6u.fsf@saeurebad.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Roel Kluin <12o3l@tiscali.nl> writes:

> When loops reaches 0 the postfix decrement still subtracts, so the test fails
>
> Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
> ---
> diff --git a/drivers/serial/dz.c b/drivers/serial/dz.c
> index 116211f..0dddd68 100644
> --- a/drivers/serial/dz.c
> +++ b/drivers/serial/dz.c
> @@ -819,7 +819,7 @@ static void dz_console_putchar(struct uart_port *uport, int ch)
>  		dz_out(dport, DZ_TCR, mask);
>  		iob();
>  		udelay(2);
> -	} while (loops--);
> +	} while (--loops);

It will run loops + 1 times.  After your change it does run loops times.

>  	if (loops)				/* Cannot send otherwise. */
>  		dz_out(dport, DZ_TDR, ch);

The intention was probably that this gets executed if the break in the
loop (trdy == dport->port.line) is reached.  Without your fix, this
branch is also taken if the while-loop terminates with loops == -1
because of the postfix dec.

Your fix is correct but your changelog entry is wrong.

	Hannes
