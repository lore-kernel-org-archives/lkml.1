Return-Path: <linux-kernel-owner+w=401wt.eu-S1754171AbZELJGA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754171AbZELJGA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 05:06:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752300AbZELJFv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 05:05:51 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:53404 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751832AbZELJFu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 05:05:50 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH v2] x86: fix ktermios-termio conversion
Date: Tue, 12 May 2009 11:04:30 +0200
User-Agent: KMail/1.9.9
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
       Remis Lima Baima <remis.developer@googlemail.com>
References: <20090511222702.352192505@arndb.de> <200905112319.17999.arnd@arndb.de> <20090512075513.GA14122@elte.hu>
In-Reply-To: <20090512075513.GA14122@elte.hu>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200905121104.31275.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19ACnkAmp8KkGZfLn5GXhVUla0nki5AoHYRiT1
 zllN5v0/uFfM9xuatXbnxVrwLZ118rRaGZipMinapZAcdDFPSN
 BrQfqpthpN0vyieQ616+Q==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 12 May 2009, Ingo Molnar wrote:
> Hm, that looks a bit ugly and it also adds 150 bytes of bloat to the 
> kernel:
> 
> drivers/char/tty_ioctl.o:
> 
>    text    data     bss     dec     hex filename
>    4704       0       0    4704    1260 tty_ioctl.o.before
>    4841       0       0    4841    12e9 tty_ioctl.o.after

It's easy to go back to a macro (or replace it by another inline
function if you prefer that stylistically) to make it look
nicer.

Regarding the bloat, I'm still looking for a better version.
The code I posted is basically what is in asm-generic/termios.h
traditionally, so at least I'm reasonably confident that it
is correct, while the x86 version currently fails to return
-EFAULT on incorrect pointers and misses c_line changes.

I now tried this version, which theoretically should be
fairly compact on most architectures:

static inline int set_low_termios_bits(unsigned int *termios,
			const short __user *termio)
{
	unsigned short tmp;
	int ret;

	ret = __get_user(tmp, termio);
	*termios = (0xffff0000 & *termios) | tmp;

	return ret;
}

/*
 * Translate a "termio" structure into a "termios". Ugh.
 */
static inline int user_termio_to_kernel_termios(struct ktermios *termios,
						const struct termio __user *termio)
{
	if (access_ok(VERIFY_READ, termio, sizeof (*termio)))
		return -EFAULT;

	return set_low_termios_bits(&termios->c_iflag, &termio->c_iflag) |
	       set_low_termios_bits(&termios->c_oflag, &termio->c_oflag) |
	       set_low_termios_bits(&termios->c_cflag, &termio->c_cflag) |
	       set_low_termios_bits(&termios->c_lflag, &termio->c_lflag) |
	       __get_user(termios->c_line, &termio->c_line) |
	       (__copy_from_user(termios->c_cc, termio->c_cc, NCC)
				? -EFAULT : 0);
}

/*
 * Translate a "termios" structure into a "termio". Ugh.
 */
static inline int kernel_termios_to_user_termio(struct termio __user *termio,
						struct ktermios *termios)
{
	if (access_ok(VERIFY_WRITE, termio, sizeof (*termio)))
		return -EFAULT;

	return __put_user(termios->c_iflag, &termio->c_iflag) |
	       __put_user(termios->c_oflag, &termio->c_oflag) |
	       __put_user(termios->c_cflag, &termio->c_cflag) |
	       __put_user(termios->c_lflag, &termio->c_lflag) |
	       __put_user(termios->c_line,  &termio->c_line) |
	       (__copy_to_user(termio->c_cc, termios->c_cc, NCC)
				? -EFAULT : 0);
}

Unfortunately, this is even more code on x86, where get_user/put_user
is out-of-line, while __get_user/__put_user is inline and produces
fixup code.
The best I could come up with is somewhat slower but also shorter:

static inline int set_low_termios_bits(unsigned int *termios,
			const short __user *termio)
{
	unsigned short tmp;
	int ret;

	ret = get_user(tmp, termio);
	*termios = (0xffff0000 & *termios) | tmp;

	return ret;
}

/*
 * Translate a "termio" structure into a "termios". Ugh.
 */
static inline int user_termio_to_kernel_termios(struct ktermios *termios,
						const struct termio __user *termio)
{
	return (set_low_termios_bits(&termios->c_iflag, &termio->c_iflag) ||
		set_low_termios_bits(&termios->c_oflag, &termio->c_oflag) ||
		set_low_termios_bits(&termios->c_cflag, &termio->c_cflag) ||
		set_low_termios_bits(&termios->c_lflag, &termio->c_lflag) ||
		get_user(termios->c_line, &termio->c_line) ||
		copy_from_user(termios->c_cc, termio->c_cc, NCC))
				? -EFAULT : 0;
}

/*
 * Translate a "termios" structure into a "termio". Ugh.
 */
static inline int kernel_termios_to_user_termio(struct termio __user *termio,
						struct ktermios *termios)
{
	return put_user(termios->c_iflag, &termio->c_iflag) ||
	       put_user(termios->c_oflag, &termio->c_oflag) ||
	       put_user(termios->c_cflag, &termio->c_cflag) ||
	       put_user(termios->c_lflag, &termio->c_lflag) ||
	       put_user(termios->c_line,  &termio->c_line) ||
	       (copy_to_user(termio->c_cc, termios->c_cc, NCC))
				? -EFAULT : 0;
}

If you think that looks better, I can send another patch. I have
not tested this code functionally though.

	Arnd <><
