Return-Path: <linux-kernel-owner+w=401wt.eu-S1757369AbZJLRbd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757369AbZJLRbd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 13:31:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757329AbZJLRbc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 13:31:32 -0400
Received: from smtp.nokia.com ([192.100.122.233]:34362 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757302AbZJLRbb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 13:31:31 -0400
Subject: Re: [PATCH] panic.c: export panic_on_oops
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Simon Kagstrom <simon.kagstrom@netinsight.net>,
       Ingo Molnar <mingo@elte.hu>, David Woodhouse <dwmw2@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "Koskinen Aaro (Nokia-D/Helsinki)" <aaro.koskinen@nokia.com>,
       linux-mtd <linux-mtd@lists.infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
In-Reply-To: <alpine.LFD.2.01.0910120837030.3438@localhost.localdomain>
References: <1255241458-11665-1-git-send-email-dedekind1@gmail.com>
	 <20091012111545.GB8857@elte.hu> <1255346731.9659.31.camel@localhost>
	 <20091012113758.GB11035@elte.hu>
	 <20091012140149.6789efab@marrow.netinsight.se>
	 <20091012120951.GA16799@elte.hu>
	 <1255349748.10605.13.camel@macbook.infradead.org>
	 <20091012122023.GA19365@elte.hu>
	 <20091012150650.51a4b4dc@marrow.netinsight.se>
	 <20091012131528.GC25464@elte.hu>
	 <20091012153937.0dcd73e5@marrow.netinsight.se>
	 <alpine.LFD.2.01.0910120828390.3438@localhost.localdomain>
	 <alpine.LFD.2.01.0910120837030.3438@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 12 Oct 2009 20:29:17 +0300
Message-Id: <1255368557.27022.226.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 12 Oct 2009 17:29:19.0017 (UTC) FILETIME=[8777D990:01CA4B61]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-10-12 at 08:44 -0700, Linus Torvalds wrote:
> 
> On Mon, 12 Oct 2009, Linus Torvalds wrote:
> > 
> > Don't. kfifo's aren't going to help. You're doing this at all the wrong 
> > levels ENTIRELY, and we already have the buffer you want to flush.
> 
> Btw, a few simple rules:
> 
>  - if you need to make your device look like a "console device" for 
>    dumping at oops time, you're doing things wrong. You don't want line 
>    buffered output to begin with, and you don't want to see each line, you 
>    only want this at exceptional points.
> 
>  - if you need to look at "in_interrupt()" or "panic_on_oops", you're 
>    doing things wrong.
> 
>  - if you add your own buffers, you're doing things wrong. I have 
>    CONFIG_LOG_BUF_SHIFT=18 in my kernel, so I've already got 256kB worth 
>    of memory allocated for kernel messages. Sometimes I increase that 
>    further, just because I do some silly printk debugging.
> 
> IOW, just add a very simple "flush the dmesg buffer on oops" callback to 
> the end of the oops printout code (just a single call after the oops thing 
> is now known to be in the dmesg buffers!)
> 
> It's not just oopses, btw. Maybe people would like to do this as the last 
> stage of a reboot/shutdown too. Because some of the final printouts from 
> the shutdown will never make it to disk, because 'ksyslogd' has been 
> killed, and the root filesystem has been turned read-only.

Yes, it is difficult to disagree with this. As Ingo also pointed,
pretending to be a console driver is ugly, although I think it
was a clever way to avoid touching generic code.

But mtdoops tries to solves the following problem. What if we are
oopsing in an interrupt, which interrupted the mtd driver, so we have
all the locks held, and the mtd driver is in a unexpected stage ATM? Or
what if we are oopsing in the mtd driver, or in something which was
called by the MTD driver.?

This is what all that "workqueue vs. mtd->panic_write()" logic is about,
which Ingo dislikes.

The logic of mtdoops (my interpretation):

1. OK, there was an oops, we have it in a buffer and we need to write
   it to flash now.
2. If we are in interrupt context, we have to write right now, because
   the system is about to die very soon. And must use special
   'mtd->panic_write()' call.
3. If we have 'panic_on_oops' set, the system will be stopped soon. So
   we also have to write now, because this is our last chance. And we
   also have to use 'mtd->panic_write()'.
4. Otherwise, it is probable that system will be somewhat alive, and we
   may schedule the write instead of using 'mtd->panic_write()', because
   'mtd->panic_write()' abuses locking and chip state, and will screw up
   the mtd flash driver. So we prefer to schedule the write instead.

I guess similar could be done in 'panic()' instead. Or you have a more
elegant solution?

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

