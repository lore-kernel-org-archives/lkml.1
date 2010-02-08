Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752204Ab0BHWCN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Feb 2010 17:02:13 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56178 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750802Ab0BHWCM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Feb 2010 17:02:12 -0500
Date: Mon, 8 Feb 2010 14:01:27 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Dave Young <hidave.darkstar@gmail.com>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 2/2] allow printk delay after multi lines
Message-Id: <20100208140127.ca80bc97.akpm@linux-foundation.org>
In-Reply-To: <20100208135654.04b79bbc.akpm@linux-foundation.org>
References: <20100206134056.GB2562@darkstar>
	<20100208135654.04b79bbc.akpm@linux-foundation.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 8 Feb 2010 13:56:54 -0800
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Sat, 6 Feb 2010 21:40:56 +0800
> Dave Young <hidave.darkstar@gmail.com> wrote:
> 
> > printk delay help us to capture printk messages on some unconvenient senarios,
> > but it is still not easy to read.
> > 
> > Add another sysctl variable printk_delay_per_lines to make it more readable.
> > We can set the lines according to screen height, then take pictures by camera.
> > 
> > kmesg will delay printk_delay_per_lines * printk_delay_msecs milliseconds
> > after every printk_delay_per_lines lines when printk_delay is enabled.
> > 
> > Setting the lines by proc/sysctl interface:
> > /proc/sys/kernel/printk_delay_per_lines
> > 
> > Andrew, sorry, I have not find time to cleanup the kernel.h sysctl variables.
> > If I'm free I will try to do it.
> > 
> > The value range from 1 - 100, default value is 1
> > 
> > ...
> >
> > --- linux-2.6.orig/include/linux/kernel.h	2010-02-02 13:38:09.537495564 +0800
> > +++ linux-2.6/include/linux/kernel.h	2010-02-02 13:40:47.657480122 +0800
> > @@ -246,6 +246,7 @@ extern bool printk_timed_ratelimit(unsig
> >  				   unsigned int interval_msec);
> >  
> >  extern int printk_delay_msec;
> > +extern int printk_delay_per_lines;
> >  
> >  /*
> >   * Print a one-time message (analogous to WARN_ONCE() et al):
> > --- linux-2.6.orig/kernel/printk.c	2010-02-02 13:39:19.446657319 +0800
> > +++ linux-2.6/kernel/printk.c	2010-02-02 13:40:47.660813615 +0800
> > @@ -656,16 +656,26 @@ static int new_text_line = 1;
> >  static char printk_buf[1024];
> >  
> >  int printk_delay_msec __read_mostly;
> > +int printk_delay_per_lines __read_mostly;
> >  
> >  static inline void printk_delay(void)
> >  {
> >  	if (unlikely(printk_delay_msec)) {
> > -		int m = printk_delay_msec;
> > +		static int m, l;
> >  
> > +		if (!l)
> > +			l = printk_delay_per_lines;
> > +
> > +		if (--l) {
> > +			m += printk_delay_msec;
> > +			return;
> > +		}
> > +		m += printk_delay_msec;
> >  		while (m--) {
> >  			mdelay(1);
> >  			touch_nmi_watchdog();
> >  		}
> > +		m = 0;
> >  	}
> >  }
> 

Also...

- The above code is racy: if multiple CPUs run printk_delay()
  concurrently, `m' and `l' will get mucked up.

  We should verify that the effects of this race are benign.  This
  will be hard.

  Or we fix the race.  One could add locking (irq-safe locking), but
  I suspect a better approach would be to use atomic ops.
