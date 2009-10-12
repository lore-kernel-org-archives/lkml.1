Return-Path: <linux-kernel-owner+w=401wt.eu-S1756628AbZJLNkc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756628AbZJLNkc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 09:40:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756590AbZJLNkb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 09:40:31 -0400
Received: from ernst.netinsight.se ([194.16.221.21]:15544 "HELO
	ernst.netinsight.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756567AbZJLNka (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 09:40:30 -0400
Date: Mon, 12 Oct 2009 15:39:37 +0200
From: Simon Kagstrom <simon.kagstrom@netinsight.net>
To: Ingo Molnar <mingo@elte.hu>
Cc: Artem Bityutskiy <dedekind1@gmail.com>,
       David Woodhouse <dwmw2@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "Koskinen Aaro \(Nokia-D/Helsinki\)" <aaro.koskinen@nokia.com>,
       linux-mtd <linux-mtd@lists.infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] panic.c: export panic_on_oops
Message-ID: <20091012153937.0dcd73e5@marrow.netinsight.se>
In-Reply-To: <20091012131528.GC25464@elte.hu>
References: <1255241458-11665-1-git-send-email-dedekind1@gmail.com>
	<20091012111545.GB8857@elte.hu>
	<1255346731.9659.31.camel@localhost>
	<20091012113758.GB11035@elte.hu>
	<20091012140149.6789efab@marrow.netinsight.se>
	<20091012120951.GA16799@elte.hu>
	<1255349748.10605.13.camel@macbook.infradead.org>
	<20091012122023.GA19365@elte.hu>
	<20091012150650.51a4b4dc@marrow.netinsight.se>
	<20091012131528.GC25464@elte.hu>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

OK, I don't think we understand each other. Sorry if I'm being slow
here, please tell me if I'm misunderstanding something fundamental
below.

On Mon, 12 Oct 2009 15:15:29 +0200
Ingo Molnar <mingo@elte.hu> wrote:

> > I'm afraid I don't really see this issue. The workqueue is used to 
> > write the buffer to the mtd device if we are not in a panic or 
> > interrupt context - in which case we do it directly.
> > 
> > So it's only used when an oops is ongoing.
> 
> This fixation on 'panic' is so wrong!
> 
> 90% of the bugs users care about dont involve any panic. And even if 
> there is a panic down the line, most of the interesting messages are in 
> the stream leading up to the panic - now tucked away in that async 
> workqueue mechanism and not visible.

Well, this is what my patch [1] aims to fix. What it does is to put all
messages in a circular buffer, and when an oops or panic occurs it
writes them out. The current version only collects messages _during_ an
oops. I'll rework it with using kfifo as per Alans suggestion though.

Neither the current code nor the new patch has them stored in the work
queue during a panic though. If this happens, they will call
panic_write (if it's available) to write it out directly.

> There's two clean solutions i think:
> 
> 1) add some new "ok, there's trouble!" callback to struct console and 
>    the console driver could via that mechanism send out the _last_ 2KB 
>    (or more) of kernel log messages. Basically we can go back in time by 
>    looking at the dmesg buffer. The low level console driver does not 
>    need to 'follow' the high level console state - it only wants to 
>    print in case of trouble anyway.
>
> 2) or add buffered (flash-friendly) writes for all printk output - panic
>    and non-panic alike. This would be useful to debug suspend/resume
>    bugs for example. This would also optimize the packets of netconsole
>    output. (last i checked we sent a packet per line.)

Well, suspend/resume hangs is one of the cases which mtdoops won't
catch. But at least on NAND flash, I'd be a bit weary about logging all
printk output for fear of wearing out the flash.

> The workqueue looks wrong in both variants. If we are panic-ing (or 
> hanging, or ...) then we are halting the machine - the workqueue has no 
> chance to actually execute.

but then we are using mtd->panic_write to write it out directly, not
via the work queue.

// Simon

[1] http://patchwork.ozlabs.org/patch/35750/
