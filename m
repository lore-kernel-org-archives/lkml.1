Return-Path: <linux-kernel-owner+w=401wt.eu-S1758542AbZELHzn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758542AbZELHzn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 03:55:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756850AbZELHz0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 03:55:26 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:36590 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757301AbZELHzZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 03:55:25 -0400
Date: Tue, 12 May 2009 09:55:13 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Arnd Bergmann <arnd@arndb.de>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
       Remis Lima Baima <remis.developer@googlemail.com>
Subject: Re: [PATCH v2] x86: fix ktermios-termio conversion
Message-ID: <20090512075513.GA14122@elte.hu>
References: <20090511222702.352192505@arndb.de> <20090511222702.352192505@arndb.de>> <200905112259.04714.arnd@arndb.de> <200905112319.17999.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200905112319.17999.arnd@arndb.de>
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


* Arnd Bergmann <arnd@arndb.de> wrote:

> The operation with the variable 'c_line' was missing in the function
> 'user_termio_to_kernel_termios'. Also the casting '*(unsigned short *)'
> in the macro 'SET_LOW_TERMIOS_BITS' was a bit 'unhealthy'. So the macro
> was removed and the function was changed to be like in other archs
> (e.g. h8300, m68k, sparc) that have a more elegant solution.
> 
> In the function 'kernel_termios_to_user_termio' the return values of
> the functions calls 'put_user' and 'copy_to_user' were not being
> checked.
> 
> Signed-off-by: Remis Lima Baima <remis.developer@googlemail.com>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
> 
> initial patch was wordwrapped, resend
> 
>  arch/x86/include/asm/termios.h |   54 +++++++++++++++++++++++++++------------
>  1 files changed, 37 insertions(+), 17 deletions(-)
> 
> diff --git a/arch/x86/include/asm/termios.h b/arch/x86/include/asm/termios.h
> index f729563..47420df 100644
> --- a/arch/x86/include/asm/termios.h
> +++ b/arch/x86/include/asm/termios.h
> @@ -54,20 +54,37 @@ struct termio {
>  /*
>   * Translate a "termio" structure into a "termios". Ugh.
>   */
> -#define SET_LOW_TERMIOS_BITS(termios, termio, x) { \
> -	unsigned short __tmp; \
> -	get_user(__tmp,&(termio)->x); \
> -	*(unsigned short *) &(termios)->x = __tmp; \
> -}
> -
>  static inline int user_termio_to_kernel_termios(struct ktermios *termios,
>  						struct termio __user *termio)
>  {
> -	SET_LOW_TERMIOS_BITS(termios, termio, c_iflag);
> -	SET_LOW_TERMIOS_BITS(termios, termio, c_oflag);
> -	SET_LOW_TERMIOS_BITS(termios, termio, c_cflag);
> -	SET_LOW_TERMIOS_BITS(termios, termio, c_lflag);
> -	return copy_from_user(termios->c_cc, termio->c_cc, NCC);
> +	unsigned short tmp;
> +
> +	if (get_user(tmp, &termio->c_iflag) < 0)
> +		goto fault;
> +	termios->c_iflag = (0xffff0000 & termios->c_iflag) | tmp;
> +
> +	if (get_user(tmp, &termio->c_oflag) < 0)
> +		goto fault;
> +	termios->c_oflag = (0xffff0000 & termios->c_oflag) | tmp;
> +
> +	if (get_user(tmp, &termio->c_cflag) < 0)
> +		goto fault;
> +	termios->c_cflag = (0xffff0000 & termios->c_cflag) | tmp;
> +
> +	if (get_user(tmp, &termio->c_lflag) < 0)
> +		goto fault;
> +	termios->c_lflag = (0xffff0000 & termios->c_lflag) | tmp;
> +
> +	if (get_user(termios->c_line, &termio->c_line) < 0)
> +		goto fault;
> +
> +	if (copy_from_user(termios->c_cc, termio->c_cc, NCC) != 0)
> +		goto fault;

Hm, that looks a bit ugly and it also adds 150 bytes of bloat to the 
kernel:

drivers/char/tty_ioctl.o:

   text	   data	    bss	    dec	    hex	filename
   4704	      0	      0	   4704	   1260	tty_ioctl.o.before
   4841	      0	      0	   4841	   12e9	tty_ioctl.o.after

(64-bit 'make defconfig', on latest tip:master)

	Ingo
