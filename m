Return-Path: <linux-kernel-owner+w=401wt.eu-S1761922AbXE1KNz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761922AbXE1KNz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 06:13:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750810AbXE1KNs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 06:13:48 -0400
Received: from mail.screens.ru ([213.234.233.54]:50124 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750787AbXE1KNr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 06:13:47 -0400
Date: Mon, 28 May 2007 14:13:40 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Ingo Molnar <mingo@elte.hu>, Roland McGrath <roland@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [BUG] signal: multithread program returns with wrong errno on receiving SIGSTOP
Message-ID: <20070528101340.GA1095@tv-sign.ru>
References: <20070528070753.GA989@tv-sign.ru> <87fy5hb76t.wl%takeuchi_satoru@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87fy5hb76t.wl%takeuchi_satoru@jp.fujitsu.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/28, Satoru Takeuchi wrote:
> 
> At Mon, 28 May 2007 11:07:53 +0400,
> Oleg Nesterov wrote:
> > 
> > 	drivers/char/n_tty.c:job_control()
> > 
> > 		kill_pgrp(task_pgrp(current), SIGTTIN, 1);
> > 		return -ERESTARTSYS;
> > 
> > This is wrong. kill_pgrp()->__group_send_sig_info() sends SIGTTIN
> > to the thread group, but can choose any sub-thread as a target for
> > signal_wake_up().
> > 
> > This means we return ERESTARTSYS, but signal_pending() != true, bug.
> > 
> > Satoru, could you re-test with the untested patch below?
> 
> I tested this patch on my ia64 box and it works fine.

Thanks! A quick grep shows that tty_check_change() may have the same problem.

> # Since I don't know anything about tty driver, I can't determine its
> # adequacy immediately, sorry.

/dev/tty is a black magic to me too. I'll send the patch later unless
maintainers have any objections.

> > --- t/drivers/char/n_tty.c~	2007-04-05 12:18:26.000000000 +0400
> > +++ t/drivers/char/n_tty.c	2007-05-28 10:57:58.000000000 +0400
> > @@ -1191,6 +1191,7 @@ static int job_control(struct tty_struct
> >  			    is_current_pgrp_orphaned())
> >  				return -EIO;
> >  			kill_pgrp(task_pgrp(current), SIGTTIN, 1);
> > +			set_thread_flag(TIF_SIGPENDING);
> >  			return -ERESTARTSYS;
> >  		}
> >  	}
> >

Oleg.

