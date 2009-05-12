Return-Path: <linux-kernel-owner+w=401wt.eu-S1755412AbZELJKf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755412AbZELJKf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 05:10:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751695AbZELJKX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 05:10:23 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:40483 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751404AbZELJKW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 05:10:22 -0400
Date: Tue, 12 May 2009 11:10:10 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Arnd Bergmann <arnd@arndb.de>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
       Remis Lima Baima <remis.developer@googlemail.com>
Subject: Re: [PATCH v2] x86: fix ktermios-termio conversion
Message-ID: <20090512091010.GD18004@elte.hu>
References: <20090511222702.352192505@arndb.de> <200905112319.17999.arnd@arndb.de> <20090512075513.GA14122@elte.hu> <200905121104.31275.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200905121104.31275.arnd@arndb.de>
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

> On Tuesday 12 May 2009, Ingo Molnar wrote:
> > Hm, that looks a bit ugly and it also adds 150 bytes of bloat to the 
> > kernel:
> > 
> > drivers/char/tty_ioctl.o:
> > 
> >    text    data     bss     dec     hex filename
> >    4704       0       0    4704    1260 tty_ioctl.o.before
> >    4841       0       0    4841    12e9 tty_ioctl.o.after
> 
> It's easy to go back to a macro (or replace it by another inline 
> function if you prefer that stylistically) to make it look nicer.

no, we shouldnt go back to a macro.

> Regarding the bloat, I'm still looking for a better version. The 
> code I posted is basically what is in asm-generic/termios.h 
> traditionally, so at least I'm reasonably confident that it is 
> correct, while the x86 version currently fails to return -EFAULT 
> on incorrect pointers and misses c_line changes.
> 
> I now tried this version, which theoretically should be fairly 
> compact on most architectures:
> 
> static inline int set_low_termios_bits(unsigned int *termios,
> 			const short __user *termio)
> {
> 	unsigned short tmp;
> 	int ret;
> 
> 	ret = __get_user(tmp, termio);
> 	*termios = (0xffff0000 & *termios) | tmp;
> 
> 	return ret;
> }
> 
> /*
>  * Translate a "termio" structure into a "termios". Ugh.
>  */
> static inline int user_termio_to_kernel_termios(struct ktermios *termios,
> 						const struct termio __user *termio)
> {
> 	if (access_ok(VERIFY_READ, termio, sizeof (*termio)))
> 		return -EFAULT;
> 
> 	return set_low_termios_bits(&termios->c_iflag, &termio->c_iflag) |
> 	       set_low_termios_bits(&termios->c_oflag, &termio->c_oflag) |
> 	       set_low_termios_bits(&termios->c_cflag, &termio->c_cflag) |
> 	       set_low_termios_bits(&termios->c_lflag, &termio->c_lflag) |
> 	       __get_user(termios->c_line, &termio->c_line) |
> 	       (__copy_from_user(termios->c_cc, termio->c_cc, NCC)
> 				? -EFAULT : 0);
> }
> 
> /*
>  * Translate a "termios" structure into a "termio". Ugh.
>  */
> static inline int kernel_termios_to_user_termio(struct termio __user *termio,
> 						struct ktermios *termios)
> {
> 	if (access_ok(VERIFY_WRITE, termio, sizeof (*termio)))
> 		return -EFAULT;
> 
> 	return __put_user(termios->c_iflag, &termio->c_iflag) |
> 	       __put_user(termios->c_oflag, &termio->c_oflag) |
> 	       __put_user(termios->c_cflag, &termio->c_cflag) |
> 	       __put_user(termios->c_lflag, &termio->c_lflag) |
> 	       __put_user(termios->c_line,  &termio->c_line) |
> 	       (__copy_to_user(termio->c_cc, termios->c_cc, NCC)
> 				? -EFAULT : 0);
> }
> 
> Unfortunately, this is even more code on x86, where get_user/put_user
> is out-of-line, while __get_user/__put_user is inline and produces
> fixup code.
> The best I could come up with is somewhat slower but also shorter:
> 
> static inline int set_low_termios_bits(unsigned int *termios,
> 			const short __user *termio)
> {
> 	unsigned short tmp;
> 	int ret;
> 
> 	ret = get_user(tmp, termio);
> 	*termios = (0xffff0000 & *termios) | tmp;
> 
> 	return ret;
> }
> 
> /*
>  * Translate a "termio" structure into a "termios". Ugh.
>  */
> static inline int user_termio_to_kernel_termios(struct ktermios *termios,
> 						const struct termio __user *termio)
> {
> 	return (set_low_termios_bits(&termios->c_iflag, &termio->c_iflag) ||
> 		set_low_termios_bits(&termios->c_oflag, &termio->c_oflag) ||
> 		set_low_termios_bits(&termios->c_cflag, &termio->c_cflag) ||
> 		set_low_termios_bits(&termios->c_lflag, &termio->c_lflag) ||
> 		get_user(termios->c_line, &termio->c_line) ||
> 		copy_from_user(termios->c_cc, termio->c_cc, NCC))
> 				? -EFAULT : 0;
> }
> 
> /*
>  * Translate a "termios" structure into a "termio". Ugh.
>  */
> static inline int kernel_termios_to_user_termio(struct termio __user *termio,
> 						struct ktermios *termios)
> {
> 	return put_user(termios->c_iflag, &termio->c_iflag) ||
> 	       put_user(termios->c_oflag, &termio->c_oflag) ||
> 	       put_user(termios->c_cflag, &termio->c_cflag) ||
> 	       put_user(termios->c_lflag, &termio->c_lflag) ||
> 	       put_user(termios->c_line,  &termio->c_line) ||
> 	       (copy_to_user(termio->c_cc, termios->c_cc, NCC))
> 				? -EFAULT : 0;
> }
> 
> If you think that looks better, I can send another patch. I have 
> not tested this code functionally though.

hm, on x86 you could use get_user_try / get_user_ex() / 
get_user_catch() approach to linearize the dependencies and reduce 
register pressure.

	Ingo
