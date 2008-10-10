Return-Path: <linux-kernel-owner+w=401wt.eu-S1758958AbYJJL4i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758958AbYJJL4i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 07:56:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754150AbYJJL4a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 07:56:30 -0400
Received: from sunrise.pg.gda.pl ([153.19.40.230]:51951 "EHLO
	sunrise.pg.gda.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753774AbYJJL43 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 07:56:29 -0400
Date: Fri, 10 Oct 2008 13:56:02 +0200
From: Adam =?UTF-8?B?VGxhxYJrYQ==?= <atlka@pg.gda.pl>
To: Adam =?UTF-8?B?VGxhxYJrYQ==?= <atlka@pg.gda.pl>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       torvalds@osdl.org
Subject: Re: [PATCH 0/1] SIGWINCH problem with terminal apps still alive
Message-ID: <20081010135602.70ed7aaa@merlin.oi.pg.gda.pl>
In-Reply-To: <20081010123517.7441a481@merlin.oi.pg.gda.pl>
References: <20081006140708.7911f101@merlin.oi.pg.gda.pl>
	<20081006141306.6a1f0a15@lxorguk.ukuu.org.uk>
	<20081006202834.5b6c5092@merlin.oi.pg.gda.pl>
	<20081006231434.7aaa41ee@lxorguk.ukuu.org.uk>
	<20081007222857.11f92ca0@merlin.oi.pg.gda.pl>
	<20081010031234.4030b176@merlin.oi.pg.gda.pl>
	<20081010102906.7fb17d4a@lxorguk.ukuu.org.uk>
	<20081010123517.7441a481@merlin.oi.pg.gda.pl>
Organization: =?UTF-8?B?R2RhxYRzaw==?= University of Technology
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.12.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fri, 10 Oct 2008 12:35:17 +0200 - Adam Tlałka <atlka@pg.gda.pl>:

> Fri, 10 Oct 2008 10:29:06 +0100 - Alan Cox <alan@lxorguk.ukuu.org.uk>:
> > 
> > NAK again
> > 
> > Moving the copies around simply moves the race, it might be that it
> > fixes your box and unfixes other peoples.
> > 
> 
> I don't think so. Race appears because of kill_pgrp() call which
> generates SIGWINCH so it leads to reschedule and ioctl() which reads
> termios sizes before they are updated - from time to time. So if we
> update variables before signal generation there will be no race.
> Moving the point of variables update eliminates
> possibility of reading old values. So even if after kill_pgrp() the
> other process will not lock here on this mutex values obtained will be
> sane.
> 
> Whats more we could protect by mutex variable only test and change
> operations and it stil will work correctly.
> 
> Because now we have 2.6.27 I tested this kind of code in
> tty_io.c(tty_do_resize):
> 
> ...
> 
> So it works, and change of tty->winsize and real_tty->winsize are
> protected . Why another process should wait more if winsize is
> already properly set?

Next if we want to speed up our code in case of resize we could remove
one of two comparizons so values always be updated in tty_io.c(tty_do_resize):

	struct pid *pgrp, *rpgrp;
        unsigned long flags;

	/* For a PTY we need to lock the tty side */                                                                 
        mutex_lock(&real_tty->termios_mutex);                                                                        
        flags = memcmp(ws, &tty->winsize, sizeof(*ws));
        tty->winsize = *ws;
        real_tty->winsize = *ws;
        mutex_unlock(&real_tty->termios_mutex);                                                                      
        if (flags){                                                                                                  
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
        }                                                                                                            
                                                                                                                     
        return 0;

We could assume that ioctl which sets the same values is rather rare
so we want faster code in case of changes. Presented above code for 
kernel 2.6.27 works quit nicely and I can't observe any bad effect of it.
Anyway we can prove on paper by time diagrams that there will be no races
according to update and reading winsize variables.

Regards

-- 
Adam Tlałka       mailto:atlka@pg.gda.pl    ^v^ ^v^ ^v^
System  & Network Administration Group       - - - ~~~~~~
Computer Center, Gdańsk University of Technology, Poland
