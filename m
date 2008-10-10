Return-Path: <linux-kernel-owner+w=401wt.eu-S1757806AbYJJKgc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757806AbYJJKgc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 06:36:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752857AbYJJKgX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 06:36:23 -0400
Received: from sunrise.pg.gda.pl ([153.19.40.230]:33492 "EHLO
	sunrise.pg.gda.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752718AbYJJKgW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 06:36:22 -0400
Date: Fri, 10 Oct 2008 12:35:17 +0200
From: Adam =?UTF-8?B?VGxhxYJrYQ==?= <atlka@pg.gda.pl>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org, torvalds@osdl.org
Subject: Re: [PATCH 0/1] SIGWINCH problem with terminal apps still alive
Message-ID: <20081010123517.7441a481@merlin.oi.pg.gda.pl>
In-Reply-To: <20081010102906.7fb17d4a@lxorguk.ukuu.org.uk>
References: <20081006140708.7911f101@merlin.oi.pg.gda.pl>
	<20081006141306.6a1f0a15@lxorguk.ukuu.org.uk>
	<20081006202834.5b6c5092@merlin.oi.pg.gda.pl>
	<20081006231434.7aaa41ee@lxorguk.ukuu.org.uk>
	<20081007222857.11f92ca0@merlin.oi.pg.gda.pl>
	<20081010031234.4030b176@merlin.oi.pg.gda.pl>
	<20081010102906.7fb17d4a@lxorguk.ukuu.org.uk>
Organization: =?UTF-8?B?R2RhxYRzaw==?= University of Technology
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.12.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fri, 10 Oct 2008 10:29:06 +0100 - Alan Cox <alan@lxorguk.ukuu.org.uk>:

> On Fri, 10 Oct 2008 03:12:34 +0200
> Adam Tlałka <atlka@pg.gda.pl> wrote:
> 
> > Welcome,
> > 
> > now we have 2.6.26.6 kernel and still terminal resize leads to
> > undesired effects. It is very inconvenient to wait for 2.6.27 for
> > corrections.
> > 
> > As Alan Cox previously said mutexes generally work but as we can
> > observe in case of kill_pgrp() call inside mutex lock we got
> > race because of rescheduling so lock is not working here.
> > Rearanging code so the variable change is placed before kill_pgrp()
> > call removes mentioned race situaction.   
> > 
> > Signed-off-by: Adam Tla/lka <atlka@pg.gda.pl>
> > 
> > I strongly suggest to patch actual 2.6.26.x kernel to remove this
> > very nasty pts behaviour.
> 
> NAK again
> 
> Moving the copies around simply moves the race, it might be that it
> fixes your box and unfixes other peoples.
> 

I don't think so. Race appears because of kill_pgrp() call which
generates SIGWINCH so it leads to reschedule and ioctl() which reads
termios sizes before they are updated - from time to time. So if we
update variables before signal generation there will be no race.
Moving the point of variables update eliminates
possibility of reading old values. So even if after kill_pgrp() the
other process will not lock here on this mutex values obtained will be
sane.

Whats more we could protect by mutex variable only test and change
operations and it stil will work correctly.

Because now we have 2.6.27 I tested this kind of code in
tty_io.c(tty_do_resize):

	struct pid *pgrp, *rpgrp;                                                                                    
        unsigned long flags;                                                                                         

/* For a PTY we need to lock the tty side */                                                                 
        mutex_lock(&real_tty->termios_mutex);                                                                        
        if ((flags = memcmp(ws, &tty->winsize, sizeof(*ws)))){                                                       
                tty->winsize = *ws;                                                                                  
                real_tty->winsize = *ws;                                                                             
        }                                                                                                            
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


So it works, and change of tty->winsize and real_tty->winsize are protected .
Why another process should wait more if winsize is already properly set?

Regards

-- 
Adam Tlałka       mailto:atlka@pg.gda.pl    ^v^ ^v^ ^v^
System  & Network Administration Group       - - - ~~~~~~
Computer Center, Gdańsk University of Technology, Poland
