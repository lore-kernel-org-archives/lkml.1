Return-Path: <linux-kernel-owner+w=401wt.eu-S1759304AbXFAXBq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759304AbXFAXBq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 19:01:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754141AbXFAXBj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 19:01:39 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:58002 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754162AbXFAXBi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 19:01:38 -0400
Subject: Re: [PATCH 1/1] V4L: stk11xx, add a new webcam driver
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       video4linux-list@redhat.com, Markus Rechberger <mrechberger@gmail.com>
In-Reply-To: <465DD40B.10409@gmail.com>
References: <2172422218943432279@wsc.cz>
	 <1180364420.21547.160.camel@localhost>  <465DD40B.10409@gmail.com>
Content-Type: text/plain
Date: Fri, 01 Jun 2007 20:00:22 -0300
Message-Id: <1180738822.3904.35.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.0-5mdv2007.1 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> >> + * Copyright (C) Nicolas VIVIEN
> > 
> > It would be interesting to have Nicolas SOB as well, if possible.
> 
> I don't think he ever knows about this version of the driver. I got his GPL
> driver, cleaned up -- coding style, v4l1 and v4l2 ioctl conversion to v4l2
> functions, some bug fixes and so on... If you still want him to sign this
> of, I'll try my best to catch him but can't guarantee any results.

It would be nice. I can accept it without his ack, but it would be
better to have it, if possible.
> 
> >> +
> >> +#ifndef CONFIG_STK11XX_DEBUG_STREAM
> >> +#define CONFIG_STK11XX_DEBUG_STREAM	0
> >> +#endif
> >> +
> >> +#if CONFIG_STK11XX_DEBUG_STREAM
> > 
> > I would instead use:
> > #ifdef CONFIG_STK11XX_DEBUG_STREAM
> 
> Hmm, no, I would rather get rid of CONFIG_ thing, it may make things
> unclear, beacuse there is (will be) no option in Kconfig for this, because
> this is the most verbose option for the driver mainly used for algorithms
> debugging.
Seems ok to me.

> > We don't do format conversions in kernel. Instead, you should return a
> > proper Bayer Fourcc format (like V4L2_PIX_FMT_SBGGR8).
> 
> 
> Ok, there is a debate about this, I will do the changes after some decision
> will be made.

As you wish.

> > Please use instead the load_firmware routines. It is not a good idea to
> > have firmware inside the kernel. Also, this might rise some legal issues
> > due to licensing models.
> 
> Markus wrote:
> <cite>
> Jiri, are you allowed to include that microcode, did you get any
> information about this from the manufacturer which could allow the
> inclusion?
> The sequences are rather small not putting it into extra firmware
> files would make life much easier for some users, on the other side if
> it raises legal issues Mauro's right with loading it from a file
> </cite>
> 
> This seems to be a reverse engineered driver, I think, all those values are
> intercepted, so there are no licensing issues.

Are those a code, or just another internal driver configuration (for
example, maybe some register initialization inside the sensors)? We
should take care to avoid adding material here that can be later
complained.
> > 
> > Instead of using all those write, you should consider creating a table
> > of values and use something like:
> > 	stk11xx_write_regs(dev, table1);
> 
> There is a problem with this approach. There are reads every 3-5 writes and
> this can grow into many small tables.

Maybe you can do this then just for the bigger tables.

> > You may also consider writing a separate c file for stk1135. Having a
> > large .c file is not very nice. The better is to split the code into a
> > few parts.
> 
> I don't like many files for one driver and finding little pieces of code
> in each file separately -- 1125 + 1235 will be small pieces. Not considering
> the static functions and warning about unused code. But it's up to you, it's
> your subtree, make a decision.

Your driver have about 3600 lines. We target to keep newer files with a
maximum of about 1000 lines on the same file (unfortunately, some
drivers are bigger than that), separating the driver into logical
pieces. I think it would be interesting to split it into two or tree
files.

> 
> >> +static void *stk11xx_rvmalloc(unsigned long size)
> > 
> > Another rvmalloc implementation? You should consider using the one
> > already at kernel.
> 
> What's the name, I can't find it?

There are some rvmalloc on cpia, cpia2, em28xx, ... 

What the current drivers are doing is to replace it to vmalloc_32:

#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,15)
                if ((buff = rvmalloc(dev->num_frames * imagesize))) {
#else
                if ((buff = vmalloc_32(dev->num_frames * imagesize))) {
#endif

> 
> The rest of comments has been applied, thanks,

You're welcome.

-- 
Cheers,
Mauro

