Return-Path: <linux-kernel-owner+w=401wt.eu-S1759253AbXKAWTU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759253AbXKAWTU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 18:19:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753757AbXKAWTM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 18:19:12 -0400
Received: from tomts10.bellnexxia.net ([209.226.175.54]:64020 "EHLO
	tomts10-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753160AbXKAWTL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 18:19:11 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ah4FADrtKUdMQWvU/2dsb2JhbACBWw
Date: Thu, 1 Nov 2007 18:19:08 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Pavel Machek <pavel@ucw.cz>
Cc: Tim Bird <tim.bird@am.sony.com>, Matt Mackall <mpm@selenic.com>,
       linux kernel <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@redhat.com>, Jon Smirl <jonsmirl@yahoo.com>
Subject: Re: IRQ off latency of printk is very high
Message-ID: <20071101221908.GE19700@Krystal>
References: <4720F21F.9090404@am.sony.com> <20071025222804.GA13954@Krystal> <47211E2C.90301@am.sony.com> <20071025231237.GT19691@waste.org> <472129C3.6040405@am.sony.com> <20071029185445.GA7742@ucw.cz> <20071101152714.GA2489@Krystal> <20071101211153.GA11074@elf.ucw.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20071101211153.GA11074@elf.ucw.cz>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 18:17:36 up 94 days, 22:36,  3 users,  load average: 0.27, 0.43, 0.61
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Pavel Machek (pavel@ucw.cz) wrote:
> Hi!
> 
> > > > It seems draconian to drain the entire buffer with ints disabled.
> > > > Is it possible to break this up and send out smaller chunks
> > > > at a time?  Maybe by putting a chunk loop in release_console_sem()?
> > > 
> > > Well, I believe someone got
> > > 
> > > DDetetccctted ed 113223 HHzz CPUCPU
> > > 
> > > in his dmesg, and now we have this 'draconian' locking. How can we
> > > prevent mangled messages without it?
> > 
> > The main interest seems to be to protect from mixed printk output
> > between different CPUs in process context. I don't think it would be
> > that bad if interrupts come and output error messages in the middle of a
> > printk, isn't it ?
> > 
> > therefore, could we do something like :
> > 
> > 
> > if (!in_irq())
> >   spin_lock(&logbuf_lock);
> > ...
> > if (!in_irq())
> >   spin_unlock(&logbuf_lock);
> > 
> > ? (yes, this is a crazy idea)
> 
> Two messages in atomic sections on different cpus could still be mixed
> :-). But yes, something like this may be the way to go.

Not in "preempt disable" sections though. Only in interrupt handlers.
But yes, I assume here that messages coming from interrupt handlers can
afford being interleaved.

Mathieu

> 									Pavel
> -- 
> (english) http://www.livejournal.com/~pavelmachek
> (cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
