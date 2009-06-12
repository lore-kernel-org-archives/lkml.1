Return-Path: <linux-kernel-owner+w=401wt.eu-S1761381AbZFLLa2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761381AbZFLLa2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 07:30:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760843AbZFLL3m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 07:29:42 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:53568 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759797AbZFLL3l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 07:29:41 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Mike Frysinger <vapier@gentoo.org>
Subject: Re: [PATCH] Blackfin: sync termios header changes with x86
Date: Fri, 12 Jun 2009 13:29:33 +0200
User-Agent: KMail/1.11.90 (Linux/2.6.30-8-generic; KDE/4.2.85; x86_64; ; )
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       uclinux-dist-devel@blackfin.uclinux.org
References: <200906121247.50745.arnd@arndb.de> <1244804202-17030-1-git-send-email-vapier@gentoo.org>
In-Reply-To: <1244804202-17030-1-git-send-email-vapier@gentoo.org>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>
 =?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <200906121329.33473.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/3K+OZfc7XQ2XOF5liW+ie4jI/yLsWm166RjX
 OTyr+cvvRkEqG/wMltrAEKPqDvcXUHU8tVzRl8IPPSzm7E93B0
 LG6QXPM/yosiJZog720FndHJ2AjwmUL
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 12 June 2009, Mike Frysinger wrote:

> Arnd: if you don't mind, i'd rather merge this ... i can put it into my
> next batch of Blackfin changes for 2.6.31

I don't see how that helps, because:
 
>  #define TIOCMIWAIT	0x545C	/* wait for a change on serial input line(s) */
>  #define TIOCGICOUNT	0x545D	/* read serial port inline interrupt counts */
> -
> -#define FIOQSIZE	0x545E
> +#define TIOCGHAYESESP   0x545E  /* Get Hayes ESP configuration */
> +#define TIOCSHAYESESP   0x545F  /* Set Hayes ESP configuration */
> +#define FIOQSIZE	0x5460

This breaks existing applications using FIOQSIZE. You really shouldn't do that.

> diff --git a/arch/blackfin/include/asm/termbits.h b/arch/blackfin/include/asm/termbits.h
> index f37feb7..faa569f 100644
> --- a/arch/blackfin/include/asm/termbits.h
> +++ b/arch/blackfin/include/asm/termbits.h

This one only changes whitespace, what is the point?

> --- a/arch/blackfin/include/asm/termios.h
> +++ b/arch/blackfin/include/asm/termios.h

This change fixes one bug but not another:

> @@ -58,37 +60,55 @@ struct termio {
>  	*(unsigned short *) &(termios)->x = __tmp; \
>  }
>  
> -#define user_termio_to_kernel_termios(termios, termio) \
> -({ \
> -	SET_LOW_TERMIOS_BITS(termios, termio, c_iflag); \
> -	SET_LOW_TERMIOS_BITS(termios, termio, c_oflag); \
> -	SET_LOW_TERMIOS_BITS(termios, termio, c_cflag); \
> -	SET_LOW_TERMIOS_BITS(termios, termio, c_lflag); \
> -	copy_from_user((termios)->c_cc, (termio)->c_cc, NCC); \
> -})
> +static inline int user_termio_to_kernel_termios(struct ktermios *termios,
> +						struct termio __user *termio)
> +{
> +	SET_LOW_TERMIOS_BITS(termios, termio, c_iflag);
> +	SET_LOW_TERMIOS_BITS(termios, termio, c_oflag);
> +	SET_LOW_TERMIOS_BITS(termios, termio, c_cflag);
> +	SET_LOW_TERMIOS_BITS(termios, termio, c_lflag);
> +	get_user(termios->c_line, &termio->c_line);
> +	return copy_from_user(termios->c_cc, termio->c_cc, NCC);
> +}

You correctly read termios->c_line now, which was missing previously,
but you still don't check the return value of the get_user and
copy_from_user functions. The code also has a very ugly property
of working only on little-endian architectures (which includes
blackfin AFAICT) but should not serve as an example.

If you want a working version of this file, best copy it from avr32
or frv. Or just wait for the asm-generic version.

	Arnd <><
