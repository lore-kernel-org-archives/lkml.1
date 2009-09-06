Return-Path: <linux-kernel-owner+w=401wt.eu-S1754187AbZIFF6r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754187AbZIFF6r (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Sep 2009 01:58:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752688AbZIFF6q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Sep 2009 01:58:46 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:35116 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752087AbZIFF6q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Sep 2009 01:58:46 -0400
Date: Sun, 6 Sep 2009 07:58:41 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Norbert van Bolhuis <nvbolhuis@aimvalley.nl>, linux-kernel@vger.kernel.org
Subject: Re: PROBLEM: CONFIG_NO_HZ could cause software timeouts
Message-ID: <20090906055841.GC1431@ucw.cz>
References: <4A9F9F64.5080305@aimvalley.nl> <4AA2ABC2.1060803@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AA2ABC2.1060803@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat 2009-09-05 20:19:46, Marcin Slusarz wrote:
> Norbert van Bolhuis wrote:
> > 
> > The problem occurs when e.g. drivers use time_after(jiffes, timeout).
> > 
> > CONFIG_NO_HZ could make jiffies advance by more than 1.
> > This is done by:
> > tick_nohz_update_jiffies->tick_do_update_jiffies64->do_timer
> > 
> > If drivers use a timeout value of jiffies+1,
> > "time_after(jiffies, timeout)" will be true after 1 interrupt
> > (given that it advances jiffies by at least 2).
> > 
> > This is exactly what happens in cfi_cmdset_0002.c:do_write_buffer
> > for our case (Powerpc MPC8313, linux-2.6.28, CONFIG_HZ=250,
> > CONFIG_NO_HZ=y).
> > 
> > do_write_buffer does the following:
> >  unsigned long uWriteTimeout = ( HZ / 1000 ) + 1;
> >  ...
> >  timeo = jiffies + uWriteTimeout;
> >  ...
> >  for (;;) {
> >   ...
> >   if (time_after(jiffies, timeo) && !chip_ready(map, adr))
> >    break;
> >   if (chip_ready(map, adr)) {
> >    xip_enable(map, chip, adr);
> >    goto op_done;
> >   }
> >   UDELAY(map, chip, adr, 1);
> >  }
> >  /* software timeout */
> >  ret = -EIO;
> > opdone:
> >  ...
> > 
> > I've seen a few software timeouts after the for-loop
> > looped only 13 times (= 13 us delay, i.s.o. the expected 1 ms). Typically
> 
> Are you sure? UDELAY may call schedule(), which can return to this thread
> after much longer time than 13us...

Too long wait is expected, but AFAICS he's complaining about too short
delay and that's a hard bug.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
