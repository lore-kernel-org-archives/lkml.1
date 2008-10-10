Return-Path: <linux-kernel-owner+w=401wt.eu-S1754812AbYJJDdk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754812AbYJJDdk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 23:33:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752111AbYJJDdc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 23:33:32 -0400
Received: from sunrise.pg.gda.pl ([153.19.40.230]:53129 "EHLO
	sunrise.pg.gda.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751539AbYJJDdb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 23:33:31 -0400
Date: Fri, 10 Oct 2008 05:32:38 +0200
From: Adam =?UTF-8?B?VGxhxYJrYQ==?= <atlka@pg.gda.pl>
To: Adam =?UTF-8?B?VGxhxYJrYQ==?= <atlka@pg.gda.pl>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       torvalds@osdl.org
Subject: Re: [PATCH 0/1] SIGWINCH problem with terminal apps still alive
Message-ID: <20081010053238.5ad56876@merlin.oi.pg.gda.pl>
In-Reply-To: <20081010031234.4030b176@merlin.oi.pg.gda.pl>
References: <20081006140708.7911f101@merlin.oi.pg.gda.pl>
	<20081006141306.6a1f0a15@lxorguk.ukuu.org.uk>
	<20081006202834.5b6c5092@merlin.oi.pg.gda.pl>
	<20081006231434.7aaa41ee@lxorguk.ukuu.org.uk>
	<20081007222857.11f92ca0@merlin.oi.pg.gda.pl>
	<20081010031234.4030b176@merlin.oi.pg.gda.pl>
Organization: =?UTF-8?B?R2RhxYRzaw==?= University of Technology
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.12.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Welcome,

Fri, 10 Oct 2008 03:12:34 +0200 - Adam Tlałka <atlka@pg.gda.pl>:
> now we have 2.6.26.6 kernel and still terminal resize leads to
> undesired effects. It is very inconvenient to wait for 2.6.27 for
> corrections.

Very funny, I've posted my patch just before 2.6.27 appeared so now it
seems obsolete. Only argument for it now is the cleaner and more
optimized code. Why?
Now we have two distant places where we use ws and tty->winsize
variables:

(from drivers/char/tty_io.c:tty_do_resize())

	mutex_lock(&real_tty->termios_mutex);
=>      if (!memcmp(ws, &tty->winsize, sizeof(*ws)))
                goto done;
        /* Get the PID values and reference them so we can
           avoid holding the tty ctrl lock while sending signals */
        spin_lock_irqsave(&tty->ctrl_lock, flags);
        pgrp = get_pid(tty->pgrp);
        rpgrp = get_pid(real_tty->pgrp);
        spin_unlock_irqrestore(&tty->ctrl_lock, flags);

        if (pgrp)
                kill_pgrp(pgrp, SIGWINCH, 1);
        if (rpgrp != pgrp && rpgrp)
                kill_pgrp(rpgrp, SIGWINCH, 1);

        put_pid(pgrp);
        put_pid(rpgrp);

=>      tty->winsize = *ws;
=>      real_tty->winsize = *ws;
done:
	mutex_unlock(&real_tty->termios_mutex);
 
Rearanged code

	mutex_lock(&real_tty->termios_mutex);
=>      if (!memcmp(ws, &tty->winsize, sizeof(*ws)))
                goto done;
=>	tty->winsize = *ws;
=>	real_tty->winsize = *ws;

        /* Get the PID values and reference them so we can
           avoid holding the tty ctrl lock while sending signals */
        spin_lock_irqsave(&tty->ctrl_lock, flags);
        pgrp = get_pid(tty->pgrp);
        rpgrp = get_pid(real_tty->pgrp);
        spin_unlock_irqrestore(&tty->ctrl_lock, flags);

        if (pgrp)
                kill_pgrp(pgrp, SIGWINCH, 1);
        if (rpgrp != pgrp && rpgrp)
                kill_pgrp(rpgrp, SIGWINCH, 1);

        put_pid(pgrp);
        put_pid(rpgrp);

done:
	mutex_unlock(&real_tty->termios_mutex);

is more logical and grouping acces to the same variable in one place
mean that gcc can better optimize outputed machine code. So it should
be a bit faster.
If some app gets SIGWINCH and will be waiting on this mutex so in case
of rearanged code it will be waiting shorter because variables setting
is done before signal generation.

Regards

-- 
Adam Tlałka       mailto:atlka@pg.gda.pl    ^v^ ^v^ ^v^
System  & Network Administration Group       - - - ~~~~~~
Computer Center, Gdańsk University of Technology, Poland
