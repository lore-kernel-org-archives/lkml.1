Return-Path: <linux-kernel-owner+w=401wt.eu-S1161732AbXEAU5p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161732AbXEAU5p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 16:57:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161782AbXEAU5p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 16:57:45 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:45996 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161732AbXEAU5m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 16:57:42 -0400
Date: Tue, 1 May 2007 21:57:40 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-m68k@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Michael Schmitz <schmitz@debian.org>,
       Roman Zippel <zippel@linux-m68k.org>
Subject: Re: [patch 04/33] m68k: Atari keyboard and mouse support.
Message-ID: <20070501205740.GC21080@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Michael Schmitz <schmitz@debian.org>,
	Roman Zippel <zippel@linux-m68k.org>
References: <20070501203234.252205858@mail.of.borg> <20070501203330.172479999@mail.of.borg>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070501203330.172479999@mail.of.borg>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

What's the reason for splitting this up?  Things would be a quite a bit
simpler if all the code was directly in atakeyb.c.

> +/*
> + * linux/atari/atakeyb.c

This is a good reason why filename comments are a really bad idea :)

> +/* state: 0: off; >0: in progress; >1: 0xf1 received */
> +static volatile int ikbd_self_test;
> +/* timestamp when last received a char */
> +static volatile unsigned long self_test_last_rcv;

Please don't use volatile variable in kernel code.  While linux/m68k doesn't
support smp or preemptible kernels we should at least put in proper synchronization
at the API level.

> +/* bitmap of keys reported as broken */
> +static unsigned long broken_keys[128/(sizeof(unsigned long)*8)] = { 0, };

DECLARE_BITMAP()

> +typedef enum kb_state_t {
> +	KEYBOARD, AMOUSE, RMOUSE, JOYSTICK, CLOCK, RESYNC
> +} KB_STATE_T;
> +
> +#define	IS_SYNC_CODE(sc)	((sc) >= 0x04 && (sc) <= 0xfb)
> +
> +typedef struct keyboard_state {
> +	unsigned char buf[6];
> +	int len;
> +	KB_STATE_T state;
> +} KEYBOARD_STATE;

Please kill the typedefs and shouting names.

> +#ifdef __MODULE__
> +MODULE_PARM(mouse_threshold, "2i");
> +#endif

__MODULE__ is never true and even if it was a MODULE_PARM wouldn't compile.
use an unconditional module_param instead.

> --- linux-m68k-2.6.21.orig/include/linux/input.h
> +++ linux-m68k-2.6.21/include/linux/input.h
> @@ -676,6 +676,7 @@ struct input_absinfo {
>  #define BUS_I2C			0x18
>  #define BUS_HOST		0x19
>  #define BUS_GSC			0x1A
> +#define BUS_ATARI		0x1B

Is this really a separate bus?  Should't we have a BUS_ONBOARD or so instead?
